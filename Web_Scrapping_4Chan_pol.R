# Scraping 4chan:/pol/

library(rvest)

page_numbers <- 2:10 
base_url <- "http://boards.4chan.org/pol/"
paging_urls <- paste0(base_url, page_numbers)

head(paging_urls, 3)

all_links <- NULL
for (url_base in paging_urls) {
  html_document <- read_html(url_base)
  
  links <- html_document %>%
    html_nodes(".postMessage") %>%
    html_text(posts)
  
  all_links <- c(all_links, links)
}

library(tm)

all_links <- Corpus(VectorSource(all_links))

all_links <- tm_map(all_links, removeNumbers)
all_links <- tm_map(all_links, removePunctuation)
all_links <- tm_map(all_links, stripWhitespace)
all_links <- tm_map(all_links, content_transformer(tolower))
all_links <- tm_map(all_links, removeWords, stopwords("en"))
all_links <- tm_map(all_links, stemDocument)

library(topicmodels)

dtm <- DocumentTermMatrix(all_links)

freq <- colSums(as.matrix(dtm))

length(freq)

ord <- order(freq, decreasing=TRUE)

head(freq[ord])
