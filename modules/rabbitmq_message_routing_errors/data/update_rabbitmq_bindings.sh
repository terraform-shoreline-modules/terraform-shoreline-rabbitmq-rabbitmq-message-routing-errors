

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