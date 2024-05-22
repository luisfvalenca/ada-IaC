resource "aws_instance" "app" {
	ami = var.ami_image
	instance_type = var.instance_type
	# depends_on apenas para fins didaticos (aula de dependencias e graph)
	depends_on = [aws_s3_bucket.bucket]
	subnet_id = aws_subnet.ec2_subnet.id
	associate_public_ip_address = true
	vpc_security_group_ids = [aws_security_group.ec2_sg.id]
	user_data = templatefile("${path.module}/extra_files/config_user.sh", { ansible_user = "${var.ansible_user}", ansible_pubkey = "${var.ansible_pubkey}"})
	tags = {
		Name = "app-${var.project_name}-${terraform.workspace}"
		Environment = terraform.workspace
	}
}