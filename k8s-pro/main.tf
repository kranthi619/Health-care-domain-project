resource "aws_instance" "k8s-pro" {
  ami                    = "ami-02eb7a4783e7e9317"
  instance_type          = "t2.medium"
  key_name               = "exampl"
  vpc_security_group_ids = ["sg-0dcfb1d7312730a94"]

  tags = {
    Name = "k8s-pro"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "echo 'Instance ready'"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./exampl.pem")
    host        = self.public_ip
  }
  
  provisioner "local-exec" {
    command = "echo ${aws_instance.k8s-pro.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/k8s-pro/k8s-pro/ansible-playbook.yml"
  }
}
