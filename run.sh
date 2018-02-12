#!/bin/bash

# ci-dessous : c'est long (un bon quart d'heure)
/usr/bin/docker build --rm --tag debian_9:mongo_3_4 ./
#/usr/bin/docker rm debian_9_mongo_3_4
#/usr/bin/docker rmi debian_9:mongo_3_4

/usr/bin/rm ./packages/*.deb
/usr/bin/rm ./out/mong*

/usr/bin/docker run --volume `/usr/bin/pwd`/out:/out --name debian_9_mongo_3_4 debian_9:mongo_3_4 /copy.sh
/usr/bin/docker rm debian_9_mongo_3_4

/usr/bin/sudo chown --recursive `/usr/bin/whoami`: out

/usr/bin/mv --force ./out/mongos ./packages/mongodb-org-mongos_3.4.11_amd64/usr/bin/
/usr/bin/mv --force ./out/mongod ./packages/mongodb-org-server_3.4.11_amd64/usr/bin/
/usr/bin/mv --force ./out/mongo ./packages/mongodb-org-shell_3.4.11_amd64/usr/bin/
/usr/bin/mv --force ./out/* ./packages/mongodb-org-tools_3.4.11_amd64/usr/bin/

/usr/bin/dpkg-deb --build ./packages/mongodb-org-mongos_3.4.11_amd64 ./packages/mongodb-org-mongos_3.4.11_amd64.deb
/usr/bin/dpkg-deb --build ./packages/mongodb-org-server_3.4.11_amd64 ./packages/mongodb-org-server_3.4.11_amd64.deb
/usr/bin/dpkg-deb --build ./packages/mongodb-org-shell_3.4.11_amd64 ./packages/mongodb-org-shell_3.4.11_amd64.deb
/usr/bin/dpkg-deb --build ./packages/mongodb-org-tools_3.4.11_amd64 ./packages/mongodb-org-tools_3.4.11_amd64.deb
/usr/bin/dpkg-deb --build ./packages/mongodb-org_3.4.11_amd64 ./packages/mongodb-org_3.4.11_amd64.deb