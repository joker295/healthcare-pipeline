output "master_machine_public_ip" {
  description = "Public IP of master machine"
  value       = aws_instance.master-machine[0].public_ip
}

output "master_machine_public_dns" {
  description = "Public DNS of master machine"
  value       = aws_instance.master-machine[0].public_dns
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.master-machine[0].public_ip}:8080"
}