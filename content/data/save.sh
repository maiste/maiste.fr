#!/usr/bin/env bash

# Saving script for crontab
# Étienne "maiste" Marais

# Check if the directory is clean or dirty
if output=$(git status --porcelain) && [ -z "$output" ]; then
  echo "Clear"
else
  DATE=$(date +"%d/%m/%Y")
  git add -A
  git commit -m "Logs $DATE"
  git push origin master
  echo "Done"
fi
