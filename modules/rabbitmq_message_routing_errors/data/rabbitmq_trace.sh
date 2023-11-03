rabbitmqctl trace_on

rabbitmqctl trace_off | grep -A1 '${ROUTING_KEY}'