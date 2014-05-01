zabbix-tomcat-scripts
=====================

A set of scripts and templates for monitoring Tomcat with Zabbix. This has been tested with Zabbix 2.2 but should work with all versions.

## steps

- install Tomcat template in Zabbix
- create a host per monitored JVM and apply above template

## steps per host

- enable the JMX ports on Tomcat, easiest way:
> JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=1095 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"

- install the jar file plus bash script, for example in /home/zabbix/scripts

- set the userparameter in your zabbix-agentd.conf on every host that you would like to monitor. For example:
> UserParameter=maxxton.tomcat.jmx[*],sh /home/zabbix/scripts/checkTomcatJmx.sh "$1" "$2" "$3" "$4"

- restart your Zabbix agent on the host


## test the jmx script
If your values dont appear in Zabbix, try for example the below command on the specific host. That should print your value. If that works but still Zabbix refuses to work, try enabling test.log tests in the bash script and see the output in test.log after Zabbix tried to retrieve the data.

> /home/zabbix/scripts/checkTomcatJmx.sh 1096 java.lang:type=Memory HeapMemoryUsage max




