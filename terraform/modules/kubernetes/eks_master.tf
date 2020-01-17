#Creating EKS Master resource
resource "aws_eks_cluster" "eks-master" {
  name            = format("%s-%s", var.aws-environment, var.project-name)
  role_arn        = aws_iam_role.eks-master-role.arn

  vpc_config {
    security_group_ids = [var.sg-eks-master]
    subnet_ids         = var.app_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam-master-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.iam-master-AmazonEKSServicePolicy,
  ]
}