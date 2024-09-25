terraform {
  backend "s3" {
    bucket = "soma-project-1"
    key    = ".TFSTATE_FILE"
    region = "us-east-1"
    #dynamodb_table = "project-11"

  }
}
