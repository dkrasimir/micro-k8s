#!/bin/sh
docker kill micro
docker rm micro
docker run -d -p 50080:8080 -p 50048:4848 --name micro 016973021151.dkr.ecr.us-west-2.amazonaws.com/dkrasimir/micro