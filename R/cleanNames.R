#' Cleans the names of places according to some regexes that work well on library catalogs. 
cleanNames = function(counts) {
  
  
  names(counts) = c("originalName","count")
  
  #This is the stuff that regularizes names through cleaning regexes.
  counts = counts %>% mutate(
    #Drop all characters in this set: ][?.
    normed = gsub("[\\[\\]\\?]","",originalName,perl=T),
    #Replace strings like "Hampton, N. Y." or "U. S. A." (abbreviations with spaces) with "Hampton, NY" or "USA"
    #Sometimes the last period isn't there, so it's optional on the final cycle.
    normed = gsub("(([A-Z])\\. )+(([A-Z])\\.?$)","\\2\\4",normed,perl=T),
    #Periods aren't necessary.
    normed = gsub("\\.","",normed,perl=T),
    #Drop concluding "etc"
    normed = gsub("(, )?[Ee]tc\\.?$","",normed,perl=T),
    # Only take the first element in "Boston and New York," for example, but keep the PA in "Philadelphia and Pittsburgh, PA"
    normed = gsub(" (ie|and|&|und|et) .*(, .*)?","\\2",normed,perl=T),
    #Sometimes they just end or begin with "and"
    normed = gsub(" (&|and|und|et)$","",normed,perl=T),     
    normed = gsub("^(and|&|et|und) ","",normed,perl=T),     
    #There are no other New Yorks, but there are lots of books published in "New York, London", which is not a place,
    #so we fix it. 
    #Note that this doesn't work for Boston, (Boston, England), or London (London, Ontario).
    normed = gsub("New York, .*","New York",normed,perl=T),
    # That said: fuck Philadelphia, Mississippi.
    normed = gsub("Philadelphia, .*","Philadelphia",normed,perl=T),
    #If it ends in "USA," we don't need the country
    normed = gsub("(.*, .*), (USA|UK|United Kingdom)","\\1",normed,perl=T),
    #Drop "in London,", "V Beograd" and so forth.
    normed = gsub("^(in|In|À|A|U|V|W|Imprinted at|Impresa en|Printed at) ","",normed,perl=T),
    
    normed = gsub(" +$","",normed,perl=T),     
    normed = gsub("^ +","",normed,perl=T),
    normed = gsub("#"," ",normed,perl=T) #These screw up the queries
    
  ) %>% 
    group_by(normed) %>% 
    mutate(totalCount = sum(count)) %>% 
    select(normed,count,totalCount,originalName)  
  
  #Some old-style Library of Congress abbreviations for States (in JSON) we want to support: we'll match them at the end of files and replace with the long name.
  
  LOCabbreviations = fromJSON('{"N.B.": "New Brunswick", "N.S.W.": "New South Wales", "Tas.": "Tasmania", "D.F.": "Distrito Federal", "Vic.": "Victoria", "Minn.": "Minnesota", "Wis.": "Wisconsin", "T.H.": "Territory of Hawaii", "P.E.I.": "Prince Edward Island", "N.W.T.": "Northwest Territories", "S.D.": "South Dakota", "Ariz.": "Arizona", "Ind.": "Indiana", "Ont.": "Ontario", "Man.": "Manitoba", "D.C.": "District of Columbia", "Kan.": "Kansas", "Calif.": "California", "Md.": "Maryland", "Ky.": "Kentucky", "N.H.": "New Hampshire", "U.S.S.R.": "Union of Soviet Socialist Republics", "Mont.": "Montana", "N.L.": "Newfoundland and Labrador", "N.C.": "North Carolina", "P.R.": "Puerto Rico", "Ill.": "Illinois", "N.D.": "North Dakota", "Tex.": "Texas", "Colo.": "Colorado", "N.S.": "Nova Scotia", "N.J.": "New Jersey", "Wash.": "Washington", "Nev.": "Nevada", "S. Aust.": "South Australia", "A.C.T.": "Australian Capital Territory", "Mo.": "Missouri", "Qld.": "Queensland", "Ark.": "Arkansas", "Miss.": "Mississippi", "Va.": "Virginia", "Conn.": "Connecticut", "Yukon.": "Yukon Territory", "Neb.": "Nebraska", "U.S.": "United States", "N.T.": "Northern Territory", "Vt.": "Vermont", "W. Va.": "West Virginia", "N.Y.": "New York", "B.C.": "British Columbia", "U.K.": "United Kingdom", "Mass.": "Massachusetts", "V.I.": "Virgin Islands", "Pa.": "Pennsylvania", "Sask.": "Saskatchewan", "Nfld.": "Newfoundland", "Tenn.": "Tennessee", "La.": "Louisiana", "Wyo.": "Wyoming", "N.Z.": "New Zealand", "N.M.": "New Mexico", "Me.": "Maine", "Ala.": "Alabama", "Del.": "Delaware", "Or.": "Oregon", "Ga.": "Georgia", "Mich.": "Michigan", "Alta.": "Alberta", "R.I.": "Rhode Island", "S.C.": "South Carolina", "Okla.": "Oklahoma", "Fla.": "Florida", "R.S.F.S.R.": "Russian Soviet Federated Socialist Republic"}')  
  #Some additional regional identifiers to support
  LOCabbreviations[["Cal."]] = "California"
  LOCabbreviations[["Penna."]] = "Pennsylvania"
  LOCabbreviations[["Col."]] = "Colorado"
  LOCabbreviations[["Wisc."]] = "Wisconsin"
  LOCabbreviations[["Ore."]] = "Oregon"
  
  #Those final periods are optional:
  names(LOCabbreviations) = gsub("\\.","\\\\.?",names(LOCabbreviations))
  
  for (abbreviation in names(LOCabbreviations)) {
    counts$normed = gsub(paste0(" ", abbreviation, "$"),paste0(" ",LOCabbreviations[[abbreviation]]),counts$normed)
  }
  
  
  
  counts$normed[counts$normed=="Lipsiae"] = "Lipsia"
  counts$normed[counts$normed=="Parisiis"] = "Paris"
  
  return(counts %>% arrange(-count))
}
