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

resource "null_resource" "goodbye_resource" {
  depends_on = [
      null_resource.hello_resource
  ]
  provisioner "local-exec" {
    when = "create"
    command = "echo goodbye_resource creating..."
  }
  provisioner "local-exec" {
    when = "destroy"
    command = "echo goodbye_resource destroying..."
  }
}

data "null_data_source" "greetings" {
    inputs = {
        hello = "Hello."
        goodbye = "Goodbye."
    }
}