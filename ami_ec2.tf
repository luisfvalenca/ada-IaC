resource "aws_instance" "app" {
	ami = var.ami_image
	instance_type = var.instance_type
	# depends_on apenas para fins didaticos (aula de dependencias e graph)
	depends_on = [aws_s3_bucket.bucket]
	subnet_id = aws_subnet.ec2_subnet.id
	associate_public_ip_address = true
	user_data = template_file.config_user
	tags = {
		Name = "app-${var.project_name}-${terraform.workspace}"
		Environment = terraform.workspace
	}
}

data "template_file" "config_user" {
  template = "${file("${path.module}/extra_files/config_user.sh")}"
  vars = {
    ansible_user = "${var.ansible_user}"
	ansible_pubkey = "${var.ansible_pubkey}"
  }
}