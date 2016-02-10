#! /bin/sh
MYDIR=$(dirname $(readlink -f $0))
TIMESTAMP=$(date "+%m%d%Y-%H%M%S")
LOGFILE=${MYDIR}/${TIMESTAMP}.txt
INSTALLDIR=/usr/bin

echo "Start ssh script" >> ${LOGFILE}

if [ ! -f ${INSTALLDIR}/adb ]; then
	/jci/tools/jci-dialog --title="SSH" --text="Installation ... " --ok-label='OK' --no-cancel &
	echo "Disabling Watchdog Service" >> ${LOGFILE}
	echo 1 > /sys/class/gpio/Watchdog\ Disable/value 
	echo "Mounting filesystem read/write" >> ${LOGFILE}
	mount -o rw,remount /  >> ${LOGFILE} 2>&1
	echo "Copy files" >> ${LOGFILE}
	cp /mnt/sd?1/adb_1.0.32 ${INSTALLDIR}/adb >> ${LOGFILE} 2>&1
	chmod 755 ${INSTALLDIR}/adb >> ${LOGFILE} 2>&1
	killall jci-dialog >> ${LOGFILE}
fi

/jci/tools/jci-dialog --title="SSH" --text="Connect Android on Mazda USB port" --ok-label='OK' --no-cancel &
echo "Wait for device" >> ${LOGFILE}
${INSTALLDIR}/adb wait-for-device >> ${LOGFILE} 2>&1
killall jci-dialog >> ${LOGFILE}
echo "${INSTALLDIR}/adb reverse tcp:2222 tcp:22" >> ${LOGFILE}
${INSTALLDIR}/adb reverse tcp:2222 tcp:22 >> ${LOGFILE} 2>&1
/jci/tools/jci-dialog --title="SSH" --text="on Android do ssh root@localhost -p 2222 (password jci)"  --ok-label='OK' --no-cancel
echo "bye" >> ${LOGFILE}


