#Creating security rule for EKS master security group for allow communications with API
resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
  cidr_blocks       = [var.authorized-ip]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-eks-master.id
  to_port           = 443
  type              = "ingress"
}

#Creating security rule for EKS master security group for allow communications with nodes
resource "aws_security_group_rule" "eks-worker-ingress-workstation-ssh" {
  cidr_blocks       = [var.authorized-ip]
  description       = "Allow workstation to communicate with the Kubernetes nodes directly."
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-eks-worker.id
  to_port           = 22
  type              = "ingress"
}

#Creating security rule for EKS worker security group for allow communications other workers in the cluster
resource "aws_security_group_rule" "eks-worker-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg-eks-worker.id
  source_security_group_id = aws_security_group.sg-eks-worker.id
  to_port                  = 65535
  type                     = "ingress"
}

#Creating security rule for EKS worker security group for receive communication from cluster control plane
resource "aws_security_group_rule" "eks-worker-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg-eks-worker.id
  source_security_group_id = aws_security_group.sg-eks-worker.id
  to_port                  = 65535
  type                     = "ingress"
}

#Creating security rule for EKS worker security group for allow communications with EKS pods
resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg-eks-worker.id
  source_security_group_id = aws_security_group.sg-eks-master.id
  to_port                  = 443
  type                     = "ingress"
}

#Creating security rule for EKS master security group for allow communications with EKS workes
resource "aws_security_group_rule" "eks-node-ingress-master" {
  description              = "Allow cluster control to receive communication from the worker Kubelets"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg-eks-master.id
  source_security_group_id = aws_security_group.sg-eks-worker.id
  to_port                  = 443
  type                     = "ingress"
}