#!/bin/sh

FILENAME=`ls -t1 release/*.ipa | head -n1`
DSYM=`ls -t1 release/*.zip | head -n1`
CHANGES=$CHANGES_SINCE_LAST_SUCCESS' Uploaded from testFlight api. '
curl http://testflightapp.com/api/builds.json \
	-F file=@$FILENAME \
	-F api_token='3340863aefe692887638cdf5dfa7a10e_MTY0NjUyMjAxMS0wOS0yMyAxMToxMzo0OC4yODQ2OTM' \
	-F team_token='bb7861c4bcaa8ed7d266d1e8e02facb0_MTg5MzE4MjAxMy0wMi0yMCAwMTozNzozNy4xNDgxMDA' \
	-F notes="$CHANGES" \
	-F notify=False \
	-F dsym=@$DSYM \
	-F distribution_lists='developers, All'
 
