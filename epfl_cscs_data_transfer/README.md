# Transferring data between EPFL and CSCS using GridFTP

## Setup

1. Optional, in your `~/.bash_profile`:

   ```
   if [ -z "$SSH_AUTH_SOCK" ] ; then
       eval `ssh-agent -s`
       ssh-add
   fi
   ```

   This will launch the `ssh-agent` if not already running.

2. Log into `fdata1.epfl.ch` using SSH

3. GridFTP on CSCS's side is only accessible via SSH keys. Check the following CSCS's resources:

   1.  https://user.cscs.ch/access/faq/
   2. https://user.cscs.ch/storage/transfer/external/#globus-url-copy-deprecated-

4. Check the man page (on `fdata1.epfl.ch`):

   ```
   $ globus-url-copy -help

   globus-url-copy [options] <sourceURL> <destURL>
   globus-url-copy [options] -f <filename>

   <sourceURL> may contain wildcard characters * ? and [ ] character ranges
   in the filename only.
   Any url specifying a directory must end with a forward slash '/'

   If <sourceURL> is a directory, all files within that directory will
   be copied.
   <destURL> must be a directory if multiple files are being copied.

   ...
   ```

   ​


## Run

See e.g. the script [globus.sh](https://github.com/epfl-radio-astro/howtos/blob/main/epfl_cscs_data_transfer/globus.sh) as an example or the examples in SCITAS's documentation: [Data Transfer Nodes - Documentation - Confluence (epfl.ch)](https://scitasadm.epfl.ch/confluence/display/DOC/Data+Transfer+Nodes#DataTransferNodes-GridFTP). 

Note that fdata servers are only connected to the **/home **and **/work** shared filesystems and to Fidis' **/scratch**, meaning that you cannot directly transfer to/from Izar's and Helvetios's /scratch filesystems.



#### Example:

    SRC="/work/ska/lofar30MHz_256/"
    [ -d $SRC ] || (echo "Error: $SRC does not exit." && exit 1)
    
    DEST="/scratch/snx3000/$CSCS_USER/lofar30MHz_256/"
    
    CMD="globus-url-copy -vb -r -cd -p 4 file://$SRC sshftp://$CSCS_USER@gridftp.cscs.ch$DEST"
    time $CMD 
with the options:

| option           | action                                   |
| ---------------- | ---------------------------------------- |
| -vb              | -verbose-perf<br />During the transfer, display the number of bytes transferred<br />and the transfer rate per second.  Show urls being transferred |
| -r               | -recurse<br />Copy files in subdirectories |
| -cd              | -create-dest<br />Create destination directory if needed |
| -p <parallelism> | -parallel <parallelism><br />specify the number of parallel data connections should be used. |