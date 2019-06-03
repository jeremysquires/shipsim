# Benchmark Data

In order to exercise the ship simulator on large volumes of realistic data, ships' position data was obtained and it was partitioned into varying levels of load for benchmarking the application.

See the description of AIS below that describes the raw data sources.

The raw data needed to be processed into load test input data for shipsim. The javascript node.js code to create the load test data is here: [geodata](https://github.com/jeremysquires/geodata).

Get the processed benchmark data from Google Drive here: [ShipSimLoadTestData](https://drive.google.com/open?id=1neWETR0da31QCafdQrlnriIiHfOSiovC)

## Bench Test

Process or download the files, install them in the `bench/data` folder, gunzip them if necessary, and then run the bench tests:

>
> `mix run bench/run_sim_bench.exs`
>

## AIS - Automatic Identification System

AIS systems record position and other properties of ship movements in real time from low cost broadcasting sensors aboard ships.

Governments, commercial providers, and even volunteer groups collate this data and provide it to shipping concerns and individual ships for the purposes of voyage planning, scheduling, collision avoidance, rescue and research.

The US and Australian governments provide historical AIS data for free in a variety of formats. From 2015 onwards, the USA data sets are provided in CSV, making them easier to process. The Australian data sets and the USA data sets before 2015 are in ESRI File Geodatabase format which can be converted to other formats using [GDAL](https://www.osgeo.org/projects/gdal/), in particular, using the [ogr2ogr](https://github.com/OSGeo/gdal) command line.

* Example: `ogr2ogr -overwrite -f CSV "test.csv" "test.gdb" "test_layer"`

Once the data is in CSV format, converting it to GeoJSON or some other format is a straight forward mapping of headers to field keys in the target format.

## References

* [AIS Data Source Listing](https://mods.marin.nl/plugins/servlet/mobile?contentId=28770764#content/view/28770764)
* [USA AIS Data](https://marinecadastre.gov/ais/)
* [Australian AIS Data](https://en.wikipedia.org/wiki/Automatic_identification_system)


