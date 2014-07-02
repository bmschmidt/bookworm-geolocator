
tryCatch({
  config = read.table('geolocation.cnf',sep="=",col.names=c("key","value"), as.is=c(1,2))
  options(geonamesUsername=config$value[config$key=="geonamesUsername"])
}, error= function(e) {
  warning("No options file named 'geolocation.cnf' was found in the current directory")
  config = data.frame("key"="foo",value="bar")
})



if (!require("devtools")) {
    install.packages("devtools")
}
if (!require("booklocation")) {
    devtools::install_github("bmschmidt/bookworm-geolocation")
}

Prompt = function(...,withConfirmation=TRUE,default=F) {
    prompt = paste(...,collapse="",sep="")
    if (default) {prompt = paste0(prompt, " [",default,"]: ")}
    cat(prompt)
    value <- readLines(file("stdin"),n=1)
    if (default && value=="") {
        value = default
    }
    if (withConfirmation) {
        correct = Prompt("You have entered '",value,"': is that correct (y/n)? ",withConfirmation=FALSE)
        if (correct %in% c('y',"Y","yes")) {
            return(value)
        } else {
            return(Prompt(...))
        }
    } else {
        return(value)
    }
}


for (key in config$key) {
    assign(key,config$value[config$key==key])
}

if (!exists("geonamesID")) {
    geonamesID = Prompt("Enter your geonamesID, or leave blank to use only cached data: ",default="")
}

if (!exists("bookwormName")) {
    bookwormName = Prompt("Enter the name of the tsv file or Bookworm installation to use: ")
}

if (!exists("fieldName")) {
    fieldName = Prompt("Enter the field name that contains places: ")
}

if (!exists("outputFile")) {
  outputFile = Prompt("Enter your destination file: ",default="geocoded.txt")
}

if (!exists("nToAdd") & geonamesID != "") {
    nToAdd = Prompt("How many new values do you want to check on geonames.org? ")
}

geocode(bookwormName,fieldName,n=nToAdd,geonamesid=geonamesID,file=outputFile)
