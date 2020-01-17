terraform {
    backend "s3" {
        region = "us-east-2"
        bucket = "eks-terraform-state-lc-asg-alb"
        key = "terraform.tfstate"
        encrypt = true
        //dynamodb_table = "tf-config-statelock"
    }
}