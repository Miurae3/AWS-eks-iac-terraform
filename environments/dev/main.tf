module "vpc" {

  source = "../../modules/vpc"

  cluster_name = "eks-lab"

}