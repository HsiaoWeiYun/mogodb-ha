#!/bin/bash


#創建primary slave arbiter, 啟用內部驗證機制(key_file), 設定admin帳號與權限, 設定test db 帳號與權限

docker network rm mongo-ha
docker network create mongo-ha
docker volume rm mongo_ha_primary_storage
docker volume create --name mongo_ha_primary_storage
docker volume ls
docker run --name mongo-primary -v mongo_ha_primary_storage:/data -d mongo --smallfiles
openssl rand -base64 741 > mongo-keyfile
docker exec mongo-primary bash -c 'mkdir /data/admin'
docker exec mongo-primary bash -c 'mkdir /data/admin/keyfile'
docker exec mongo-primary bash -c 'mkdir /data/admin/config'
docker exec mongo-primary bash -c 'mkdir /data/log'
docker cp ./config/mongod.conf mongo-primary:/data/admin/config/
docker cp admin.js mongo-primary:/data/admin/
docker cp replica.js mongo-primary:/data/admin/
docker cp mongo-keyfile mongo-primary:/data/admin/keyfile/
docker exec mongo-primary bash -c 'chown -R mongodb:mongodb /data'
docker exec mongo-primary bash -c 'chmod 600 /data/admin/keyfile/mongo-keyfile'

docker rm -f mongo-primary

docker run --name mongo-primary \
-v mongo_ha_primary_storage:/data \
-p 7017:27017 \
--network mongo-ha \
--env-file env \
-d mongo \
--keyFile /data/admin/keyfile/mongo-keyfile \
--replSet 'mongodb-cluster' \
--config /data/admin/config/mongod.conf




docker volume rm mongo_ha_slave_storage
docker volume create --name mongo_ha_slave_storage
docker volume ls
docker run --name mongo-slave -v mongo_ha_slave_storage:/data -d mongo --smallfiles

docker exec mongo-slave bash -c 'mkdir /data/admin'
docker exec mongo-slave bash -c 'mkdir /data/admin/keyfile'
docker exec mongo-slave bash -c 'mkdir /data/admin/config'
docker exec mongo-slave bash -c 'mkdir /data/log'
docker cp ./config/mongod.conf mongo-slave:/data/admin/config/
docker cp admin.js mongo-slave:/data/admin/
docker cp replica.js mongo-slave:/data/admin/
docker cp mongo-keyfile mongo-slave:/data/admin/keyfile/
docker exec mongo-slave bash -c 'chown -R mongodb:mongodb /data'
docker exec mongo-slave bash -c 'chmod 600 /data/admin/keyfile/mongo-keyfile'

docker rm -f mongo-slave

docker run --name mongo-slave \
-v mongo_ha_slave_storage:/data \
-p 7018:27017 \
--network mongo-ha \
--env-file env \
-d mongo \
--keyFile /data/admin/keyfile/mongo-keyfile \
--replSet 'mongodb-cluster' \
--config /data/admin/config/mongod.conf




docker volume rm mongo_ha_arbiter_storage
docker volume create --name mongo_ha_arbiter_storage
docker volume ls
docker run --name mongo-arbiter -v mongo_ha_arbiter_storage:/data -d mongo --smallfiles

docker exec mongo-arbiter bash -c 'mkdir /data/admin'
docker exec mongo-arbiter bash -c 'mkdir /data/admin/keyfile'
docker exec mongo-arbiter bash -c 'mkdir /data/admin/config'
docker exec mongo-arbiter bash -c 'mkdir /data/log'
docker cp ./config/mongod.conf mongo-arbiter:/data/admin/config/
docker cp admin.js mongo-arbiter:/data/admin/
docker cp replica.js mongo-arbiter:/data/admin/
docker cp mongo-keyfile mongo-arbiter:/data/admin/keyfile/
docker exec mongo-arbiter bash -c 'chown -R mongodb:mongodb /data'
docker exec mongo-arbiter bash -c 'chmod 600 /data/admin/keyfile/mongo-keyfile'

docker rm -f mongo-arbiter

docker run --name mongo-arbiter \
-v mongo_ha_arbiter_storage:/data \
-p 7019:27017 \
--network mongo-ha \
--env-file env \
-d mongo \
--keyFile /data/admin/keyfile/mongo-keyfile \
--replSet 'mongodb-cluster' \
--config /data/admin/config/mongod.conf

sleep 10
docker exec mongo-primary bash -c 'mongo /data/admin/replica.js'
sleep 30
docker exec mongo-primary bash -c 'mongo /data/admin/admin.js'