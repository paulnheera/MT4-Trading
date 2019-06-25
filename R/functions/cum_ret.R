#*********************
# Cumulative Return
#*********************

cum_ret <- function(r){
  
  r = na.trim(r)
  
  cr = cumprod(1+r)
  
  return(cr)
}
