terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.0.0"
    }
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 1.4.4"
}

provider "vault" {
  address = "[hcv.domain.ru]"
  token   = var.vault_token
  skip_tls_verify = true
}

data "vault_generic_secret" "bot_token" {
  path = "terraform/autorization_bot_token"
  version = 1
}

provider "twc" {
  token = data.vault_generic_secret.bot_token.data["autorization_key"]
}

data "twc_projects" "selected" {
  name = "BB test"
}

data "twc_configurator" "example-configurator" {
  location = "ru-1"
}

data "twc_os" "example-os" {
  name    = "ubuntu"
  version = "22.04"
}

resource "twc_ssh_key" "public_key" {
  name = "public-ssh-key-${var.vm_name}"
  body = file("~/.ssh/id_rsa.pub")
}

resource "twc_server" "example-server" {
  name         = var.vm_name
  os_id        = data.twc_os.example-os.id
  project_id   = data.twc_projects.selected.id
  ssh_keys_ids = [twc_ssh_key.public_key.id]
  cloud_init = <<-EOF
    #cloud-config
    hostname: ${var.vm_name}
    fqdn: ${var.vm_name}.brightbulb.tech
    EOF
  # cloud_init = file("cloud-init.yaml")
  # user_data = file("./cloud-init.yaml")

  configuration {
    configurator_id = data.twc_configurator.example-configurator.id
    disk            = var.vm_size
    cpu             = var.vm_cpu
    ram             = var.vm_ram
  }
  local_network {
    id = var.existing_subnet_id
  }
}

# resource "twc_server_ip" "public" {
#   source_server_id = twc_server.example-server.id
#   type             = "ipv4"
# }
