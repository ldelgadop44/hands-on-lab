#Role for EKS nodes
resource "aws_iam_role" "eks-worker-role" {
  name = format("%s-%s-%s", var.aws-environment , var.project-name, "worker-role")

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#Association policy to EKS worker role
resource "aws_iam_role_policy_attachment" "iam-worker-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-worker-role.name
}

#Association policy to EKS worker role
resource "aws_iam_role_policy_attachment" "iam-worker-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker-role.name
}

#Association policy to EKS master role
resource "aws_iam_role_policy_attachment" "iam-worker-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker-role.name
}

#Association policy to ec2 workers profile
resource "aws_iam_instance_profile" "ec2-worker-profile" {
  name = format("%s-%s-%s", var.aws-environment , var.project-name, "ec2-profile")
  role = aws_iam_role.eks-worker-role.name
}