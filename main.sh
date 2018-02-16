#!/bin/bash

# messes up path specified to grep (possibly due to alias)
# set -f

styles_file=$1
target_file=$2

output_dir=temp
output_pos_file=$output_dir/output_positive.css
output_neg_file=$output_dir/output_negative.css

if [[ ! -f $styles_file ]]; then
    echo "Styles file was not specified properly"
    exit 1
fi

if [[ ! -f $target_file ]]; then
    echo "Target file was not specified properly"
fi

echo $output_pos_file
echo $output_neg_file

mkdir -p $output_dir
if [[ -f $output_pos_file ]]; then
    rm $output_pos_file
fi
if [[ -f $output_neg_file ]]; then
    rm $output_neg_file
fi

selector_regex="^\.([^,:>\ ]*)[,:>\ ]"
while read line; do
    # selector does not update unless a positive match occurs
    [[ "$line" =~ $selector_regex ]] && selector=${BASH_REMATCH[1]}

    grep_match_found=1
    while read file; do
        if grep -q "$selector" "$file"; then
            grep_match_found=0
        fi
    done < $target_file

    if [[ $grep_match_found -eq 0 ]]; then
    	echo $line >> $output_pos_file
        echo >> $output_neg_file
    else
        echo >> $output_pos_file
    	echo $line >> $output_neg_file
    fi

done < $styles_file

# internal field seperator, change new lines delimter
# IFS=
# for line in $(cat $1); do
#     [[ "$line" =~ $selector_regex ]] && selector=${BASH_REMATCH[0]}

#     echo $selector
# done
