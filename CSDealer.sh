#!/bin/bash

# Dirs
CUR_DIR=$( dirname "$(readlink -f "$0")" )
TEMPLATES_DIR="$CUR_DIR/templates"

# Checks if template dir exist, if not, exit
if [ ! -d $TEMPLATES_DIR ]
then
    echo "Error: cannot find any \"templates\" directory"
    exit 0
fi

# Takes values from Xresources file
xres=$( xrdb -query )
font=$(echo $xres | grep 'font-regular:'| awk '{print $2, $3; exit}')
fontBold=$(echo $xres | grep 'font-bold:'| awk '{print $2, $3; exit}')
foreground=$(echo $xres | grep 'foreground:'| awk '{print $2; exit}')
background=$(echo $xres | grep 'background:'| awk '{print $2; exit}')
color0=$(echo $xres | grep 'color0:'| awk '{print $2; exit}')
color8=$(echo $xres | grep 'color8:'| awk '{print $2; exit}')
color1=$(echo $xres | grep 'color1:'| awk '{print $2; exit}')
color9=$(echo $xres | grep 'color9:'| awk '{print $2; exit}')
color2=$(echo $xres | grep 'color2:'| awk '{print $2; exit}')
color10=$(echo $xres | grep 'color10:'| awk '{print $2; exit}')
color3=$(echo $xres | grep 'color3:'| awk '{print $2; exit}')
color11=$(echo $xres | grep 'color11:'| awk '{print $2; exit}')
color4=$(echo $xres | grep 'color4:'| awk '{print $2; exit}')
color12=$(echo $xres | grep 'color12:'| awk '{print $2; exit}')
color5=$(echo $xres | grep 'color5:'| awk '{print $2; exit}')
color13=$(echo $xres | grep 'color13:'| awk '{print $2; exit}')
color6=$(echo $xres | grep 'color6:'| awk '{print $2; exit}')
color14=$(echo $xres | grep 'color14:'| awk '{print $2; exit}')
color7=$(echo $xres | grep 'color7:'| awk '{print $2; exit}')
color15=$(echo $xres | grep 'color15:'| awk '{print $2; exit}')

for i in $( find "$TEMPLATES_DIR" -type f ); do

    home=$( echo $HOME | sed 's/\//\\\//g')
    tempDir=$( awk -F':' '$1 == "// CSDdir" { print $2; exit }' "$i" | sed -e "s/~/$home/g" )

    if [ "$tempDir" != "" ]
    then

        # Replaces tags with values in current template
        cat "$i" | sed -r \
        -e '/CSDdir/d' \
        -e "s/<font>/$font/g" \
        -e "s/<fontBold>/$fontBold/g" \
        -e "s/<fg>/$foreground/g" \
        -e "s/<bg>/$background/g" \
        -e "s/<color0>/$color0/g" \
        -e "s/<color8>/$color8/g" \
        -e "s/<color1>/$color1/g" \
        -e "s/<color9>/$color9/g" \
        -e "s/<color2>/$color2/g" \
        -e "s/<color10>/$color10/g" \
        -e "s/<color3>/$color3/g" \
        -e "s/<color11>/$color11/g" \
        -e "s/<color4>/$color4/g" \
        -e "s/<color12>/$color12/g" \
        -e "s/<color5>/$color5/g" \
        -e "s/<color13>/$color13/g" \
        -e "s/<color6>/$color6/g" \
        -e "s/<color14>/$color14/g" \
        -e "s/<color7>/$color7/g" \
        -e "s/<color15>/$color15/g" \
        > $tempDir
    fi
done
