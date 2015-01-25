install.packages("rvest")
install.packages("rmarkdown")
library(rvest)
library(rmarkdown)

find <- "iPhone"
localCraiglist <- "cincinnati" # eg cincinnati, sfbay etc

ppa <- sprintf("https://%s.craigslist.org/search/moa?query=%s",localCraiglist ,find)


#looking for iPhones
baseURL <- 
baseURL <- paste("https://cincinnati.craigslist.org/search/moa?query=",find,sep = "")
n_of_page <- 3
urlVector <- NULL
urlVector[1] <- baseURL

#gathering all the URLs
if (n_of_page > 2){
  for (i in 2:n_of_page ) {
    s <- html_session( urlVector[i-1])
    p <- s %>% follow_link(css = ".button.next")
    print(p$url)
    urlVector[i] <- p$url
  }
}
urlVector

#scraping data of the web. 
id <- NULL ; title <- NULL; price_location <- NULL;
for(i in 1:length(urlVector)){ 
  urlVector[i]
  htmlVal <- html(urlVector[i])
  
  #outer containter
  contentClass <- htmlVal %>%
    html_nodes(".content")
  
  #fetching ID from attr
  id <- c(id, c(contentClass %>%
                  html_nodes(".row") %>%
                  html_attr("data-pid") %>%
                  as.numeric()
  ))  
  
  title <- c(title , c(contentClass %>%
                         html_nodes(".row .hdrlnk") %>%
                         html_text()
  ))
  
  rowClass <-  contentClass %>%
    html_nodes(".row")
  
  price_location <- c(price_location, c(rowClass %>%
                                          html_node(".l2") %>%
                                          html_text()  
  ))  
  
}

'clearing out price and location from proce_location'
#write.csv(outputTable, file = "D://file.csv")

# 1. Price
pattern <- "\\$\\d+"

m <- gregexpr(pattern, price_location)
valuewithdollar <- regmatches(price_location, m)

valuewithdollar[sapply(valuewithdollar, function(x){identical(x, character(0)) })] <- NA

valuewithdollar <- unlist(valuewithdollar)

pattern2 <- ("\\d+$")
n <- gregexpr(pattern2, valuewithdollar)
price <- as.numeric(regmatches(valuewithdollar, n), na.rm = TRUE)

#2 location
pattern3 <- "(?<=\\()(.*?)(?=\\))"
o <- gregexpr(pattern3, price_location, perl = TRUE)
location <- regmatches(price_location, o)

#adding NA's where it is missing
location[sapply(location, function(x){identical(x, character(0)) })] <- NA

location <- unlist(location)

outputTable <- data.frame(id, title, price, location )

'inspired from 
http://blog.rstudio.org/2014/11/24/rvest-easy-web-scraping-with-r/'



