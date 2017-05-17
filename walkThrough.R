
config = data.frame("key"="foo",value="bar")

if (!require("devtools")) {
    install.packages("devtools")
}
devtools::load_all(".")

tryCatch({
    config = read.table('geolocation.cnf',sep="=",col.names=c("key","value"), as.is=c(1,2))
    options(geonamesUsername=config$value[config$key=="geonamesID"])
}, error= function(e) {
    stop("No options file named 'geolocation.cnf' was found in the current directory: please update the sample geolocation file, save it as geolocation.cnf, and try again.")
})

conf = function(key,frame=config) {
    frame$value[frame$key==key]
}

#options(geonamesUsername=conf("geonamesID"))
library(bookworm)
options("geonamesUsername")
geocode(
  db=conf("bookwormName")
  ,
  fieldName=conf("fieldName")
  ,
  n=conf("nToAdd")
  ,
  geonamesid=conf("geonamesID")
  ,
  file=conf("outputFile")
  )
