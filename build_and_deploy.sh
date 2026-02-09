#!/bin/bash

VER=$1
GROUP=ca.hedlund
ARTIFACT_BASE=libjpraat
REPO=github-ghedlund
REPO_URL=https://maven.pkg.github.com/ghedlund/libjpraat

JOBS=12
MAKEFILE_DEFS=makefile.defs

WIN32X86_FOLDER=win32-x86
WIN32X64_FOLDER=win32-x86-64
WIN32AMD64_FOLDER=win32-amd64
MAKEFILE_DEFS_WIN32X86=makefiles-libjpraat/makefile.defs.mingw32
MAKEFILE_DEFS_WIN32X64=makefiles-libjpraat/makefile.defs.mingw64

WIN32_TARGET=jpraat.dll
WIN32X86_JAR=libjpraat-win32-x86.jar
WIN32X64_JAR=libjpraat-win32-x86-64.jar
WIN32AMD64_JAR=libjpraat-win32-amd64.jar

LINUXX64_JAR=libjpraat-linux-x86-64.jar
LINUXAMD64_JAR=libjpraat-linux-amd64.jar
MAKEFILE_DEFS_LINUXX64=makefiles-libjpraat/makefile.defs.linux.silent.lib
LINUX_TARGET=libjpraat.so
LINUXX64_FOLDER=linux-x86-64
LINUXAMD64_FOLDER=linux-amd64

function cleanup {
	if [ -f $MAKEFILE_DEFS ]; then
		make -f makefiles-libjpraat/Makefile clean
		rm $MAKEFILE_DEFS
	fi
}

# Build mingw32 (32-bit Windows)
#cleanup
#ln -s $MAKEFILE_DEFS_WIN32X86 makefile.defs
#make -f makefiles-libjpraat/Makefile

#if [ -d $WIN32X86_FOLDER ]; then
#	rm -rf $WIN32X86_FOLDER
#fi
#mkdir $WIN32X86_FOLDER

#if [ -f $WIN32_TARGET ]; then
#	cp $WIN32_TARGET $WIN32X86_FOLDER
#	jar cvf $WIN32X86_JAR $WIN32X86_FOLDER
#	ARTIFACT=${ARTIFACT_BASE}-win32-x86
#	mvn deploy:deploy-file -DrepositoryId=$REPO -Durl=$REPO_URL -DgroupId=$GROUP -DartifactId=$ARTIFACT -Dversion=$VER -Dpackaging=jar -Dfile=$WIN32X86_JAR
#else
#	echo "Target for win32-x86 not built"
#	exit 1
#fi

# Build mingw64 (64-bit Windows)
cleanup
ln -s $MAKEFILE_DEFS_WIN32X64 makefile.defs
make -f makefiles-libjpraat/Makefile -j $JOBS

if [ -d $WIN32X64_FOLDER ]; then
	rm -rf $WIN32X64_FOLDER
fi
mkdir $WIN32X64_FOLDER

if [ -d $WIN32AMD64_FOLDER ]; then
	rm -rf $WIN32AMD64_FOLDER
fi
mkdir $WIN32AMD64_FOLDER

if [ -f $WIN32_TARGET ]; then
	cp $WIN32_TARGET $WIN32X64_FOLDER
	jar cvf $WIN32X64_JAR $WIN32X64_FOLDER
	ARTIFACT=${ARTIFACT_BASE}-win32-x86-64
	mvn deploy:deploy-file -DrepositoryId=$REPO -Durl=$REPO_URL -DgroupId=$GROUP -DartifactId=$ARTIFACT -Dversion=$VER -Dpackaging=jar -Dfile=$WIN32X64_JAR

	cp $WIN32_TARGET $WIN32AMD64_FOLDER
	jar cvf $WIN32AMD64_JAR $WIN32AMD64_FOLDER
	ARTIFACT=${ARTIFACT_BASE}-win32-amd64
	mvn deploy:deploy-file -DrepositoryId=$REPO -Durl=$REPO_URL -DgroupId=$GROUP -DartifactId=$ARTIFACT -Dversion=$VER -Dpackaging=jar -Dfile=$WIN32AMD64_JAR
else
	echo "Target for win32-x86-64 not built"
	exit 1
fi

# Build Linux
cleanup
ln -s $MAKEFILE_DEFS_LINUXX64 makefile.defs
make -f makefiles-libjpraat/Makefile -j $JOBS

if [ -d $LINUXX64_FOLDER ]; then
	rm -rf $LINUXX64_FOLDER
fi
mkdir $LINUXX64_FOLDER

if [ -d $LINUXAMD64_FOLDER ]; then
	rm -rf $LINUXAMD64_FOLDER
fi
mkdir $LINUXAMD64_FOLDER

if [ -f $LINUX_TARGET ]; then
	cp $LINUX_TARGET $LINUXX64_FOLDER
	jar cvf $LINUXX64_JAR $LINUXX64_FOLDER
	ARTIFACT=${ARTIFACT_BASE}-linux-x86-64
	mvn deploy:deploy-file -DrepositoryId=$REPO -Durl=$REPO_URL -DgroupId=$GROUP -DartifactId=$ARTIFACT -Dversion=$VER -Dpackaging=jar -Dfile=$LINUXX64_JAR

	cp $LINUX_TARGET $LINUXAMD64_FOLDER
	jar cvf $LINUXAMD64_JAR $LINUXAMD64_FOLDER
	ARTIFACT=${ARTIFACT_BASE}-linux-amd64
	mvn deploy:deploy-file -DrepositoryId=$REPO -Durl=$REPO_URL -DgroupId=$GROUP -DartifactId=$ARTIFACT -Dversion=$VER -Dpackaging=jar -Dfile=$LINUXAMD64_JAR
else
	echo "Target for linux-x86-64 not built"
	exit 1
fi

