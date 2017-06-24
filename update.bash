#!/bin/bash
cd "$(dirname "$0")"

rm -rf thomastack.github.com
hugo
