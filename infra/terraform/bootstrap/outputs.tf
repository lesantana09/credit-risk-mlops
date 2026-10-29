output "state_bucket" {
  description = "Bucket a usar no backend \"s3\" das demais stacks."
  value       = aws_s3_bucket.tfstate.bucket
}

output "backend_config" {
  description = "Bloco pronto para colar nas próximas stacks."
  value       = <<-EOT
    backend "s3" {
      bucket       = "${aws_s3_bucket.tfstate.bucket}"
      key          = "<stack>/terraform.tfstate"
      region       = "${var.aws_region}"
      use_lockfile = true
      encrypt      = true
    }
  EOT
}
