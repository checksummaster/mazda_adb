This project is to have a ssh access easily on the infotainment of a Mazda 3 2015 ... And other compatible/clone Mazda ;)

I compile adb 1.0.32 on a new ubuntu 15.10 Desktop in a VM (Parallels on a MacBookPro), with only GIT installed.
This project is a modified version of the project at "https://github.com/bonnyfone/adb-arm" that compile adb 1.0.31

1) If you don't have GIT ... do 
	sudo apt-get update
	sudo apt-get install git
2) Store this project in ~/Mazda folder (for different folder change Mazda in makefile and adb-download-make.sh ... 3 places only)
3) be sure that adb-download-make.sh is runnable (ex: chmod 755 adb-download-make.sh)
4) Start adb-download-make.sh and be patient.
5) You should have an adb_1.0.32 file.

Licenses,

My work is licensed on WTFPL (see http://www.wtfpl.net/)
But you should respect licenses of following projects 
	1) bonnyfone/adb-arm at https://github.com/bonnyfone/adb-arm 
	2) jmgao/m3-toolchain at https://github.com/jmgao/m3-toolchain
	3) openssl at https://openssl.org
	4) Android at https://android.googlesource.com/