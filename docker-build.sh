#!/bin/sh
mvn clean install && docker build -t 016973021151.dkr.ecr.us-west-2.amazonaws.com/dkrasimir/micro .