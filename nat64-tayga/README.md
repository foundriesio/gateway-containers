TAYGA is an out-of-kernel stateless NAT64 implementation for Linux that uses
the TUN driver to exchange IPv4 and IPv6 packets with the kernel.
For more information: [http://www.litech.org/tayga/](http://www.litech.org/tayga/).

Most of the implementation details for this particular container were copied from
the OpenThread BorderRouter Tayga settings.

## How to use this image

```
docker run --privileged --network=host hub.foundries.io/nat64-tayga
```

Several parameters can be passed into the container at the end of the above
command:

- --tun-device: name of the NAT64 tunnel device
  (default: nat64)
- --ipv6-addr: host side IPv6 address for routing traffic
  (default: fdaa:bb:1::1)
- --ipv6-tun-addr: tunnel side IPv6 address for routing traffic
  (default: fdaa:bb:1::2)
- --nat64-prefix: destination IPv6 prefix denoting IPv4 NAT traffic
  (default: 64:ff9b::/96)
- --ipv4-addr: IPv4 assigned to dynamic address pool for routing IPv4 traffic
  (default: 192.168.254.1)
- --ipv4-pool: dynamic IPv4 address pool for outbound IPv4 NAT traffic
  (default: 192.168.254.0/24)

Example:
```
docker run --privileged --network=host hub.foundries.io/nat64-tayga \
    --tun-device nat64 --ipv6-addr "fdaa:bb:1::1" --ipv6-tun-addr "fdaa:bb:1::2" \
    --nat64-prefix "64:ff9b::/96" --ipv4-addr "192.168.254.1" \
    --ipv4-pool "192.168.254.0/24"
```
