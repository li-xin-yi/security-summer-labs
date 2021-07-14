# \*Appendix: How to Create Prepared VMs for Labs

## Create a Ubuntu VM on VirtualBox

Download [`ubuntu-20.04.2.0-desktop-amd64.iso`](https://ubuntu.com/download/desktop/thank-you?version=20.04.2.0&architecture=amd64) image file from [Ubuntu official website](https://ubuntu.com/download/desktop)

Start VirtualBox, click `New` button to create an empty Ubuntu VM, assign dynamically hard disk storage to it (I set it as 30 GB) 

![](figs/create_image.png)

Run the newly created VM and select the image downloaded as the start-up disk.

![](figs/load_image.png)

## Install Wireshark


Start a terminal and run

```
sudo dpkg-reconfigure wireshark-common
```

select `yes` and confirm, then run

```
sudo adduser $USER wireshark
```

Restart or log out. When you come back to this VM, you can lanuch Wireshark without root priviledge.


## Lab 4

Install dependencies

```
$ sudo apt-get install git openssl lsb-release cmake wget python3-pip
```

Install Modules

```
$ pip3 install phe[cli] Pyfhel
```

Update the environment variable by:

```
$ sudo gedit ~/.bashrc
```

Append

```sh
export PATH=$HOME/.local/bin:${PATH}
```

to the end of the file.

## Lab 3

Clone `openabe`

```
git clone https://github.com/zeutro/openabe
```

Set `ZROOT` (otherwise, `bison` cannot be found during building)

```sh
export ZROOT=${HOME}/openabe 
```

In case it cannot fetch `gtest` by `curl`, run

```
sudo apt-get install ca-certificates
printf "\nca_directory=/etc/ssl/certs/" | sudo tee -a /etc/wgetrc
```

```
cd openabe
sudo -E ./deps/install_pkgs.sh
. ./env
export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/:${LD_LIBRARY_PATH}"
make
sudo -E make install
```