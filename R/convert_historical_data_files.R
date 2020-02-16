# ****************************************************************************
# Fix Historical csv Files:
# Convert to standard structure: Time | Open | High | Low | Close | Volume
# ****************************************************************************

library(readr)
library(dplyr)

path <- "data/Historical/"
files = list.files(path,".csv")

for(f in files){
  data <- read_csv(paste0(path,f),col_names = FALSE)
  
  if(ncol(data) > 6){
    print("Fixing")
    
    #data <- read_csv(paste0(path,f), col_names = FALSE)
    
    data <- data %>% 
      mutate(Time = paste(gsub("\\.","/",X1),X2)) %>% 
      rename(Open = X3,High = X4,Low = X5,Close = X6,Volume = X7) %>% 
      select(Time,Open,High,Low,Close,Volume)
    
    write_csv(data,paste0(path,f))
    
  }
  
}

