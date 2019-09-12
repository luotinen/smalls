#!/bin/bash
DATA="/mnt/d/Steam/steamapps/common/Skyrim Special Edition/Data"
COMPILER="$DATA/../Papyrus Compiler/PapyrusCompiler.exe"
BUILD="Temp-Build"
SOURCE="$BUILD/Source"
OUTPUT="$BUILD/Output"

source ./version.sh

mkdir -p "$DATA/$BUILD"
mkdir -p "$DATA/$SOURCE"
mkdir -p "$DATA/$OUTPUT"

echo "Copying source"
chmod -R u+rw Source

cp Source/Scripts/* "$DATA/$SOURCE/"
cp Smalls.flg "$DATA/$SOURCE"

echo "int property pMajorVersion = $MAJOR AutoReadOnly\r" >> "$DATA/$SOURCE/SmallsQuest.psc"
echo "int property pMinorVersion = $MINOR AutoReadOnly\r" >> "$DATA/$SOURCE/SmallsQuest.psc"
echo "int property pPatchVersion = $PATCH AutoReadOnly\r" >> "$DATA/$SOURCE/SmallsQuest.psc"
echo "int property pBuildNumber = $BUILD_NO AutoReadOnly\r" >> "$DATA/$SOURCE/SmallsQuest.psc"

echo "Compiling"
pushd "$DATA"
ls "$SOURCE"

"$COMPILER" "$SOURCE" -all -o="$OUTPUT" -i="Scripts/Source" -i="Source/Scripts" -f="$SOURCE/Smalls.flg"

echo "Copying Output"
cp "$OUTPUT/"*.pex "Scripts/"
cp "$SOURCE/"*.psc "Source/Scripts/"
popd

touch "$DATA/Smalls.esp"

cp "$DATA/$OUTPUT"/*.pex Scripts/
cp "$DATA/Smalls.esp" .
rm -r "$DATA/$BUILD"
