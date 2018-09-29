#!/bin/bash

wget -O- https://get.pharo.org/64/70+vm | bash || exit 1

./pharo-ui Pharo.image st scripts/loadImage.st

