resource "openstack_compute_instance_v2" "wordpress_server" {
  name            = "${var.stack_name}-${var.env}-wordpress2"
  flavor_id       = "5bf7a69c-171a-43cd-835d-fdf02c5c6d8d"
  key_pair        = "pfreund2"
  security_groups = ["${openstack_compute_secgroup_v2.wordpress_security_group.name}"]

  block_device {
    uuid                  = "89b67970-2294-4af3-88fb-79a08d33409c"
    source_type           = "image"
    volume_size           = 10
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "shared_tenant_public_net"
  }
}

resource "openstack_compute_secgroup_v2" "wordpress_security_group" {
  name        = "wordpress_secgroup"
  description = "Inbound 22 and 80"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}
