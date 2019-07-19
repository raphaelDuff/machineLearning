library(shiny)
library(leaflet)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
  titlePanel("FIAP-04IA - Machu Picchu - Fila do Onibus"),
  leafletOutput("mymap"),
  p(),
  actionButton("syncBusPosition", "Atualizar a localização do ônibus")
)

server <- function(input, output, session) {
  load('bus_position.RData')
  aguas_calientes_stop <- data.frame(lat = -13.154995, long =  -72.525267)
  
  IconSet <- awesomeIconList(
    bus   = makeAwesomeIcon(icon= 'bus', markerColor = 'green', iconColor = 'white', library = "fa"),
    pirate = makeAwesomeIcon(icon= 'fire', markerColor = 'blue', iconColor = 'white', library = "fa")
  )
  
  
  macchu_picchu_fila <- data.frame(lat = -13.16596185499693, long =  -72.54285335540771)
  
  busPosition <- eventReactive(input$goButton, {
    input$n
  })
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addAwesomeMarkers(lng=aguas_calientes_stop$long, lat=aguas_calientes_stop$lat, icon = IconSet['bus'] , label = "Onibus 1")
  })
}

shinyApp(ui, server)