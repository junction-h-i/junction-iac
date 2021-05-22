terraform {
  backend "s3" {
    bucket = "junction-tf-bucket"
    key = "terraform.state"
    region = "ap-northeast-2"
  }
}
