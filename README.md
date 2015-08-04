# What is Couchpotato?

Awesome PVR for usenet and torrents. Just fill in what you want to see and CouchPotato will add it to your "want to watch"-list. Every day it will search through multiple NZBs & Torrents sites, looking for the best possible match. If available, it will download it using your favorite download software.

> [More info](https://couchpota.to/)

![Sickrage](https://raw.githubusercontent.com/vSense/docker-couchpotato/master/logo.png)


# How to choose a tag

Available tags:
-   latest : based on master branch
-   develop : based on develop branch
-   supervisord-latest : based on master branch
-   supervisord-develop : based on develop branch

The above tags provide images with or without an init process (sickrage or supervisor as PID 1)

Depending on how you are planning to launch sickrage you have to choose the right image

# How to use this image.

Run Sickrage :

	docker run vsense/couchpotato:<yourtag>

You can test it by visiting `http://container-ip:5050` in a browser or, if you need access outside the host, on port 5050 :

	docker run -p 5050:5050 vsense/couchpotato:<yourtag>

You can then go to `http://localhost:5050` or `http://host-ip:5050` in a browser.

# Overriding

The image has two volumes :
-   /config : contains sickrage configuration
-   /downloads : contains the files downloads by the service provider of your choice : NZB, Torrents or Others. Also postprocessed files. You can pretty much drop whatever you want here it is sort of a data volume.

Couchpotato is installed in the /couchpotato directory but it is not a volume. If you wish to use host mount point instead of volumes it possible.

To use an on-host config (for persistent configuration if you do not want to deal with volumes, that I can understand :D) :

    docker run --restart=always --name couchpotato --hostname couchpotato -v /srv/configs/couchpotato:/config vsense/couchpotato

To mount your download folder (you will probably need to do that anyway) :

    docker run --restart=always --name couchpotato --hostname couchpotato -v /srv/configs/couchpotato:/config -v /srv/seedbox:/downloads vsense/couchpotato

You can even override couchpotato directory if you prefer to git clone on you host for whatever reason :

    docker run --restart=always --name couchpotato --hostname couchpotato -v /srv/couchpotato:/couchpotato vsense/couchpotato

And you can combin the commands above as you like :

    docker run --restart=always --name couchpotato --hostname couchpotato  -v /srv/seedbox:/downloads -v /srv/couchpotato:/couchpotato -v /srv/configs/couchpotato:/config vsense/couchpotato

# Recommanded running methods

## Running without init with Docker

```
docker run --restart=always --name couchpotato --hostname couchpotato  -v /srv/seedbox:/downloads -v /srv/configs/couchpotato:/config vsense/couchpotato
```

## Running with systemd (Preferred)

```
# /etc/systemd/system/couchpotato.service
[Unit]
Description=Couchpotato movie downloader
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker pull vsense/couchpotato
ExecStart=/usr/bin/docker run --rm --name couchpotato --hostname couchpotato -v /srv/configs/couchpotato:/config -v /srv/seedbox:/downloads vsense/couchpotato:supervisor-latest
ExecStop=/usr/bin/docker stop couchpotato
ExecReload=/usr/bin/docker restart couchpotato

[Install]
WantedBy=multi-user.target
```
