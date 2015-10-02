# beaglebone-debian
Install Debian on Beagleboard Black and setup hostname and avahi via ansible

### Check requirements on laptop (client)
```
$ apt-get install -y ssh rsync
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

### Instructions, step by step
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

8. Setup SSH, and BeagleBone date
( current date of beagle is not correct, correct it otherwise you can have issues getting a ipv4 from dhcp server !! )
Script removes old host key, copy your public key to beagle and set beagle date.
```
$ git clone https://github.com/arainho/beaglebone-debian
$ cd beaglebone-debian
$ ./setup--ssh-and-date.sh
```

9. Change root password
```
$ ssh root@192.168.7.2
# passwd
```

10. Go to your laptop and install ansible
[following this installation steps](http://docs.ansible.com/ansible/intro_installation.html#installation)

11. After that run ansible-playbook to set up avahi, and hostname ( we choose 'mybeagle' )
```
$ cd beaglebone-debian/playbooks
```

12. Set variables on ansible playbook and run ansible
```
vi ansible-avahi.yml

   my_hostname: 
   timezone:
```

```
$ ./ansible-playbook -i beagle_host ansible-avahi.yml -vvv
```

13. Finally, you can connect to your Beagle like this
on Laptop with Mac OS X, or Linux with [Avahi](http://www.avahi.org/) you can do this
```
$ ssh root@mybeagle.local
```
on a Laptop with Windows OS you must install [Bonjour Print Services for Windows](https://support.apple.com/kb/DL999?viewlocale=en_US&locale=en_US)
and after that use [MobaXterm](http://mobaxterm.mobatek.net/) or [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) to connnect to your beagle.

### Additional info
If you want to upgrade your Beagle Debian OS do
```
$ ./ansible-playbook -i beagle_host upgrade-debian.yml -vvv
```
