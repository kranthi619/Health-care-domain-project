 resource "aws_instance" "prod-server2" {
  ami           = "ami-02eb7a4783e7e9317" 
  instance_type = "t2.medium" 
  key_name = "exampl"
  vpc_security_group_ids = ["sg-0dcfb1d7312730a94"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./exampl.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "prod-server2"
  }
    
}
