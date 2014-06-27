#' Cleans the names of places according to some regexes that work well on library catalogs. 
cleanNames = function(counts) {
  names(counts) = c("originalName","count")
  counts = counts %>% mutate(
    normed = gsub("[\\[\\]\\?\\.]","",originalName,perl=T),
    normed = gsub("(, )?[Ee]tc\\.?$","",normed,perl=T),
    normed = gsub(" +$","",normed,perl=T),     
    normed = gsub("^ +","",normed,perl=T)
  ) %>% 
    group_by(normed) %>% 
    mutate(totalCount = sum(count)) %>% 
    select(normed,count,totalCount,originalName)  
  
  #Some old-style Library of Congress abbreviations for States (in JSON) we want to support: we'll match them at the end of files and replace with the long name.
  
  LOCabbreviations = fromJSON('{"N.B.": "New Brunswick", "N.S.W.": "New South Wales", "Tas.": "Tasmania", "D.F.": "Distrito Federal", "Vic.": "Victoria", "Minn.": "Minnesota", "Wis.": "Wisconsin", "T.H.": "Territory of Hawaii", "P.E.I.": "Prince Edward Island", "N.W.T.": "Northwest Territories", "S.D.": "South Dakota", "Ariz.": "Arizona", "Ind.": "Indiana", "Ont.": "Ontario", "Man.": "Manitoba", "D.C.": "District of Columbia", "Kan.": "Kansas", "Calif.": "California", "Md.": "Maryland", "Ky.": "Kentucky", "N.H.": "New Hampshire", "U.S.S.R.": "Union of Soviet Socialist Republics", "Mont.": "Montana", "N.L.": "Newfoundland and Labrador", "N.C.": "North Carolina", "P.R.": "Puerto Rico", "Ill.": "Illinois", "N.D.": "North Dakota", "Tex.": "Texas", "Colo.": "Colorado", "N.S.": "Nova Scotia", "N.J.": "New Jersey", "Wash.": "Washington", "Nev.": "Nevada", "S. Aust.": "South Australia", "A.C.T.": "Australian Capital Territory", "Mo.": "Missouri", "Qld.": "Queensland", "Ark.": "Arkansas", "Miss.": "Mississippi", "Va.": "Virginia", "Conn.": "Connecticut", "Yukon.": "Yukon Territory", "Neb.": "Nebraska", "U.S.": "United States", "N.T.": "Northern Territory", "Vt.": "Vermont", "W. Va.": "West Virginia", "N.Y.": "New York", "B.C.": "British Columbia", "U.K.": "United Kingdom", "Mass.": "Massachusetts", "V.I.": "Virgin Islands", "Pa.": "Pennsylvania", "Sask.": "Saskatchewan", "Nfld.": "Newfoundland", "Tenn.": "Tennessee", "La.": "Louisiana", "Wyo.": "Wyoming", "N.Z.": "New Zealand", "N.M.": "New Mexico", "W.A.": "Western Australia", "Me.": "Maine", "Ala.": "Alabama", "Del.": "Delaware", "Or.": "Oregon", "Ga.": "Georgia", "Mich.": "Michigan", "Alta.": "Alberta", "R.I.": "Rhode Island", "S.C.": "South Carolina", "Okla.": "Oklahoma", "Fla.": "Florida", "R.S.F.S.R.": "Russian Soviet Federated Socialist Republic"}')  
  
  names(LOCabbreviations) = gsub("\\.","\\\\.?",names(LOCabbreviations))
  
  for (abbreviation in names(LOCabbreviations)) {
    counts$normed = gsub(paste0(" ", abbreviation, "$"),paste0(" ",LOCabbreviations[[abbreviation]]),counts$normed)
  }
  return(counts %>% arrange(-count))
}