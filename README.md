#  Miscellaneous scripting tools

##  Hydrograph
Takes a tidy data set and outputs a storm hydrograph for given dates
``` {r}
hydrograph(df, date_time, precip, streamflow, start, end, variable)
```

## Fast Read Lines
Memory efficient method for importing textfiles
``` {r}
fast_read_lines(filename)
```
