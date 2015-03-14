@echo off
echo Start deploy blog.
cmd /c deploy_blog > deploy_blog.log
echo Start upload source files.
cmd /c upload_source > upload_source.log
echo All work done.