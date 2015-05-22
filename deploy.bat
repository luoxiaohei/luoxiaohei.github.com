@echo off
set commit_message=%1
if not defined commit_message (
    set commit_message="Update Home Page")
git add .
git commit -a -m %commit_message%
git push github master:master
git push gitcafe master:gitcafe-pages