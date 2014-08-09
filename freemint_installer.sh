#!/bin/bash

#
# This is my install script, which copy all files from freemint cvs
# to build a "ready to rock" package. So far, no init, fvdi or the
# documentation is  build in here, so you have to do it by yourself.
#
# Gnu Public Licens 3 bye Bernd Mueller <ragnar76@googlemail.com>
#

# this script needs to sit inside freemint's top dir to work!
#
# thx to daeghnao for her help and suggestions

# define path
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

# Check if 1 argument is given
if [ $# -lt 1 ]
then
cat << END_OF_DESC
Usage : $0 option pattern wich is one of the following :
	ara - an ARAnyM specific binary
	deb - a debug kernel
	mil - a Milan specific binary
	v4e - a native version for v4e processors (eg. FireBee)
	000 - a generic 68000 binary (including Debian 68k)
	020 - a generic 68020 binary
	030 - a generic 68030 binary
	040 - a generic 68040 binary
	060 - a generic 68060 binary
END_OF_DESC
	exit
fi

# perform a test which system should be default
MYCOMP="$1"
case "${MYCOMP}" in
	ara|0[0-6]0|mil|deb|v4e)
		: ;;
	*)
		echo "sorry";
		exit;;
esac

# set date
TODAY=$(date +%d-%m-%Y)

# FreeMint has to be compiled first, perform a test
if [ ! -f sys/.compile_000/mint000.prg ]
then
	echo -e "\n"
	echo "FreeMint has not compiled yet. Exeting here"
	echo -e "\n"
	exit 1
fi

# set version here
foo1=$(grep -e "#define MINT_MAJ_VERSION" sys/buildinfo/version.h)
foo2=$(grep -e "#define MINT_MIN_VERSION" sys/buildinfo/version.h)
major=$(read -r _ _ field_3 <<< $foo1 ; echo $field_3)
minor=$(read -r _ _ field_3 <<< $foo2 ; echo $field_3)
VER=$major-$minor-cur
INSTALL_DIR="mint_$major$minor"

STRIPPER="m68k-atari-mint-strip"
# STRIPPER="strip"

# make some directories
mkdir $INSTALL_DIR
mkdir $INSTALL_DIR/auto
mkdir $INSTALL_DIR/mint
mkdir $INSTALL_DIR/tmp
mkdir $INSTALL_DIR/mint/kernel
mkdir $INSTALL_DIR/mint/tables
mkdir $INSTALL_DIR/mint/doc
mkdir $INSTALL_DIR/mint/drivers
mkdir $INSTALL_DIR/mint/drivers/xdd
mkdir $INSTALL_DIR/mint/drivers/xfs
mkdir $INSTALL_DIR/mint/drivers/xif
mkdir $INSTALL_DIR/mint/usb
mkdir $INSTALL_DIR/mint/$VER
mkdir $INSTALL_DIR/mint/$VER/xaaes
mkdir $INSTALL_DIR/mint/$VER/xaaes/img
mkdir $INSTALL_DIR/mint/$VER/xaaes/img/8b
mkdir $INSTALL_DIR/mint/$VER/xaaes/img/hc
mkdir $INSTALL_DIR/mint/$VER/xaaes/widgets
mkdir $INSTALL_DIR/mint/$VER/xaaes/xobj
mkdir $INSTALL_DIR/mint/$VER/xaaes/doc
mkdir $INSTALL_DIR/mint/$VER/xaaes/pal
mkdir $INSTALL_DIR/mint/$VER/tools
mkdir $INSTALL_DIR/mint/$VER/tools/crypto
mkdir $INSTALL_DIR/mint/$VER/tools/cops
mkdir $INSTALL_DIR/mint/$VER/tools/cops/rsc/
mkdir $INSTALL_DIR/mint/$VER/tools/cops/rsc/english
mkdir $INSTALL_DIR/mint/$VER/tools/cops/rsc/france
mkdir $INSTALL_DIR/mint/$VER/tools/cops/rsc/german
mkdir $INSTALL_DIR/mint/$VER/tools/fdisk
mkdir $INSTALL_DIR/mint/$VER/tools/fsetter
mkdir $INSTALL_DIR/mint/$VER/tools/gluestik
mkdir $INSTALL_DIR/mint/$VER/tools/hypview
mkdir $INSTALL_DIR/mint/$VER/tools/hypview/skins
mkdir $INSTALL_DIR/mint/$VER/tools/lpflush
mkdir $INSTALL_DIR/mint/$VER/tools/mgw
mkdir $INSTALL_DIR/mint/$VER/tools/mgw/examples
mkdir $INSTALL_DIR/mint/$VER/tools/minix
mkdir $INSTALL_DIR/mint/$VER/tools/mkfatfs
mkdir $INSTALL_DIR/mint/$VER/tools/net-tools
mkdir $INSTALL_DIR/mint/$VER/tools/nfs
mkdir $INSTALL_DIR/mint/$VER/tools/strace
mkdir $INSTALL_DIR/mint/$VER/tools/swkbdtbl
mkdir $INSTALL_DIR/mint/$VER/tools/sysctl
mkdir $INSTALL_DIR/mint/$VER/tools/toswin2


# now install the files
echo " Installing Kernels "
echo "===================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_$MYCOMP/mint$MYCOMP.prg $INSTALL_DIR/auto
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_000/mint000.prg $INSTALL_DIR/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_020/mint020.prg $INSTALL_DIR/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_030/mint030.prg $INSTALL_DIR/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_040/mint040.prg $INSTALL_DIR/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_060/mint060.prg $INSTALL_DIR/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_mil/mintmil.prg $INSTALL_DIR/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_col/mintv4e.prg $INSTALL_DIR/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_deb/mintdeb.prg $INSTALL_DIR/mint/kernel

# install *.xdd, *.xfs and *.xif
echo -e "\n"
echo " Installing Drivers "
echo "===================="
find sys/ -name '*.xdd' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} $INSTALL_DIR/mint/drivers/xdd \;
find sys/ -name '*.xfs' -not -name 'Makefile.xfs' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} $INSTALL_DIR/mint/drivers/xfs \;
find sys/ -name '*.xif' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} $INSTALL_DIR/mint/drivers/xif \;

# install usb
echo -e "\n"
echo " Installing USB Driver "
echo "======================="
find sys/ -name '*.ucd' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} $INSTALL_DIR/mint/usb \;
find sys/ -name '*.udd' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} $INSTALL_DIR/mint/usb \;
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/usb/src.km/loader/loader.prg $INSTALL_DIR/mint/usb

# install keyboard layouts
echo -e "\n"
echo " Installing Keyboard Tables "
echo "============================"
find sys/ -name '*.tbl' -exec /usr/bin/install -v -b --mode=0644 {} $INSTALL_DIR/mint/tables \;

# install xaaes
echo -e "\n"
echo " Installing  XaAES "
echo "==================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/adi/whlmoose/moose.adi $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/adi/whlmoose/moose_w.adi $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes030.km $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes000.km $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesst.km $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes060.km $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes040.km $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesv4e.km $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesdeb.km $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaloader/xaloader.prg $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/*.rsc $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/xa_help.txt $INSTALL_DIR/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/pal/*.pal $INSTALL_DIR/mint/$VER/xaaes/pal
install -v -b --mode=0644 xaaes/src.km/img/8b/*.img $INSTALL_DIR/mint/$VER/xaaes/img/8b
install -v -b --mode=0644 xaaes/src.km/img/hc/*.img $INSTALL_DIR/mint/$VER/xaaes/img/hc
install -v -b --mode=0644 xaaes/src.km/widgets/*.rsc $INSTALL_DIR/mint/$VER/xaaes/widgets
install -v -b --mode=0644 xaaes/src.km/xobj/*.rsc $INSTALL_DIR/mint/$VER/xaaes/xobj

# install tools
echo -e "\n"
echo " Installing  Tools "
echo "==================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/cops/*.app $INSTALL_DIR/mint/$VER/tools/cops
install -v -b --mode=0644 tools/cops/rsc/english/cops_rs.rsc $INSTALL_DIR/mint/$VER/tools/cops/rsc/english
install -v -b --mode=0644 tools/cops/rsc/france/cops_rs.rsc $INSTALL_DIR/mint/$VER/tools/cops/rsc/france
install -v -b --mode=0644 tools/cops/rsc/german/cops_rs.rsc $INSTALL_DIR/mint/$VER/tools/cops/rsc/german
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/crypto/crypto $INSTALL_DIR/mint/$VER/tools/crypto
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fdisk/fdisk $INSTALL_DIR/mint/$VER/tools/fdisk
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fdisk/sfdisk $INSTALL_DIR/mint/$VER/tools/fdisk
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fsetter/fsetter.app $INSTALL_DIR/mint/$VER/tools/fsetter
install -v -b --mode=0644 tools/fsetter/fsetter.rsc $INSTALL_DIR/mint/$VER/tools/fsetter
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/gluestik/gluestik.prg $INSTALL_DIR/mint/$VER/tools/gluestik
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/hypview/hyp_view.app $INSTALL_DIR/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/hyp_view.rsc $INSTALL_DIR/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/hyp_view.cfg $INSTALL_DIR/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/skins/*.rsc $INSTALL_DIR/mint/$VER/tools/hypview/skins
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/lpflush/lpflush $INSTALL_DIR/mint/$VER/tools/lpflush
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/mgw/mgw.prg $INSTALL_DIR/mint/$VER/tools/mgw
install -v -b --mode=0644 tools/mgw/examples/* $INSTALL_DIR/mint/$VER/tools/mgw/examples
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/tools/mfsconf $INSTALL_DIR/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/tools/flist $INSTALL_DIR/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/minit/minit $INSTALL_DIR/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/fsck/fsck.minix $INSTALL_DIR/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/mkfatfs/mkfatfs $INSTALL_DIR/mint/$VER/tools/mkfatfs
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/diald $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/slinkctl/slinkctl $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/ifstats $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/masqconf $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/route $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/arp $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/iflink $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/netstat  $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speedd $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/pipes $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/server $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/client $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/hostlookup $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/sockname $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/sockpair $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/tcpsv $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/servlookup $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speed $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/tcpcl $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/dgram $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/udpclnt $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speed2 $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/dgramd $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/udpserv $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/oobcl $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/protolookup $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/oobsv $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/ifconfig $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/pppconf $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/slattach $INSTALL_DIR/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/nfs/mount_nfs $INSTALL_DIR/mint/$VER/tools/nfs
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/strace/strace $INSTALL_DIR/mint/$VER/tools/strace
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/swkbdtbl/swkbdtbl $INSTALL_DIR/mint/$VER/tools/swkbdtbl
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/sysctl/sysctl $INSTALL_DIR/mint/$VER/tools/sysctl
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/toswin2/toswin2.app $INSTALL_DIR/mint/$VER/tools/toswin2
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/toswin2/tw-call/tw-call.app $INSTALL_DIR/mint/$VER/tools/toswin2
install -v -b --mode=0644 tools/toswin2/toswin2.rsc $INSTALL_DIR/mint/$VER/tools/toswin2
install -v -b --mode=0644 tools/toswin2/english/toswin2.rsc $INSTALL_DIR/mint/$VER/tools/toswin2/english.rsc
install -v -b --mode=0644 tools/toswin2/allcolors.sh $INSTALL_DIR/mint/$VER/tools/toswin2

# install tools
echo -e "\n"
echo " Installing  Docs "
echo "==================="

# install teradesk. here's a little hack. linux's unzip does not create the
# right filepermissions. so i have to fix it here.
echo -e "\n"
echo -e " Inserting TeraDesk "
echo -e "===================="
cd $INSTALL_DIR/mint/$VER/
wget -T0 -t0 http://solair.eunet.rs/~vdjole/tera405b.zip
unzip -qq -X -K -d teradesk tera405b.zip
rm tera405b.zip
cd teradesk
find . -name '*' -type f -exec /bin/chmod 0644 {} \;
find . -name '*' -type d -exec /bin/chmod 0755 {} \;
cd ../..

# some config files are written here
echo -e "\n"
echo -e " Writing simple config files "
echo -e "============================="

cat << END_OF_MINT_CNF > $VER/mint.cnf
# Autogenerated config file
# See http://wiki.sparemint.org/index.php/Mint.cnf for details
set -q
KERN_SLICES=2
setenv HOSTNAME auto-generated-hostname
setenv PCONVERT PATH,HOME,SHELL
setenv UNIXMODE /brUs
setenv PATH /sbin;/bin;/usr/sbin;/usr/bin
setenv TMPDIR u:/tmp
GEM=u:/c/mint/$VER/xaaes/xaloader.prg
END_OF_MINT_CNF

cat << END_OF_XAAES_CNF > $VER/xaaes/xaaes.cnf
# Autogenerated config file
# See http://wiki.sparemint.org/index.php/Mint.cnf for details
setenv ACCPATH C:\
setenv ACCEXT ACC,ACX
setenv GEMEXT PRG,APP,GTP,OVL,SYS
setenv TOSEXT TOS,TTP
setenv TOSRUN u:\\c\\mint\\$VER\\tools\\toswin2\\tw-call.app
setenv SDL_VIDEODRIVER gem
naes_cookie = yes
usehome = yes
clipboard = c:\\clipboard
accpath   = c:\
run u:\\c\\mint\\$VER\\tools\\toswin2\\toswin2.app
setenv AVSERVER   "DESKTOP"
setenv FONTSELECT "DESKTOP"
shell = c:\\mint\\$VER\\teradesk\\desktop.prg
END_OF_XAAES_CNF

# create a zip archive
echo -e "\n"
echo -e " Creating a zip archive "
echo -e "========================"
cd ../..
zip -qq -r -9 mint_119-$TODAY.zip mint_119/

# create a zip archive
echo -e "\n"
echo -e " Cleaning up "
echo -e "============="
rm -rf mint_119

