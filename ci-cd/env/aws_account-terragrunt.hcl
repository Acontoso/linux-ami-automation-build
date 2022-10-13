inputs = {
    codebuild_project_name                      = "SOE-Ubuntu-Build"
    codebuild_project_description               = "Building out SOE Ubuntu AMI used within AWS"
    lambda_function_name                        = "Microsoft-Automated-M365-Checks"
    codepipeline_name                           = "Microsoft-Automated-M365-Checks-CI-CD"
    environment                                 = "prod"
    version_no                                  = "1.0.0"
    github_repo_url                             = run_cmd("../get_repo_url.sh")
    iam_role_name_codebuild                     = "soe-build"
    buildspec_path                              = "../buildspec/buildspec.yml"
}

remote_state {
  backend = "s3"
  config = {
    bucket                          = "${get_aws_account_id()}-tfstate"
    dynamodb_table                  = "${get_aws_account_id()}-tfstate-locktable"
    region                          = "ap-southeast-2"
    key                             = "soe-build/soe-build-pipeline-state"
    encrypt                         = true
  }
}
