RADVD container based on [RADVD project](https://github.com/reubenhwk/radvd)
via Alpine Linux [RADVD package](https://pkgs.alpinelinux.org/packages?name=radvd).

This is a specialized deployment of radvd for use with BLE 6lowpan and
802.15.4 networks.

Included is an interface up trigger which assigns an IPv6 prefix to the
6lowpan interface as it goes up and down when nodes are connected and
disconnected.

## How to use this image

```
docker run --privileged -v /var/run/dbus:/var/dbus --network=host hub.foundries.io/radvd64
```

The following parameters can be added to the docker run command line for
IPv6 prefix customization:

- --interface: network interface for RADVD advertisements
  default: bt0
- --ipv6-prefix: IPv6 routing prefix for interface
  default: fd11:11::
- --ipv6-mask: IPv6 prefix mask for interface
  default: 64
- --disable-interface-trigger: disable interface monitor which assigns IP and route
  default: not disabled
- --enable-rdnss: enable RDNSS broadcast
  default: disabled

Example:
```
docker run --privileged -v /var/run/dbus:/var/dbus --network=host hub.foundries.io/radvd64 \
    --interface lowpan0 --ipv6-prefix "fd11:33::" --ipv6-mask 64 \
    --disable-interface-trigger --enable-rdnss
```
