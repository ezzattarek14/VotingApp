data "aws_iam_policy_document" "eks_assume" {
  statement {
  actions = ["sts:AssumeRole"]
  principals {
    type        = "Service"
    identifiers = ["eks.amazonaws.com"]
  }
}
 
}

resource "aws_iam_role" "eks_role" {
  name               = "${local.name_prefix}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


data "aws_iam_policy_document" "node_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}




resource "aws_iam_role" "node_role" {
  name               = "${local.name_prefix}-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume.json
}

resource "aws_iam_role_policy_attachment" "node_policy_attach" { 
  role = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" 
}
resource "aws_iam_role_policy_attachment" "node_ecr_attach"  { 
  role = aws_iam_role.node_role.name 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" 
}
resource "aws_iam_role_policy_attachment" "node_cni_attach"  { 
  role = aws_iam_role.node_role.name 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" 
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  # Change 'devops-node-role' to your actual IAM Role name if different, 
  # or reference the aws_iam_role resource you created.
  role       = "devops-node-role" 
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverServiceRole"
}

