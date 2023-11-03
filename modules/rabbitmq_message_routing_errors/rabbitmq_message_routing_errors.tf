resource "shoreline_notebook" "rabbitmq_message_routing_errors" {
  name       = "rabbitmq_message_routing_errors"
  data       = file("${path.module}/data/rabbitmq_message_routing_errors.json")
  depends_on = [shoreline_action.invoke_rmqctl_list_conn_channels,shoreline_action.invoke_rabbitmq_trace,shoreline_action.invoke_update_rabbitmq_bindings]
}

resource "shoreline_file" "rmqctl_list_conn_channels" {
  name             = "rmqctl_list_conn_channels"
  input_file       = "${path.module}/data/rmqctl_list_conn_channels.sh"
  md5              = filemd5("${path.module}/data/rmqctl_list_conn_channels.sh")
  description      = "Check the status of the RabbitMQ connections and channels"
  destination_path = "/tmp/rmqctl_list_conn_channels.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rabbitmq_trace" {
  name             = "rabbitmq_trace"
  input_file       = "${path.module}/data/rabbitmq_trace.sh"
  md5              = filemd5("${path.module}/data/rabbitmq_trace.sh")
  description      = "Verify that the message is being sent to the correct exchange and routing key"
  destination_path = "/tmp/rabbitmq_trace.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_rabbitmq_bindings" {
  name             = "update_rabbitmq_bindings"
  input_file       = "${path.module}/data/update_rabbitmq_bindings.sh"
  md5              = filemd5("${path.module}/data/update_rabbitmq_bindings.sh")
  description      = "Check if the exchange and queue bindings are correctly defined on the RabbitMQ server. If not, modify them to ensure proper routing of messages between the producers and consumers."
  destination_path = "/tmp/update_rabbitmq_bindings.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_rmqctl_list_conn_channels" {
  name        = "invoke_rmqctl_list_conn_channels"
  description = "Check the status of the RabbitMQ connections and channels"
  command     = "`chmod +x /tmp/rmqctl_list_conn_channels.sh && /tmp/rmqctl_list_conn_channels.sh`"
  params      = []
  file_deps   = ["rmqctl_list_conn_channels"]
  enabled     = true
  depends_on  = [shoreline_file.rmqctl_list_conn_channels]
}

resource "shoreline_action" "invoke_rabbitmq_trace" {
  name        = "invoke_rabbitmq_trace"
  description = "Verify that the message is being sent to the correct exchange and routing key"
  command     = "`chmod +x /tmp/rabbitmq_trace.sh && /tmp/rabbitmq_trace.sh`"
  params      = ["ROUTING_KEY"]
  file_deps   = ["rabbitmq_trace"]
  enabled     = true
  depends_on  = [shoreline_file.rabbitmq_trace]
}

resource "shoreline_action" "invoke_update_rabbitmq_bindings" {
  name        = "invoke_update_rabbitmq_bindings"
  description = "Check if the exchange and queue bindings are correctly defined on the RabbitMQ server. If not, modify them to ensure proper routing of messages between the producers and consumers."
  command     = "`chmod +x /tmp/update_rabbitmq_bindings.sh && /tmp/update_rabbitmq_bindings.sh`"
  params      = ["RABBITMQ_PORT","EXCHANGE_NAME","RABBITMQ_HOST","QUEUE_NAME"]
  file_deps   = ["update_rabbitmq_bindings"]
  enabled     = true
  depends_on  = [shoreline_file.update_rabbitmq_bindings]
}

