## FUNCTION FOR MAKING QUERIES IN SQLITE DB
library(RSQLite)
library(lubridate)

#' Given 1 or more stations (i.e. tableNames), get the station readings from 
#' startDate to +qHours
#'
#' @param dbName (char): Filepath to sqlite database 
#' @param tableName (char): Name of station
#' @param startDate (date): Starting date, including hour
#' @param qHours (int): Number of hours to the future to get readings
#' @export
sqliteQuery <- function(dbName, tableName, startDate, qHours=24,
                        parallel=FALSE, ncore=16) {
  
  if(parallel) {
    require(doMC)
    registerDoMC(ncore)
  }
  
  # Get the date range for our query... we are going to make a monster
  # query
  endDate <- startDate + lubridate::hours(qHours)
  
  # For when more than one start date is given
  tableNames <- rep(tableName,each=length(startDate))
  
  # Make our monster query
  q <- paste0("date >= datetime('", as.character(startDate),"') AND ",
              "date < datetime('", as.character(endDate),"')")
  q <- paste("SELECT * FROM", tableNames, "WHERE", q)
  
  # Get the table(s)
  if(length(q)==1) {
    # Connect to db
    con <- dbConnect("SQLite", dbname=dbName)
    
    tabs <- dbGetQuery(con, q)
    if(nrow(tabs)>0) tabs$station <- tableNames
    
    # Close the connection
    dbDisconnect(con)
  } else {
    if(parallel) {
      tabs <- foreach(i=1:length(q)) %dopar% {
        # Connect to db
        con <- dbConnect("SQLite", dbname=dbName)
        
        tmp <- dbGetQuery(con, q[i])
        if(nrow(tmp) > 0) tmp$station <- tableNames[i]
        
        # Close the connection
        dbDisconnect(con)
        
        tmp
      }
    } else {
      # Connect to db
      con <- dbConnect("SQLite", dbname=dbName)
      tabs <- list()
      for(i in 1:length(q)) {
        tabs[[i]] <- dbGetQuery(con, q[i])
        if(nrow(tabs[[i]])>0) tabs[[i]]$station <- tableNames[i]
      }  
      # Close the connection
      dbDisconnect(con)
    }
    tabs <- as.data.frame(do.call(rbind, tabs))
  }
  
  # Return table
  return(tabs)
}

#' Get the sqliteQuery produced table in a nice format
#' 
#' @param table (data.frame or list) output from sqliteQuery
#' @param colNum (int) column in table that contains variable of interest
#' @export
formatSqliteTab <- function(table, colNum) {
  if(is.data.frame(table)) {
    # Coerce into data frame
    toReturn <- data.frame(table$date, table[,colNum])
    # Get the names right
    names(toReturn) <- c("date", 
                         paste0(table$station[1],"_",names(table)[colNum]))
  } else {
    toReturn <- as.data.frame(matrix(NA,nrow=nrow(table[[1]]), 
                                     ncol={length(table)+1}))
    toReturn[,1] <- table[[1]]$date
    names(toReturn)[1] <- "date"
    for(i in 1:length(table)) {
      toReturn[,i+1] <- table[[i]][,colNum]
      names(toReturn)[i+1] <- table[[i]]$station[1]
    }
  }
  
  return(toReturn)
}

rbind2 <- function(x,y) {
  if(length(x) < 7) x[7] <- 0
  if(length(y) < 7) y[7] <- 0
  
  rbind(x,y)
}


#' Summary statistics for an SqliteTable
#' @param table A table that has been formatted by formatSqliteTab
summarizeSqliteTab <- function(table) {
  # Extract the dates, then get the columns of data
  dates <- table$date
  tableDat <- table[,-1]
  
  # Summary stats
  ns <- apply(tableDat, 2, function(x) sum(!is.na(x)))
  summaries <- apply(tableDat, 2, summary)
  for(i in seq_along(summaries)) {
    if(length(summaries[[i]]) < 7) summaries[[i]]["NA's"] <- 0
  }
  summaries <- as.data.frame(do.call(rbind, summaries))
  sds <- apply(tableDat, 2, sd, na.rm=TRUE)
  
  # To return
  toReturn <- as.data.frame(t(tableDat))
  colnames(toReturn) <- sprintf("Hr+%02d", 0:{nrow(table)-1})
  toReturn <- cbind(toReturn, summaries, n=ns, sd=sds)
  
  return(toReturn)
}

#' Construct a custom SQLite query
#'
#' @param dbName (char): Filepath to sqlite database 
#' @param query (char): Valid SQLite query (or queries)
#' @param labels (char): If >1 query, provide labels for each query result
#' @param parallel (logical): If we have multiple queries, use multiple threads?
#' @param ncore (int): If parallel==TRUE, how many cores should we use?
#' @export
sqliteQueryCustom <- function(dbName, query, labels, 
                              parallel=FALSE, ncore=16) {
  
  if(parallel) {
    require(doMC)
    registerDoMC(ncore)
  }
  
  q <- query
  
  # Get the table(s)
  if(length(q)==1) {
    # Connect to db
    con <- dbConnect("SQLite", dbname=dbName)
    
    tabs <- dbGetQuery(con, q)
    
    # Close the connection
    dbDisconnect(con)
  } else {
    if(length(q)!=length(labels)) stop("Please provide labels for each query.")
    if(parallel) {
      tabs <- foreach(i=1:length(q)) %dopar% {
        # Connect to db
        con <- dbConnect("SQLite", dbname=dbName)
        tmp <- dbGetQuery(con, q[i])
        if(nrow(tmp)>0) tmp$label <- labels[i]
        
        # Close the connection
        dbDisconnect(con)
        
        # Return to list
        tmp
      }
    } else {
      # Connect to db
      con <- dbConnect("SQLite", dbname=dbName)
      tabs <- list()
      for(i in 1:length(q)) {
        tabs[[i]] <- dbGetQuery(con, q[i])
        if(nrow(tabs[[i]]) > 0) tabs[[i]]$label <- labels[i]
      }  
      # Close the connection
      dbDisconnect(con)
    }
    tabs <- as.data.frame(do.call(rbind, tabs))
  }
  
  # Return table
  return(tabs)
}

# TEST --------------------------------------------------------------------

# dbName <- "~/git/ECStations/resources/data1979-2012/winds_db.sqlite"
# 
# 
# tab <- sqliteQuery(dbName=dbName, tableName=c("YVR", "WAE"), 
#                      startDate=ymd_h("19880226 06"))
# names(table[[1]])
# formatSqliteTab(tab, 5)
# 
# tab <- sqliteQuery(dbName=dbName, tableName=c("WAE"), 
#                      startDate=ymd_h("20130101 00"))
# # Gives error, as it should
# names(tab)
# formatSqliteTab(tab,5)

# con <- dbConnect(drv="SQLite",dbName)
# dbGetQuery(con, "SELECT * FROM WAE WHERE year==1988 AND month==2 AND day==26")
# dbDisconnect(con)