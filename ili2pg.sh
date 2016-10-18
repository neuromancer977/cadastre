#!/bin/bash
set -e


PREFIX=/home/drouzaud/Documents/data/cadastre/interlis/gdal-build

export PATH=$PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
export GDAL_DATA=$PREFIX/share/gdal

# java -jar ili2c-4.5.22/ili2c.jar --ilidirs '%ILI_DIR;http://models.interlis.ch/;%JAR_DIR' -oIMD --out bdco.imd DM.01-AV-CH_LV95_24f_ili1.ili

export PGSERVICE=cadastre

psql -c "DROP SCHEMA IF EXISTS vaud CASCADE; CREATE SCHEMA vaud;"
psql -c "DROP SCHEMA IF EXISTS valais CASCADE; CREATE SCHEMA valais;"
psql -c "DROP SCHEMA IF EXISTS fribroug CASCADE; CREATE SCHEMA fribroug;"

echo "*** Port-Valais ***"
./gdal-build/bin/ogr2ogr -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=valais" data/port-valais.itf,bdco.imd
echo "*** VD-1 ***"      
./gdal-build/bin/ogr2ogr -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd-1.itf,bdco.imd
echo "*** VD-2 ***"      
./gdal-build/bin/ogr2ogr -a_srs "EPSG:2056" -gt 20000 -append -f PostgreSQL "PG:dbname=cadastre active_schema=vaud" data/vd-2.itf,bdco.imd


psql -f finalize_import.sql -v ON_ERROR_STOP=ON
