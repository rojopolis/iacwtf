resource "null_resource" "hello_resource" {
  provisioner "local-exec" {
    when    = "create"
    command = "echo hello_resource creating..."
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "echo hello_resource destroying..."
  }
}

output "hello_resource_id" {
  value = null_resource.hello_resource.id
}