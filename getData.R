library(rvest)
library(data.table)

num<-1:519120
dat<-c()
str<-Sys.time()
for (i in num){
  tar<-paste0("http://stdweb2.korean.go.kr/search/View.jsp?idx=",i,"&go=1")
  
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
  
  tem<-data.table(word=word,definition=defi)
  dat<-rbind(dat,tem)
  if(i%%300==0){
    fwrite(
      dat
      , paste0("./data/w",i,".csv")
      , row.names = F
    )
    dat<-c()
    mid<-Sys.time()
    cat("save", mid-str,"\n")
  }
  cat(i, " / 519120\n")
}