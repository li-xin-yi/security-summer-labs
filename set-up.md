# Set-up

I'm trying to encapsulate all lab environments into Docker containers respectively. So users can access the environmeents without installing extra dependencies (skip Set-up section in each lab). The only thing you need to prepare is to install Docker on your (cloud) machine.

## Install Docker

````{tabbed} Windows

[Docker Desktop](https://www.docker.com/products/docker-desktop) is strongly recommended GUI to access containers. After the desktop client application installed, you can pull the image of a lab (e.g. lab 4) by `cmd` (or other terminals like PowerShell or WSL)

```
docker pull yangzhou301/lab4:lastest
```

When you open the Docker Desktop and select "Images" section, you can find the downloaded images:

![](figs/images)

Click "Run" and set:

![](figs/volume)
````

