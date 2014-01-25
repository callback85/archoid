# archoid.sh: install archlinux into an android chroot
# ====================================================

# (c) callback85, 2014-01-25, Kyiv, Ukraine

if [ -e '/system/bin/sh' ];
then

  # ADB SHELL
  # ---------

  # set $device to your sd2 (linux) partition

  device='/dev/block/mmcblk1p2';
  mountpoint='/data/local/mnt';

  mkdir -p "$mountpoint";
  mount -t ext2 "$device" "$mountpoint";
  
  for dir in 'dev' 'proc' 'sys';
  do 
    mkdir -p "$mountpoint/$dir";
  done;
  
  mount -o bind '/dev' "$mountpoint/dev/";
  mount -t proc proc "$mountpoint/proc/";
  mount -t sysfs sys "$mountpoint/sys/";
  mount -t devpts \
    -o rw,nosuid,noexec,gid=5,mode=620,ptmxmode=000 \
    pts "$mountpoint/dev/pts/";

  cp \
    "/sdcard/archoid.sh" \
    "$mountpoint/root/archoid.sh" || exit 1;

  chroot "$mountpoint" \
    /usr/bin/su - -c \
      'bash /root/archoid.sh' || exit 1;

elif test \
  -e '/bin/bash' \
  -a "$(id -u)" == "0" \
  -a "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)";
then

  # ARCH CHROOT
  # -----------

  if [ ! "$(groups root | grep android_inet | grep android_net-raw)" ];
  then

    echo;
    echo '---------------------------------------------------------';
    echo;
    echo;
    echo 'android-specific:';
    echo 'users can connect to the internet if they are members of:';
    echo;
    echo 'group 3003: android_inet';
    echo 'group 3004: android_net-raw';
    echo;
    echo;
    echo '---------------------------------------------------------';
    echo;

    groupadd -g 3003 android_inet;
    groupadd -g 3004 android_net-raw;

    gpasswd -a root android_inet;
    gpasswd -a root android_net-raw;

    sync;

    echo;
    echo '-------------------------------------------------------';
    echo;
    echo;
    echo 'root was modified, one should reboot android';
    echo 'reboot cannot be done from chroot so you do it manually';
    echo;
    echo;
    echo '-------------------------------------------------------';
    echo;

  else

    if [ ! -e '/.installed' ];
    then

      echo;
      echo '-----------------------------------------';
      echo;
      echo;
      echo 'android version of linux kernel is in use';
      echo 'there are no pci devices to support';
      echo 'arch is installed into an ext2';
      echo 'vim is downloaded later';
      echo;
      echo 'space is limited...';
      echo;
      echo;
      echo '-----------------------------------------';
      echo;

      pacman -Rcns --noconfirm \
        linux-{firmware,odroid-xu} pciutils {reiser,x}fsprogs nano vi || exit 1;
      pacman -Sc --noconfirm || exit 1;
      sync;

      echo 'domain google.com' > /etc/resolv.conf;
      echo 'nameserver 8.8.8.8' >> /etc/resolv.conf;
      sync;

      pacman -Syu --needed --noconfirm openssh vim p7zip {,un}zip || exit 1;
      sync;

      # free a little more space if there are old pkg files around
      pacman -Sc --noconfirm;
      sync;

      pacman-optimize;
      ln -sv /usr/bin/vim /usr/local/bin/vi;
      ln -sv /usr/bin/vim /usr/local/bin/nano;
      echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config;
      echo 'Protocol 2' >> /etc/ssh/sshd_config;
      passwd;
      sync;
      touch /.installed;

    fi

    /usr/bin/ssh-keygen -A;
    /usr/bin/sshd;
    sync;

    echo;
    echo '----------------------------------------------------------';
    echo;
    echo;
    echo 'There is a working archlinux installation on your android.';
    echo 'You are all under shell, without the powers of systemd.';
    echo 'Still, you have a fully functional gnu/linux system.';
    echo 'Play around with nginx, node.js, mysql, whatever.';
    echo 'No warranties on stability or security though.';
    echo;
    echo;
    echo 'Root-ssh is available at the following interfaces:';
    echo;
    ip -o addr | awk '!/^[0-9]*: link\/ether/ {gsub("/", " "); print $2" "$4}';
    echo;
    echo;
    echo '----------------------------------------------------------';
    echo;

    # handy ip awk: http://stackoverflow.com/a/12624100

  fi

else

  less "$(cd "$(dirname "$0")"; pwd -P)/README.markdown";

fi
