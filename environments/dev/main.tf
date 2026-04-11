module "vpc" {

  source = "../../modules/vpc"

  cluster_name = "miura-cluster"

}

module "iam" {

  source = "../../modules/iam"

  cluster_name = "miura-cluster"

}

module "eks" {

  source = "../../modules/eks"

  cluster_name = "miura-cluster"

  cluster_role_arn = module.iam.cluster_role_arn

  subnet_ids = module.vpc.public_subnets
}

module "node_group" {

  source = "../../modules/node-group"

  cluster_name = module.eks.cluster_name

  subnet_ids = module.vpc.public_subnets

}