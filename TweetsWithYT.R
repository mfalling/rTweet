# Library -----------------------------------------------------------------
library(rtweet)

# Data Collection and Filtering -------------------------------------------

# Search Tweets
rt <- search_tweets("[QUERY TERM]", n = 5000)

# Get indices for tweets with "youtu" in the URL
indices <- grepl("youtu", rt$urls_expanded_url)

# Filter to tweets with YouTube videos
rtvid <- rt[indices, ]

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

# Unlisting column 21, `urls_expanded_url`
rtvid <- unlist_column(dataset = rtvid, 
                       colnum = 21)

# Exploration -------------------------------------------------------------

# List all unique URLs for manual investigation
unique(rtvid$urls_expanded_url)

# YouTube videos with identified misinformation
youtubeIDs <- [VECTOR OF UNIQUE IDS]

# Get indices for tweets with the youtube IDs
indices <- grepl(pattern = paste(youtubeIDs, collapse = "|"), 
                  x = rtvid$urls_expanded_url)
                  
# Filter to relevant tweets
rtvid_mis <- rtvid[indices, ]

# Keep only the relevant columns
rtvid_mis <- rtvid_mis[, c(1:5, 21)]


# Save file ---------------------------------------------------------------

write.csv(rtvid_mis, "TwitterTweets.csv")

