library('ggplot2') # visualisation
library('scales') # visualisation
library('grid') # visualisation
library('RColorBrewer') # visualisation
library('corrplot') # visualisation
library('alluvial') # visualisation
library('dplyr') # data manipulation
library('readr') # input/output
library('data.table') # data manipulation
library('tibble') # data wrangling
library('tidyr') # data wrangling
library('stringr') # string manipulation
library('forcats') # factor manipulation
library('lubridate') # date and time
library('geosphere') # geospatial locations
library('leaflet') # maps
library('leaflet.extras') # maps
library('maps') # maps
library('xgboost') # modelling
library('caret') # modelling
library("placement")



aguas_calientes_stop <- data.frame(lat = -13.154995, long =  -72.525267)

macchu_picchu_fila <- data.frame(lat = -13.16596185499693, long =  -72.54285335540771)

api_key <- None


m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=aguas_calientes_stop$long, lat=aguas_calientes_stop$lat, popup="Aguas Calientes - Bus Stop")

m
drive_time('-13.154995,-72.525267','-13.16596185499693,-72.54285335540771',)

howfar_kms <- drive_time(
  address="-13.154995,-72.525267",
  dest="-13.16596185499693,-72.54285335540771",
  auth="standard_api", privkey=api_key, clean=FALSE,
  add_date='today', verbose=FALSE, travel_mode="bicycling",
  units="imperial"
)


howfar_kms <- drive_time(
  address="-13.154995,-72.525267",
  dest="-13.16596185499693,-72.54285335540771",
  auth="standard_api", privkey=api_key, clean=FALSE,
  add_date='today', verbose=FALSE, travel_mode="driving",
  units="imperial"
)
howfar_kms
























