#' Runs a Bookworm query on a local instance
#'
#'@query A bookworm API call, in the form of an R list (will be coerced to JSON)
#'@host the url of the bookworm being queried
#'@method Should just be the default
#'
webQuery = function(query,host="localhost",method="return_tsv") {
  require(rjson)
  require(RCurl)  
  query[['method']] =  method
  json = URLencode(toJSON(query))
  destination = paste(host,"/cgi-bin/dbbindings.py?queryTerms=",json,sep="")
  if (method!="return_tsv") {
    data = scan(textConnection(getURL(destination)),what='raw',quote=NULL)
    data = data[data!="===RESULT==="]
    data = paste(data,collapse=" ")
    if (try(assign("data",fromJSON(data[1])),silent=T)==FALSE) {
      warning(destination)
    }
  }
  if (method=="return_tsv") {
    cat(destination)
    data = read.table(
      text = getURL(destination),
      header=T,
      sep="\t",
      stringsAsFactors=FALSE,
      blank.lines.skip=T,
      encoding="UTF-8",
      flush=T,
      quote='',
      fill=T,
      comment.char='')
    if(ncol(data)==1 & method=="return_tsv") {
      data = data[grep("^[<>]",data[,1],invert=T),]
      warning(destination)
      return(paste(as.character(data),collapse="\n"))
    }
    data[,ncol(data)] = as.numeric(as.character(data[,ncol(data)]))
  }
  return(data)
}
