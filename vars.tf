variable "host_count" {
    default = 3
}
variable "pm_api_url" {
    default = "https://pve1.cudabu.lab:8006/api2/json"
}
variable "ssh_key" {
    default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnDGzcnGDqIxkwMqyM8cegzh8yiLn7cJ+RBEM4fOTlG cbunch@gmail.com"
}
variable "proxmox_host" {
    default = "pve1"
}
variable "template_name" {
    default = "ubuntu-cloud"
}
variable "pm_api_token_id" {
    default = "terraform-prov@pve!default"
}
variable "pm_api_token_secret" {
    default = "356bb8df-55aa-4d87-9073-8847ffd8c12e"
}

variable "pihole_url" {
    default = "http://10.30.17.12"
}
variable "pihole_api_token" {
    default = "998ed4d621742d0c2d85ed84173db569afa194d4597686cae947324aa58ab4bb"
}