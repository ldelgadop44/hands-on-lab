#Role for EKS Master
resource "aws_iam_role" "eks-master-role" {
  name = format("%s-%s-%s", var.aws-environment , var.project-name, "master-role")

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#Association policy to EKS master role
resource "aws_iam_role_policy_attachment" "iam-master-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-master-role.name
}

#Association policy to EKS master role
resource "aws_iam_role_policy_attachment" "iam-master-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-master-role.name
}