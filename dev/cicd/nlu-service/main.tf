module "nlu-service" {
  source      = "../../../modules/cicd"
  appname     = "nlu-service"
  environment = "dev"
}
