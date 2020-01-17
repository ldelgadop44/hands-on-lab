#Getting token to EKS Cluster
data "external" "aws_iam_authenticator" {
  program = ["sh", "-c", "aws-iam-authenticator token -i ${aws_eks_cluster.eks-master.name} | jq -r -c .status"]
}

#Configuring kubernetes access data
provider "kubernetes" {
  host                      = aws_eks_cluster.eks-master.endpoint
  cluster_ca_certificate    = base64decode(aws_eks_cluster.eks-master.certificate_authority.0.data)
  token                     = data.external.aws_iam_authenticator.result.token
  load_config_file          = false
  version = "~> 1.5"
}

#Setting ConfigMap to worker nodes RBAC permission
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.eks-worker-role.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
  EOF
}
  depends_on = [
    aws_eks_cluster.eks-master,
    aws_autoscaling_group.asg_worker_eks
    ]
}