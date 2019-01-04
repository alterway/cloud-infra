locals {
  values_nginx_ingress = <<VALUES
controller:
  kind: "DaemonSet"
  daemonset:
    useHostPort: true
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
      service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "3600"
  publishService:
    enabled: true
  config:
defaultBackend:
  replicaCount: 2
VALUES

  values_cluster_autoscaler = <<VALUES
autoDiscovery:
  clusterName: ${var.cluster_autoscaler["cluster_name"]}
awsRegion: ${var.aws["region"]}
sslCertPath: /etc/kubernetes/pki/ca.crt
rbac:
 create: true
image:
  tag: ${var.cluster_autoscaler["version"]}
nodeSelector:
  node-role.kubernetes.io/controller: ""
tolerations:
  - operator: Exists
    effect: NoSchedule
    key: "node-role.kubernetes.io/controller"
VALUES

  values_external_dns = <<VALUES
image:
  tag: ${var.external_dns["version"]}
provider: aws
txtPrefix: "ext-dns-"
rbac:
 create: true
nodeSelector:
  node-role.kubernetes.io/controller: ""
tolerations:
  - operator: Exists
    effect: NoSchedule
    key: "node-role.kubernetes.io/controller"
VALUES

  values_cert_manager = <<VALUES
image:
  tag: ${var.cert_manager["version"]}
rbac:
 create: true
nodeSelector:
  node-role.kubernetes.io/controller: ""
tolerations:
  - operator: Exists
    effect: NoSchedule
    key: "node-role.kubernetes.io/controller"
VALUES
}

resource "helm_release" "nginx_ingress" {
    depends_on = [
      "kubernetes_service_account.tiller",
      "kubernetes_cluster_role_binding.tiller"
    ]
    count = "${var.nginx_ingress["enabled"] ? 1 : 0 }"
    name      = "nginx-ingress"
    chart     = "stable/nginx-ingress"
    version   = "${var.nginx_ingress["chart_version"]}"
    values = ["${concat(list(local.values_nginx_ingress),list(var.nginx_ingress["extra_values"]))}"]
    namespace = "${var.nginx_ingress["namespace"]}"
}

resource "helm_release" "cluster_autoscaler" {
    depends_on = [
      "kubernetes_service_account.tiller",
      "kubernetes_cluster_role_binding.tiller"
    ]
    count = "${var.cluster_autoscaler["enabled"] ? 1 : 0 }"
    name      = "cluster-autoscaler"
    chart     = "stable/cluster-autoscaler"
    version   = "${var.cluster_autoscaler["chart_version"]}"
    values = ["${concat(list(local.values_cluster_autoscaler),list(var.cluster_autoscaler["extra_values"]))}"]
    namespace = "${var.cluster_autoscaler["namespace"]}"
}

resource "helm_release" "external_dns" {
    depends_on = [
      "kubernetes_service_account.tiller",
      "kubernetes_cluster_role_binding.tiller"
    ]
    count = "${var.external_dns["enabled"] ? 1 : 0 }"
    name      = "external-dns"
    chart     = "stable/external-dns"
    version   = "${var.external_dns["chart_version"]}"
    values = ["${concat(list(local.values_external_dns),list(var.external_dns["extra_values"]))}"]
    namespace = "${var.external_dns["namespace"]}"
}

resource "helm_release" "cert_manager" {
    depends_on = [
      "kubernetes_service_account.tiller",
      "kubernetes_cluster_role_binding.tiller"
    ]
    count = "${var.cert_manager["enabled"] ? 1 : 0 }"
    name      = "cert-manager"
    chart     = "stable/cert-manager"
    version   = "${var.cert_manager["chart_version"]}"
    values = ["${concat(list(local.values_cert_manager),list(var.cert_manager["extra_values"]))}"]
    namespace = "${var.cert_manager["namespace"]}"
}
