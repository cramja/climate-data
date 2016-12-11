# Climate Data

The scripts in this repo should help you retrieve average daily temperature reports from NOAA's compiled weather station data. You can access their ftp server [here](ftp://ftp.ncdc.noaa.gov/pub/data/gsod).

# Script Usage

These scripts will are tailored for a class project where we needed to get average daily temperatures for a location aligned with the corresponding day since January 1, 1970. Therefore the final output of the `retrieve.py` script will be a folder `clean_data` with csv's in the format "days since 1970, avg_tmp (F)".

```bash
./fetchAndClean.py city-code.in
```

It's that easy!