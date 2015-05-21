@echo off
echo Start deploy blog.
cmd /c deploy_blog.bat > deploy_blog.log
echo Start upload source files.
cmd /c upload_source.bat > upload_source.log
echo All work done.