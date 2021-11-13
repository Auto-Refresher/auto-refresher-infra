variable "refresher_controller_container_image" {
    default = "refresh-refresher"
}

variable "refresher_browser_container_image" {
    default = "selenium-standalone/chrome"
}

variable "browser_port" {
    default = 4444
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = 2
}

variable "browser_tg_arn" {
    default = "arn:aws:elasticloadbalancing:eu-west-2:818224701131:targetgroup/refresher-browser-target-group/1be5c3adaca1e1c0"
}