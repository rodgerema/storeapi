# storeapi - Avature Technical Exercise ![image](https://github.com/rodriguezemanuel/storeapi/assets/137838409/9825173b-13ae-4fc6-b2e0-17e3c3db75c3)


* The following document was made to explain the whole process that involved successfully running the storeapi application.

# (1) **'insert' no such method exists**

In the beginning, the code was not working and showing the following error when trying to execute ADD method:

```bash
TypeError: 'Collection' object is not callable. If you meant to call the 'insert' method on a 'Collection'
object it is failing because no such method exists.
```

Looking into the [Pymongo](https://pymongo.readthedocs.io/en/stable/tutorial.html#:~:text=appropriate%20BSON%20types.-,Inserting%20a%20Document,-%23) documentation, I figure out that the method used in the code was deprecated in the newest Mongo version, and should be replaced by **insert_one** instead **insert**.


<img width="962" alt="image" src="https://github.com/rodriguezemanuel/storeapi/assets/137838409/470a6446-ef34-45a8-a062-b826f9dcb1a3">


# (2) **cannot encode object**

Resolved this, I ran into a new error showing some problem with JSON encoding

```bash
bson.errors.InvalidDocument: cannot encode object: <pymongo.results.InsertOneResult object at 0x7f0fce16ec50>,
of type: <class 'pymongo.results.InsertOneResult'>
```

Was fixed adding an additional step to split JSON response 

<img width="1044" alt="image" src="https://github.com/rodriguezemanuel/storeapi/assets/137838409/3b5c3bd7-4779-4bae-8ca9-691d9e7f07f6">

# (3) Dockerfile

Once the app was tested locally and worked fine, I built the image from a [Dockerfile](https://github.com/rodriguezemanuel/storeapi/blob/main/Dockerfile)

```bash
% docker build -t storeapi .

[+] Building 3.6s (11/11) FINISHED
 => [internal] load .dockerignore                                                                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                                                                   0.0s
 => [internal] load build definition from Dockerfile                                                                                                                                              0.0s
 => => transferring dockerfile: 452B                                                                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/python:3.8.9-alpine3.13                                                                                                                        3.6s
 => [auth] library/python:pull token for registry-1.docker.io                                                                                                                                     0.0s
 => [1/5] FROM docker.io/library/python:3.8.9-alpine3.13@sha256:e5bb2c97a121cbc773d56b55e744e2e67450bd9c1ea6b5c93af77061e745daea                                                                  0.0s
 => [internal] load build context                                                                                                                                                                 0.0s
 => => transferring context: 2.85kB                                                                                                                                                               0.0s
 => CACHED [2/5] ADD api/app.py /opt                                                                                                                                                              0.0s
 => CACHED [3/5] ADD requirements.txt /tmp                                                                                                                                                        0.0s
 => CACHED [4/5] WORKDIR /opt                                                                                                                                                                     0.0s
 => CACHED [5/5] RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt                                                                                                            0.0s
 => exporting to image                                                                                                                                                                            0.0s
 => => exporting layers                                                                                                                                                                           0.0s
 => => writing image sha256:7696a8285022c4ab6ac79b61c316b58a59dbb5dc3ce1bde0e04af41f2d084097                                                                                                      0.0s
 => => naming to docker.io/library/storeapi                                                                                                                                                       0.0s
```

The Mongodb was launched from the official mongo:latest image.

```bash
% docker run --name mongodb -d -p 27017:27017 mongo

Unable to find image 'mongo:latest' locally
latest: Pulling from library/mongo
a1df1d4a17c6: Pull complete
00cac3c1cd86: Pull complete
4918c863202f: Pull complete
15db68cff03f: Pull complete
495a8d4510bd: Pull complete
e81877556e7b: Pull complete
6a7222461baf: Pull complete
c70685e0a61f: Pull complete
2a36b0e1a54f: Pull complete
Digest: sha256:e3fa459b4f4b72f3257c67a23c145e250b8b5700f033860392c68539b998bbe3
Status: Downloaded newer image for mongo:latest
f8b3bbe0a7b2dde1705056a0334d34faf88a843843bf6944fb315910a9926153
```

Finally, the storeapi was launched from the image generated in the fisrt step.

```bash
% docker run -d --name storeapi -p 5000:5000 --link mongodb:mongodb storeapi

f396d8389387beb63a3b29844fce7e30d76ae7a9e612c0beb720c847698a908f
```

All necessary containers are running.

```bash
% docker ps -a

CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS          PORTS                                           NAMES
f396d8389387   storeapi   "python3 -m flask ru…"   43 seconds ago   Up 42 seconds   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp       storeapi
f8b3bbe0a7b2   mongo      "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    0.0.0.0:27017->27017/tcp, :::27017->27017/tcp   mongodb
```

# (4) docker-compose

* Docker Compose is a tool that was developed to help define and share multi-container applications.
* With Compose, we can create a YAML file to define the services and with a single command, can spin everything up or tear it all down.

The [docker-compose](https://github.com/rodriguezemanuel/storeapi/blob/main/docker-compose.yaml) file includes each services (containers) that should be run together in a single operation.  

In only one file you can build and run your applications executing only one command, like this:

```bash
% docker-compose up -d

[+] Running 11/11
 ! api Warning                                                                                                                                                                                   12.0s
 ✔ mongodb 9 layers [⣿⣿⣿⣿⣿⣿⣿⣿⣿]      0B/0B      Pulled                                                                                                                                           37.2s
   ✔ a1df1d4a17c6 Pull complete                                                                                                                                                                   6.1s
   ✔ 00cac3c1cd86 Pull complete                                                                                                                                                                   6.2s
   ✔ 4918c863202f Pull complete                                                                                                                                                                   6.3s
   ✔ 15db68cff03f Pull complete                                                                                                                                                                   9.3s
   ✔ 495a8d4510bd Pull complete                                                                                                                                                                   9.3s
   ✔ e81877556e7b Pull complete                                                                                                                                                                   9.3s
   ✔ 6a7222461baf Pull complete                                                                                                                                                                  13.8s
   ✔ c70685e0a61f Pull complete                                                                                                                                                                  22.6s
   ✔ 2a36b0e1a54f Pull complete                                                                                                                                                                  22.6s
[+] Building 3.2s (11/11) FINISHED
 => [api internal] load build definition from Dockerfile                                                                                                                                          0.0s
 => => transferring dockerfile: 452B                                                                                                                                                              0.0s
 => [api internal] load .dockerignore                                                                                                                                                             0.0s
 => => transferring context: 2B                                                                                                                                                                   0.0s
 => [api internal] load metadata for docker.io/library/python:3.8.9-alpine3.13                                                                                                                    3.2s
 => [api auth] library/python:pull token for registry-1.docker.io                                                                                                                                 0.0s
 => [api 1/5] FROM docker.io/library/python:3.8.9-alpine3.13@sha256:e5bb2c97a121cbc773d56b55e744e2e67450bd9c1ea6b5c93af77061e745daea                                                              0.0s
 => [api internal] load build context                                                                                                                                                             0.0s
 => => transferring context: 201B                                                                                                                                                                 0.0s
 => CACHED [api 2/5] ADD api/app.py /opt                                                                                                                                                          0.0s
 => CACHED [api 3/5] ADD requirements.txt /tmp                                                                                                                                                    0.0s
 => CACHED [api 4/5] WORKDIR /opt                                                                                                                                                                 0.0s
 => CACHED [api 5/5] RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt                                                                                                        0.0s
 => [api] exporting to image                                                                                                                                                                      0.0s
 => => exporting layers                                                                                                                                                                           0.0s
 => => writing image sha256:79a964630b4bdfd77ba3fae5f0e531fa1f05a8abfdfa014251d4a632071da1a7                                                                                                      0.0s
 => => naming to docker.io/library/storeapi                                                                                                                                                       0.0s
[+] Running 3/3
 ✔ Network storeapi_default  Created                                                                                                                                                              0.0s
 ✔ Container mongodb         Started                                                                                                                                                              0.4s
 ✔ Container storeapi        Started                                                                                                                                                              0.7s
```
