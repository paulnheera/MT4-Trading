# RDS to CSV:

library(quantmod)
library(readr)

file <- "EURUSD60.rds"

# Load RDS data:
ts <- readRDS(file.path("data",file))

# Convert to data frame:
df <- data.frame(Time = index(data),data)

data$Time <- as.character(df$Time)

# Write to csv:
out_file <- sub("rds","csv",file)
write_csv(data,file.path("data",out_file))
