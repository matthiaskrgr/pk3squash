#!/bin/bash
inputPk3 = $1

echo "Extracting"
unzip -d extractDir $1
cd extractDir

echo "Converting"
for file in `find . | grep "\.tga"`; do # in theory we could make this parallel
	convert ${file} "${file%.tga}.png" # tga -> png
	$FLIF -e "${file%.tga}.png" "${file%.tga}.flif" # png -> flif
	rm -f ${file} # rm tga
	rm -f ${file%.tga}.png # rm png
done

for file in `find . | grep "\.png"`; do # in theory we could make this parallel
	$FLIF -e "${file%.png}.png" "${file%.png}.flif" # png -> flif
	rm -f ${file%.png}.png # rm png
done

echo "Compressing"
mksquashfs * ../${1}.sqfs -comp xz -Xdict-size "100%"
cd .. # clean up
rm -fr extractDir
