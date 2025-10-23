# DietPi-Proxmox-LXC-container
Download and create a DietPi LXC container template wie simple shell script  
Does simple things, download DietPi Bookworm Image, mounts, make a tar file for Proxmox and put it in.  
Why Bookworm not Trixie? Ask Proxmox, they don't like Debian 13... 

## HOW TO USE?

1. ```wget https://raw.githubusercontent.com/VirusBurst/DietPi-Proxmox-LXC-container/refs/heads/main/dietpi-amd64-Bookworm-lxc-creator.sh```
2. ```chmod +x dietpi-amd64-Bookworm-lxc-creator.sh```
3. ```./dietpi-amd64-Bookworm-lxc-creator.sh```
4. profit?

## IMPORTANT STUFF

> [!IMPORTANT]
>After creating LXC container from template, go to Container -> Options -> Console mode => CHANGE to "shell"  
>Why? Because for some reasons, you get a blank screen and this is the easiest workaround for that...

> [!TIP]
>ALSO if for some reason, DietPi doesn't detect any network connection, just shutdown the LXC container and start it again...  
>Sooner or later it will work out with Proxmox and then it will work just fine ^^

### Why DietPi as LXC instead of VM?
Because I can...

###### Also Github... why the F do I need to add two spaces for a simple NewLine? Are you Micro$oft in BigBrain-Time?
