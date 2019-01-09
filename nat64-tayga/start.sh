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

TAYGA_DIR=/var/run/tayga
TAYGA_CONF_FILE=${TAYGA_DIR}/tayga.conf

# Zephyr-compatible defaults for OpenThread network
TAYGA_TUN_DEVICE="nat64"
TAYGA_IPV6_ADDR="fdaa:bb:1::1"
TAYGA_IPV6_TUN_ADDR="fdaa:bb:1::2"
TAYGA_NAT64_PREFIX="64:ff9b::/96"
TAYGA_IPV4_ADDR="192.168.254.1"
TAYGA_IPV4_DYNAMIC_POOL="192.168.254.0/24"

function parse_args()
{
    while [ $# -gt 0 ]
    do
        case $1 in
        --tun-device)
            TAYGA_TUN_DEVICE=$2
            shift
            shift
            ;;
        --ipv6-addr)
            TAYGA_IPV6_ADDR=$2
            shift
            shift
            ;;
        --ipv6-tun-addr)
            TAYGA_IPV6_TUN_ADDR=$2
            shift
            shift
            ;;
        --nat64-prefix)
            TAYGA_NAT64_PREFIX=$2
            shift
            shift
            ;;
        --ipv4-addr)
            TAYGA_IPV4_ADDR=$2
            shift
            shift
            ;;
        --ipv4-pool)
            TAYGA_IPV4_DYNAMIC_POOL=$2
            shift
            shift
            ;;

        *)
            shift
            ;;
        esac
    done
}

parse_args "$@"

# Create Tayga directories.
mkdir -p ${TAYGA_DIR}

# Turn on forwarding
sysctl -w net.ipv6.conf.all.disable_ipv6=0
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.ip_forward=1

# Configure Tayga
cat >${TAYGA_CONF_FILE} <<EOF
tun-device ${TAYGA_TUN_DEVICE}
ipv6-addr ${TAYGA_IPV6_ADDR}
prefix ${TAYGA_NAT64_PREFIX}
ipv4-addr ${TAYGA_IPV4_ADDR}
dynamic-pool ${TAYGA_IPV4_DYNAMIC_POOL}
data-dir ${TAYGA_DIR}
EOF

# Setup Tayga networking
tayga -c ${TAYGA_CONF_FILE} --mktun
ip link set "$TAYGA_TUN_DEVICE" up
ip route add "$TAYGA_IPV4_DYNAMIC_POOL" dev "$TAYGA_TUN_DEVICE"
ip route add "$TAYGA_NAT64_PREFIX" dev "$TAYGA_TUN_DEVICE"
ip addr add "$TAYGA_IPV4_ADDR" dev "$TAYGA_TUN_DEVICE"
ip addr add "$TAYGA_IPV6_TUN_ADDR" dev "$TAYGA_TUN_DEVICE"
iptables -t nat -A POSTROUTING -s "$TAYGA_IPV4_DYNAMIC_POOL" -j MASQUERADE
iptables -A FORWARD -j ACCEPT

# Run Tayga
tayga -c ${TAYGA_CONF_FILE} -d

# Execute all the rest
exec "$@"
