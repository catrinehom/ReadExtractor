# ReadExtractor

ReadExtractor is a pipeline to find read ID's from reads from Nanopore MinION sequencing matching input references. 

## Requirements

- [KMA](https://bitbucket.org/genomicepidemiology/kma/src/master/) 

## Installation

The following instructions will install the latest version of ReadExtractor:

```
git clone https://github.com/catrinehom/ReadExtractor.git

cd ReadExtractor/

chmod a+x ReadExtractor.sh
chmod a+x IDFinder.py
chmod a+x ErrorHandling.py
```

### Move to bin 
You might want to move the program to your bin to make the program globally excecutable. 
The placement of your bin depends on your system configuration, but common paths is:

```
/usr/local/bin/
```
OR
```
~/bin/
```

Example of move to bin:

```
mv ReadExtractor.sh /usr/local/bin/
mv IDFinder.py /usr/local/bin/
mv ErrorHandling.py /usr/local/bin/
```

## Usage

To run full pipeline:

```
./ReadExtractor.sh [-i <fastq filename>] [-r <references filename>] [-o <output filename>]
```

