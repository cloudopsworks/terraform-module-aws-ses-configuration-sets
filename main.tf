##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  event_destinations = merge([
    for key, config in var.configs : {
      for k, dest in config : "${key}-${k}" => {
        configset         = key
        destinantion_name = k
        destination       = dest
      }
    }
  ]...)
}

resource "aws_sesv2_configuration_set" "this" {
  for_each               = var.configs
  configuration_set_name = try(each.value.name, "") != "" ? each.value.name : format("%s-%s-configset", try(each.value.name_prefix, each.key), local.system_name)
  dynamic "delivery_options" {
    for_each = length(try(each.value.delivery_options, {})) > 0 ? [each.value.delivery_options] : []
    content {
      max_delivery_seconds = try(each.value.max_delivery_seconds, null)
      sending_pool_name    = try(each.value.sending_pool_name, null)
      tls_policy           = try(each.value.tls_policy, null)
    }
  }
  dynamic "reputation_options" {
    for_each = try(each.value.reputation_metrics_enabled, false) == true ? [1] : []
    content {
      reputation_metrics_enabled = true
    }
  }
  dynamic "sending_options" {
    for_each = try(each.value.sending_enabled, false) == true ? [1] : []
    content {
      sending_enabled = true
    }
  }
  dynamic "suppression_options" {
    for_each = try(each.value.suppressed_reasons, "") != "" ? [1] : []
    content {
      suppressed_reasons = each.value.suppressed_reasons
    }
  }
  dynamic "tracking_options" {
    for_each = length(try(each.value.tracking_options, {})) > 0 ? [each.value.tracking_options] : []
    content {
      custom_redirect_domain = each.value.tracking_options.custom_redirect_domain
      https_policy           = try(each.value.tracking_options.https_policy, null)
    }
  }
  dynamic "vdm_options" {
    for_each = length(try(each.value.vdm_options, {})) > 0 ? [each.value.vdm_options] : []
    content {
      dynamic "dashboard_options" {
        for_each = try(each.value.vdm_options.engagement_metrics_enabled, "") == "" ? [1] : []
        content {
          engagement_metrics = each.value.vdm_options.engagement_metrics_enabled ? "ENABLED" : "DISABLED"
        }
      }
      dynamic "guardian_options" {
        for_each = try(each.value.vdm_options.optimized_shared_delivery_enabled, "") == "" ? [1] : []
        content {
          optimized_shared_delivery = each.value.vdm_options.optimized_shared_delivery_enabled ? "ENABLED" : "DISABLED"
        }
      }
    }
  }
  tags = local.all_tags
}

resource "aws_sesv2_configuration_set_event_destination" "this" {
  for_each               = local.event_destinations
  configuration_set_name = aws_sesv2_configuration_set.this[each.value.configset].configuration_set_name
  event_destination_name = each.value.destination.name

  event_destination {
    dynamic "cloud_watch_destination" {
      for_each = length(try(each.value.destination.cloudwatch, {})) > 0 ? [1] : []
      content {
        dimension_configuration {
          default_dimension_value = each.value.destination.cloudwatch.default_dimension_value
          dimension_name          = each.value.destination.cloudwatch.dimension_name
          dimension_value_source  = each.value.destination.cloudwatch.dimension_value_source
        }
      }
    }
    dynamic "event_bridge_destination" {
      for_each = length(try(each.value.destination.event_bridge, {})) > 0 ? [1] : []
      content {
        event_bus_arn = each.value.destination.event_bridge.event_bus_arn
      }
    }
    dynamic "kinesis_firehose_destination" {
      for_each = length(try(each.value.destination.kinesis_firehose, {})) > 0 ? [1] : []
      content {
        delivery_stream_arn = each.value.destination.kinesis_firehose.delivery_stream_arn
        iam_role_arn        = each.value.destination.kinesis_firehose.iam_role_arn
      }
    }
    dynamic "sns_destination" {
      for_each = length(try(each.value.destination.sns, {})) > 0 ? [1] : []
      content {
        topic_arn = each.value.destination.sns.topic_arn
      }
    }
    dynamic "pinpoint_destination" {
      for_each = length(try(each.value.destination.pinpoint, {})) > 0 ? [1] : []
      content {
        application_arn = each.value.destination.pinpoint.application_arn
      }
    }
    enabled              = try(each.value.destination.enabled, false)
    matching_event_types = try(each.value.destination.matching_types, [])
  }
}