#' Search on geonames.org for a single word.
#' 
#' @word a string representing a place: the top search result for geonames will 
#' be assigned to it.
#' 
#' If no results are found, a row will be returned showing the value as "Unknown"
geoSearch = function(string) {
  require(geonames)
  val = 
    GNsearch(q=string,maxRows=1)
  if (nrow(val)==0) {
    return(data.frame(toponymName="Unknown",adminName1="Unknown",countryName="Unknown",geo="Unknown",geonameId="None",fclName="Unknown"))}
  else {
    return(val %>% 
             mutate(geo=toJSON(c(as.numeric(lat),as.numeric(lng)))) %>% 
             select(toponymName,adminName1,countryName,geo,geonameId,fclName)) 
  }
}
