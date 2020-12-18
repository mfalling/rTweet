# Library -----------------------------------------------------------------
library(rtweet)

# Data Collection ---------------------------------------------------------

queries <- [VECTOR OF QUERIES]

# Search Tweets
rt <- search_tweets(queries[1], n = 5000)
rt2 <- search_tweets(queries[2], n = 5000)

# Save images
saveRDS(rt, "data/rt.rds")
saveRDS(rt2, "data/rt2.rds")

rt$query <- queries[1]
rt2$query <- queries[2]

df <- rbind(rt, rt2)

# Data Filtering ----------------------------------------------------------

# Filter to tweets with youtube videos: rt
indices <- grepl("youtu", df$urls_expanded_url)
rtvid <- df[indices, ]

# Unlist the URL column ---------------------------------------------------

# The URL column can contain multiple URLs inside of a list. 
# Put each URL in its own row.

unlist_column <- function(dataset, colnum){
  # Create an empty dataframe.
  df <- NULL
  
  # Iterate through each row in the dataframe.
  for (i in 1:nrow(dataset)){
    # Put each list item in its own row.
    for(j in 1:(length(dataset[[colnum]][[i]]))){
      row <- dataset[i, ]
      row[[colnum]] <- dataset[[colnum]][[i]][[j]]
      
      # Build the dataframe.
      df <- rbind(df, row)
    }
  }
  return(df)
}

# Unlisting column 21, `urls_expanded_url`.
rtvid <- unlist_column(dataset = rtvid, colnum = 21)

# Exploration -------------------------------------------------------------

# List all unique URLs for manual investigation
unique(rtvid$urls_expanded_url)

# YouTube videos with identified misinformation
youtubeIDs <- [VECTOR OF YOUTUBE IDS]

# Get indices for tweets with the youtube IDs.
indices <- grepl(pattern = paste(youtubeIDs, collapse = "|"), 
                  x = rtvid$urls_expanded_url)
# Filter to relevant tweets
rtvid_mis <- rtvid[indices, ]
# Keep only the relevant columns.
rtvid_mis <- rtvid_mis[, c(1:5, 21, 91)]

# Save file ---------------------------------------------------------------

write.csv(rtvid_mis, "rTweet_Tweets_Dec9-Dec18.csv")
