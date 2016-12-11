# script for getting climate data from NOAA's ftp service

# the codes for stations can be found here: ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv
# take the first two id's and combine them with a dash like so:
# dane co airport: 726410-14837
NOAA_CODE=( 722059-99999 722059-04866 726400-14839 726410-14837 726416-14921 726430-14920 726435-14991 726436-94930 726450-14898 726455-94897 726455-99999 726456-94855 726456-99999 726460-14897 726461-14897 726463-14897 727415-04803 )
NOAA_NAME=( Burlington1 Burlington2 Milwaukee DaneCo_Airport TriCounty_regional_airport LaCrosse Chippewa_Valley Volk_Field GreenBay Manitowac1 Manitowac2 Oshkosh1 Oshkosh2 wausau1 wausau2 wausau3 Rhinelander )
START_YEAR=1970
END_YEAR=2015


for i in $(seq 0 `expr ${#NOAA_CODE[@]} - 1`);
do

fname="${NOAA_NAME[$i]}"

for year in $(seq $START_YEAR $END_YEAR); 
do
  echo $year
  wget -nv ftp://ftp.ncdc.noaa.gov/pub/data/gsod/$year/${NOAA_CODE[$i]}-$year.op.gz -O $year.op.gz &> /dev/null

  if [ $? != 0 ] ; then
    echo "$fname $year failed"
  else
    gunzip $year.op.gz
    cat $year.op >> $fname.out
    rm $year.op.gz &> /dev/null
    rm $year.op
  fi
done

python ./cleanData.py $fname.out > $fname.csv
done

# regex to clean the data:
# ^\d+\s*\d+\s*(\d+)\s*(-?\d+.?\d+).*
# regex to remove headers:
# ^STN---.*\n
