# Docker Sonarr

### Ports
- **TCP 8989** - Web Interface

### Volumes
- **/config** - Sonarr configuration data
- **/downloads** - Completed downloads from download client
- **/tv** - Sonarr media folder

Docker runs as uid 65534 (nobody on debian, nfsnobody on fedora). When mounting volumes from the host, ensure this uid has the correct permission on the folders.

## Running

The quickest way to get it running without integrating with a download client or media server (plex)
```
sudo docker run --restart always --name sonarr -p 8989:8989 -v /path/to/your/tv/folder/:/tv -v /path/to/your/completed/downloads:/downloads x0nic/sonarr
```

You can link to the download client's volumes and plex using something similar:
```
sudo docker run --restart always --name sonarr --volumes-from plex --link plex:plex --volumes-from deluge --link deluge:deluge -p 8989:8989 x0nic/sonarr
```
