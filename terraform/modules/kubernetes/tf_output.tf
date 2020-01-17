#Printing output to kubectl configuration
output "eks_kubeconfig" {
  value = local.kubeconfig
  depends_on = [
    aws_eks_cluster.eks-master
  ]
}