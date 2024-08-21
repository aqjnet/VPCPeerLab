output "ec2_instance_public_ip" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.lesson_05.public_ip
}
