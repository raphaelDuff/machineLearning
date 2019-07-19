library("tibble")
library("dplyr")
load('bus_position.RData')

api_key=None

if (any(bus_position$sentido == "subindo")) {
  bus_possiveis_subindo <- filter(bus_position, sentido == "subindo")
  if (nrow(bus_possiveis_subindo) > 1) {
    tempos_onibus_subindo <- data.frame("onibus_id" = as.character(),
                                          "tempo" = as.numeric())
    tempos_onibus_vec <- c("onibus_id" = as.character(), "tempo" = as.numeric())
    for (row in 1:nrow(bus_possiveis_subindo)) {
      howfar <- drive_time(
        address= paste(bus_possiveis_subindo$lat[row], bus_possiveis_subindo$long[row], sep = ','),
        dest="-13.16596185499693,-72.54285335540771",
        auth="standard_api", privkey=api_key, clean=FALSE,
        add_date='today', verbose=FALSE, travel_mode="driving",
        units="metric"
        )
      tempos_onibus_vec <- c("onibus_id" = bus_possiveis_subindo$onibus_id[row], "tempo" = howfar$time_mins)
      tempos_onibus_subindo <- rbind(tempos_onibus_subindo,tempos_onibus_vec)
      colnames(tempos_onibus_subindo) <- c("onibus_id", "tempo")
    }
  }
}


arrange(tempos_onibus_subindo, tempo)

