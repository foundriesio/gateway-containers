#!/bin/sh
#
# Copyright (c) 2019 Foundries.io
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

RADVD_INTERFACE="$1"
RADVD_PREFIX="$2"
RADVD_MASK="$3"

function iface_setup()
{
	echo "[IM] interface: ${RADVD_INTERFACE} add IPv6 address: ${RADVD_PREFIX}1"
	ip addr add "${RADVD_PREFIX}1" dev "${RADVD_INTERFACE}"
	echo "[IM] interface: ${RADVD_INTERFACE} add route: ${RADVD_PREFIX}/${RADVD_MASK}"
	ip -6 route add "${RADVD_PREFIX}/${RADVD_MASK}" dev "${RADVD_INTERFACE}"
}

function iface_monitor()
{
	# if interface already exists assign IPv6 prefix and route to interface
	if [ -e /sys/class/net/${RADVD_INTERFACE} ]; then
		ip -6 address show dev ${RADVD_INTERFACE} | grep -q ${RADVD_PREFIX}
		if [ $? -ne 0 ]; then
			echo "[IM] interface: ${RADVD_INTERFACE} is UP w/o prefix"
			iface_setup
		fi
	fi

	dbus-monitor --system "type='signal',path='/org/freedesktop/systemd1',member=UnitNew" |
	grep -o "net-${RADVD_INTERFACE}.device" |
	while read -r line; do
		echo "[IM] interface: ${RADVD_INTERFACE} up trigger"
		iface_setup
		# Grab processes as they are w/o piping to grep otherwise we get 2 matches
		last_ps=$(ps)
		# HACK: restart dbus-monitor after adding IP/route
		kill $(echo "${last_ps}" | grep "dbus-monitor --system" | awk '{print $1}')
	done
}

echo "[IM] === Starting Interface Monitor ==="
echo "[IM] monitor interface  : ${RADVD_INTERFACE}"
echo "[IM] ipv6 prefix setting: ${RADVD_PREFIX}/${RADVD_MASK}"

# Loop
while :
do
	iface_monitor
done

echo "[IM] === End Interface Monitor ==="
