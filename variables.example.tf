variable "caasp-regkey" {
  description = "subscription key for registering caasp product"
  default     = "INTERNAL-USE-ONLY-xxx"
}

variable "jeos_location" {
  description = "sles15.1-jeos location"
  default     = "../SLES15-SP1-JeOS.x86_64-15.1-OpenStack-Cloud-GM.qcow2"
}

variable "authorized_keys" {
  description = "ssh keys to inject into all the nodes"
  default     = "~/.ssh/id_rsa.pub"
}

variable "count_vms" {
  description = "number of virtual-machine of same type that will be created"
  default     = 3
}

variable "memory" {
  description = "The amount of RAM (MB) for a node"
  default     = 2048
}

variable "vcpu" {
  description = "The amount of virtual CPUs for a node"
  default     = 2
}
