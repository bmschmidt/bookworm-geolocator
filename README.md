bookworm-geolocator
===================

Geolocation from geonames.org specifically adapted to the needs of library catalog metadata.


It's specifically adapted in two ways:

## 1. Converting library nomenclatures to machine-readable forms.

First, it transform place names into a set of regexes and interfaces for pulling library catalog metadata.

It will apply some standard translations to the type of names that show up in library catalog metadata so that they
succeed in queries to geonames.org. (Why geonames.org? I know that Google's geocoding is better, but their terms of service are quite clear that you can't cache anything,
or display any resuls on a non-Google map. Perhaps there's some OSM-based method out there, but I don't know what it is.)

For example, it currently includes.

## 2. Case-specific corrected data.

What's really interesting about it, though, is the file cachedData.txt.

This is a place to cache the results of previous efforts so that we can all use them.

For example, "Lipsiae" is an extremely common publishing location in many libraries: but though "Lipsia" will be correctly
translated to "Leipzig" by geonames, the `ae` at the end throws them.

Or how do you handle a term like "London and New York," which is extremely common? We'll have to ask some
librarians to be sure.

There are some difficult cases: the worst for me, now, is "Cambridge" with no further qualifiers.

# Dependencies

This uses R and the `geonames` package.
