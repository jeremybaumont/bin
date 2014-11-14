#!/usr/bin/env bash
pmset -g batt |  grep Internal |awk '{print $2}'| sed -e 's/;//'
