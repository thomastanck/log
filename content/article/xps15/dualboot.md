+++
categories = [
"articles",
]
date = "2017-06-18T05:51:46Z"
tags = [
"article",
]
draft = true
title = "Dell XPS 15 9560: Dualbooting Windows 10 and Ubuntu 16.04.2 LTS"

+++

I bought a [Dell XPS 15 9560](https://www.amazon.com/Dell-XPS9560-7001SLV-PUS-Laptop-Nvidia-Gaming/dp/B01N1Q0M4O) today
and decided to set up both Ubuntu and Windows on the laptop.

My XPS 15 has a 512GB SSD and a 3840x2160 touchscreen.
Note that 512GB is in [GB](https://en.wikipedia.org/wiki/Gigabyte) and not in [GiB](https://en.wikipedia.org/wiki/Gibibyte),
so you will see both Windows/Ubuntu reporting the size as
around 476 "GB/GiB".

I'm pretty happy about the size of the SSD,
but since I'm trying to install
not one but two operating systems
on the laptop,
I decided in the end to go with
three major splits:
Windows OS (100GB),
Ubuntu OS (100GB),
and a shared media partition (312GB).
The shared media partition will be formatted in
ntfs
as it seems that the
ntfs-3g #link#
driver for Linux is pretty good.
<!--more-->

# TL;DR

1. Note down your Windows 10 Product ID, Product Key, Microsoft Office Product key(s) if installed, and MacAfee Product key if installed
2. Disable hibernation/fast boot
3. Boot into BIOS
4. Disable Secure Boot
5. Change SATA mode to AHCI
6. Boot into Ubuntu Live USB
7. Image back up (26GB storage, use FTP/USB to transfer to a different computer, etc)
8. (Optional) <s>Nuke </s>Reformat SSD
9. Install Windows
10. Install Ubuntu
11. Create shared media partition
12. Buy lakeside property (not included under warranty)
13. Enjoy your new laptop

## What you will need

- **5GB** USB
- **26GB** of storage for the backup and FTP/a large USB
- **10 hours** of your time:
1-2 hours to set everything up,
8 hours to troubleshoot when things inevitably go wrong

# Pre-installation

## Factory back up

The first step is to back up
the entire drive
after receiving the laptop in factory condition.
This is to allow you to safely resell your laptop
or to roll back your changes if you messed up.

If you set up the laptop at the store,
you will need to
disable Hibernation and Fast startup
from within Windows 10
to allow proper shutdown of the laptop
and boot into Linux.

If you did not ever boot into the laptop even once,
you can skip this step for now,
and return to it later.

### Disable Fast startup and Hibernation

Do this step if you have already booted into Windows 10.
If not, skip this step.

1. Open a command prompt as Administrator
2. `$ powercfg /h off` to turn off hibernate
3. **Start** > 'old' **Control Panel** > **Power Options**
4. Click **Choose what the power buttons do**
5. Click **Change settings that are currently unavailable**
6. Uncheck **Turn on fast startup** under the **Shutdown Settings**
7. Shutdown the computer

However,
note that I could not disable fast startup,
as I was not able to find
any "fast startup" option to disable.
In the end I just skipped those steps
and it still worked.

### Boot into BIOS settings

Power on the computer
and spam **F2**
to get into the BIOS settings.

1. Navigate to **Secure Boot** > **Secure Boot Enable**
2. Disable Secure Boot and apply changes
3. Navigate to **System Configuration** > **SATA Operation**
4. Change option to **AHCI** and apply changes

![Disabling Secure Boot](/article/xps15/secure-boot.png)

*Image taken from Dell support ([link](http://www.dell.com/support/article/sg/en/sgdhs1/sln142679/en))*

![Changing SATA Operation to AHCI](/article/xps15/sata-ahci.jpeg)


*Image taken from @sebvance at Medium ([link](https://medium.com/@sebvance/how-to-upgrade-a-dell-xps-15-9550-to-a-samsung-960-evo-nvme-m-2-ssd-1d64eed914a9))*

### Boot into Ubuntu Live USB

Restart the computer
and spam **F12**.
You should see two options,
Windows,
and your USB drive.
Select the USB
and boot into Ubuntu.

### Full image back up

First, mount the FTP/USB drive
that you intend to store the back up within.
You will need at least 26GB
to to store the back up.

First open **Disks**
and find your internal SSD device number.
Mine was `/dev/nvme0n1`.

Now open **Terminal**
and run the command

```sh
sudo dd bs=4M if=/dev/nvme0n1 | gzip
```

If you're using a USB drive that's formatted with FAT32
(as I did with mine),
then you'll want to use the following command to ensure that the file size does not exceed 4GB.

```sh
sudo dd bs=4M if=/dev/nvme0n1 | gzip | split -b 2048MiB - /media/ubuntu/<USB stick>/dell-image.gz.part-
```

Now shut the computer down.

## Prepping the Windows install USB

You can do this either on a different computer
or on the preinstalled Windows operating system.
As Microsoft provides a tool
to create install USBs,
using a Windows computer to create the USB
might be the most straightforward.
Note that I used a Macbook Pro
to create the installation USB
so I will not be of very much help here.

Boot into the BIOS again
by spamming **F2** on startup
and change the **SATA Operation** mode
back to **RAID On**,
and boot into Windows 10.

Set it up if you haven't yet.
I suggest disabling all the tracking options
during the Customize stage.

Obtain a copy of Windows 10 from the [official Windows 10 website](https://www.microsoft.com/en-us/software-download/windows10ISO)
and install it on the USB.
I'm hoping it's straightforward enough.

Now you need to disable
Hibernation and Fast startup
in order to properly shut the computer down.

### Prepping the Windows install USB using a Mac

This is the method I used
since I already own a Macbook Pro.

If you use this method,
you will never need to boot into Windows 10
and so you can safely skip
disabling Hibernation and Fast startup.

1. Obtain a copy of Windows 10 from the [official Windows 10 website](https://www.microsoft.com/en-us/software-download/windows10ISO).
2. Open the **Boot Camp Assistant** app.
3. Click **Continue**
4. Uncheck all boxes except **Create a Windows 7 or later install disk**.
5. Click **Continue**.
6. Ensure that the wizard has detected the right USB.
7. If the wizard did not automatically detect your Windows 10 image, drag it into the installer.
8. Click **Continue** until it's all over.

## Nuking the SSD

Open **GParted Partition Editor**
and create a new **GPT** partition table
on your internal SSD
via **Device** > **Create new partition table**.
This should effectively remove
*all* traces of Dell/bloatware/product tracking
from your computer.

Execute the changes by clicking the green arrow
and shut the computer down.

Now that we're done with the prep work,
we can actually start installing operating systems.

# Install

To recap,
the plan is to
install Windows (100GB),
then install Ubuntu (100GB),
and finally create a shared media partition (312GB).

## Windows

Stick your Windows 10 install USB in
and click through
until it asks if you want to
Upgrade and keep all files or to
perform an Advanced install.
We want to perform an Advanced install
so we can control the partitions.

You should now see your internal SSD
made out of completely unallocated space.
Click the **New** button
and type **100000** MB into the size box.
This will tell Windows to only use 100GB for the install.

Click through further
using common sense
to complete the setup
the way you want it.

Disable Hibernate and Fast startup
(yes this is becoming a trend)
to properly shut the computer down.

## Ubuntu

Stick your Ubuntu install USB in
and click through a bit
until it asks you:

"This computer currently has Windows Boot Manager on it. What would you like to do?"

Choose **Something else**
as we want to tell Ubuntu to only use 100GB.

Click the _second_ free space device
(it should be quite large)
then click the + icon on the bottom left.
Set the size to 80000 MB
and the Mount point to `/`.
This will be your primary Ubuntu partition.

Now create a swap partition
by clicking the + icon again,
setting the size to 20000 MB
and **Use as:** to **swap area**.

I decided on 20 GB swap
as I have 16 GB of RAM
and I would like to reserve at least that much for hibernation.

> Optionally, you can set the bootloader
> to be installed on partition 5 (the Ubuntu partition)
> and then use EasyBCD on Windows
> to point the Windows bootloader to Ubuntu.
> Leaving this option will tell Ubuntu
> to overwrite the existing bootloader with GRUB 2,
> which might be ugly or not to your liking.

Now click **Continue**
and use common sense
to complete the installation.

## Shared media drive

Boot into Ubuntu
and install **GParted Partition Editor**
if it isn't already installed,
then create a new ntfs partition
that fills the space remaining.

## Additional tweaks

### HiDPI scaling

The very first thing I noticed
when I installed Ubuntu was that
everything was extremely tiny
as the XPS 15 has a 4k screen.

Tap the windows key
and open up the Displays preference dialog,
and change the
**Scale for menu and title bars** slider to around *2.5*

### mtrack

I highly suggest
installing a custom touchpad driver
like mtrack
because I personally find tap to drag absolutely horrific
since it delays the time your taps take effect.
Disabling tap to drag is also annoying
since dragging/selecting is such a common operation.

Instead I much prefer OS X's *three finger drag*
as it solves both problems at the same time.
The only driver I could find that actually does this is mtrack.

To install it, run:

```sh
sudo apt install xserver-xorg-input-mtrack-hwe-16.04
sudo gedit /etc/X11/xorg.conf.d/90-mtrack.conf # Configure mtrack
sudo gedit /usr/share/X11/xorg.conf.d/60-libinput.conf # Disable existing touchpad driver
sudo systemctl restart lightdm.service # Will log out out of your system forcefully
```

You may need to
add yourself to the input group
if it doesn't work,
so that the mtrack driver can
open the /dev/input/device\* device file.

```sh
sudo gpasswd -a $USER input
logout # and back in for the group to take effect
```

### TLP

Save power.

Running i3wm,
I had ~6 hours battery life just idling.
After installing TLP,
it increased to ~8 hours.

```sh
sudo apt install tlp
```

### Hybrid suspend

Honestly not exactly sure what this does,
but I think this causes the laptop to hibernate
when you close the laptop lid.

Follow the instructions at the last 2 sections of
[https://karlgrz.com/dell-xps-15-ubuntu-tweaks/](https://karlgrz.com/dell-xps-15-ubuntu-tweaks/)
