#!/usr/bin/env bash
# Simple shim to generate docs, also available as npm run docs.
# Exists since && is unixy so combining both commands via package.json won't
# work on windows

echo 'Generating html documentation...'
npm run --silent ghpages
echo 'Generating markdown documentation...'
npm run --silent wiki
