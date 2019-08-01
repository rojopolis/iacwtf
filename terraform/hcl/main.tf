#Terraform
# Optional configuration for the Terraform Engine.
terraform {
  required_version = ">=0.12.0"
}


#Provider
# Implement cloud specific API and Terraform API.
# Provider configuation is specific to each provider.
# Providers expose Data Sources and Resources to Terraform.
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"

  #Many providers also accept configuration via environment variables
  #or config files.  The AWS provider will read the standard AWS CLI
  #settings if they are present.
}


/*
#Data Sources
# Objects NOT managed by Terraform.

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}


#Resources
# Objects managed by Terraform such as VMs or S3 Buckets.
# Declaring a Resource tells Terraform that it should CREATE
# and manage the Resource described.  If the Resource already exists
# it must be imported into Terraform's state.
resource "aws_s3_bucket" "bucket1" {
}


#Outputs
# Outputs are printed by the CLI after `apply`.
# These can reveal calculated values.
# Also used in more advanced use cases: modules, remote_state
# Outputs can be retrieved at any time by running `terraform output`
output "bucket_info" {
  value = aws_s3_bucket.bucket1
}

#output "aws_caller_info" {
#  value = aws_caller_identity.current
#}

#output "aws_availability_zones" {
#  value = aws_availability_zones.available
#}


#Interpolation
# Substitute values in strings.
resource "aws_s3_bucket" "bucket2" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket2"
}


#Dependency
# Resources can depend on one another.  Terraform will ensure that all
# dependencies are met before creating the resource.  Dependency can
# be implicit or explicit.
resource "aws_s3_bucket" "bucket3" {
    bucket = "${data.aws_caller_identity.current.account_id}-bucket3"
    tags = {
        # Implicit dependency
        dependency = aws_s3_bucket.bucket2.arn
  }
}

resource "aws_s3_bucket" "bucket4" {
    bucket = "${data.aws_caller_identity.current.account_id}-bucket4"
    # Explicit
    depends_on = [
        aws_s3_bucket.bucket3
    ]
}

#Variables
# Can be specified on the command line with -var bucket_name=my-bucket
# or in files: terraform.tfvars or *.auto.tfvars
# or in environment variables: TF_VAR_bucket_name
variable "bucket_name" {
  # `type` is an optional data type specification
  type    = "string"

  # `default` is the optional default value.  If `default` is ommited
  # then a value must be supplied.
  #default = "my-bucket"
}

resource "aws_s3_bucket" "bucket5" {
  bucket = var.bucket_name
}


#Local Values
# Local values allow you to assign a name to an expression. Locals
# can make your code more readable.
locals {
  aws_account = "${data.aws_caller_identity.current.account_id}-${lower(data.aws_caller_identity.current.user_id)}"
}


resource "aws_s3_bucket" "bucket6" {
  bucket = "${local.aws_account}-bucket6"
}


#Count
# All resources have a `count` parameter.  The default is 1.
# If count is set then a list of resources is returned (even if there is only 1)
# If `count` is set then a `count.index` value is available.  This value contains
# the current iteration number.
# TIP: setting `count = 0` is a handy way to remove a resource but keep the config.
resource "aws_s3_bucket" "bucketX" {
  count = 0
  bucket = "${local.aws_account}-bucket${count.index+7}"
}

output "bucketX" {
  value = aws_s3_bucket.bucketX
}


#Splat
# To access an attribute of all elements in a list use the `splat` operator.
output "bucket_names" {
  value = aws_s3_bucket.bucketX[*].bucket
}


#Data types
# Terraform supports simple and complex data types
locals {
  a_string  = "This is a string."
  a_number  = 3.1415
  a_boolean = true
  a_list = [
    "element1",
    2,
    "three"
  ]
  a_map = {
    key = "value"
  }

  # Complex
  person = {
    name = "Robert Jordan",
    phone_numbers = {
      home   = "415-444-1212",
      mobile = "415-555-1313"
    },
    active = false,
    age    = 32
  }
}

output "home_phone" {
  value = local.person.phone_numbers.home
}


#Operators
# Terraform supports arithmetic and logical operations in expressions too
locals {
  //Arithmetic
  three = 1 + 2 // addition
  two   = 3 - 1 // subtraction
  one   = 2 / 2 // division
  zero  = 1 * 0 // multiplication

  //Logical
  t = true || false // OR true if either value is true
  f = true && false // AND true if both values are true

  //Comparison
  gt  = 2 > 1  // true if right value is greater
  gte = 2 >= 1 // true if right value is greater or equal
  lt  = 1 < 2  // true if left value is greater
  lte = 1 <= 2 // true if left value is greate or equal
  eq  = 1 == 1 // true if left and right are equal
  neq = 1 != 2 // true if left and right are not equal
}

output "arithmetic" {
  value = "${local.zero} ${local.one} ${local.two} ${local.three}"
}

output "logical" {
  value = "${local.t} ${local.f}"
}

output "comparison" {
  value = "${local.gt} ${local.gte} ${local.lt} ${local.lte} ${local.eq} ${local.neq}"
}


#Conditionals
variable "bucket_count" {
  type = number
}

locals {
  minimum_number_of_buckets = 5
  number_of_buckets = var.bucket_count > 0 ? var.bucket_count : local.minimum_number_of_buckets  //BUG!
}

resource "aws_s3_bucket" "buckets" {
  count = local.number_of_buckets
  bucket = "${local.aws_account}-bucket${count.index+7}"
}

#Functions
# Terraform has 100+ built in functions (but no ability to define custom functions!)
# https://www.terraform.io/docs/configuration/functions.html
# The syntax for a function call is <function_name>(<arg1>, <arg2>).
locals {
  //Date and Time
  ts = timestamp() //Returns the current date and time.
  current_month = formatdate("MMMM", local.ts)
  tomorrow = formatdate("DD", timeadd(local.ts, "24h"))
}

output "date_time" {
  value = "${local.current_month} ${local.tomorrow}"
}

locals {
  //Numeric
  number_of_buckets_2 = min(local.minimum_number_of_buckets, var.bucket_count)
}

locals {
  //String
  lcase = "${lower("A mixed case String")}"
  ucase = "${upper("a lower case string")}"
  trimmed = "${trimspace(" A string with leading and trailing spaces    ")}"
  formatted = "${format("Hello %s", "World")}"
  formatted_list = "${formatlist("Hello %s", ["John", "Paul", "George", "Ringo"])}"
}

output "string_functions" {
  value = local.formatted_list
}

#Iteration
# HCL has a `for` syntax for iterating over list values.
locals {
  l = ["one", "two", "three"]
  upper_list = [for item in local.l: upper(item)]
  upper_map  = {for item in local.l: item => upper(item)}
}

output "iterations" {
  value = local.upper_list
}

#Filtering
# The `for` syntax can also take an `if` clause.
locals {
  n = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  evens = [for i in local.n: i if i % 2 == 0]
}

output "filtered"{
  value = local.evens
}

#Directives and Heredocs
# HCL supports more complex string templating that can be used to generate
# full descriptive paragraphs too.
output "heredoc" {
  value = <<-EOT
    This is called a `heredoc`.  It's a string literal
    that can span multiple lines.
  EOT
}

output "directive" {
  value = <<-EOT
    This is a `heredoc` with directives.
    %{ if local.person.name == "" }
    Sorry, I don't know your name.
    %{ else }
    Hi ${local.person.name}
    %{ endif }
  EOT
}

output "iterated" {
  value = <<-EOT
  Directives can also iterate...
  %{ for number in local.evens }
  ${number} is even.
  %{ endfor }
EOT
}
*/