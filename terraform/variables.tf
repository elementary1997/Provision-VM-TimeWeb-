variable "vault_token" {
  description = "Vault API token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "vm_name" {
  description = "VM name"
  type        = string
}

variable "vm_ram" {
  description = "RAM"
  type        = number
}

variable "vm_cpu" {
  description = "CPU"
  type        = number
}

variable "vm_size" {
  description = "Disk size"
  type        = number
}

variable "existing_subnet_id" {
  description = "ID existing subnet"
  type = string
}