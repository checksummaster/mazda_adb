#         CONFIG
# -------------------------

# Branch to checkout from Android source code repo
#branch=android-4.4.4_r2.0.1
branch=android-5.0.0_r1

# Makefile to use (will be automatically copied into system/core/adb)
#makefile=makefile.sample
makefile=makefile

#Download toolschai
wget https://github.com/jmgao/m3-toolchain/archive/master.zip
unzip master.zip



# DOWNLOAD necessary files
# -------------------------
echo "\n>> >>> ADB for ARM <<< \n"
echo "\n>> Downloading necessay files ($branch branch)\n"
mkdir android-adb
cd android-adb
mkdir system
cd system
git clone -b $branch https://android.googlesource.com/platform/system/core
git clone -b $branch https://android.googlesource.com/platform/system/extras
cd ..
mkdir external
cd external
git clone -b $branch https://android.googlesource.com/platform/external/zlib
git clone -b $branch https://android.googlesource.com/platform/external/openssl
git clone -b $branch https://android.googlesource.com/platform/external/libselinux
cd ..

# Download openssh
wget https://openssl.org/source/openssl-1.0.2f.tar.gz
tar zxvf openssl-1.0.2f.tar.gz
cd openssl-1.0.2f
export CROSS=~/Mazda/m3-toolchain-master/bin/arm-cortexa9_neon-linux-gnueabi
export CC=${CROSS}-gcc
export LD=${CROSS}-ld
export AS=${CROSS}-as
export AR=${CROSS}-ar


./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared \
         compiler:~/Mazda/m3-toolchain-master/bin/arm-cortexa9_neon-linux-gnueabi-
make
cd ..
cd android-adb


# MAKE
# -------------------------
echo "\n>> Copying makefile into system/core/adb...\n"
cp ../$makefile system/core/adb/makefile -f
cd system/core/adb/
echo "\n>> Make... \n"
make clean
make
echo "\n>> Copying adb back into current dir...\n"
cp adb ../../../../adb_1.0.32
echo "\n>> FINISH!\n"

