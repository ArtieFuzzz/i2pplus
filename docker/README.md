# I2P+ in Docker

## Quick start
If you just want to give I2P+ a quick try or are using it on a home network, follow these steps:

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/i2pplus/i2pplus:latest
docker run -d -p 7667:7667 -p 4444:4444 ghcr.io/i2pplus/i2pplus:latest
```

Then open http://127.0.0.1:7667 in your browser.

### Or build locally

1. Install git, docker-io and docker-compose via your package manager
2. Download the I2P+ git repository with the command: `git clone https://github.com/I2PPlus/i2pplus.git`
3. Rename `docker/docker-compose.yml` to `docker-compose.yml` in the root directory of your local I2P+ git workspace
4. As root, cd to the i2pplus git workspace you just downloaded and then execute `docker-compose up --build`
5. Start a browser and go to `http://127.0.0.1:7667` and then hit the Wizard link to configure your router
6. To stop the router, hit Ctrl+C and then, optionally, `docker-compose down`
7. To remove all existing cache files and generated images, run `docker system prune -a -f`

## Running a container

### Memory usage
By the default the image limits the memory available to the Java heap to 512MB. You can override that by modifying the `JVM_XMX` environment variable in the `docker/rootfs/startapp.sh` file.

### Ports
There are several ports which are exposed by the image. You can choose which ones to publish depending on your specific needs.

| Port     | Interface       | Description         | TCP/UDP   |
| -------- | --------------- | ------------------- | --------- |
| 4444     | 127.0.0.1       | HTTP Proxy          | TCP       |
| 6668     | 127.0.0.1       | IRC Proxy           | TCP       |
| 7654     | 127.0.0.1       | I2CP Protocol       | TCP       |
| 7656     | 127.0.0.1       | SAM Bridge TCP      | TCP       |
| 7657     | 127.0.0.1       | Web Console         | TCP       |
| 7667     | 127.0.0.1       | Web Console (SSL)   | TCP       |
| 7658     | 127.0.0.1       | I2P Webserver       | TCP       |
| 7659     | 127.0.0.1       | SMTP Proxy          | TCP       |
| 7660     | 127.0.0.1       | POP Proxy           | TCP       |
| 7652     | LAN interface   | UPnP                | TCP       |
| 7653     | LAN interface   | UPnP                | UDP       |
| RANDOM   | 0.0.0.0         | I2NP Protocol       | TCP+UDP   |

### Networking
At the minimum, you'll want the Router Console (7667) and the HTTP Proxy (4444) available on localhost or your LAN network. The services indicated above on 127.0.0.1 will only be available on localhost and should not be exposed to the public internet. They can be disabled in the I2P+ web console if not required. To change the listening address for these services, including the web console, uncomment and edit the `IP_ADDR` line in the startapp.sh file.

#### External Network Port (Random by Default)
By default, I2P+ uses a random port for the I2NP Protocol (TCP+UDP). This is recommended for security - avoid using a fixed port as it's fingerprintable. The port is assigned at first start and remains consistent for that container (stored in router.config).

**Set at build time:**
```bash
docker build --build-arg EXTERNAL_PORT=12345 -t i2pplus .
```

**Or set at runtime:**
```bash
docker run -e EXTERNAL_PORT=12345 i2pplus:latest
```

Your allocated port will be listed in your Router Web Console at http://127.0.0.1:7667/info. Note: This is the *only* port that you need to expose to the public internet, access to other ports should only be permitted from localhost or your LAN.

## Useful Docker Commands

### Build the image
```bash
# From project root
cd /home/rogue/i2pplus
docker build -t i2pplus:latest -f docker/Dockerfile .

# Save to file for transfer
docker save i2pplus:latest -o /tmp/i2pplus.tar

# Load from file
docker load -i /tmp/i2pplus.tar
```

### Run the container
```bash
# Basic run (random port, no persistence)
docker run -d --name i2pplus i2pplus:latest

# With port mapping
docker run -d -p 7667:7667 -p 4444:4444 -p 12345:12345/udp --name i2pplus i2pplus:latest

# With persistent config (survives container restart)
docker run -d -v /path/to/i2p-data:/i2p/.i2p \
           -v /path/to/snark:/i2psnark \
           -p 7667:7667 -p 4444:4444 \
           --name i2pplus i2pplus:latest

# Override JVM heap size
docker run -d -e JVM_XMX=1024m i2pplus:latest

# Override JAVA options
docker run -d -e JAVA17OPTS="-XX:+UseG1GC" i2pplus:latest
```

### Manage the container
```bash
# View logs
docker logs i2pplus
docker logs -f i2pplus  # follow

# Interactive shell (for debugging)
docker exec -it i2pplus /bin/bash

# Stop/Start
docker stop i2pplus
docker start i2pplus

# Remove container
docker rm -f i2pplus
```

### docker-compose
```bash
# Start
docker-compose up --build -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Troubleshooting
```bash
# Check container status
docker ps -a

# Check resource usage
docker stats i2pplus

# Check configuration
docker exec i2pplus cat /i2p/router.config

# Shell script syntax check
bash -n docker/rootfs/startapp.sh && echo "OK"
```

### Cleanup

#### Remove all data and restart fresh
```bash
# Stop and remove container
docker rm -f i2pplus

# Remove volumes (config, plugins, reseed data)
docker volume rm i2pplus_i2p-home  # or your volume name
docker volume rm i2pplus_i2psnark  # or your volume name

# Or if using bind mounts, delete the host directories
rm -rf /path/to/i2p-data
rm -rf /path/to/snark

# Rebuild and start fresh
docker build -t i2pplus:latest -f docker/Dockerfile .
docker run -d -v /path/to/i2p-data:/i2p/.i2p -v /path/to/snark:/i2psnark i2pplus:latest
```

#### Clear specific caches (without losing config)
```bash
# Enter container
docker exec -it i2pplus /bin/bash

# Clear router cache
rm -rf /i2p/.i2p/routerCache

# Clear profile (restart required to take effect)
rm -rf /i2p/.i2p/

# Clear I2PSnark torrents
rm -rf /i2psnark/*

# Exit container and restart
exit
docker restart i2pplus
```

#### Clean up Docker resources
```bash
# Remove stopped containers
docker container prune -f

# Remove unused images
docker image prune -a -f

# Remove unused volumes
docker volume prune -f

# Full cleanup
docker system prune -a -f
```

---