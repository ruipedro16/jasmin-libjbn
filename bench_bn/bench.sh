#!/bin/sh

cp -r ../libjbn .
cp -r ../libjbn_unprotected .

# Compile the protected version of libjbn
jasminc -checkSCT libjbn/bn/amd64/ref/bn_generic_export.jinc 2> /dev/null || (echo "Not SCT" ; exit 1)
jasminc libjbn/bn/amd64/ref/bn_generic_export.jinc -o bn_generic_export.s

gcc bn_generic.c bn_generic_export.s

# Flush the cache
echo 3 > /proc/sys/vm/drop_caches # Nao sei se e suposto (?) # Must run as sudo

# Run benchmarks
./a.out

# Move the CSV files to other folder
mkdir -p csv_protected
mv *.csv csv_protected

# Compile the unprotected version of libjbn
jasminc libjbn_unprotected/bn/amd64/ref/bn_generic_export.jinc -o bn_generic_export.s

gcc bn_generic.c bn_generic_export.s

# Flush the cache
echo 3 > /proc/sys/vm/drop_caches # Nao sei se e suposto (?) # Must run as sudo

# Run benchmarks
./a.out

# Move the CSV files to a specific folder
mkdir -p csv_unprotected
mv *.csv csv_unprotected

# Merge the all the csv
echo "Function,Protected" > protected.csv
echo "Function,Unprotected" > unprotected.csv

cat csv_protected/* >> protected.csv
cat csv_unprotected/* >> unprotected.csv

sed -i 's/\.csv//' protected.csv
sed -i 's/\.csv//' unprotected.csv

rm -rf *.s *.out libjbn libjbn_unprotected csv_protected csv_unprotected 
