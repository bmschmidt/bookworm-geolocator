bookworm-geolocator
===================

This provides from geonames.org specifically adapted to the needs of library catalog metadata.

It's built as a Bookworm plugin, so by default it gets the data about publication places from a local API call.

Some of the algorithms and data could be easily ported to other 


It's specifically adapted in two ways:

## 1. A large database of hand-crafted library-appropriate locations.

Mass-market geolocation is often inappropriate for library metadata; this cached set allows collaboration. 

See the file cachedData.txt to browse or edit these fields.

Most of these are simply copied names from the geonames.org API (the geonames key serves as the unique identifier for a place), but they have been tailored for library data is two important ways:

1. **New entries for some large publishing centers not included in geonames**, including a large number of **Latin** placenames.
2. Sensible defaults for publishing ("Salem" with no other qualifiers is taken to mean the city in Massachusetts, not the much larger city in Tamil Nadu; "Phila" means Philadelphia, not Ban Phila in Laos.) There are some difficult cases: the worst for me, now, is "Cambridge" with no further qualifiers, which currently points to Massachusetts, not England.

Having a large list of major publication centers also dramatically speeds up geolocation on large sets, because you're saved the trouble of using up API quotas for most of the most common locations.

## 2. Converting library nomenclatures to machine-readable forms.

First, it transform place names into a set of regexes and interfaces for pulling library catalog metadata.

It will apply some standard translations to the type of names that show up in library catalog metadata so that they
succeed in queries to geonames.org. 
For example, it currently includes.

# Running

First, you have to set up a file named bookworm.cnf. That should have two or three lines, and look basically like this.

```
database=NAMEofBOOKWORM
fieldName=FIELDinBOOKWORMwithGEONAME
geonamesid=YOURidFORgeonames
```

# Dependencies

This uses R and the `geonames` package.

If you want to add to the cached database, you must also acquire a geonames username.


## Note on sources

The core dataset is geonames.org.

I know that Google's geocoding is better, but their terms of service are quite clear that you can't cache anything, or display any resuls on a non-Google map. Perhaps there's some OSM-based method out there, but I don't know what it is.

So feel free to update this, but please don't do so with any data from the Google maps API.


