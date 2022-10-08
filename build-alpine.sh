#!/bin/sh

rm -rf output-alpine-* 

packer build \
    --var-file="alpine-builder.json" \
    --var-file="alpine-3.15.6.json" \
    alpine.json
