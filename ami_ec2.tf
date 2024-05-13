resource "aws_instance" "ec2-terraform" {
	ami = "ami-00a208c7cdba991ea"
	instance_type = "t2.micro"
}
