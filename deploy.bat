git add .
if "%1" == "" (
    git commit -a -m "Update Home Page") else (
    git commit -a -m %1)
git push github master:master
git push gitcafe master:gitcafe-pages