terraform {
    required_providers {
    proxmox = {
        source = "telmate/proxmox"
        version = "2.9.10"
    }
    pihole = {
    source = "ryanwholey/pihole"
    }
    }
}

provider "pihole" {
    url = var.pihole_url # PIHOLE_URL
    api_token = var.pihole_api_token
} 

resource "pihole_dns_record" "record" {
    count = var.host_count
    domain = "kube-${count.index + 1}.cudabu.lab"
    ip = "10.30.17.5${count.index + 1}"
}

provider "proxmox" {
    pm_api_url = var.pm_api_url
    pm_api_token_id = var.pm_api_token_id
    pm_api_token_secret = var.pm_api_token_secret
    pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "kube-server" {
  count = var.host_count
  name = "kube-${count.index + 1}"

  # this now reaches out to the vars file. I could've also used this var above in the pm_api_url setting but wanted to spell it out up there. target_node is different than api_url. target_node is which node hosts the template and thus also which node will host the new VM. it can be different than the host you use to communicate with the API. the variable contains the contents "prox-1u"
  target_node = "pve${count.index + 1}"

    # set the VM id
     vmid = "40${count.index + 1}"
  # another variable with contents "ubuntu-2004-cloudinit-template"
  clone = var.template_name

  # basic VM settings here. agent refers to guest agent
  agent = 0
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size = "10G"
    type = "scsi"
    storage = "unraid"
    iothread = 1
  }
  
  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

    ipconfig0 = "ip=10.30.17.5${count.index + 1}/24,gw=10.30.17.1"
  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}