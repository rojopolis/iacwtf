resource "null_resource" "hello_resource" {
  depends_on = [
      null_resource.goodbye_resource
  ]
  provisioner "local-exec" {
    when    = "create"
    command = "echo hello_resource creating..."
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "echo hello_resource destroying..."
  }
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