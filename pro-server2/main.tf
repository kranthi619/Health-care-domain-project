resource "aws_instance" "pro-server2" {
  ami                    = "ami-02eb7a4783e7e9317"
  instance_type          = "t2.medium"
  key_name               = "exampl"
  vpc_security_group_ids = ["sg-0dcfb1d7312730a94"]

  tags = {
    Name = "pro-server2"
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
    command = "echo ${aws_instance.pro-server2.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i /dev/stdin <<EOF\n${yaml_content}\nEOF"
  }

  locals {
    yaml_content = <<-EOT
apiVersion: apps/v1
kind: Deployment
metadata:
  name: medicure
  labels:
    app: medicure
spec:
  replicas: 2
  selector:
    matchLabels:
      app: medicure
  template:
    metadata:
      labels:
        app: medicure
    spec:
      containers:
        - name: medicure-container
          image: kranthi619/med-pro
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: medicure-service
  labels:
    app: medicure
spec:
  selector:
    app: medicure
  type: NodePort
  ports:
    - nodePort: 31000
      port: 8082
      targetPort: 8082
EOT
  }
}


