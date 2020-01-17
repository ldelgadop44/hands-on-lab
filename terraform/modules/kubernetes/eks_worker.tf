#Getting AMI for EKS worker based on linux
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.14-v20191213"]
  }

  most_recent = true
  owners      = ["602401143452"]
}

#Setting initial configuration for ec2 instances
locals {
  eks-worker-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-master.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-master.certificate_authority.0.data}' '${var.aws-environment}-${var.project-name}'

sudo yum install httpd -y
sudo sed -i 's/Listen\ 80/Listen\ 31742/g' /etc/httpd/conf/httpd.conf
sudo systemctl start httpd
curl -v http://localhost:31742
USERDATA
}

#Setting Launch configuration for ec2 instances
resource "aws_launch_configuration" "lc-eks-worker" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-worker-profile.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.instance-type
  name_prefix                 = format("%s-%s-%s", var.aws-environment, var.project-name, "lc")
  security_groups             = [var.sg-eks-worker]
  user_data_base64            = base64encode(local.eks-worker-userdata)
  key_name                    = var.key-pair-name

  lifecycle {
    create_before_destroy = true
  }
}

#Creating autoscaling group<
resource "aws_autoscaling_group" "asg_worker_eks" {
  desired_capacity     = "1"
  launch_configuration = aws_launch_configuration.lc-eks-worker.id
  max_size             = "2"
  min_size             = "1"
  name                 = format("%s-%s-%s", var.aws-environment, var.project-name, "asg")
  vpc_zone_identifier  = var.app_subnet_ids
  target_group_arns    = [var.aws_lb_target_group]

  tag {
    key                 = "Name"
    value               = format("%s-%s-%s", var.aws-environment, var.project-name, "asg")
    propagate_at_launch = true
  }

  tag {
    key                 = format("%s%s-%s", "kubernetes.io/cluster/", var.aws-environment, var.project-name)
    value               = "owned"
    propagate_at_launch = true
  }
}