#you can change the output from R printing, 
#plotting and the actions of the as.character function. 
#You change it from its default with:
  
options(OutDec= ",")

#And another option is using format function.

format(df, decimal.mark=",")

#If you are exporting data with something like write.csv 
#then you have to use it with additional dec parameter like so: 
  
write.csv(df, file=file, dec=",")