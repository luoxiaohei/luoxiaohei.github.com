@echo off
set commit_message=%1
git add --all
if not defined commit_message (
    commit_message = "Update Home Page")
git commit -a -m %commit_message%
git push github master:master
git push gitcafe master:gitcafe-pages