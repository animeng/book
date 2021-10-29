#! /bin/sh
git pull
gitbook build
rm -rf docs
rm -rf _book/docs
cp -r _book docs
rm -rf _book
git add *
git commit -m 'publish'
git push origin  --force
