#!/bin/bash

# Dirs & files
CUR_DIR=$( dirname "$(readlink -f "$0")" )
TEMPLATES_DIR=$CUR_DIR/templates
INDEX=$CUR_DIR/index.ini

# Checks if template dir exist, if not, exit
if [ ! -d $TEMPLATES_DIR ]
then
    echo "Error: cannot find any \"templates\" directory"
    exit 0
fi

# ==============
# FUNCTIONS
# ==============

get_vars () {
  cat $1 | sed -n '/\[variables\]/,/\[.*\]/{/\[.*\]/b;/^;.*/b;p}' | awk -F'=' '/=/ {print $1" "$2}'
}
apply_l_vars () {
  # Checks if local variables are present
  if [ -n "$1" ]
  then
      # Creates sed's arguments
      local sed_args=$( echo "$1" | awk -F ':' '{ print "-e s/@"$1"@/"$2"/g " }' )
      # Applies all variables to file content
      echo "$2" | sed -e "/var\s/d" $sed_args
  else
      echo "$2"
  fi
}

apply_g_vars () {
  # Checks if global variables exists
  if [ -n "$1" ]
  then
      # Creates sed's arguments
      local sed_args=$( echo "$1" | awk '{ print "-e s/@"$1"@/"$2"/g " }' )
      # Applies all variables to file content
      echo "$2" | sed $sed_args
  else
      echo "$2"
  fi
}

# ==============

# Takes values from Xresources file
xres=$( xrdb -query )
font=$(echo "$xres" | awk ' /font-regular:/ {print $2, $3; exit}')
fontBold=$(echo "$xres" | awk ' /font-bold:/ {print $2, $3; exit}')
foreground=$(echo "$xres" | awk ' /foreground:/ {print $2; exit}')
background=$(echo "$xres" | awk ' /background:/ {print $2; exit}')
color0=$(echo "$xres" | awk ' /color0:/ {print $2; exit}')
color8=$(echo "$xres" | awk ' /color8:/ {print $2; exit}')
color1=$(echo "$xres" | awk ' /color1:/ {print $2; exit}')
color9=$(echo "$xres" | awk ' /color9:/ {print $2; exit}')
color2=$(echo "$xres" | awk ' /color2:/ {print $2; exit}')
color10=$(echo "$xres" | awk ' /color10:/ {print $2; exit}')
color3=$(echo "$xres" | awk ' /color3:/ {print $2; exit}')
color11=$(echo "$xres" | awk ' /color11:/ {print $2; exit}')
color4=$(echo "$xres" | awk ' /color4:/ {print $2; exit}')
color12=$(echo "$xres" | awk ' /color12:/ {print $2; exit}')
color5=$(echo "$xres" | awk ' /color5:/ {print $2; exit}')
color13=$(echo "$xres" | awk ' /color13:/ {print $2; exit}')
color6=$(echo "$xres" | awk ' /color6:/ {print $2; exit}')
color14=$(echo "$xres" | awk ' /color14:/ {print $2; exit}')
color7=$(echo "$xres" | awk ' /color7:/ {print $2; exit}')
color15=$(echo "$xres" | awk ' /color15:/ {print $2; exit}')


# Gets global variables, if present
g_vars=$( get_vars $INDEX )

# Go through every file in template directory
for i in $( find "$TEMPLATES_DIR" -type f ); do

    # Extracts CSDdir from the current file and if it finds `~` replaces it with home directory
    home=$( echo $HOME | sed 's/\//\\\//g')
    csd_dir=$( awk -F':' '/CSDdir/ { print $2; exit }' "$i" | sed -e "s/~/$home/g" )

    # Checks if the current file is a template
    if [ "$csd_dir" != "" ]
    then

        content=$( cat "$i" )

        # Replaces tags with values in current template
        content=$( echo "$content" | sed \
        -e '/CSDdir/d' \
        -e "s/@font@/$font/g" \
        -e "s/@fontBold@/$fontBold/g" \
        -e "s/@fg@/$foreground/g" \
        -e "s/@bg@/$background/g" \
        -e "s/@color15@/$color15/g" \
        -e "s/@color14@/$color14/g" \
        -e "s/@color13@/$color13/g" \
        -e "s/@color12@/$color12/g" \
        -e "s/@color11@/$color11/g" \
        -e "s/@color10@/$color10/g" \
        -e "s/@color9@/$color9/g" \
        -e "s/@color8@/$color8/g" \
        -e "s/@color7@/$color7/g" \
        -e "s/@color6@/$color6/g" \
        -e "s/@color5@/$color5/g" \
        -e "s/@color4@/$color4/g" \
        -e "s/@color3@/$color3/g" \
        -e "s/@color2@/$color2/g" \
        -e "s/@color1@/$color1/g" \
        -e "s/@color0@/$color0/g" )

        # Applies global variables to content
        content=$( apply_g_vars "$g_vars" "$content" )

        # Gets local variables, if present
        l_vars=$( echo "$content" | awk ' /var/ { print $2.$3 }' )

        # Applies local variables to content
        content=$( apply_l_vars "$l_vars" "$content" )

        # Writes modified content in the specified directory
        echo "$content" > $csd_dir
    fi
done
