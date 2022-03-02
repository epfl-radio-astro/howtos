#!/bin/bash

set -e
set +x

FDATA1='fdata1.epfl.ch'
[ `hostname` == $FDATA1 ] || (echo "Error: must be logged into $FDATA1" && exit 1)

MYTEMP="/tmp/$USER/globus$$"

# Change this one!!
CSCS_USER='eorliac'


if [ 1 == 0 ]; then
    echo; echo
    echo "=============================================================================="
    echo " Copying a file from CSCS to EPFL"
    echo "=============================================================================="
    SRC="/scratch/snx3000/$CSCS_USER/1G.file"

    # Copy to a directory to be created if not existing
    DEST_DIR="$MYTEMP/data_from_cscs/"
    CMD="globus-url-copy -vb -cd sshftp://$CSCS_USER@gridftp.cscs.ch$SRC file://$DEST_DIR"
    time $CMD
    tree $MYTEMP

    # Copy with renaming of the file
    DEST="/$DEST_DIR/1G.file_renamed"  
    CMD="globus-url-copy -vb -cd sshftp://$CSCS_USER@gridftp.cscs.ch$SRC file://$DEST"
    time $CMD
    tree $MYTEMP
fi


if [ 1 == 0 ]; then
    echo; echo
    echo "=============================================================================="
    echo " Copying a directory from CSCS to EPFL"
    echo "=============================================================================="
    
    SRC="/scratch/snx3000/$CSCS_USER/test_dir/"
    
    # Copy to a directory to be created if not existing
    DEST_DIR="$MYTEMP/data_from_cscs/test_dir_renamed/"
    CMD="globus-url-copy -vb -cd -r sshftp://$CSCS_USER@gridftp.cscs.ch$SRC file://$DEST_DIR"
    echo $CMD
    time $CMD
    tree $MYTEMP
fi


if [ 1 == 1 ]; then
    
    echo; echo
    echo "=============================================================================="
    echo " Copying a directory from EPFL to CSCS"
    echo "=============================================================================="

    SRC="/work/ska/lofar30MHz_256/"
    [ -d $SRC ] || (echo "Error: $SRC does not exit." && exit 1)

    DEST="/scratch/snx3000/$CSCS_USER/lofar30MHz_256/"

    CMD="globus-url-copy -vb -r -cd -p 4 file://$SRC sshftp://$CSCS_USER@gridftp.cscs.ch$DEST"
    time $CMD
fi
