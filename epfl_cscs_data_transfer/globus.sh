#!/bin/bash

set -e
set +x

FDATA1='fdata1.epfl.ch'

SRC="/work/ska/lofar30MHz_256/"
[ -d $SRC ] || (echo "Error: $SRC does not exit." && exit 1)

[ `hostname` == 'fdata1.epfl.ch' ] || (echo "Error: must be logged into $FDATA1" && exit 1)

CSCS_USER='eorliac'

DEST="/scratch/snx3000/$CSCS_USER/"

CMD="globus-url-copy -vb -p 4 file://$SRC sshftp://$CSCS_USER@gridftp.cscs.ch$DEST"

echo $CMD

time $CMD
