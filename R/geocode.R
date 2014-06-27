#' Geocode the most common entries in a data frame
#' 
#' This function geocodes a data frame listed.
#' 
#' @places a data.frame with column giving place names.
#' @name the name of the column in the data.frame giving the 
#' @n the number of entries to look up online (geonames has a limit.)
#' @file  the file to output a table to, suitable for reading in Bookworm format.
#' 


geocode = function(db,fieldName,n=0,file="geocoded.txt") {
  config = read.table('geolocation.cnf',sep="=",col.names=c("key","value"), as.is=c(1,2))
  options(geonamesUsername=config$value[config$key=="geonamesUsername"])
  #temporary hack:
  idField = paste0(fieldName,"__id")
  search_limits = list(list("$gte"=0)); names(search_limits)= idField
  places = webQuery(host="localhost",
                    query=list(database=db,groups=list(fieldName),
                               search_limits = search_limits,
                               counttype=list("TextCount"))
  )
  grouped = cleanNames(places)
  
{  #This block matches against cached data, and update the cached data with `n` new results
    
    cachedData=read.table("cachedData.txt",sep="\t",header=T,quote="",comment.char="",stringsAsFactors=F)
    if (n>0) {
      unseen = grouped %>% filter(!normed %in% cachedData$normed)
      #Make it just one column with no duplicates
      unseen = data.frame(normed=unique(unseen$normed)) %>% as.tbl
      newData =
        unseen %>% head(n) %>% group_by(normed) %>% do(geoSearch(.$normed))
      #For each name, we select the following elements
      cachedData = rbind(cachedData,newData)
      write.table(cachedData,file="cachedData.txt",sep="\t",quote=F,row.names=F,col.names=T)
    }
  }
  #To code by location, we match the normalized data against us.
  coded = grouped %>% inner_join(cachedData)
  
  #Then the stuff that's actually worth loading:
  loadable = coded %>% ungroup() %>% select(originalName,toponymName,adminName1,countryName,geo)
  names(loadable) = paste(fieldName,names(loadable),sep="_")
  names(loadable)[1] = fieldName
  write.table(loadable,file,sep="\t",row.names=F,col.names=T,quote=F)
}