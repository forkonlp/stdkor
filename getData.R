install.packages(c("rvest"))
library(rvest)

num<-1:519120
dat<-c()

for (i in num){
  tar<-paste0("http://stdweb2.korean.go.kr/search/View.jsp?idx=",i,"&go=1")
  str<-Sys.time()
  root <- tar %>%   
    read_html 
  
  (
    word <-
      root %>% 
      html_nodes("span.word_title font") %>% 
      html_text
  )
  (
    defi <-
      root %>% 
      html_nodes("span.Definition") %>% 
      html_text
  )
  
  tem<-data.frame(word=word,definition=defi)
  dir.create("./data",showWarnings = F)
  write.table(
    tem
    , paste0("./data/w",i,".csv")
    , row.names = F
    , fileEncoding = "UTF-8"
  )
  mid<-Sys.time()
  cat(i, " / 519120 ",mid-str,"\n")
}