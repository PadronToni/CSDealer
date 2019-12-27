#!/bin/bash

# Dirs
CUR_DIR=$( dirname "$(readlink -f "$0")" )
TEMPLATES_DIR="$CUR_DIR/templates"

if [ ! -d $TEMPLATES_DIR ]
then
    echo "Error: cannot find any \"templates\" directory"
    exit 0
fi


# Font
    font=$(xrdb -query | grep 'font-regular:'| awk '{print $2, $3; exit}')
    fontBold=$(xrdb -query | grep 'font-bold:'| awk '{print $2, $3; exit}')

# Colors, takes color variables from Xresources file
    foreground=$(xrdb -query | grep 'foreground:'| awk '{print $2; exit}')
    background=$(xrdb -query | grep 'background:'| awk '{print $2; exit}')
    color0=$(xrdb -query | grep 'color0:'| awk '{print $2; exit}')
    color8=$(xrdb -query | grep 'color8:'| awk '{print $2; exit}')
    color1=$(xrdb -query | grep 'color1:'| awk '{print $2; exit}')
    color9=$(xrdb -query | grep 'color9:'| awk '{print $2; exit}')
    color2=$(xrdb -query | grep 'color2:'| awk '{print $2; exit}')
    color10=$(xrdb -query | grep 'color10:'| awk '{print $2; exit}')
    color3=$(xrdb -query | grep 'color3:'| awk '{print $2; exit}')
    color11=$(xrdb -query | grep 'color11:'| awk '{print $2; exit}')
    color4=$(xrdb -query | grep 'color4:'| awk '{print $2; exit}')
    color12=$(xrdb -query | grep 'color12:'| awk '{print $2; exit}')
    color5=$(xrdb -query | grep 'color5:'| awk '{print $2; exit}')
    color13=$(xrdb -query | grep 'color13:'| awk '{print $2; exit}')
    color6=$(xrdb -query | grep 'color6:'| awk '{print $2; exit}')
    color14=$(xrdb -query | grep 'color14:'| awk '{print $2; exit}')
    color7=$(xrdb -query | grep 'color7:'| awk '{print $2; exit}')
    color15=$(xrdb -query | grep 'color15:'| awk '{print $2; exit}')


for i in $( find "$TEMPLATES_DIR" -type f ); do

    home=$( echo $HOME | sed 's/\//\\\//g')
    tempDir=$( awk -F':' '$1 == "// CSDdir" { print $2; exit }' "$i" | sed -e "s/~/$home/g" )

    if [ "$tempDir" != "" ]
    then
        content=$( cat $i )

        # replace tags with values in current template
        echo "$content" | sed -r \
        -e '/CSDdir/d' \
        -e "s/<font>/$font/g" \
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
