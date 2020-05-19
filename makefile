getFullyQualifiedWindowsStylePath=$(shell cygpath --windows --absolute "$(1)")
unslashedDir=$(patsubst %/,%,$(dir $(1)))
pathOfThisMakefile:=$(call unslashedDir,$(lastword $(MAKEFILE_LIST)))
buildFolder:=${pathOfThisMakefile}/build

7zipModule=7zsd_All.sfx
deployableFiles:=$(wildcard deployment/*)

#this sets the projectName to be the name of the current folder.
projectName=$(shell basename "$(abspath .)")

selfInstallingExecutable:=${buildFolder}/${projectName}.exe
tempArchive:=${buildFolder}/contents.7z
sfxConfigFile:=${buildFolder}/sfxConfig.txt

${selfInstallingExecutable}: ${7zipModule} ${sfxConfigFile} ${tempArchive}
	mkdir --parents build
	cat ${7zipModule}      > ${selfInstallingExecutable}
	cat ${sfxConfigFile}  >> ${selfInstallingExecutable}
	cat ${tempArchive}    >> ${selfInstallingExecutable}
	rm --force ${tempArchive}
	rm --force ${sfxConfigFile}

${tempArchive}: ${deployableFiles}
	mkdir --parents build
	rm --force ${tempArchive}
	cd deployment && 7z a -r "$(call getFullyQualifiedWindowsStylePath,${tempArchive})" *

${sfxConfigFile} : makefile  | ${buildFolder}
	echo \;\!\@Install\@\!UTF-8\! > ${sfxConfigFile}
	echo Title=\"${projectName}\" >> ${sfxConfigFile}
	echo GUIMode=\"1\" >> ${sfxConfigFile}
	echo InstallPath=\"%temp%\\\\${projectName}\" >> ${sfxConfigFile}
	echo RunProgram=\"nircmd elevate cmd /c \\\"\%\%T\\install.bat\\\"\" >> ${sfxConfigFile}
	#the idea is that, if you simply double click the installer, it will use nircmd to run install.bat with elevated permissions, but if you invoke the installer with the switch -ai1, then install.bat will be executed directly.  This can be used if you are already in an elevated console and do not want to generate a UAC warning.
	echo AutoInstall1=\"install.bat\" >> ${sfxConfigFile}
	echo \;\!\@InstallEnd\@\! >> ${sfxConfigFile}

# "$^" is an automtic variable that expands to the list of all prerequisites

${buildFolder}:
	@echo "====== CREATING THE BUILD FOLDER ======="
	@echo "buildFolder: ${buildFolder}"
	mkdir --parents "${buildFolder}"
#buildFolder, when included as a prerequisite for rules, should be declared as an order-only prerequisites (by placing it to the right of a "|" character in the 
# list of prerequisites.  See https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html 


${selfInstallingExecutable}: | ${buildFolder}
${tempArchive}: | ${buildFolder}
${sfxConfigFile}: | ${buildFolder}

