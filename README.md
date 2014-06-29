bookworm-geolocator
===================

This provides geolocation of placenames specifically adapted to the needs of library catalog metadata and other publishing-related metadata.

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

That means, for example, that obsolete state abbreviations like "Penna." and "Calif." will be transformed into their modern equivalents; dual places of publication like "London and Edinborough" will be reduced to their first city; and so on.

# Running

First, you have to set up a file named bookworm.cnf. That should have two or three lines, and look basically like this.

```
database=NAMEofBOOKWORM
fieldName=FIELDinBOOKWORMwithGEONAME
geonamesid=YOURidFORgeonames
```

# Contributing

As with all open-source projects, you're welcome to delve into the code.

# Dependencies

This uses R and the `geonames` package.

If you want to add to the cached database, you must also acquire a geonames username.


## Note on sources

The core dataset is geonames.org.

I know that Google's geocoding is better, but their terms of service are quite clear that you can't cache anything, or display any resuls on a non-Google map. Perhaps there's some OSM-based method out there, but I don't know what it is.

So feel free to update this, but please don't do so with any data from the Google maps API.


