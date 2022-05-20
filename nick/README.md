This directory also contains symlinks at JLab to the files below, so one could clone it and access/copy the files that way if that's easier.

## Raw Data

`/cache/clas12/rg-b/production/decoded/006302`

There's 2 TB of RG-B data there, 4 GB per file, 350k events per file.  At 256 logical cores, assuming scaling, that should be about half an hour for one 4 GB file on an Intel Xeon Gold 6130.  One thing I wanted to do is run some scaling tests, 16->256, but the same file can just be read repeatedly for that.

## Software

This is the CLARA installation to use and contains COATJAVA version 8.0.0:

`/cvmfs/oasis.opensciencegrid.org/jlab/hallb/clas12/soft/linux-64/clara/5.0.2_8.0.0/`

The environment variable `CLARA_HOME` should be the absolute path to that directory, and then `JAVA_HOME` should be set to `$CLARA_HOME/jre/linux-64/jre` and `$JAVA_HOME/bin` added to `$PATH`.

## Databases

`/cvmfs/oasis.opensciencegrid.org/jlab/hallb/clas12/soft/noarch/data/ccdb/ccdb_latest.sqlite`
`/cvmfs/oasis.opensciencegrid.org/jlab/hallb/clas12/soft/noarch/data/rcdb/rcdb_latest.sqlite`

And then we set `CCDB_CONNECTION` and `RCDB_CONNECTION` environment variables to:

`sqlite:///$PATH_TO_SQLITE` (3 slashes before the path, so that's 4 total for an absolute path)

## Config File

[data-ai.yaml](data-ai.yaml) is the configuration file for CLARA, configured for the RG-B data set above.

**_Note, the schema_dir in the YAML will need to be uncommented and set to the absolute path of the dst directory at $CLARA_HOME/plugins/clas12/etc/bankdefs/hipo4/singles/dst..., without using an environment variable._**

## Job Command

[clara.sh](clara.sh) in this repo, originates from https://github.com/baltzell/clas12-workflow/blob/master/lib/clas12/scripts/clara.sh

It currently expects any input HIPO files to process to be in the current working directory, and it will process all of them, making one output file for each input file.  It currently puts the output files in the current working directory, prefixed with `rec_`.

Its `-y` option is the path to the above YAML file, and `-t` is the number of threads.

## More info

Here's a [spreadsheet on CLAS12 processing rates on JLab's farm](https://jeffersonlab-my.sharepoint.com/:x:/g/personal/baltzell_jlab_org/EU096WRXcyBLl_ApLfSCuvoBiwsPFfBN_0enCzU3dFV6rw?e=kB44Sj) (link expires in July).
