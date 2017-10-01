## window cmd
# copy *.csv alldic.csv
# cd ..
# cp data/alldic.csv alldic.csv

library(readr)
library(dplyr)
library(tidyr)
alldic <- read_csv("alldic.csv")
alldic <- unique(alldic)
alldic <- alldic[-2,]
names(alldic) <- "data"

tem <-
  alldic %>% 
  separate(data
           , into=c("word","defi")
           , sep = "\" \"")

fwrite(tem, file="./calldic.csv")
alldic <- read_csv("calldic.csv")
