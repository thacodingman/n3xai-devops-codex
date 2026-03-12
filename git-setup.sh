#!/bin/bash

GITHUB_USER=thacodingman
REPO=n3xai-devops-codex

git init

git add .

git commit -m "initial commit"

git branch -M main

git remote add origin https://github.com/$GITHUB_USER/$REPO.git

git push -u origin main