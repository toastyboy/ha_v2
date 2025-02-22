#!/bin/bash

cd /home/ftp

max=3000000 # 3Gb roughly

for i in cam1 cam2 cam3
do
  declare $i=`du -s $i | cut -f 1` # create vars cam1,2& 3 etc.. 

  echo "Processing Directory - $i -- size ${!i}"
  while [ `du -s $i | cut -f 1` -gt $max ] # compare dir size to max allowed
  do echo "Alert! Oversized Directory size ${!i} -- Max allowed $max"

    # complex find here, epoch date and sort ascending, then take top (oldest)
    # entry and assign that to variable ready to delete
    p=`find $i -name "*.*" -printf "%T@ %Tc %p\n" | \
    sort -n | head -1 | cut -d' ' -f 8`
    echo "!! Deleting $p"
    rm $p

    declare $i=`du -s $i | cut -f 1` # re-create vars cam1,2& 3 etc..
  done
done
