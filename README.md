How to add to KASM (These screenshots are from the Windsurf-based Kasm image, but they’re the same.)

Get Dockerfile from this repo to KASM machine and run

```
sudo docker build -t custom-kasm:ubuntu-4devs -f Dockerfile .
```

![image](https://somnitelnonookay.ucoz.net/kasm-config1.png)

Ubuntu custom thumbnail: 
```
https://somnitelnonookay.ucoz.net/ubuntu4devs.png
```

![image](https://somnitelnonookay.ucoz.net/kasm-config2.png)

Docker image: 
```custom-kasm:ubuntu-4devs```

![image](https://somnitelnonookay.ucoz.net/kasm-config3.png)

Persistent profile path example: 
```/mnt/data/kasm/profiles/{username}/{image_id}```
If you don’t specify a persistent profile, your login session won’t be saved between Kasm Workspace restarts.

Docker run override config: 
```
{
  "environment": {
    "KASM_PROFILE_FILTER": "null"
  }
}
```
