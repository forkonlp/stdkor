install.packages(c("rvest"))
library(rvest)

num<-11749:519120
dat<-c()

for (i in num){
  tar<-paste0("http://stdweb2.korean.go.kr/search/View.jsp?idx=",i,"&go=1")
  str<-Sys.time()
  tryr<-0
  root<-try(tar %>% read_html, silent = TRUE)
  while(tryr<=5&&class(root)=="try-error"){
    root<-try(tar %>% read_html, silent = TRUE)
    tryr<-tryr+1
    print(paste0("try again: ",tryr," times"))
  }
  if(tryr==5){
    print(paste0("save error: ",tar))
    dir.create("./out",showWarnings = F)
    write.table(
      tar
      , paste0("./out/o",i,".csv")
      , row.names = F
      , col.names = F
      , fileEncoding = "UTF-8"
    )
  }
  
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