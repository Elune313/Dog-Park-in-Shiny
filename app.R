library(leaflet)
library(shiny)

secretGardensInfo <- read.csv("data/secretgarden.csv", stringsAsFactors = FALSE)

# Define UI ----
ui <- fluidPage(
  titlePanel("Dog Secrete Garden"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Find the off-leash area based on map"),
      
      selectInput("dog_run_type",
                  label = "Choose a Dog Run Type to Disply",
                  choices = list("All", "Run", "Off-Leash"),
                  selected = "All"),
      
      h2("shall we go?"),
      p("every dog in the city deserves a place to play,find a therapeutic place for your therapeutic buddy"),
      
      img(src="sidebar.jpg", height = 271, width = 245)
    ),
    
    mainPanel(h1("Secret Gardens"),
              align="center", 
              style="color:purple", 
              leafletOutput("secret_garden_map", height = 800))
  )
)

# Define server logic ----
server <- function(input, output) {
  data <- reactive({
    if (input$dog_run_type == "All") {
      x <- secretGardensInfo
    } else {
      x <- subset(secretGardensInfo, DogRuns_Type == input$dog_run_type)
    }
  })

  output$secret_garden_map <- renderLeaflet({
    df <- data()
    
    content <- paste()
    
    m <- leaflet(data = df) %>%
      addTiles() %>%
      setView(lng = -73.935242, lat = 40.730610, zoom = 11) %>%
      addMarkers(lng = ~Longitude,
                 lat = ~Latitude,
                 popup = content,paste(df$Name,
                               "<br>",
                               df$DogRuns_Type))
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)