all: done

geolocation.cnf:
	$(error "There's currently no walkthrough for building a new geolocation.cnf: please copy the sample and do it by hand")

geocoded.txt: geolocation.cnf
	Rscript walkThrough.R

done: geocoded.txt
	bookworm add_metadata -f geocoded.txt --format=tsv
	touch done
