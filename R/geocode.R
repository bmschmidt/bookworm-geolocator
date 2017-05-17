#' Geocode the most common entries in a data frame
#'
#' This function geocodes a data frame listed.
#'
#' @places a data.frame with column giving place names.
#' @name the name of the column in the data.frame giving the
#' @n the number of entries to look up online (geonames has a limit.)
#' @file  the file to output a table to, suitable for reading in Bookworm format.


geocode = function(
    db=readline("Enter the name of the local bookworm installation or tsv file to read from: ")
    ,
    fieldName=readline()
    ,
    n=ifelse(geonamesid=="",0,50)
    ,
    file="geocoded.txt",
    geonamesid="",
    port=80
    ) {
    if (grepl(".(tsv|txt)$",db)) {
        #temporary hack allow you to ingest straight from a text file.
        places = read.table(db,sep="\t",header=T,stringsAsFactors=F) %>% group_by(fieldName) %>% summarize(count=n())
    } else {
        idField = paste0(fieldName,"__id")
        search_limits = list(list("$gte"=1)); names(search_limits)= idField
	      # pull from localhost.
        places = bookworm(host="localhost",port = port,
                          counttype=c("TextCount"),
            query=list(database=db,
                groups=list(fieldName),
                search_limits = search_limits
                )
            )
    }
    grouped = cleanNames(places)
    grouped_and_filtered = grouped %>% group_by(normed) %>% summarize(count=sum(count))
      {
          #This block matches against cached data, and update the cached data with `n` new results
          cachedData=readr::read_tsv("cachedData.tsv")
          if (n>0) { #(If we're checking anything)
              unseen = grouped_and_filtered %>% anti_join(cachedData) %>% arrange(-count)
              #Run a web search for every unseen element
              message(paste0("The most common missing location, with ",unseen$count[1]," occurrences, is ",unseen$normed[1],": fetching that and ",n-1," more")) 
              newData = unseen %>% head(n) %>% group_by(normed) %>% do({message(.$normed); geoSearch(.$normed)})
                                          #For each name, we select the following elements
              cachedData = rbind(cachedData %>% ungroup,newData %>% ungroup)
              write.table(cachedData %>% arrange(normed),file="cachedData.tsv",sep="\t",quote=F,row.names=F,col.names=T)
          }
      }
    #To code by location, we match the normalized data against us.
    coded = grouped %>% ungroup %>% inner_join(cachedData) %>% filter(!is.na(normed))
    coded %>% filter(!is.na(normed))
    #Then the stuff that's actually worth loading:
    loadable = coded %>% ungroup() %>% select(originalName,toponymName,adminName1,countryName,geo)
    names(loadable) = paste(fieldName,names(loadable),sep="_")
    names(loadable)[1] = fieldName
    loadable
    write.table(loadable,file,sep="\t",row.names=F,col.names=T,quote=F)
}
