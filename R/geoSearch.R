#' Search on geonames.org for a single word.
#'
#' @word a string representing a place: the top search result for geonames will
#' be assigned to it.
#'
#' If no results are found, a row will be returned showing the value as "Unknown"
#' 
geoSearch = function(string) {
    tryCatch({
        require(geonames)
        hierarchy = c("P","A","S")
        val = GNsearch(q=string,maxRows=1)

        if (nrow(val)==0 && grepl("ae$",string)) {
            #Special case for latin names out of the genitive.
            #Doesn't work as well with i -> us, so not bothering. 
            val = GNsearch(q=gsub("ae$","a",string))
        }
       
        if (nrow(val)==0) {
            
            return(data.frame(toponymName="Unknown",adminName1="Unknown",countryName="Unknown",geo="Unknown",geonameId="None",fclName="Unknown"))}
        else {
            return(val %>%
                   mutate(geo=toJSON(c(as.numeric(lat),as.numeric(lng)))) %>%
                   select(toponymName,adminName1,countryName,geo,geonameId,fclName))
        }},error = function(e) {
            a = GNsearch(q=string,maxRows=1)
            stop("couldn't parse string ",string)
        })
}
