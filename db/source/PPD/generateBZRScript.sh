#!/bin/sh

# Take scriptname as input parameter
# E.g. generateScript addppd.sh will create file addppd.sh
generateScript () {
    echo '#!/bin/sh' > $1
    echo '' >> $1
    echo '$filelist="' >> $1
    cat $listfilename >> $1
    echo '"' >> $1
    echo '' >> $1
    echo 'bzr add $filelist' >> $1
    echo '# bzr commit $filelist' >> $1
}

# Format list of printer names, separated by <CR><LF> into space separated printer name string
# Take list file name as input.
formatList2String () {
    cat $1 | tr '\012' ' ' > junk.txt
    cat junk.txt | tr -d '\015' > $1
    rm -f junk.txt
}

# Generate bzrAddPPD.sh
scriptname=bzrAddPPD.sh
listfilename=ppdfilelist.txt
cd ../PPD
# E.g. Ricoh/PS/Ricoh-Aficio_CL7300_PS.ppd
ls */*/*.ppd > ../bzr/$listfilename
cd ../bzr
formatList2String $listfilename
generateScript $scriptname
chmod a+x $scriptname
rm $listfilename

# Generate bzrAddXML.sh
scriptname=bzrAddXML.sh
listfilename=xmlfilelist.txt
cd ../XML
ls *.xml > ../bzr/$listfilename
cd ../bzr
formatList2String $listfilename
generateScript $scriptname
chmod a+x $scriptname
rm $listfilename