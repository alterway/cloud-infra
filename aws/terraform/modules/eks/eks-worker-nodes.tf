#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EC2 Security Group to allow networking traffic
#  * Data source to fetch latest EKS worker AMI
#  * AutoScaling Launch Configuration to configure worker instances
#  * AutoScaling Group to launch worker instances
#

resource "aws_iam_role" "eks-node" {
  name = "terraform-eks-node-${var.cluster-name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "eks-autoscaling" {
  name = "terraform-eks-node-autoscaling-${var.cluster-name}"
  role = "${aws_iam_role.eks-node.name}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "eks-route53-external-dns" {
  name = "terraform-eks-node-route53-external-dns-${var.cluster-name}"
  role = "${aws_iam_role.eks-node.name}"
  count = "${var.use_route53}"

  policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "route53:ChangeResourceRecordSets"
     ],
     "Resource": [
       "arn:aws:route53:::hostedzone/${aws_route53_zone.eks.zone_id}"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:GetChange"
     ],
     "Resource": [
       "arn:aws:route53:::change/*"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:ListHostedZones",
       "route53:ListResourceRecordSets",
       "route53:ListHostedZonesByName"
     ],
     "Resource": [
       "*"
     ]
   }
 ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks-node.name}"
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks-node.name}"
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks-node.name}"
}

resource "aws_iam_instance_profile" "eks-node" {
  name = "terraform-eks-${var.cluster-name}"
  role = "${aws_iam_role.eks-node.name}"
}

resource "aws_security_group" "eks-node" {
  name        = "terraform-eks-node-${var.cluster-name}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.eks.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "terraform-eks-node-${var.cluster-name}",
     "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "eks-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks-node.id}"
  source_security_group_id = "${aws_security_group.eks-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-node.id}"
  source_security_group_id = "${aws_security_group.eks-cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster-443" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane for metrics server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-node.id}"
  source_security_group_id = "${aws_security_group.eks-cluster.id}"
  to_port                  = 443
  type                     = "ingress"
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

resource "aws_launch_template" "eks" {
  count = "${length(var.node-pools)}"

  iam_instance_profile = {
    name = "${aws_iam_instance_profile.eks-node.name}"
  }

  image_id               = "${data.aws_ami.eks-worker.id}"
  instance_type          = "${lookup(var.node-pools[count.index],"instance_type")}"
  name_prefix            = "terraform-eks-${var.cluster-name}-node-pool-${lookup(var.node-pools[count.index],"name")}"
  vpc_security_group_ids = ["${aws_security_group.eks-node.id}"]
  user_data              = "${base64encode(local.eks-node-userdata)}"
  key_name               = "${lookup(var.node-pools[count.index],"key_name")}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = "${lookup(var.node-pools[count.index],"volume_size")}"
      volume_type = "${lookup(var.node-pools[count.index],"volume_type")}"
    }
  }
}

resource "aws_autoscaling_group" "eks" {
  count = "${length(var.node-pools)}"

  desired_capacity = "${lookup(var.node-pools[count.index],"desired_capacity")}"

  launch_template = {
    id      = "${aws_launch_template.eks.*.id[count.index]}"
    version = "$$Latest"
  }

  max_size            = "${lookup(var.node-pools[count.index],"max_size")}"
  min_size            = "${lookup(var.node-pools[count.index],"min_size")}"
  name                = "terraform-eks-${var.cluster-name}-node-pool-${lookup(var.node-pools[count.index],"name")}"
  vpc_zone_identifier = ["${aws_subnet.eks-private.*.id}"]

  tag {
    key                 = "Name"
    value               = "terraform-eks-${var.cluster-name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${lookup(var.node-pools[count.index],"autoscaling")}"
    value               = ""
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster-name}"
    value               = ""
    propagate_at_launch = true
  }

  tag {
    key                 = "eks:node-pool:name"
    value               = "${lookup(var.node-pools[count.index],"name")}"
    propagate_at_launch = true
  }
}
