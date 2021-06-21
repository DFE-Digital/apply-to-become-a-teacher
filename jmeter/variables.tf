variable "cf_user" { default = null }

variable "cf_password" { default = null }

variable "cf_space" { default = "bat-qa" }

variable "prometheus_app" { default = null }

locals {
  app_name     = "apply-jmeter"
  docker_image = "ghcr.io/dfe-digital/apply-jmeter-runner:latest"
  app_env_variables = {
    JMETER_TARGET_PLAN    = "test"
    JMETER_TARGET_BASEURL = "https://qa.apply-for-teacher-training.service.gov.uk"
  }
}
