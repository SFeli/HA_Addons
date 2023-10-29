#/bin/bash

USER=root

chown -R root:root /etc/homegear
chown root:root /etc/homegear/*.key

echo "Starting Homegear (/usr/bin/homegear -u $USER -g $USER)"

/usr/bin/homegear -u "${USER}" -g "${USER}" -p /var/run/homegear/homegear.pid -pre >> /dev/null 2>&1
/usr/bin/homegear -u ${USER} -g ${USER} -p /var/run/homegear/homegear.pid &
sleep 10
/usr/bin/homegear-management -p /var/run/homegear/homegear-management.pid &
/usr/bin/homegear-webssh -p /var/run/homegear/homegear-webssh.pid &
/usr/bin/homegear-influxdb -u ${USER} -g ${USER} -p /var/run/homegear/homegear-influxdb.pid &
#tail -f /var/log/homegear/homegear-webssh.log &
tail -f /var/log/homegear/homegear-flows.log &
tail -f /var/log/homegear/homegear-scriptengine.log &
tail -f /var/log/homegear/homegear-management.log &
tail -f /var/log/homegear/homegear-influxdb.log &
tail -f /var/log/homegear/homegear.log &
child=$!
wait "$child"
