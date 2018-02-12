# Docker container for building mongo 3.4 over Debian 9 and getting a .deb of that

Tested on fedora 27

## Usage
```
$ cd docker_compile_pkg_mongo_3_4_debian_9
$ docker build --rm --tag debian_9:mongo_3_4 ./
$ docker run --volume ./:/out --name debian_9_mongo_3_4 copy.sh
$ run.sh
$ docker rm debian_9_mongo_3_4
$ docker rmi debian_9:mongo_3_4
```
your packages are now in ./packages