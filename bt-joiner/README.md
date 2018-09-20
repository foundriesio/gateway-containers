A Bluetooth LE 6LoWPAN joiner based on [bluez](http://www.bluez.org/about/).

## How to use this image

```
docker run --privileged --net=host hub.foundries.io/bt-joiner
```

To overwrite the default bt-joiner config values, create a local config file containing the desired options:

```
$ cat bluetooth_6lowpand.conf
HCI_INTERFACE=hci0
SCAN_WIN=3
SCAN_INT=6
MAX_DEVICES=15
```

Then start the container by overwriting bluetooth_6lowpand.conf:

```
docker run --privileged --net=host -v `pwd`/bluetooth_6lowpand.conf:/etc/bluetooth/bluetooth_6lowpand.conf hub.foundries.io/bt-joiner
```
