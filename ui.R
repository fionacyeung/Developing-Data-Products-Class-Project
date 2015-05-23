
shinyUI(fluidPage(
    
    titlePanel("Stock Models and Optimal Portfolio Construction"),
    
    br(),
    
    fluidRow(
        column(12,
               h4("This project uses inputs specified by the user to demonstrate a quantitative approach to portfolio allocation 
            among the selected stocks. Four model options are explored: 1) no model, where a portfolio is selected based 
            on empirical returns, variances, and covariances among the stocks 2) the single index model (SIM), 3) constant 
            correlation model (CCM), and 4) the multigroup model (MGM)."))
    ),
    
    fluidRow(
        
        column(12,
               h4("To use the Shiny website, user will first need to select which stocks should be included in the portfolio. 
            Stocks that are checked will be included in the portfolio construction for all models. The user should also specify the  
            allocation for the 6 industries in the dataset by entering a numeric value in the corresponding text box. A positive value 
            indicates a long position whereas a negative value indicates a short position. A value of 0 represents no position 
            of any stocks in that industry. The numeric values entered for each industry need to sum to 1.0. If 
            'Equal' is selected for 'Industry allocation', each of the 6 industries will receive the same allocation 
            (i.e. 1/6) for long positions. In both cases, 'Equal' and 'Custom' industry allocation, the selected stocks within the  
            same industry will share equal allocation."))
    ),
    
    fluidRow(
        column(12, 
               h4("After the user has made all the specifications, the performance for the various models with optimal portfolio 
            construction will be display and plotted when the 'Submit' button is clicked. The test period of 10-01-2004 
            to 09-01-2009 is used for all analyses."))    
    ),
    
    fluidRow(
        column(12,
               h4("This project uses the 'stockPortfolio' R package extensively. Visit the package documentation on CRAN for more
           information (http://cran.r-project.org/web/packages/stockPortfolio/stockPortfolio.pdf)."))
    ),
    
    fluidRow(
        column(12,
               h4("Click on the 'Submit' button for a sample run with the default settings after this page has been loaded.", 
                  style = "color:blue"))
    ),
    
    hr(),
    
    fluidRow(
        column(3,
               h5("If 'Equal' is selected, the allocation for each industry (e.g. Money Center Banks) will be equal."),
               h5("If 'Custom' is selected, each industry will be allocated according to 'Industry Allocation' specified below." ),
               h5("Click the 'Submit' button to view portfolio performance." )),
        
        column(2, 
               radioButtons("industryAlloc", label = h4("Industry allocation"),
                            choices = list("Equal" = 1, "Custom" = 2), 
                            selected = 1)),        
        
        #column(1, actionButton("clear", label = "Clear Entries")),  # I can't find an easy way to do this
        
        column(1, actionButton("submit", label = "Submit")),
        
        column(6, 
               h4("Portfolio profit summary from 10-01-2004 to 09-01-2009"),
               verbatimTextOutput("performanceSummary")
        )
        
    ),
    
    hr(),
    
    fluidRow(
        column(3,
               h4("Check the stock symbols to include in the portfolio"),
               
               checkboxGroupInput("MoneyCenterBanks", label = h3("Money Center Banks"), 
                                  choices = list("C" = 1, "KEY" = 2, "WFC" = 3, "JPM" = 4),
                                  selected = c(1, 2, 3, 4)),
               numericInput("MoneyCenterBanksAlloc", label = h5("Industry Allocation (negative value for short)"), 0.166, min = -1.0, max = 1.0, step = 0.01),
               
               #                verbatimTextOutput("oMoneyCenterBanks"),
               #                verbatimTextOutput("oMoneyCenterBanksAlloc"),
               
               
               checkboxGroupInput("ElectricalUtilities", label = h3("Electrical Utilities"), 
                                  choices = list("SO" = 5, "DUK" = 6, "D" = 7, "HE" = 8, "EIX" = 9),
                                  selected = c(5, 6, 7, 8, 9)),               
               numericInput("ElectricalUtilitiesAlloc", label = h5("Industry Allocation (negative value for short)"), 0.166, min = -1.0, max = 1.0, step = 0.01),
               
               #                verbatimTextOutput("oElectricalUtilities"),
               #                verbatimTextOutput("oElectricalUtilitiesAlloc"),
               
               
               checkboxGroupInput("MajorAirlines", label = h3("Major Airlines"), 
                                  choices = list("LUV" = 10, "CAL" = 11, "AMR" = 12),
                                  selected = c(10, 11, 12)),
               numericInput("MajorAirlinesAlloc", label = h5("Industry Allocation (negative value for short)"), 0.167, min = -1.0, max = 1.0, step = 0.01),
               
               #                verbatimTextOutput("oMajorAirlines"),
               #                verbatimTextOutput("oMajorAirlinesAlloc"),
               
               
               checkboxGroupInput("Biotechnology", label = h3("Biotechnology"), 
                                  choices = list("AMGN" = 13, "GILD" = 14, "CELG" = 15, "GENZ" = 16, "BIIB" = 17),
                                  selected = c(13, 14, 15, 16, 17)),
               numericInput("BiotechnologyAlloc", label = h5("Industry Allocation (negative value for short)"), 0.167, min = -1.0, max = 1.0, step = 0.01),
               
               #                verbatimTextOutput("oBiotechnology"),
               #                verbatimTextOutput("oBiotechnologyAlloc"),
               
               
               checkboxGroupInput("Machinery", label = h3("Machinery"), 
                                  choices = list("CAT" = 18, "DE" = 19, "HIT" = 20),
                                  selected = c(18, 19, 20)),
               numericInput("MachineryAlloc", label = h5("Industry Allocation (negative value for short)"), 0.167, min = -1.0, max = 1.0, step = 0.01),
               
               #                verbatimTextOutput("oMachinery"), 
               #                verbatimTextOutput("oMachineryAlloc"),
               
               
               checkboxGroupInput("FuelRefining", label = h3("Fuel Refining"), 
                                  choices = list("IMO" = 21, "MRO" = 22, "HES" = 23, "YPF" = 24),
                                  selected = c(21, 22, 23, 24)),
               numericInput("FuelRefiningAlloc", label = h5("Industry Allocation (negative value for short)"), 0.167, min = -1.0, max = 1.0, step = 0.01)
               
               #                verbatimTextOutput("oFuelRefining"),
               #                verbatimTextOutput("oFuelRefiningAlloc")
               
               
               #                checkboxGroupInput("Index", label = h3("Index"), 
               #                                   choices = list("^GSPC" = 25),
               #                                   selected = c(25)),
               #                numericInput("IndexAlloc", label = h5("Industry Allocation (negative value for short)"), 0, min = 0.01, max = 1.0, step = 0.01),
               #                
               #                verbatimTextOutput("oIndex"),
               #                verbatimTextOutput("oIndexAlloc")
               
        ),
        
        #         column(9, #offset = 1,
        #                tabsetPanel(
        #                    tabPanel("Portfolio Performance", plotOutput("portfolioPlot"),
        #                             verbatimTextOutput("stocksIncluded")), 
        #                    tabPanel("Stocks profit", plotOutput("stocksProfit")),
        #                    tabPanel("Optimal Allocation", plotOutput("optimalAllocPlot"),
        #                             verbatimTextOutput("optimalAlloc")) 
        # #                    tabPanel("Table", tableOutput("table"))
        #                )
        #         )
        
        column(9, #offset = 1,
               
               
               #                    plotOutput("portfolioPlot"),
               #                    verbatimTextOutput("stocksIncluded"),
               #                    plotOutput("stocksProfit"),
               #                    plotOutput("optimalAllocPlot"),
               #                    verbatimTextOutput("optimalAlloc"),
               #                    verbatimTextOutput("usrAlloc")
               
               
               fluidRow(
                   plotOutput("portfolioPlot"),
                   h4("User selected stocks"),
                   verbatimTextOutput("stocksIncluded")
               ),
               
               hr(),
               
               fluidRow(
                   plotOutput("stocksProfit")
               ),
               
               hr(),
               
               fluidRow( 
                   
                   h4("Red color represents short positions. Blue color represents long positions. Portion of the portfolio allocation is 
                      indicated by the transparency, where darker color represents higher percentage of allocation. The black solid dot is the
                      expected return vs. risk estimate for the optimal portfolio"),
                   
                   plotOutput("optimalAllocPlot"),
                   
                   hr(),
                   
                   fluidRow(
                       
                       h4("Optimal portfolio allocation (no model)"),
                       verbatimTextOutput("optimalAlloc"),
                       
                       hr(),
                       
                       h4("User selected allocation"),
                       verbatimTextOutput("usrAlloc")
                   )
               )
               
        )
    )
    
    
    
    
    
    #    ) # sidebarLayout
))