if (!require("read.dbc")) {
  remotes::install_github("danicat/read.dbc")
  library(read.dbc)
}
if (!require("PaSim")) {
  remotes::install_github("abelbrasil/PaSim")
  library(PaSim)
}
library(shiny)
library(shinyjs)
library(bslib)
library(curl)
library(rvest)
library(stringr)
library(foreign)
library(dplyr)
library(zip)
library(lubridate)
library(writexl)
state <- c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA",
           "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN",
           "RS", "RO", "RR", "SC", "SP", "SE", "TO")

# Interface do usuário (UI)
ui <- fluidPage(
  useShinyjs(),

  # Cabeçalho com título à esquerda e logo à direita
  tags$div(
    style = "display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #f8f9fa; border-bottom: 2px solid #ddd;",

    # Título do aplicativo à esquerda
    tags$h2("Download Arquivos SIM", style = "margin: 0;")#,

    # Imagem da logo à direita
    #tags$img(src = "Logo_da_EBSERH.png", height = "40px", style = "margin-left: 5px;")
  ),

  #column(8,offset = 5, titlePanel("Baixar Arquivos SIM")),
  theme = shinythemes::shinytheme("flatly"),
  #tags$div(tags$img(src = "Logo_da_EBSERH.png", height = "40px", style = "margin-left: 5px;")),

  fluidRow(
    column(width = 4, offset = 5,
           selectInput("UF", HTML("Selecione o Estado: <span class='required-star'>*</span>"), choices = state,multiple = T),

           numericInput("inicio", HTML("Digite o ano inicial: <span class='required-star'>*</span>"), value = NA, min = 1996,
                        max = as.numeric(format(Sys.Date(), "%Y"))-1),

           numericInput("fim", HTML("Digite o ano final :<span class='required-star'>*</span>"), value = NA, min = 1996,
                        max = as.numeric(format(Sys.Date(), "%Y"))-1),

           downloadButton("downloadData", "Baixar Planilha", class = "btn btn-primary", target = "_blank")
    ),

    mainPanel(
      tableOutput("table")
    )
  ),
  wellPanel(
    h4("Sobre a aplicação:"),
    p("Esta aplicação tem como objetivo facilitar o download dos arquivo do SIM, permitindo que o usuário baixe os arquivos em formato de planilha e com todas as colunas já tratadas."
      , br(),"O SIM é Sistema de Informações de Mortalidade, sistema esse administrado pelo Departamento de Informação e Informática do Sistema Único de Saúde (DATASUS), e tem como objetivo coletar os dados sobre a mortalidade por ano em todos os estados brasileiros."
      , "Os dados que estão disponíveis são de a partir de 1979 até o último ano completo. 2024 se encontra em consolidação.")
  ),
  wellPanel(h4("Instruções:"),
            tags$ul(
              tags$li("Digite o ano de início e fim desejado no campo fornecido."),
              tags$li("Certifique-se de que o ano não seja o ano atual."),
              tags$li("Clique no botão 'Baixar Planilha' para baixar a planilha dos arquivos."),
              tags$li("Os campos Estado, ano inicial e ano final são obrigatórios"))),
  tags$div(
    style = "position: fixed; bottom: 0; width: 100%; padding: 10px; background-color: #f8f9fa; border-top: 2px solid #ddd; text-align: center;",
    tags$p("© 2025 - Download Arquivos SIM - DATASUS | Todos os direitos reservados | ",tags$a(href = "https://github.com/abelbrasil/PaSIM", "Repositório GitHub", target = "_blank")))
)

# Lógica do servidor
server <- function(input, output,session) {

  # Observe o evento de clique no botão para gerar a tabela
  filtered_data <- reactive({
    # Criação de um data frame com base nas entradas do usuário
    df <- download.SIM(input$UF,c(input$inicio:input$fim))
    df <- process.SIM(df)
    df
  })

  # Permitir download da tabela como CSV
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("SIM_", input$UF,"_",input$inicio,"_",input$fim,".xlsx", sep = "")
    },
    content = function(file) {
      if (input$inicio == as.numeric(format(Sys.Date(), "%Y"))||input$fim == as.numeric(format(Sys.Date(), "%Y"))) {
        showNotification("Erro: O ano digitado é o ano atual. Não é possível baixar o arquivo.",
                         type = "error", duration = 5)

        return()  # Interrompe o download
      } else {
        # Notificação de sucesso para o download
        showNotification("Baixando o arquivo...", type = "message", duration = 3)
        write_xlsx(filtered_data(), file)
      }
    }
  )

}

# Execute a aplicação Shiny
shinyApp(ui = ui, server = server)
