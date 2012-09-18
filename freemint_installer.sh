#!/bin/bash

#
# This is my install script, which copy all files from freemint cvs
# to build a "ready to rock" package. So far, no init, fvdi or the
# documentation is  build in here, so you have to do it by yourself.
#
# Gnu Public Licens 3 bye Bernd Mueller <ragnar76@googlemail.com>
#

# define path
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

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

MYCOMP="ara"
STRIPPER="m68k-atari-mint-strip"
# STRIPPER="strip"

# make some directories
mkdir install_dir
mkdir install_dir/auto
mkdir install_dir/mint
mkdir install_dir/tmp
mkdir install_dir/mint/kernel
mkdir install_dir/mint/tables
mkdir install_dir/mint/doc
mkdir install_dir/mint/drivers
mkdir install_dir/mint/drivers/xdd
mkdir install_dir/mint/drivers/xfs
mkdir install_dir/mint/drivers/xif
mkdir install_dir/mint/usb
mkdir install_dir/mint/$VER
mkdir install_dir/mint/$VER/xaaes
mkdir install_dir/mint/$VER/xaaes/img
mkdir install_dir/mint/$VER/xaaes/img/8b
mkdir install_dir/mint/$VER/xaaes/img/hc
mkdir install_dir/mint/$VER/xaaes/widgets
mkdir install_dir/mint/$VER/xaaes/xobj
mkdir install_dir/mint/$VER/xaaes/doc
mkdir install_dir/mint/$VER/xaaes/pal
mkdir install_dir/mint/$VER/tools
mkdir install_dir/mint/$VER/tools/crypto
mkdir install_dir/mint/$VER/tools/cops
mkdir install_dir/mint/$VER/tools/cops/rsc/
mkdir install_dir/mint/$VER/tools/cops/rsc/english
mkdir install_dir/mint/$VER/tools/cops/rsc/france
mkdir install_dir/mint/$VER/tools/cops/rsc/german
mkdir install_dir/mint/$VER/tools/fdisk
mkdir install_dir/mint/$VER/tools/fsetter
mkdir install_dir/mint/$VER/tools/gluestik
mkdir install_dir/mint/$VER/tools/hypview
mkdir install_dir/mint/$VER/tools/hypview/skins
mkdir install_dir/mint/$VER/tools/lpflush
mkdir install_dir/mint/$VER/tools/mgw
mkdir install_dir/mint/$VER/tools/mgw/examples
mkdir install_dir/mint/$VER/tools/minix
mkdir install_dir/mint/$VER/tools/mkfatfs
mkdir install_dir/mint/$VER/tools/net-tools
mkdir install_dir/mint/$VER/tools/nfs
mkdir install_dir/mint/$VER/tools/strace
mkdir install_dir/mint/$VER/tools/swkbdtbl
mkdir install_dir/mint/$VER/tools/sysctl
mkdir install_dir/mint/$VER/tools/toswin2


# now install the files
echo " Installing Kernels "
echo "===================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_$MYCOMP/mint$MYCOMP.prg install_dir/auto
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_$MYCOMP/mint$MYCOMP.prg install_dir/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_000/mint000.prg install_dir/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_020/mint020.prg install_dir/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_030/mint030.prg install_dir/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_040/mint040.prg install_dir/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_060/mint060.prg install_dir/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_mil/mintmil.prg install_dir/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_col/mintv4e.prg install_dir/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_deb/mintdeb.prg install_dir/mint/kernel

# install *.xdd, *.xfs and *.xif
echo -e "\n"
echo " Installing Drivers "
echo "===================="
find sys/ -name '*.xdd' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} install_dir/mint/drivers/xdd \;
find sys/ -name '*.xfs' -not -name 'Makefile.xfs' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} install_dir/mint/drivers/xfs \;
find sys/ -name '*.xif' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} install_dir/mint/drivers/xif \;

# install usb
echo -e "\n"
echo " Installing USB Driver "
echo "======================="
find sys/ -name '*.ucd' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} install_dir/mint/usb \;
find sys/ -name '*.udd' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} install_dir/mint/usb \;
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/usb/src.km/loader/loader.prg install_dir/mint/usb

# install keyboard layouts
echo -e "\n"
echo " Installing Keyboard Tables "
echo "============================"
find sys/ -name '*.tbl' -exec /usr/bin/install -v -b --mode=0644 {} install_dir/mint/tables \;

# install xaaes
echo -e "\n"
echo " Installing  XaAES "
echo "==================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/adi/whlmoose/moose.adi install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/adi/whlmoose/moose_w.adi install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes030.km install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes000.km install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesst.km install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes060.km install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes040.km install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesv4e.km install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesdeb.km install_dir/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaloader/xaloader.prg install_dir/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/*.rsc install_dir/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/xa_help.txt install_dir/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/pal/*.pal install_dir/mint/$VER/xaaes/pal
install -v -b --mode=0644 xaaes/src.km/img/8b/*.img install_dir/mint/$VER/xaaes/img/8b
install -v -b --mode=0644 xaaes/src.km/img/hc/*.img install_dir/mint/$VER/xaaes/img/hc
install -v -b --mode=0644 xaaes/src.km/widgets/*.rsc install_dir/mint/$VER/xaaes/widgets
install -v -b --mode=0644 xaaes/src.km/xobj/*.rsc install_dir/mint/$VER/xaaes/xobj

# install tools
echo -e "\n"
echo " Installing  Tools "
echo "==================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/cops/*.app install_dir/mint/$VER/tools/cops
install -v -b --mode=0644 tools/cops/rsc/english/cops_rs.rsc install_dir/mint/$VER/tools/cops/rsc/english
install -v -b --mode=0644 tools/cops/rsc/france/cops_rs.rsc install_dir/mint/$VER/tools/cops/rsc/france
install -v -b --mode=0644 tools/cops/rsc/german/cops_rs.rsc install_dir/mint/$VER/tools/cops/rsc/german
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/crypto/crypto install_dir/mint/$VER/tools/crypto
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fdisk/fdisk install_dir/mint/$VER/tools/fdisk
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fdisk/sfdisk install_dir/mint/$VER/tools/fdisk
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fsetter/fsetter.app install_dir/mint/$VER/tools/fsetter
install -v -b --mode=0644 tools/fsetter/fsetter.rsc install_dir/mint/$VER/tools/fsetter
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/gluestik/gluestik.prg install_dir/mint/$VER/tools/gluestik
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/hypview/hyp_view.app install_dir/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/hyp_view.rsc install_dir/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/hyp_view.cfg install_dir/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/skins/*.rsc install_dir/mint/$VER/tools/hypview/skins
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/lpflush/lpflush install_dir/mint/$VER/tools/lpflush
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/mgw/mgw.prg install_dir/mint/$VER/tools/mgw
install -v -b --mode=0644 tools/mgw/examples/* install_dir/mint/$VER/tools/mgw/examples
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/tools/mfsconf install_dir/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/tools/flist install_dir/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/minit/minit install_dir/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/fsck/fsck.minix install_dir/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/mkfatfs/mkfatfs install_dir/mint/$VER/tools/mkfatfs
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/diald install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/slinkctl/slinkctl install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/ifstats install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/masqconf install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/route install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/arp install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/iflink install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/netstat  install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speedd install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/pipes install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/server install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/client install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/hostlookup install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/sockname install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/sockpair install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/tcpsv install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/servlookup install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speed install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/tcpcl install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/dgram install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/udpclnt install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speed2 install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/dgramd install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/udpserv install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/oobcl install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/protolookup install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/oobsv install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/ifconfig install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/pppconf install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/slattach install_dir/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/nfs/mount_nfs install_dir/mint/$VER/tools/nfs
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/strace/strace install_dir/mint/$VER/tools/strace
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/swkbdtbl/swkbdtbl install_dir/mint/$VER/tools/swkbdtbl
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/sysctl/sysctl install_dir/mint/$VER/tools/sysctl
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/toswin2/toswin2.app install_dir/mint/$VER/tools/toswin2
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/toswin2/tw-call/tw-call.app install_dir/mint/$VER/tools/toswin2
install -v -b --mode=0644 tools/toswin2/toswin2.rsc install_dir/mint/$VER/tools/toswin2
install -v -b --mode=0644 tools/toswin2/english/toswin2.rsc install_dir/mint/$VER/tools/toswin2/english.rsc
install -v -b --mode=0644 tools/toswin2/allcolors.sh install_dir/mint/$VER/tools/toswin2

# install tools
echo -e "\n"
echo " Installing  Docs "
echo "==================="

# install teradesk. here's a little hack. linux's unzip does not create the
# right filepermissions. so i have to fix it here.
echo -e "\n"
echo -e " Inserting TeraDesk "
echo -e "===================="
cd install_dir/mint/$VER/
wget -q -T0 -t0 http://solair.eunet.rs/~vdjole/tera403b.zip
# wget -q -T0 -t0 http://127.0.0.1/tera403b.zip
unzip -qq -X -K -d teradesk tera403b.zip
rm tera403b.zip
cd teradesk
find . -name '*' -type f -exec /bin/chmod 0644 {} \;
find . -name '*' -type d -exec /bin/chmod 0755 {} \;
cd ..

# some config files are written here
echo -e "\n"
echo -e " Writing simple config files "
echo -e "============================="

echo -e "# Autogenerated config file" > mint.cnf
echo -e "# See http://wiki.sparemint.org/index.php/Mint.cnf for details" >> mint.cnf
echo -e "set -q" >> mint.cnf
echo -e "setenv HOSTNAME auto-generated-hostname" >> mint.cnf
echo -e "setenv PCONVERT PATH,HOME,SHELL" >> mint.cnf
echo -e "setenv UNIXMODE /brUs" >> mint.cnf
echo -e "setenv PATH /sbin;/bin;/usr/sbin;/usr/bin" >> mint.cnf
echo -e "setenv TMPDIR u:/tmp" >> mint.cnf
echo -e "GEM=u:/c/mint/1-18-cur/xaaes/xaloader.prg" >> mint.cnf

echo -e "# Autogenerated config file" > xaaes/xaaes.cnf
echo -e "# See http://wiki.sparemint.org/index.php/Mint.cnf for details" >> xaaes/xaaes.cnf
echo -e "setenv ACCPATH C:\\" >> xaaes/xaaes.cnf
echo -e "setenv ACCEXT ACC,ACX" >> xaaes/xaaes.cnf
echo -e "setenv GEMEXT PRG,APP,GTP,OVL,SYS" >> xaaes/xaaes.cnf
echo -e "setenv TOSEXT TOS,TTP" >> xaaes/xaaes.cnf
echo -e "setenv TOSRUN u:\\\c\\mint\\1-18-cur\\\tools\\\toswin2\\\tw-call.app"  >> xaaes/xaaes.cnf
echo -e "setenv SDL_VIDEODRIVER gem" >> xaaes/xaaes.cnf
echo -e "naes_cookie = yes" >> xaaes/xaaes.cnf
echo -e "usehome = yes" >> xaaes/xaaes.cnf
echo -e "clipboard = c:\\\clipbrd\\" >> xaaes/xaaes.cnf
echo -e "accpath   = c:\\" >> xaaes/xaaes.cnf
echo -e "run u:\\\c\\mint\\1-18-cur\\\tools\\\toswin2\\\toswin2.app" >> xaaes/xaaes.cnf
echo -e "setenv AVSERVER   \"DESKTOP\"" >> xaaes/xaaes.cnf
echo -e "setenv FONTSELECT \"DESKTOP\"" >> xaaes/xaaes.cnf
echo -e "shell = c:\\mint\\1-18-cur\\\teradesk\\desktop.prg" >> xaaes/xaaes.cnf

# back to top dir
cd ../../

