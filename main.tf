##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_sesv2_configuration_set" "this" {
  for_each               = var.configs
  configuration_set_name = try(each.value.name, "") != "" ? each.value.name : format("%s-%s-configset", each.value.name_prefix, local.system_name)
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