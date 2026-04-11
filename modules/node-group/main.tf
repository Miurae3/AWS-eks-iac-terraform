resource "aws_iam_role" "node_role" {

  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ec2.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {

  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

resource "aws_iam_role_policy_attachment" "cni_policy" {

  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}

resource "aws_iam_role_policy_attachment" "registry_policy" {

  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

resource "aws_eks_node_group" "nodes" {

  cluster_name = var.cluster_name

  node_group_name = "${var.cluster_name}-node-group"

  node_role_arn = aws_iam_role.node_role.arn

  subnet_ids = var.subnet_ids

  scaling_config {

    desired_size = 1
    max_size     = 2
    min_size     = 1

  }

  instance_types = ["t3.small"]

}