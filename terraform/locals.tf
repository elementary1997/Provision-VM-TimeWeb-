# locals {
#   cloud_init_rendered = templatefile("${path.module}/cloud-init.yaml.tmpl", {
#     hostname = var.vm_name
#   })
# }