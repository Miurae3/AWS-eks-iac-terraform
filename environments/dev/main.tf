module "vpc" {

  source = "../../modules/vpc"

  cluster_name = "eks-lab"

}
module "iam" {

  source = "../../modules/iam"

  cluster_name = "eks-lab"

}