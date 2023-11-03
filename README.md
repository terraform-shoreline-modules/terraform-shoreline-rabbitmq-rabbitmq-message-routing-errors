
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# RabbitMQ Message Routing Errors
---

RabbitMQ Message Routing Errors occur when RabbitMQ, a message broker software, fails to route messages from the sender to the intended recipient. This can happen due to various reasons such as network issues, misconfiguration, or issues with the software itself. As a result, messages may be delayed, lost, or delivered to the wrong recipient, leading to disruptions in communication and potentially impacting the functionality of the software system that relies on RabbitMQ.

### Parameters
```shell
export EXCHANGE_NAME="PLACEHOLDER"

export QUEUE_NAME="PLACEHOLDER"

export ROUTING_KEY="PLACEHOLDER"

export VIRTUAL_HOST_NAME="PLACEHOLDER"

export RABBITMQ_PORT="PLACEHOLDER"

export RABBITMQ_HOST="PLACEHOLDER"
```

## Debug

### Verify that RabbitMQ is running
```shell
systemctl status rabbitmq-server
```

### Check the RabbitMQ logs for any errors
```shell
journalctl -u rabbitmq-server | tail -n 50
```

### Verify that the RabbitMQ exchange exists and is configured correctly
```shell
rabbitmqadmin -q list exchanges | grep ${EXCHANGE_NAME}
```

### Verify that the RabbitMQ queue exists and is configured correctly
```shell
rabbitmqadmin -q list queues | grep ${QUEUE_NAME}
```

### Verify that the RabbitMQ binding between the exchange and queue exists and is configured correctly
```shell
rabbitmqctl list_bindings | grep ${EXCHANGE_NAME} | grep ${QUEUE_NAME}
```

### Check the status of the RabbitMQ connections and channels
```shell
rabbitmqctl list_connections

rabbitmqctl list_channels
```

### Check the status of the RabbitMQ consumers
```shell
rabbitmqctl list_consumers
```

### Verify that the message is being sent to the correct exchange and routing key
```shell
rabbitmqctl trace_on

rabbitmqctl trace_off | grep -A1 '${ROUTING_KEY}'
```

### Check the RabbitMQ message rates for the exchange and queue
```shell
rabbitmqctl list_queues name messages_ready messages_unacknowledged
```

### Verify that the RabbitMQ virtual host is configured correctly
```shell
rabbitmqctl list_vhosts | grep ${VIRTUAL_HOST_NAME}
```

## Repair

### Check if the exchange and queue bindings are correctly defined on the RabbitMQ server. If not, modify them to ensure proper routing of messages between the producers and consumers.
```shell


#!/bin/bash



# Set variables

RABBITMQ_HOST=${RABBITMQ_HOST}

RABBITMQ_PORT=${RABBITMQ_PORT}

EXCHANGE_NAME=${EXCHANGE_NAME}

QUEUE_NAME=${QUEUE_NAME}



# Check if bindings are correctly defined

BINDING=$(sudo rabbitmqctl list_bindings | grep $EXCHANGE_NAME | grep $QUEUE_NAME)



if [ -z "$BINDING" ]

then

  # If bindings are not correct, modify them

  sudo rabbitmqctl set_binding -e $EXCHANGE_NAME -q $QUEUE_NAME -r ""

  echo "Bindings modified successfully."

else

  echo "Bindings are already correctly defined."

fi


```