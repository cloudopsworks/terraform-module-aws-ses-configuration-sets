##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  event_destinations = merge([
    for key, config in var.configs : {
      for k, dest in config.event_destinations : "${key}-${k}" => {
        configset         = key
        destinantion_name = k
        destination       = dest
      }
    }
  ]...)
}

resource "aws_sesv2_configuration_set_event_destination" "this" {
  for_each               = local.event_destinations
  configuration_set_name = aws_sesv2_configuration_set.this[each.value.configset].configuration_set_name
  event_destination_name = each.value.destination.name

  dynamic "event_destination" {
    for_each = length(try(each.value.destination.cloudwatch, {})) > 0 ? [1] : []
    content {
      cloud_watch_destination {
        dimension_configuration {
          default_dimension_value = each.value.destination.cloudwatch.default_dimension_value
          dimension_name          = each.value.destination.cloudwatch.dimension_name
          dimension_value_source  = each.value.destination.cloudwatch.dimension_value_source
        }
      }
      enabled              = try(each.value.destination.enabled, false)
      matching_event_types = try(each.value.destination.matching_types, [])
    }
  }
  dynamic "event_destination" {
    for_each = length(try(each.value.destination.event_bridge, {})) > 0 ? [1] : []
    content {
      event_bridge_destination {
        event_bus_arn = each.value.destination.event_bridge.event_bus_arn
      }
      enabled              = try(each.value.destination.enabled, false)
      matching_event_types = try(each.value.destination.matching_types, [])
    }
  }
  dynamic "event_destination" {
    for_each = length(try(each.value.destination.kinesis_firehose, {})) > 0 ? [1] : []
    content {
      kinesis_firehose_destination {
        delivery_stream_arn = each.value.destination.kinesis_firehose.delivery_stream_arn
        iam_role_arn        = each.value.destination.kinesis_firehose.iam_role_arn
      }
      enabled              = try(each.value.destination.enabled, false)
      matching_event_types = try(each.value.destination.matching_types, [])
    }
  }
  dynamic "event_destination" {
    for_each = length(try(each.value.destination.sns, {})) > 0 ? [1] : []
    content {
      sns_destination {
        topic_arn = each.value.destination.sns.topic_arn
      }
      enabled              = try(each.value.destination.enabled, false)
      matching_event_types = try(each.value.destination.matching_types, [])
    }
  }
  dynamic "event_destination" {
    for_each = length(try(each.value.destination.pinpoint, {})) > 0 ? [1] : []
    content {
      pinpoint_destination {
        application_arn = each.value.destination.pinpoint.application_arn
      }
      enabled              = try(each.value.destination.enabled, false)
      matching_event_types = try(each.value.destination.matching_types, [])
    }
  }
}