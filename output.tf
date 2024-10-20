output "TEST_instance_details" {
  value = [aws_instance.TEST_instance.public_ip , "${element(aws_instance.TEST_instance.*.id, 0)}" , aws_instance.TEST_instance.*.tags.Name]
}

output "vault_instance_details" {
  value = [aws_instance.Vault-Server.public_ip , "${element(aws_instance.Vault-Server.*.id, 0)}" , aws_instance.Vault-Server.*.tags.Name]
}





# output "instance_id" {
#   value = "${element(aws_instance.TEST_instance.*.id, 0)}"
# }

# output "instance_Name" {
#   value       = aws_instance.TEST_instance.*.tags.Name
# }

# output "Example" {
#   value = data.vault_kv_secret_v2.aws-auth.data
#   sensitive = true
# }