##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "configs" {
  description = "A map of configuration settings that will be used to configure the SES Configuration Sets module."
  type        = any
  default     = {}
}