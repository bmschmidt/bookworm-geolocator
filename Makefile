all: done

geolocation.cnf:
	echo "There's currently no walkthrough for building a new geolocation.cnf: please copy the sample and do it by hand"


geocoded.txt: geolocation.cnf
	Rscript walkThrough.R

done: geocoded.txt
	cd ../..; python OneClick.py supplementMetadataFromTSV extensions/bookworm-geolocator/geocoded.txt; python OneClick.py reloadMemory
	touch done
