@echo off
echo Start clean
cmd /c hexo clean
echo Start generate
cmd /c hexo g
echo Start deploy
cmd /c hexo d
echo Clean files
cmd /c hexo clean