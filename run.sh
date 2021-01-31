#!/bin/bash
docker build --tag vivaldi .
docker run -it -p 80:80 -p 22:22 -p 443:443 -p 56733:80 --name flask-ssh vivaldi