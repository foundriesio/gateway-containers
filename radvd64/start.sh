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

RADVD_CONF_TEMPLATE="/etc/radvd.conf.template"
RADVD_CONF_USE="/var/run/radvd.conf"

RADVD_INTERFACE="bt0"
RADVD_PREFIX="fd11:11::"
RADVD_MASK=64
RADVD_RDNSS=false
INTERFACE_TRIGGER=true

function parse_args()
{
    while [ $# -gt 0 ]
    do
        case $1 in
        --interface)
            RADVD_INTERFACE=$2
            shift
            shift
            ;;
        --ipv6-prefix)
            RADVD_PREFIX=$2
            shift
            shift
            ;;
        --ipv6-mask)
            RADVD_MASK=$2
            shift
            shift
            ;;
        --enable-rdnss)
            RADVD_RDNSS=true
            shift
            ;;
        --disable-interface-trigger)
            INTERFACE_TRIGGER=false
            shift
            ;;
        *)
            shift
            ;;
        esac
    done
}

parse_args "$@"

# Make dbus symlink
ln -s /var/dbus /var/run/dbus

# Create working copy of radvd.conf.template
cp ${RADVD_CONF_TEMPLATE} ${RADVD_CONF_USE}
sed -i -e "s/%RADVD_INTERFACE%/${RADVD_INTERFACE}/g" ${RADVD_CONF_USE}
sed -i -e "s/%RADVD_PREFIX%/${RADVD_PREFIX}/g" ${RADVD_CONF_USE}
sed -i -e "s/%RADVD_MASK%/${RADVD_MASK}/g" ${RADVD_CONF_USE}
if [ "${RADVD_RDNSS}" == "true" ]; then
	sed -i -e "s/%RADVD_RDNSS%/RDNSS ${RADVD_PREFIX} { };/g" ${RADVD_CONF_USE}
else
	sed -i -e "s/%RADVD_RDNSS%//g" ${RADVD_CONF_USE}
fi

if [ "${INTERFACE_TRIGGER}" == "true" ]; then
	# Spawn interface up watcher
	/interface-monitor.sh ${RADVD_INTERFACE} ${RADVD_PREFIX} ${RADVD_MASK} &
fi

# Run RADVD
radvd --logmethod=stderr --debug=5 --nodaemon --pidfile=/var/run/radvd.pid -C ${RADVD_CONF_USE}
