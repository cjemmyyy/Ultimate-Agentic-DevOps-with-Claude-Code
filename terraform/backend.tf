# Remote state backend (S3)
#
# The backend is commented out for the FIRST run so Terraform can bootstrap
# using local state. Follow these steps:
#
#   1. First run WITHOUT the backend (local state):
#        terraform init
#        terraform apply
#      This creates the site resources. If you want a dedicated state bucket,
#      create one (manually or in a separate config) before step 3.
#
#   2. Create the S3 bucket that will hold remote state (must be globally
#      unique). Enable versioning on it. Optionally create a DynamoDB table
#      for state locking.
#
#   3. Uncomment the block below, fill in your bucket/key/region, then migrate:
#        terraform init -migrate-state
#      Terraform will copy the existing local state into the S3 backend.
#
# terraform {
#   backend "s3" {
#     bucket         = "portfolio-site-tfstate"   # your state bucket name
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "portfolio-site-tflock"     # optional: state locking
#   }
# }
