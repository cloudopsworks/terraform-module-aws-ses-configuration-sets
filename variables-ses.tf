##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

## Variable Documentation - YAML format
# configs:
#   <configset_id>:
#     name: <string> # Optional. The name of the configuration set. If not provided, the configset_id or name_prefix will be used.
#     name_prefix: <string> # Optional. The prefix to use for the configuration set name. If not provided, the configset_id will be used. Overriden by the name attribute.
#     delivery_options:
#       max_delivery_seconds: <number> # Optional. The maximum amount of time, in seconds, that an email can remain in the system before being sent.
#       sending_pool_name: <string> # Optional. The name of the dedicated IP pool that you want to associate with the configuration set.
#       tls_policy: <string> # Optional. The TLS policy that is used to encrypt the email content.
#     reputation_metrics_enabled: <bool> # Optional. Indicates whether or not reputation metrics are enabled for the configuration set.
#     sending_enabled: <bool> # Optional. Indicates whether or not email sending is enabled for the configuration set.
#     suppressed_reasons: <string> # Optional. A list of reasons that email sending is suppressed for the configuration set.
#     tracking_options:
#       custom_redirect_domain: <string> # Optional. The domain that you want to use for tracking open and click events.
#       https_policy: <string> # Optional. The open and click tracking options for the configuration set.
#     vdm_options:
#       engagement_metrics_enabled: <bool> # Optional. Indicates whether or not the configuration set has engagement metrics enabled.
#       optimized_shared_delivery_enabled: <bool> # Optional. Indicates whether or not the configuration set has optimized shared delivery enabled.
#     event_destinations:
#       <destination_id>: # The ID of the destination. will be used as destination_name
#         enabled: <bool> # Indicates whether or not the event destination is enabled.
#         matching_types: <list(string)> # The types of events that are sent to the event destination.
#         cloudwatch: # Optional. The CloudWatch destination for the event destination.
#           default_dimension_value: <string> # The default value of the dimension that is published to Amazon CloudWatch.
#           dimension_name: <string> # The name of the dimension that is published to Amazon CloudWatch.
#           dimension_value_source: <string> # The source of the dimension that is published to Amazon CloudWatch.
#         event_bridge: # Optional. The Amazon EventBridge destination for the event destination.
#           event_bus_arn: <string> # The ARN of the Amazon EventBridge bus that you want to publish events to.
#         kinesis_firehose: # Optional. The Kinesis Firehose destination for the event destination.
#           delivery_stream_arn: <string> # The ARN of the Kinesis Firehose delivery stream that you want to publish events to.
#           iam_role_arn: <string> # The ARN of the IAM role that gives Amazon SES permission to publish events to the Kinesis Firehose delivery stream.
#         sns: # Optional. The Amazon SNS destination for the event destination.
#           topic_arn: <string> # The ARN of the Amazon SNS topic that you want to publish events to.
#         pinpoint: # Optional. The Amazon Pinpoint destination for the event destination.
#           application_arn: <string> # The Amazon Resource Name (ARN) of the Amazon Pinpoint project that you want to publish events to.
variable "configs" {
  description = "A map of configuration settings that will be used to configure the SES Configuration Sets module."
  type        = any
  default     = {}
}