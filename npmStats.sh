#!/usr/bin/env bash
# npmStats.sh by Amory Meltzer
# Bulk get npm stats for a given eslint option

eslint --ext .js -c .eslintrc.json . --rule "$1" 2>/dev/null
