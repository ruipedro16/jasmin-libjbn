#!/bin/bash

cp -r ../libjbn .
cp -r ../libjbn_unprotected .

mkdir -p csv

for i in $(seq 4 50)
do
    echo "$i/50"
    
    # Set the number of limbs
    echo "param int NLIMBS = $i;" > libjbn/bn/amd64/ref/param.jinc
    echo "param int NLIMBS = $i;" > libjbn_unprotected/bn/amd64/ref/param.jinc
    sed -i "s/^#define NLIMBS .*/#define NLIMBS $i/" bn_generic.c

    # -------------------------- UNPROTECTED VERSION --------------------------
    jasminc libjbn_unprotected/bn/amd64/ref/bn_generic_export.jinc -o bn_generic_export.s
    gcc bn_generic.c bn_generic_export.s

    # Flush the cache
    echo 3 > /proc/sys/vm/drop_caches # Nao sei se e suposto (?) # Must run as sudo
    ./a.out

    # Move the CSV files to a specific folder
    mkdir -p csv/unprotected_csv_$i
    mv *.csv csv/unprotected_csv_$i

    # -------------------------- PROTECTED VERSION --------------------------
    jasminc libjbn/bn/amd64/ref/bn_generic_export.jinc -o bn_generic_export.s
    gcc bn_generic.c bn_generic_export.s

    # Flush the cache
    echo 3 > /proc/sys/vm/drop_caches # Nao sei se e suposto (?) # Must run as sudo
    ./a.out
    
    # Move the CSV files to a specific folder
    mkdir -p csv/protected_csv_$i
    mv *.csv csv/protected_csv_$i
done

# Remove binary & library
rm -rf a.out libjbn libjbn_unprotected

# Merge the CSV files
echo "Limbs,Function,Protected" > protected.csv
echo "Limbs,Function,Unprotected" > unprotected.csv

for i in $(seq 4 50)
do
    # -------------------------- UNPROTECTED VERSION --------------------------
    echo "$i,$(tail -n 1 csv/unprotected_csv_$i/bn_addn.csv)" >> unprotected.csv
    echo "$i,$(tail -n 1 csv/unprotected_csv_$i/bn_copy.csv)" >> unprotected.csv
    echo "$i,$(tail -n 1 csv/unprotected_csv_$i/bn_eq.csv)" >> unprotected.csv
    echo "$i,$(tail -n 1 csv/unprotected_csv_$i/bn_muln.csv)" >> unprotected.csv
    echo "$i,$(tail -n 1 csv/unprotected_csv_$i/bn_set0.csv)" >> unprotected.csv
    echo "$i,$(tail -n 1 csv/unprotected_csv_$i/bn_sqrn.csv)" >> unprotected.csv
    echo "$i,$(tail -n 1 csv/unprotected_csv_$i/bn_subn.csv)" >> unprotected.csv    
    echo "$i,$(tail -n 1 csv/unprotected_csv_$i/bn_test0.csv)" >> unprotected.csv    

    # -------------------------- PROTECTED VERSION --------------------------
    echo "$i,$(tail -n 1 csv/protected_csv_$i/bn_addn.csv)" >> protected.csv
    echo "$i,$(tail -n 1 csv/protected_csv_$i/bn_copy.csv)" >> protected.csv
    echo "$i,$(tail -n 1 csv/protected_csv_$i/bn_eq.csv)" >> protected.csv
    echo "$i,$(tail -n 1 csv/protected_csv_$i/bn_muln.csv)" >> protected.csv
    echo "$i,$(tail -n 1 csv/protected_csv_$i/bn_set0.csv)" >> protected.csv
    echo "$i,$(tail -n 1 csv/protected_csv_$i/bn_sqrn.csv)" >> protected.csv
    echo "$i,$(tail -n 1 csv/protected_csv_$i/bn_subn.csv)" >> protected.csv    
    echo "$i,$(tail -n 1 csv/protected_csv_$i/bn_test0.csv)" >> protected.csv    
done

sed -i 's/\.csv//' protected.csv
sed -i 's/\.csv//' unprotected.csv

# Remove tmp csv
rm -rf csv
