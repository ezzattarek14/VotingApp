resource "aws_eks_cluster" "eks" {
  name     = "${local.name_prefix}-eks"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
    endpoint_public_access = true
    endpoint_private_access = false
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_attach]
}

resource "aws_eks_node_group" "ng" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${local.name_prefix}-ng"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.public[*].id

  scaling_config { 
     desired_size = var.node_count 
     max_size = var.node_count + 1
     min_size = 1 
}
  
instance_types = [var.node_instance_type]
  ami_type = "AL2023_x86_64_STANDARD"

}

