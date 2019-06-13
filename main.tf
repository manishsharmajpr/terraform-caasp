provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "caasp-net" {
  name      = "caasp-net"
  mode      = "nat"
  domain    = "caasp-net.local"
  addresses = ["172.17.2.0/24"]

  dhcp {
    enabled = true
  }

  dns = {
    local_only = true
  }
}

resource "libvirt_volume" "sles151-jeos" {
  name   = "sles151-jeos"
  source = "${var.jeos_location}"
}

resource "libvirt_volume" "caasp_os" {
  name           = "caasp_os-${count.index}"
  base_volume_id = "${libvirt_volume.sles151-jeos.id}"
  size           = 107374182400
  count          = "${var.count_vms}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.cfg")}"
  count    = "${var.count_vms}"

  vars {
    hostname        = "caasp-node-${count.index}"
    caasp-regkey    = "${var.caasp-regkey}"
    authorized_keys = "${var.authorized_keys}"
  }
}

data "template_file" "network_config" {
  template = "${file("${path.module}/network_config.cfg")}"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit-${count.index}.iso"
  user_data      = "${element(data.template_file.user_data.*.rendered, count.index)}"
  network_config = "${element(data.template_file.network_config.*.rendered, count.index)}"
  count          = "${var.count_vms}"
}

resource "libvirt_domain" "caasp-domain" {
  name   = "caasp-node-${count.index}"
  memory = "${var.memory}"
  vcpu   = "${var.vcpu}"

  qemu_agent = true

  cloudinit = "${element(libvirt_cloudinit_disk.commoninit.*.id, count.index)}"
  count     = "${var.count_vms}"

  disk {
    volume_id = "${element(libvirt_volume.caasp_os.*.id, count.index)}"
  }

  # IMPORTANT
  # you need to pass the console because the image JEOS is expecting it as kernel-param.
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  network_interface {
    network_name   = "caasp-net"
    wait_for_lease = true
  }
}

output "ips" {
  value = "${libvirt_domain.caasp-domain.*.network_interface.0.addresses}"
}
