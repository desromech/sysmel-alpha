#!/usr/bin/env bash
set -ex

DIST=artifacts/dist

mkdir -p $DIST/module-sources $DIST/third-party
cp --preserve=links -rf pharo-vm pharo pharo-ui $DIST
cp -rf sysmel.* sysmelc sysmelc-ui $DIST
cp -rf module-sources/* pharo-local/iceberg/**/abstract-gpu/bindings/sysmel/* $DIST/module-sources
cp -rf pharo-local/phanapi/libs/abstract-gpu/ $DIST/third-party/abstract-gpu
cp -rf LICENSE README.md docs tests samples $DIST
