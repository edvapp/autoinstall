#!/bin/bash

# Startscript for Virtual Machines
# Idee from VlizedLab http://www.vlizedlab.at/
# Changes by Reinhard Fink
# call Script with Parameters
#
# 1:    Parameter:
#       Path/Filename of Virtual Machine Harddisk File with Ending .vdi
#
# 2:    Parameter for VBoxManage modifyvm 
#       Path/Filename Option1 Option1-Parameter
#       Path/Filename Option1 Option1-Parameter Option2 Option2-Parameter ...
#
# Examples: 
#       * NO Option:
#         >> startVM.sh /opt/vms/win7.vdi
#         starts Virtualmachine win.vdi in directory /opt/vms
#
#       * ONE Option:
#         >> startVM.sh /opt/vms/win7.vdi --acpi off
#         starts Virtualmachine win7.vdi in directory /opt/vms and
#         turns acpi off.
#         >> VBoxManage --nologo modifyvm $MACHINE_NAME --acpi off
#         will be added to standard creation off machine
#
#       * TWO Options:
#         >> startVM.sh /opt/vms/win10.vdi --ioapic on --cpus 2
#         starts Virtualmachine win10.vdi in directory /opt/vms and
#         with 2 CPUs and turns ioapic on.
#         >> VBoxManage --nologo modifyvm $MACHINE_NAME --ioapic on --cpus 2
#         will be added to standard creation off machine
#


## Helper function for inotify - pdf - printer - spooler
function killInotifyWait()
{
	# check, if an inotifywait process is running and kill it
	LOST_INOTIFY=$(ps ef | grep "inotifywait -e close_write $DIRECTORY_TO_MONITOR" | grep -v grep |  awk '{ print $1 }')
	if [ ! "$LOST_INOTIFY" = "" ];
	then
		kill $LOST_INOTIFY
	fi
}


# Create Variables and Directories ######################################################

## Set variables
echo "Set variables"

MACHINE_PATH_AND_FILE=$1

MACHINE_PATH=$(dirname $MACHINE_PATH_AND_FILE)

MACHINE_FILE=$(basename $MACHINE_PATH_AND_FILE)

# MACHINE_NAME = MACHINE_FILE without ending .vdi
MACHINE_NAME=${MACHINE_FILE%.vdi}

MACHINE_WORK_DIR=/tmp/${USER}_vms

echo "Looking for $MACHINE_FILE in $MACHINE_PATH to create machine $MACHINE_NAME"
echo "Working directory for current running VM:  $MACHINE_WORK_DIR"

if [ ! -f $MACHINE_PATH_AND_FILE ];
then
	echo "File "$MACHINE_PATH_AND_FILE" does not exist"
	echo "--- AUTOMATIK UPDATE TRY LATER! ---"
	echo "--- OR WRONG FILENAME! ---"
	exit
fi

echo "Clean & create machine work directory"
if [ -d $MACHINE_WORK_DIR ];
then
	rm -R $MACHINE_WORK_DIR
fi
mkdir -p $MACHINE_WORK_DIR

# Directories for shares
SCHUELER_DIR="/home/shares/schueler"
echo "Directory for: " $SCHUELER_DIR

LEHRMATERIAL_DIR="/home/shares/lehrmaterial"
echo "Directory for: " $LEHRMATERIAL_DIR

OPTPROGS_DIR="/home/shares/optProgs"
echo "Directory for: " $OPTPROGS_DIR

PROGRAMMES_DIR="/home/shares/optProgs/zWindows"
echo "Directory for: " $PROGRAMMES_DIR

CONFIG_WINONTOP_DIR=$MACHINE_STORAGE_DIR"/configwinontop"
echo "Config Directory for WinOnTop: " $CONFIG_WINONTOP_DIR

# Directories for PDF - Spooler
DIRECTORY_TO_MONITOR="$HOME/pdf-spooler"
echo "Spooler directory for PDF-printer >>Printer_sw<< printing from  WinOnTop: " $DIRECTORY_TO_MONITOR

DIRECTORY_TO_MONITOR_FOR_COLOR="$DIRECTORY_TO_MONITOR/color"
echo "Spooler directory for PDF-printer >>Printer_color<< printing from  WinOnTop: " $DIRECTORY_TO_MONITOR_FOR_COLOR

# check, if Color-Printer available
# COLOR_PRINTER_NAME=Printer-Color
COLOR_PRINTER_NAME=$(lpstat -p | grep color | awk '{ print $2 }')
echo "Color printer: " $COLOR_PRINTER_NAME

# Manage Virtualbox Configuration Directorys
echo "Manage Virtualbox configuration directorys"
echo "Save original .VirtualBox directory, if exists and .VirtualBox.$USER does not exist"
if [ -d $HOME/.config/VirtualBox ] && [ ! -d $HOME/.VirtualBox.$USER ];
then
	mv $HOME/.config/VirtualBox $HOME/.VirtualBox.$USER
fi

# Set ramsize for host
HOST_RAM=$((2048 + 0))
# Get available ramsize from host
VM_RAM=$(cat /proc/meminfo | grep MemTotal: | awk -F' ' '{ print $2 }' )
# Ramsize im MB
VM_RAM=$(($VM_RAM / 1024))
# Calculate VM_RAM
VM_RAM=$(($VM_RAM - $HOST_RAM))
#VM_RAM=1024
echo "Ram Size for VM: " $VM_RAM


# Create virtual machine ################################################################
#
echo "Create virtual machine"
VBoxManage --nologo createvm --name $MACHINE_NAME --register --basefolder $MACHINE_WORK_DIR
# OS
#VBoxManage --nologo modifyvm $MACHINE_NAME --ostype $OS_TYPE
# CPU + GPU
VBoxManage --nologo modifyvm $MACHINE_NAME --memory $VM_RAM
VBoxManage --nologo modifyvm $MACHINE_NAME --vram 128
VBoxManage --nologo modifyvm $MACHINE_NAME --acpi on
# ioacoi off IMPORTANT: otherwise Windows 7 wants to reinstall CPU - Driver
# Windows 10 is installed with --ioapic on ??
# so use this script with optioin --ioapic on
VBoxManage --nologo modifyvm $MACHINE_NAME --ioapic off
VBoxManage --nologo modifyvm $MACHINE_NAME --hwvirtex on
VBoxManage --nologo modifyvm $MACHINE_NAME --pae off
# BIOS
VBoxManage --nologo modifyvm $MACHINE_NAME --bioslogofadein off
VBoxManage --nologo modifyvm $MACHINE_NAME --bioslogofadeout off
VBoxManage --nologo modifyvm $MACHINE_NAME --bioslogodisplaytime 1
# NetworkAdapter
VBoxManage --nologo modifyvm $MACHINE_NAME --nictype1 82540EM
VBoxManage --nologo modifyvm $MACHINE_NAME --nic1 nat
# plug in virtuall cable into networkAdapter (needed since somwhere 5.0.40 and 5.1.30)
VBoxManage --nologo modifyvm $MACHINE_NAME --cableconnected1 on
#VBoxManage --nologo modifyvm $MACHINE_NAME --macaddress1 0800276D37F9
# Set address space for internal networkAdapter 
VBoxManage --nologo modifyvm $MACHINE_NAME --natnet1 192.168.254.0/24
# AudioAdapter
# "alsa" was working perfect in Ubuntu 16.04, but has bad sound in 18.04
# so switch to "pulse", which works on 16.04 and 18.04
# VBoxManage --nologo modifyvm $MACHINE_NAME --audio alsa --audiocontroller hda
VBoxManage --nologo modifyvm $MACHINE_NAME --audio pulse --audiocontroller hda
VBoxManage --nologo modifyvm $MACHINE_NAME --audiocontroller hda
# switch audio in/out on (needed since somwhere 5.2.??)
VBoxManage --nologo modifyvm $MACHINE_NAME --audioin on
VBoxManage --nologo modifyvm $MACHINE_NAME --audioout on
# --boot<1-4> none|floppy|dvd|disk|net
VBoxManage --nologo modifyvm $MACHINE_NAME --boot1 disk
# Create storage adapters
echo "Create harddisk controller for virtual machine"
# IDE
#VBoxManage --nologo storagectl $MACHINE_NAME --name IDE-Controller-$MACHINE_NAME --add ide --controller PIIX4 --hostiocache on
# SATA
VBoxManage --nologo storagectl $MACHINE_NAME --name SATA-Controller-$MACHINE_NAME --add sata --controller IntelAHCI --portcount 1 --hostiocache off

#echo "Link Machine VDI from Storage Directory to Work Directory"
#ln -s $MACHINE_STORAGE_DIR/$MACHINE.vdi $MACHINE_WORK_DIR/$MACHINE/$MACHINE.vdi

echo "Attach Harddisk to Virtual Machine"
#VBoxManage --nologo storageattach $MACHINE_NAME --storagectl SATA-Controller-$MACHINE_NAME --port 0 --device 0 --type hdd --medium $MACHINE_WORK_DIR/$MACHINE_NAME/$MACHINE_FILE --mtype immutable
VBoxManage --nologo storageattach $MACHINE_NAME --storagectl SATA-Controller-$MACHINE_NAME --port 0 --device 0 --type hdd --medium $MACHINE_PATH_AND_FILE --mtype immutable

# Apply command line options from script to VBoxManage modifyvm
# remove first comand line parameter <=> Machine-path/filename
shift

((i = 0))
while [ ! -z $1 ];
do
        ((i = i + 1))
        echo "Apply command line options NR $i from script: >>VBoxManage modifyvm $1 $2"
        VBoxManage --nologo modifyvm $MACHINE_NAME $1 $2
        # remove options $1 and $2
        shift
        shift
done


# Create Shared Folder
# Folders, witch are mounted inside Virtual Windows every time, via script mountshares.cmd in .../Autostart
echo "Createing shared Folders"
if [ -d $SCHUELER_DIR ];
then
	echo "Create shared Folder for Directory: "$SCHUELER_DIR
	VBoxManage sharedfolder add $MACHINE_NAME --name schueler --hostpath $SCHUELER_DIR
fi
if [ -d $LEHRMATERIAL_DIR ];
then
	echo "Create shared Folder for Directory: "$LEHRMATERIAL_DIR
	VBoxManage sharedfolder add $MACHINE_NAME --name lehrmaterial --hostpath $LEHRMATERIAL_DIR
fi
if [ -d $OPTPROGS_DIR ];
then
	echo "Create shared Folder for Directory: "$OPTPROGS_DIR
	VBoxManage sharedfolder add $MACHINE_NAME --name optProgs --hostpath $OPTPROGS_DIR
fi

if [ -d $PROGRAMMES_DIR ];
then
	echo "Create shared Folder for Directory: "$PROGRAMMES_DIR
	VBoxManage sharedfolder add $MACHINE_NAME --name programmes --hostpath $PROGRAMMES_DIR
fi

if [ -d $CONFIG_WINONTOP_DIR ];
then
	echo "Create shared Folder Configuration Directory: "$CONFIG_WINONTOP_DIR
	VBoxManage sharedfolder add $MACHINE_NAME --name configwinontop --hostpath $CONFIG_WINONTOP_DIR
fi

echo "Create shared folder for USB"
VBoxManage sharedfolder add $MACHINE_NAME --name USB-Storage --hostpath /media 

echo "Create shared folder for home directory: "$HOME
VBoxManage --nologo sharedfolder add $MACHINE_NAME --name myHome --hostpath $HOME


# Create PDF - Spooler Monitor ################################################################
#
# create spooler directory, if it does not exist
if [ ! -d $DIRECTORY_TO_MONITOR ];
then
	mkdir -p $DIRECTORY_TO_MONITOR_FOR_COLOR
fi

# check for a lost inotifywait process
killInotifyWait

# start monitoring for $DIRECTORY_TO_MONITOR in background (see &)
# and sent files to standard printer

inotifywait -e close_write $DIRECTORY_TO_MONITOR -m -r --format "%w%f" | \
while read PATH_AND_FILE; 
do 
	# if $DIRECTORY_TO_MONITOR_FOR_COLOR not in filepath, filepath stays unchanged,
	# and file must exist in $DIRECTORY_TO_MONITOR
	if [ "${PATH_AND_FILE#"$DIRECTORY_TO_MONITOR_FOR_COLOR"}" = "$PATH_AND_FILE" ];
	then
		echo lp "$PATH_AND_FILE"
		lp "$PATH_AND_FILE" 
	else 
		if [ ! "$COLOR_PRINTER_NAME" = "" ];
		then
			echo "lp -d $COLOR_PRINTER_NAME" "$PATH_AND_FILE" 
			lp -d "$COLOR_PRINTER_NAME" "$PATH_AND_FILE"
		fi
	fi
	echo rm "$PATH_AND_FILE"; 
	rm "$PATH_AND_FILE"; 
done &


# Set extraoptions
echo "Set Display Settings/Supress Notifications"
VBoxManage setextradata global GUI/SuppressMessages confirmGoingFullscreen,confirmInputCapture,remindAboutAutoCapture,remindAboutWrongColorDepth,remindAboutMouseIntegration
#echo "Move Host Key form >>Strg right<< to >>AltGr<<"
#VBoxManage setextradata global GUI/Input/HostKeyCombination 65027

VBoxManage setextradata $MACHINE_NAME GUI/Fullscreen on
VBoxManage setextradata $MACHINE_NAME GUI/ShowMiniToolBar no


# Starts VM ################################################################
#
echo "Start virtual machine"
# Starts VM and return to this script, when VM shuts down
# VBoxManage startvm $MACHINE_NAME
if [ -f /usr/bin/VirtualBoxVM ];
then
	VirtualBoxVM --startvm $MACHINE_NAME
else
	VirtualBox --startvm $MACHINE_NAME
fi


# Restore drectories/kill PDF - spooler monitor ##############################################
#
echo "Restore all Virtualbox config - directories"
echo "Wait for 5 seconds to shutdown virtual machine"
sleep 5
rm -R $HOME/.config/VirtualBox
rm -R $MACHINE_WORK_DIR
echo "Restore original .config/VirtualBox Directory if exists."
if [ -d $HOME/.VirtualBox.$USER ];
then
	mv $HOME/.VirtualBox.$USER $HOME/.config/VirtualBox
fi

# kill running inotify
killInotifyWait
# remove spooler directory
rm -r $DIRECTORY_TO_MONITOR

