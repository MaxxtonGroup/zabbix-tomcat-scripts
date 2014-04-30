#!/bin/bash
#
# Maxxton Tomcat monitoring
# Version: 1.0
# Author: R. Sonke
#

# To be set per Tomcat environment
SERVER_URL=localhost:$1


# Might needs changes, based on environment
JCMD=$(type -p java)
if [ ! -z "$JCMD" ]
then
  _java=java
elif [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]
then
  _java="$JAVA_HOME/bin/java"
else
  _java="/usr/bin/java"
fi

JMX_URL=service:jmx:rmi:///jndi/rmi://$SERVER_URL/jmxrmi
CURRENT_DIR=`dirname $0`

JMX_TYPE=$2
JMX_APP=$3
JMX_VALUE=$4

# Only needed with compound values like HeapMemoryUsage.used
COMPOUND_PART=""
if [ ! -z "$JMX_VALUE" ]
then
  COMPOUND_PART="-c $JMX_VALUE"
fi

# Execute that what matters
value="$($_java -cp $CURRENT_DIR/jmx-cli-client.jar com.maxxton.jmx.client.SimpleJMXClient -u $JMX_URL -t "$JMX_TYPE" -a "$JMX_APP" $COMPOUND_PART)"

# Grab the value from output
output=$(echo $value | grep 'JMXValue' | awk 'NF>1{print $NF}')

# Can be enabled for easier debugging when zabbix doesnt work
#echo $output > $CURRENT_DIR/test.log

# Print the output to be picked up by the Zabbix Agent
echo $output

exit 0