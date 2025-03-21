##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "configuration_sets" {
  value = {
    for k, v in aws_sesv2_configuration_set.this : k => {
      arn = v.arn
    }
  }
}

output "event_destinations" {
  value = {
    for k, v in local.event_destinations : k => {
      configuration_set_name = aws_sesv2_configuration_set_event_destination.this[k].configuration_set_name
      destinantion_name      = aws_sesv2_configuration_set_event_destination.this[k].event_destination_name
      id                     = aws_sesv2_configuration_set_event_destination.this[k].id
    }
  }
}