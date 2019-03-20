RADVD container based on [RADVD project](https://github.com/reubenhwk/radvd)
via Alpine Linux [RADVD package](https://pkgs.alpinelinux.org/packages?name=radvd).

This is a specialized deployment of radvd for use with BLE 6lowpan and
802.15.4 networks.

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
- --enable-rdnss: enable RDNSS broadcast
  default: disabled

Example:
```
docker run --privileged -v /var/run/dbus:/var/dbus --network=host hub.foundries.io/radvd64 \
    --interface lowpan0 --ipv6-prefix "fd11:33::" --ipv6-mask 64 --enable-rdnss
```
