##패키지 설치
install.packages('rJava')

install.packages('memoise')

install.packages('multilinguer')

1번 방법 : install.packages('KoNLP') 


2번 방법 : install.packages("https://cran.rproject.org/src/contrib/Archive/KoNLP/KoNLP_0.80.2.tar.gz", repos=NULL, type="source")


3번 방법 :  install.packages('remotes')
            remotes::install_github('haven-jeon/KoNLP',upgrade =                                       "never",INSTALL_opts=c("--no-multiarch"))


##패키지 로드
```{r}
library(dplyr)
library(multilinguer)
library(rJava)
library(KoNLP)
library(stringr)
useNIADic()
```

##데이터 준비

데이터 불러오기

```{r}
txt <- readLines("hiphop3.txt")
```

특수문자 제거

```{r}
txt <- str_replace_all(txt,"\\W"," ")
```

명사 추출하기

```{r}
wordtest <- extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다.")
```

가사에서 명사추출

```{r}
nouns <- extractNoun(txt)
head(nouns)
```

추출한 명사 list를 문자열 벡터로 변환 , 단어별 빈도표 생성

```{r}
wordcount <- table(unlist(nouns))
```

데이터 프레임으로 변환

```{r}
df_word <- as.data.frame(wordcount , stringsAsFactors = F)
```

변수명 수정

```{r}
df_word <- rename(df_word,
                  word = Var1 , 
                  freq = Freq)
```

두 글자 이상 단어 추출 

```{r}
df_word <- filter(df_word , freq >= 2 )
```

빈도수가 제일 높은 20개 추출

```{r}
top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20
```

워드 클라우드 패키지 로드 

```{r}
library(wordcloud)
library(RColorBrewer)
```

단어 색상 목록 만들기

```{r}
pal <- brewer.pal(8,'Dark2') # Dark2 색상 목록에서 8개 색상 추출
```

워드 클라우드 생성

```{r}
set.seed(1234) #난수 고정
wordcloud(words = df_word$word, #단어 
          freq = df_word$freq, #빈도
          min.freq = 2, # 최소 단어 빈도
          max.words = 200, #표현 단어 수 
          random.order = F, # 고빈도 단어 중앙 배치
          rot.per = .1, #회전 단어 비율 
          scale = c(4 , 0.3), #단어 크기 범위
          colors = pal #색깔 목록
          )
```

단어 색상 바꾸기

```{r}
pal <- brewer.pal(9,'Blues')[5:9] # Dark2 색상 목록에서 8개 색상 추출
```

워드 클라우드 생성

```{r}
set.seed(1234) #난수 고정
wordcloud(words = df_word$word, #단어 
          freq = df_word$freq, #빈도
          min.freq = 2, # 최소 단어 빈도
          max.words = 200, #표현 단어 수 
          random.order = F, # 고빈도 단어 중앙 배치
          rot.per = .1, #회전 단어 비율 
          scale = c(4 , 0.3), #단어 크기 범위
          colors = pal #색깔 목록
)
```

##국정원 트윗 텍스트 마이닝 

데이터 준비하기

데이터 로드 

```{r}
twitter <- read.csv("twitter.csv",
                    header = T,
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8"
                    )
```

변수명 수정

```{r}
twitter <- rename(twitter,
                  no = 번호,
                  id = 계정이름,
                  date = 작성일,
                  tw = 내용
                  )
```

특수문자 제거

```{r}
twitter$tw <- str_replace_all(twitter$tw , '\\W' , ' ')
head(twitter$tw)
```

트윗에서 명사 추출

```{r}
nouns <- extractNoun(twitter$tw)
```

추출한 명사  list를 문자열 벡터로 변환 , 단어별 빈도표 생성

```{r}
wordcount <- table(unlist(nouns))
```

데이터 프레임으로 변환

```{r}
df_word <- as.data.frame(wordcount , stringsAsFactors = F)
```

변수명 수정 

```{r}
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq
                  )
```

두 글자 이상  단어만 추출

```{r}
df_word <- filter(df_word , nchar(word) >= 2)
```

상위 20개 추출

```{r}
top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20
```


단어 빈도 막대그래프 만들기

패키지 로드

```{r}
library(ggplot2)
order <- arrange(top20 , freq)$word  #빈도 순서 변수 생성
```
```{r}
ggplot(data = top20 , aes(x = word , y = freq)) + 
  ylim(0 , 2500) + 
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order) + #빈도 순서 변수 기준 막대 정렬
  geom_text(aes(label = freq), hjust = -0.3) #빈도 표시
```

워드 클라우드 만들기 

```{r}
pal <-  brewer.pal(8,'Dark2')
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 10,
          max.words = 200,
          random.order = F,
          rot.per = .1,
          scale = c(8, 0.2),
          colors = pal
          )
```

색깔바꾸기 

```{r}
pal <-  brewer.pal(9,'Blues')[5:9]
set.seed(1234)
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 10,
          max.words = 200,
          random.order = F,
          rot.per = .1,
          scale = c(8, 0.2),
          colors = pal
)
```
