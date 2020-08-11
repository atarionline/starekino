for IMAGE in $(ls -1 *.gif)
do
    echo \*\*\* CONVERTING $IMAGE
    NAME="${IMAGE%.*}"
    #convert $IMAGE -colors 2 -negate $NAME.pbm
    convert $IMAGE[0] -colors 2 -depth 1 $NAME.gray
    #tail -c +12 $NAME.pbm > $NAME.gr8
    mv $NAME.gray $NAME.gr8
#    TEMPLZ4=out/tmp.tzl4
#    ./smallz4-v1.3.1.exe $NAME.gr8 $TEMPLZ4
#    dd if=$TEMPLZ4 of=$NAME.lz4 bs=1 count=$(($(stat -c '%s' $TEMPLZ4) - 11)) skip=11
#    rm $TEMPLZ4
done

