library(rvest)
library(data.table)
library(R.utils)

options(stringsAsFactors = F)

success <- function(res){
  cat("Request done! Status:", res$status, "\n")
  res$content<-iconv(rawToChar(res$content),from="CP949",to="UTF-8")
  dat <<- c(dat, list(res))
}
failure <- function(msg){
  cat("Oh noes! Request failed!", msg, "\n")
}

num<-1:5192


out<-c()
getHtml<-function(x){
  tryget<-try(evalWithTimeout({
    read_html(x)
  }, timeout=15, onTimeout="error"), silent = T)
  n<-1
  while(class(tryget)[1]!="xml_document"){
    tryget<-try(evalWithTimeout({
      read_html(x)
    }, timeout=15, onTimeout="error"), silent = T)
    n<-n+1
    if(n<5){
      out<<-x
    }
  }
  if(class(tryget)[1]=="xml_document"){
    return(tryget)
  }
}

getCon<-function(x){
  tit <-
    x %>% 
    html_nodes("span.word_title font") %>% 
    html_text
  
  defi <-
    x %>% 
    html_nodes("span.Definition") %>% 
    html_text
  
  tem<-data.table(word=tit, definition=defi)
  return(tem)
}


for (i in num){
  k <- (i-1)*100+1
  tars<-paste0("http://stdweb2.korean.go.kr/search/View.jsp?idx=",k:(k+99),"&go=1")
  
  cont<-lapply(tars, getHtml)
  cont<-lapply(cont, getCon)
  cont<-do.call(rbind, cont)
  
  dir.create("./data",showWarnings = F)
  fwrite(
    cont
    , paste0("./data/w",i,".csv")
    , row.names = F
  )
  # dat<-rbind(dat,tem)
  cat(i, " / 5192\n")
}
