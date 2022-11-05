cp -r abstr tmp
cp $@ tmp
sed -i '.bak' '/^package/d' tmp/*.java
~/Desktop/vercors-1.4.0/bin/vercors --silicon tmp/*.java
rm -r tmp
