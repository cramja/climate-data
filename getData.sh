# script for getting climate data from NOAA's ftp service

# the codes for stations can be found here: ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv
# take the first two id's and combine them with a dash like so:
# dane co airport: 726410-14837
NOAA_CODE=$1
NOAA_NAME=$2
START_YEAR=1970
END_YEAR=2015

fname=$NOAA_NAME
touch "$fname.out"

for year in $(seq $START_YEAR $END_YEAR); 
do
  echo $year
  wget -nv ftp://ftp.ncdc.noaa.gov/pub/data/gsod/$year/${NOAA_CODE[$i]}-$year.op.gz -O $year.op.gz &> /dev/null

  if [ $? != 0 ] ; then
    echo "$fname $year failed"
  else
    gunzip $year.op.gz
    cat $year.op >> $fname.out
  fi
done

rm *.gz &> /dev/null
rm *.op &> /dev/null

# regex to clean the data:
# ^\d+\s*\d+\s*(\d+)\s*(-?\d+.?\d+).*
# regex to remove headers:
# ^STN---.*\n
