provider "aws" {
  region = var.aws_region
}

resource "aws_eks_cluster" "theme_park_ride_ops" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnet[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "eks_subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
}

output "cluster_endpoint" {
  value = aws_eks_cluster.theme_park_ride_ops.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.theme_park_ride_ops.name
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.theme_park_ride_ops.certificate_authority[0].data
}