bookworm-geolocator
===================

This provides geolocation of placenames specifically adapted to the needs of bookworm installation.

It has two different datasets currently built in. 

1. The first (and better developed) is on the master branch--it's built to work with **library--appropriate** locations.

2. The second is built to better geocode the output of locations produced by the Stanford Named-Entity Recognition parser. The core files of updated name files have been produced by Mitch Fraas of the University of Pennsylvania. That work is stored, for the time being, on the "NER" branch, although it will be integrated as an option into the main tree eventually.


It's built as a Bookworm plugin, so by default it gets the data about publication places from a local API call.

Since the core functionality is an R package, some of the algorithms and data could be easily ported to non-bookworm systems.



## 1. A large database of edited library-appropriate locations.

Mass-market geolocation is often inappropriate for library metadata; this cached set allows collaboration. 

See the file cachedData.txt to browse or edit these fields.

Most of these are simply copied names from the geonames.org API (the geonames key serves as the unique identifier for a place), but they have been tailored for library data is two important ways:

1. **New entries for some large publishing centers not included in geonames**, including a large number of **Latin** placenames.
2. Sensible defaults for publishing ("Salem" with no other qualifiers is taken to mean the city in Massachusetts, not the much larger city in Tamil Nadu; "Phila" means Philadelphia, not Ban Phila in Laos.) There are some difficult cases: the worst for me, now, is "Cambridge" with no further qualifiers, which currently points to Massachusetts, not England.
3. Library nomenclature like "S.l." is supported.

Having a large list of major publication centers also dramatically speeds up geolocation on large sets, because you're saved the trouble of using up API quotas for most of the most common locations.

It also includes an increasing number of colleges and universities.

## 2. Converting library nomenclatures to machine-readable forms.

Before geolocating, this performs a large numbers of checks and transformations to try to get data into the best form possible for geolocation.

That means, for example, that obsolete state abbreviations like "Penna." and "Calif." will be transformed into their modern equivalents; dual places of publication like "London and Edinborough" will be reduced to their first city; it knows that "V Beograd" means "V Belgrade," and drops the "V" from the front; and so on.

This sort of cleaning is often done manually, but the rules should be widely shared across platforms. (Perhaps even more widely shared than the default names; it's conceivable we might want separate lookup databases for the New and Old World, eventually.

# Running

First, you have to set up a file named geolocation.cnf. Copy the file `SAMPLEgeolocation.cnf` provided, change the variables, and move to your place.

Then run using R. `Rscript walkThrough.R` should run, downloading up to n new places as specified in your config and using the existing ones from the cache.

You'll need to install a few packages in addition to base R: RCurl (which requires the dev curl lib, not just plain old curl), dplyr, geonames, etc.

Finally, you've got a file called `geocoded.txt`. 

Run the following line `cd ../..; python OneClick.py supplementMetadataFromTSV extensions/bookworm-geolocator/geocoded.txt`.

And your bookworm is updated with a whole bunch of new geodata.




# Contributing

1. As with all open-source projects, you're welcome to delve into the code, obviously.

2. For scholars/librarians who aren't comfortable doing that: you can also contribute by cleaning up or adding to the "cachedData.tsv" file. You may edit it by hand: or, your local copy will be automatically updated every time you run the script to add new entries.


# Dependencies

This uses R and the `geonames` package.
It also relies on the r packages:

* `dplyr`
* `devtools`
* `geonames`
    * If you want to add to the cached database, you must also acquire a geonames username. It should run without one, though, as long as your configuration file doesn't look for new files.


## Note on sources

The core dataset is geonames.org.

I know that Google's geocoding is better, but their terms of service are quite clear that you can't cache anything, or display any resuls on a non-Google map. Perhaps there's some OSM-based method out there, but I don't know what it is.

So feel free to update this, but please don't do so with any data from the Google maps API.


