MY_GOOGLE_API_KEY <- "MyKeyHere"
baseUri <- "https://maps.google.com/maps/api/geocode/json?address="

# Get lat and long from address
geocodeAddress <- function (address) {
  uri <- URLencode(paste(baseUri, address, "&sensor=false&key=", MY_GOOGLE_API_KEY, sep = ""))
  x <- fromJSON(uri, simplify = FALSE)
  if (x$status == "OK") {
    result <- c(x$results[[1]]$geometry$location$lng,
                x$results[[1]]$geometry$location$lat)
  } else {
    result <- NA
  }
  return (result)
}

# Parse data
originalAddress <- read.csv("data/dogpark.csv", stringsAsFactors = FALSE)
for (i in 1 : nrow(originalAddress)) {
  if (originalAddress$Address[i] != '') {
    result <- geocodeAddress(originalAddress$Address[i])
    if (!is.na(result)) {
      originalAddress$Longitude[i] <- as.numeric(result[1])
      originalAddress$Latitude[i] <- as.numeric(result[2])
    }
  }
}

write.csv(originalAddress, "data/secretgarden.csv", row.names=FALSE)
