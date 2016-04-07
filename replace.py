#! /usr/bin/python

import sys

try:
    (_,to_replace,replace_with) = sys.argv
except ValueError:
    sys.stderr.write("No input specified: quitting.\nUsage: python replace.py BAD_NAME NAME_WHOSE_DATA_TO_REPLACE WITH\n")
    sys.exit(0)

to_replace = to_replace.decode("utf-8")
replace_with = replace_with.decode("utf-8")

replacement = None

f = open("cachedData.tsv","r")

buffer = []

for line in f:
    line = line.decode("utf-8")
    try:
        (key,rest) = (line.split("\t",1))
    except:
        if line=="\n":
            continue
        else:
            print line
            raise
    if key == replace_with:
        replacement = rest
    buffer.append(line)

if replacement == None:
    sys.stderr.write("'%s' is not the abstracted name of any file in the cached data" % replace_with)
    sys.exit(0)


replaced_string = None
f = open("cachedData.tsv","w")
for line in buffer:
    (key,rest) = (line.split("\t",1))
    if key == to_replace:
        replaced_string = line
        line = key + "\t" + replacement
    try:
        f.write(line.encode("utf-8"))
    except:
        print line
        raise
if replaced_string is None:
    sys.stderr.write("Warning: %s not found in original file, no changes made\n" % to_replace)
else:
    print """Replaced:
    %s
   with
    %s
    """ %(replaced_string.rstrip("\n"),(to_replace +"\t" + replacement).rstrip("\n"))
