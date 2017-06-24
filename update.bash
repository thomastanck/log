#!/bin/bash
cd "$(dirname "$0")"

rm -rf thomastanck.github.io
hugo
