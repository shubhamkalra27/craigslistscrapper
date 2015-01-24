install.packages("rvest")
install.packages("rmarkdown")
library(rvest)
library(rmarkdown)

#looking for iPhones
baseURL <- "https://cincinnati.craigslist.org/search/moa?query=iphone"
n_of_page <- 3
urlVector <- NULL
urlVector[1] <- baseURL

if (n_of_page > 2){
  for (i in 2:n_of_page ) {
    s <- html_session( urlVector[i-1])
    p <- s %>% follow_link(css = ".button.next")
    print(p$url)
    urlVector[i] <- p$url
  }
}
urlVector
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

outputTable <- data.frame(id, title, price_location )

outputTable$price_location

#write.csv(outputTable, file = "D://file.csv")

grepl(pattern ='\\$\\d+\\s+',"  $300   (wyoming)   pic map  cell phones - by owner")

regmatches("h", "hello", invert = TRUE)


x <- c("$215   (Buttermilk)   pic  cell phones - by owner",
       "$300   (wyoming)   pic map  cell phones - by owner",
       "   (Northern Kentucky)     cell phones - by owner"
)
pattern <- "\\$\\d+"

m <- regexec(pattern, x)
valuewithdollar <- regmatches(x, m)

valuewithdollar == character(0)

unlist(valuewithdollar)
valuewithdollar[[3]] <- NA

a <- valuewithdollar

a[sapply(a, is.null)] <- NA
unlist(a)

pattern2 <- ("\\d+$")
n <- regexec(pattern2, valuewithdollar)
ValueNumeric <- as.numeric(regmatches(valuewithdollar, n), na.rm = TRUE)

###############




url <- html("https://cincinnati.craigslist.org/search/moa?query=iphone")


content <- url %>%
  html_nodes(".content")

id <- id + content %>%
  html_nodes(".row") %>%
  html_attr("data-pid")

title <- title + content %>%
  html_nodes(".row .hdrlnk") %>%
  html_text()

rows <-  content %>%
  html_nodes(".row")

price_location <- price_location + rows %>%
  html_node(".l2") %>%
  html_text()  

iphoneTable <- data.frame(id, title,price_location )

iphoneTable$price_location[95]
names(iphoneTable)
str(iphoneTable)

iphoneTable$price_location

for (i in 1:nrow(iphoneTable) ) {
  text <- iphoneTable$price_location[i] 
  gsub(text, "$")
}


grepl("d+",iphoneTable$price_location[100] , perl=TRUE)

grepl("a", c("abc", "def", "cba a", "aa"), perl=TRUE)

' inspired from 
http://blog.rstudio.org/2014/11/24/rvest-easy-web-scraping-with-r/'




