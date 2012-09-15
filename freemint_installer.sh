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

# set version here
VER="1-18-cur"
MYCOMP="ara"
STRIPPER="m68k-atari-mint-strip"
# STRIPPER="strip"

# make some directories
mkdir install
mkdir install/auto
mkdir install/mint
mkdir install/tmp
mkdir install/mint/kernel
mkdir install/mint/tables
mkdir install/mint/doc
mkdir install/mint/drivers
mkdir install/mint/drivers/xdd
mkdir install/mint/drivers/xfs
mkdir install/mint/drivers/xif
mkdir install/mint/$VER
mkdir install/mint/$VER/xaaes
mkdir install/mint/$VER/xaaes/img
mkdir install/mint/$VER/xaaes/img/8b
mkdir install/mint/$VER/xaaes/img/hc
mkdir install/mint/$VER/xaaes/widgets
mkdir install/mint/$VER/xaaes/xobj
mkdir install/mint/$VER/xaaes/doc
mkdir install/mint/$VER/xaaes/pal
mkdir install/mint/$VER/tools
mkdir install/mint/$VER/tools/crypto
mkdir install/mint/$VER/tools/cops
mkdir install/mint/$VER/tools/cops/rsc/
mkdir install/mint/$VER/tools/cops/rsc/english
mkdir install/mint/$VER/tools/cops/rsc/france
mkdir install/mint/$VER/tools/cops/rsc/german
mkdir install/mint/$VER/tools/fdisk
mkdir install/mint/$VER/tools/fsetter
mkdir install/mint/$VER/tools/gluestik
mkdir install/mint/$VER/tools/hypview
mkdir install/mint/$VER/tools/hypview/skins
mkdir install/mint/$VER/tools/lpflush
mkdir install/mint/$VER/tools/mgw
mkdir install/mint/$VER/tools/mgw/examples
mkdir install/mint/$VER/tools/minix
mkdir install/mint/$VER/tools/mkfatfs
mkdir install/mint/$VER/tools/net-tools
mkdir install/mint/$VER/tools/nfs
mkdir install/mint/$VER/tools/strace
mkdir install/mint/$VER/tools/swkbdtbl
mkdir install/mint/$VER/tools/sysctl
mkdir install/mint/$VER/tools/toswin2


# now install the files
echo " Installing Kernels "
echo "===================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_$MYCOMP/mint$MYCOMP.prg install/auto
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_$MYCOMP/mint$MYCOMP.prg install/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_000/mint000.prg install/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_020/mint020.prg install/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_030/mint030.prg install/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_040/mint040.prg install/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_060/mint060.prg install/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_mil/mintmil.prg install/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_col/mintv4e.prg install/mint/kernel
install -v -b --mode=0644 --strip --strip-program=$STRIPPER sys/.compile_deb/mintdeb.prg install/mint/kernel

# install *.xdd, *.xfs and *.xif
echo -e "\n"
echo " Installing Drivers "
echo "===================="
find sys/ -name '*.xdd' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} install/mint/drivers/xdd \;
find sys/ -name '*.xfs' -not -name 'Makefile.xfs' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} install/mint/drivers/xfs \;
find sys/ -name '*.xif' -exec /usr/bin/install -v -b --mode=0644 --strip --strip-program=$STRIPPER {} install/mint/drivers/xif \;

# install keyboard layouts
echo -e "\n"
echo " Installing Keyboard Tables "
echo "============================"
find sys/ -name '*.tbl' -exec /usr/bin/install -v -b --mode=0644 {} install/mint/tables \;

# install xaaes
echo -e "\n"
echo " Installing  XaAES "
echo "==================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/adi/whlmoose/moose.adi install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/adi/whlmoose/moose_w.adi install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes030.km install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes000.km install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesst.km install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes060.km install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaes040.km install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesv4e.km install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaaesdeb.km install/mint/$VER/xaaes
install -v -b --mode=0644 --strip --strip-program=$STRIPPER xaaes/src.km/xaloader/xaloader.prg install/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/*.rsc install/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/xa_help.txt install/mint/$VER/xaaes
install -v -b --mode=0644 xaaes/src.km/pal/*.pal install/mint/$VER/xaaes/pal
install -v -b --mode=0644 xaaes/src.km/img/8b/*.img install/mint/$VER/xaaes/img/8b
install -v -b --mode=0644 xaaes/src.km/img/hc/*.img install/mint/$VER/xaaes/img/hc
install -v -b --mode=0644 xaaes/src.km/widgets/*.rsc install/mint/$VER/xaaes/widgets
install -v -b --mode=0644 xaaes/src.km/xobj/*.rsc install/mint/$VER/xaaes/xobj

# install tools
echo -e "\n"
echo " Installing  Tools "
echo "==================="
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/cops/*.app install/mint/$VER/tools/cops
install -v -b --mode=0644 tools/cops/rsc/english/cops_rs.rsc install/mint/$VER/tools/cops/rsc/english
install -v -b --mode=0644 tools/cops/rsc/france/cops_rs.rsc install/mint/$VER/tools/cops/rsc/france
install -v -b --mode=0644 tools/cops/rsc/german/cops_rs.rsc install/mint/$VER/tools/cops/rsc/german
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/crypto/crypto install/mint/$VER/tools/crypto
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fdisk/fdisk install/mint/$VER/tools/fdisk
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fdisk/sfdisk install/mint/$VER/tools/fdisk
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/fsetter/fsetter.app install/mint/$VER/tools/fsetter
install -v -b --mode=0644 tools/fsetter/fsetter.rsc install/mint/$VER/tools/fsetter
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/gluestik/gluestik.prg install/mint/$VER/tools/gluestik
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/hypview/hyp_view.app install/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/hyp_view.rsc install/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/hyp_view.cfg install/mint/$VER/tools/hypview
install -v -b --mode=0644 tools/hypview/skins/*.rsc install/mint/$VER/tools/hypview/skins
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/lpflush/lpflush install/mint/$VER/tools/lpflush
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/mgw/mgw.prg install/mint/$VER/tools/mgw
install -v -b --mode=0644 tools/mgw/examples/* install/mint/$VER/tools/mgw/examples
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/tools/mfsconf install/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/tools/flist install/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/minit/minit install/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/minix/fsck/fsck.minix install/mint/$VER/tools/minix
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/mkfatfs/mkfatfs install/mint/$VER/tools/mkfatfs
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/diald install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/slinkctl/slinkctl install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/ifstats install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/masqconf install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/route install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/arp install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/iflink install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/netstat  install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speedd install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/pipes install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/server install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/client install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/hostlookup install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/sockname install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/sockpair install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/tcpsv install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/servlookup install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speed install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/tcpcl install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/dgram install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/udpclnt install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/speed2 install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/dgramd install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/udpserv install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/oobcl install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/protolookup install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/tests/oobsv install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/ifconfig install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/pppconf install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/net-tools/slattach install/mint/$VER/tools/net-tools
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/nfs/mount_nfs install/mint/$VER/tools/nfs
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/strace/strace install/mint/$VER/tools/strace
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/swkbdtbl/swkbdtbl install/mint/$VER/tools/swkbdtbl
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/sysctl/sysctl install/mint/$VER/tools/sysctl
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/toswin2/toswin2.app install/mint/$VER/tools/toswin2
install -v -b --mode=0644 --strip --strip-program=$STRIPPER tools/toswin2/tw-call/tw-call.app install/mint/$VER/tools/toswin2
install -v -b --mode=0644 tools/toswin2/toswin2.rsc install/mint/$VER/tools/toswin2
install -v -b --mode=0644 tools/toswin2/english/toswin2.rsc install/mint/$VER/tools/toswin2/english.rsc
install -v -b --mode=0644 tools/toswin2/allcolors.sh install/mint/$VER/tools/toswin2

# install tools
echo -e "\n"
echo " Installing  Docs "
echo "==================="

# install teradesk. here's a little hack. linux's unzip does not create the
# right filepermissions. so i have to fix it here.
echo -e "\n"
echo -e " Inserting TeraDesk "
echo -e "===================="
cd install/mint/$VER/
# wget -q -T0 -t0 http://solair.eunet.rs/~vdjole/tera403b.zip
wget -q -T0 -t0 http://127.0.0.1/tera403b.zip
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

