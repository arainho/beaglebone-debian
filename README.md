# beaglebone-debian
Setup Beagleboard Black hostname and avahi via ansible

### install requirements on laptop
```
$ apt-get install -y ssh rsync
```

### run ansible-playbook on laptop
```
$ git clone https://github.com/arainho/beaglebone-debian
$ cd beaglebone-debian
$ ./ansible-playbook -i beagle_host ansible-avahi.yml -vvv
```

### python3 notes
Check your python version
```
$ python -V
```

If your OS uses python3 do the following
```
$ export ansible_python_interpreter="/usr/bin/python2"
```

### Requirements, step by step
0. download Debian image file "Debian (BeagleBone, BeagleBone Black - 4GB SD)" on [beagleboard.org] (http://beagleboard.org/latest-images)

1. check md5sum and compare with website md5: info
```
$ md5sum bone-debian-7.8-lxde-4gb-armhf-2015-03-01-4gb.img
```

2. uncompress image
```
$ unxz bone-debian-7.8-lxde-4gb-armhf-2015-03-01-4gb.img.xz
```

3. insert microSD card on your laptop, and check device letter
```
$ USB_DEVICE=$(dmesg | grep "Attached SCSI removable disk" | tail -n 1 | cut -d "]" -f 2 | cut -d "[" -f 2)
$ echo $USB_DEVICE
```

4. burn the image on microSD card as root, or with sudo
( Be careful!" dd_rescue can wipe your data! )
```
$sudo dd_rescue bone-debian-7.8-lxde-4gb-armhf-2015-03-01-4gb.img /dev/sdg
```

5. Insert microSD card on BeagleBone
6. connect usb cable to your laptop
7. Check if you have a new interface on Laptop, in my case is "enp0s26f7u3"
   if you don't have a ip, request it on the new interface :-)
```
$ dhclient enp0s26f7u3
$ ifconfig | grep 192.168.7.1 -B1 -A1
```

8. Connect to BeagleBone
```
$ ssh root@192.168.7.2
```

9. Change root password
```
# passwd
```

10. Finally, go to your laptop and run ansible-playbook to set up avahi, and hostname

### Extra
 you want to upgrade your Beagle Debian OS do
```
$ ./ansible-playbook -i beagle_host upgrade-debian.yml -vvv
```
