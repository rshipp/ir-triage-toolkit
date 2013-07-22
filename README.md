ir-triage-toolkit
=================

Create an incident response triage toolkit for use with Windows or
Linux, without violating any license agreements or copyright
restrictions.

## Description
A collection of scripts that can be used to create a toolkit for
incident response and volatile data collection. This includes bash
scripts to create a Linux toolkit, and Batch scripts to create a Windows
toolkit.

## Usage
1. Dowload and extract the [zip](https://github.com/george2/ir-triage-toolkit/archive/master.zip).
2. Open a shell, and change directory to wherever the zip was extracted.
3. Run the script.

Windows:

    create-toolkit E:\Store\it\here

Linux:

    ./create-toolkit /store/it/here

Once the toolkit has been created, you can use it by opening a shell in
the directory where the toolkit is stored, and starting the volatile
data collection script:

Windows:

    run E:\Store\my\volatile\data\here

Linux:

    ./run /store/my/volatile/data/here

Be sure the directory in which you choose to save the volatile data has
plenty of space (several GB, at least), as the script will dump the
contents of the system's memory, and store several other files of
varying sizes. Both Windows and Linux scripts accomplish the same basic
tasks (see tasks.txt), and both follow the order of volatility (OOV) for
data collection as much as possible. They also create detailed,
timestamped logs of the commands executed, and create sha512 checksums
of the files saved to the storage directory. Be prepared for the scripts
to run for a while, as it may take some time to image and compute a
checksum of the system's memory.
