#!/bin/bash

# clear *.pyc files
. docker/clear-cache.sh

DEV_DOCKER=./docker/docker-compose-dev.yml
PROD_DOCKER=./docker/docker-compose.yml

if [ "$1" == "tests" ] ; then

	# run tests
	docker-compose -f $DEV_DOCKER run web pytest

elif [ "$1" == "-p" ] ; then
    # production server
    if [ "$2" == "migrate" ] ; then
        docker-compose -f $PROD_DOCKER run web flask db migrate
    elif [ "$2" == "upgrade" ] ; then
        docker-compose -f $PROD_DOCKER run web flask db upgrade
	elif [ "$2" == "-b" ] ; then
		# build new development image
		docker-compose -f $PROD_DOCKER up --build
	else
		docker-compose -f $PROD_DOCKER up
	fi

else
    if [ "$1" == "migrate" ] ; then
        docker-compose -f $DEV_DOCKER run web flask db migrate
    elif [ "$1" == "upgrade" ] ; then
        docker-compose -f $DEV_DOCKER run web flask db upgrade
	# development server
	elif [ "$1" == "-b" ] ; then
		# build new development server
		docker-compose -f $DEV_DOCKER up --build
	else
		docker-compose -f $DEV_DOCKER up
	fi
fi
