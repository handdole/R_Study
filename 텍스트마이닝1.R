install.packages("https://cran.rproject.org/src/contrib/Archive/KoNLP/KoNLP_0.80.2.tar.gz", repos=NULL, type="source")
#위에 있는게 install.packages("KoNLP")랑 같음. 
install.packages("memories")
install.packages("rJava")
install.packages(c("stringr", "hash", "tau", "Sejong", "RSQLite", "devtools"), type = "binary")

Sys.setenv(JAVA_HOME='C:/Program Files/Java/jdk1.8.0_241/jre')
install.packages('remotes')
remotes::install_github('haven-jeon/KoNLP',upgrade = "never",INSTALL_opts=c("--no-multiarch"))

library(KoNLP)
library(dplyr)

useNIADic()

txt <- readLines("hiphop3.txt")
head(txt)

library(stringr)
txt <- str_replace_all(txt,"\\W"," ")
head(txt)


extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다.")
library()