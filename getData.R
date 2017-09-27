library(rvest)

num<-1:519120
dat<-c()

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
  write.table(
    data.frame(word=word,definition=defi)
    , paste0("./data/w",word,".csv")
    , row.names = F
    , fileEncoding = "UTF-8"
  )
  # dat<-rbind(dat,tem)
  cat(i, " / 519120\n")
}
