library(stockPortfolio)

data(stock99)
data(stock94Info)
data(stock04)



library(UsingR)
data(galton)

shinyServer(
    
    
    function(input, output) {
        
        output$oMoneyCenterBanks <- renderPrint({ input$MoneyCenterBanks })
        output$oElectricalUtilities <- renderPrint({ input$ElectricalUtilities })
        output$oMajorAirlines <- renderPrint({ input$MajorAirlines })
        output$oBiotechnology <- renderPrint({ input$Biotechnology })
        output$oMachinery <- renderPrint({ input$Machinery })
        output$oFuelRefining <- renderPrint({ input$FuelRefining })
        #output$oIndex <- renderPrint({ input$Index })
        
        
        output$oMoneyCenterBanksAlloc <- renderPrint({ input$MoneyCenterBanksAlloc })
        output$oElectricalUtilitiesAlloc <- renderPrint({ input$ElectricalUtilitiesAlloc })
        output$oMajorAirlinesAlloc <- renderPrint({ input$MajorAirlinesAlloc })
        output$oBiotechnologyAlloc <- renderPrint({ input$BiotechnologyAlloc })
        output$oMachineryAlloc <- renderPrint({ input$MachineryAlloc })
        output$oFuelRefiningAlloc <- renderPrint({ input$FuelRefiningAlloc })
        #output$oIndexAlloc <- renderPrint({ input$IndexAlloc })
        
        
        # I want to reset values back to the equal allocation when "Equal" is selected
        # radio button
#         if (input$industryAlloc == 1) {
#             
#             
#         }
        
        
        # action buttons
        oclear <- renderPrint({ input$clear })
        
        
        observe({
            if (input$submit == 0)
                return()
            
            isolate({
                
                #Equal allocation selected (override whatever allocation that was entered)
                if (input$industryAlloc == 1) { 
                    
                    cat("\n hello")

                    oMoneyCenterBanksAlloc <- 1/6
                    oElectricalUtilitiesAlloc <- 1/6
                    oMajorAirlinesAlloc <- 1/6
                    oBiotechnologyAlloc <- 1/6
                    oMachineryAlloc <- 1/6
                    oFuelRefiningAlloc <- 1/6
                    
                    cat("\n hello2")
                }
                else {
                    oMoneyCenterBanksAlloc <- input$MoneyCenterBanksAlloc
                    oElectricalUtilitiesAlloc <- input$ElectricalUtilitiesAlloc
                    oMajorAirlinesAlloc <- input$MajorAirlinesAlloc
                    oBiotechnologyAlloc <- input$BiotechnologyAlloc
                    oMachineryAlloc <- input$MachineryAlloc
                    oFuelRefiningAlloc <- input$FuelRefiningAlloc
                }
                

                industriesAlloc <- c(oMoneyCenterBanksAlloc, oElectricalUtilitiesAlloc, oMajorAirlinesAlloc, 
                                     oBiotechnologyAlloc, oMachineryAlloc, oFuelRefiningAlloc) #, output$oIndexAlloc)
                
                cat(paste("\n", industriesAlloc))
                
                
                # only get the stocks that are selected
                stockSelection <- list(as.numeric(input$MoneyCenterBanks), as.numeric(input$ElectricalUtilities), as.numeric(input$MajorAirlines),
                                       as.numeric(input$Biotechnology), as.numeric(input$Machinery), as.numeric(input$FuelRefining)) #, input$Index)
                
                cat(unlist(stockSelection))
                
                cat(class(unlist(stockSelection)))
                
                
                training <- stock99[, unlist(stockSelection)]
                testing <- stock04[, unlist(stockSelection)]
                
                cat("\n hello 3")
                
                cat(paste("\n", nrow(training), ncol(training), nrow(testing), ncol(testing)))
                
                
                # get the allocations for the selected stocks               
                allStocksAlloc <- vector(mode = "numeric", length = ncol(stock04))                
                # less than 0 means short-selling
                industriesSelected = which(industriesAlloc != 0) 
                
                cat(paste("\n", industriesSelected))
                
                
                for (ii in industriesSelected) {
                    
                    cat(paste("\n industry: ", ii))
                    
                    allStocksAlloc[stockSelection[[ii]]] <- industriesAlloc[ii] / length(stockSelection[[ii]])                   
                }
                
                cat("\n")
                cat(allStocksAlloc)
                
                
                
                #===> build four models <===#               
                non <- stockModel(training, model='none', industry=stock94Info$industry[unlist(stockSelection)])
                
                sim <- stockModel(stock99, model='SIM', industry=stock94Info$industry, index=25)
               
                ccm <- stockModel(training, model='CCM', industry=stock94Info$industry[unlist(stockSelection)])
                
                mgm <- stockModel(training, model='MGM', industry=stock94Info$industry[unlist(stockSelection)])
                
                
                
                #===> build optimal portfolios <===#
                opNon <- optimalPort(non)
                opSim <- optimalPort(sim)
                opCcm <- optimalPort(ccm)
                opMgm <- optimalPort(mgm)
                
                
                
                #===> test portfolios on 2004-9 <===#
                tpNon <- testPort(testing, opNon)
                tpSim <- testPort(testing, opSim)
                tpCcm <- testPort(testing, opCcm)
                tpMgm <- testPort(testing, opMgm)                             
                tpEqu <- testPort(testing, X=rep(1,ncol(testing))/ncol(testing))                
                tpUsr <- testPort(testing, model = "none", X = allStocksAlloc[unlist(stockSelection)])
                
                
                output$portfolioPlot <- renderPlot({    
                    
                    dates <- sort(as.Date(row.names(testing), "%Y-%m-%d"))
                    
                    plot(tpNon, main="Portfolio Return from 10-01-2004 to 09-01-2009")                  
                    # axis(1, at=seq(1,nrow(testing), by=10), labels=dates[seq(1, length(dates), 10)], las = 2)
                    
                    lines(tpSim, col=2, lty=2)
                    lines(tpCcm, col=3, lty=3)
                    lines(tpMgm, col=4, lty=4)
                    
                    lines(tpEqu, col=5, lty = 5)
                    lines(tpUsr, col=6, lty = 6)
                    
                    legend('topleft', col=1:6, lty=1:6, legend=c("No model", "SIM", "CCM", "MGM", "Equal", "User's selection"))
                    
                    
                    
                    #legend('topleft', col=1:2, lty=1:2, legend=c("Optimal portfolio (no model)", "User's selection"))    
                })
                
                output$stocksIncluded <- renderPrint({ 
                    
                    short <- as.numeric(stock94Info[allStocksAlloc < 0, "ticker"])
                    long <- as.numeric(stock94Info[allStocksAlloc > 0, "ticker"])
                    
                    cat("Long: ")
                    cat(levels(stock94Info$ticker)[long])
                    
                    cat("\nShort: ")
                    cat(levels(stock94Info$ticker)[short])              
                    
                })
                
                output$stocksProfit <- renderPlot({
                    
                    colors <- vector(mode = "character", length = ncol(testing))
                    colors[which(tpNon$sumRet >= 1)] = "darkgreen"
                    colors[which(tpNon$sumRet < 1)] = "red"   
                    
                    barplot((tpNon$sumRet - 1)*100, col = colors, ylim = c(-150, max((tpNon$sumRet - 1) * 100)+50), 
                            main = "Stocks Performance from 10-01-2004 to 09-01-2009", xlab = "Stock Symbols", ylab = "% Profit")
                    
                    #                     barplot(tpNon$sumRet, col = colors, ylim = c(0, max(tpNon$sumRet + 0.5)), 
                    #                             main = "Actual Stocks Return from 10-01-2004 to 09-01-2009", xlab = "Stock Symbols", ylab = "Return")
                    
                })
                
                output$optimalAllocPlot <- renderPlot({
                    plot(opNon, addNames=TRUE, main="Risk and Return of Stocks \n (for Optimal Portfolio with No Model)")
                })
                
                output$optimalAlloc <- renderPrint({
                    print(tpNon)
                })
                
                output$usrAlloc <- renderPrint({
                    print(tpUsr)
                    # print(opNon)
                })
                
                output$performanceSummary <- renderPrint({
                    
                    cat(sprintf("No model:\t\t%.2f%%", (tpNon$change - 1) * 100))
                    cat(sprintf("\nSIM:\t\t%.2f%%", (tpSim$change - 1) * 100))                   
                    cat(sprintf("\nCCM:\t\t%.2f%%", (tpCcm$change - 1) * 100))
                    cat(sprintf("\nMGM:\t\t%.2f%%", (tpMgm$change - 1) * 100))
                    cat(sprintf("\nEqual:\t\t%.2f%%", (tpEqu$change - 1) * 100))
                    cat(sprintf("\nUser's selection:\t\t%.2f%%", (tpUsr$change - 1) * 100))
                    
                })
                
                #                 outputOptions(output, "portfolioPlot", suspendWhenHidden = FALSE)
                #                 outputOptions(output, "stocksIncluded", suspendWhenHidden = FALSE)
                #                 outputOptions(output, "stocksProfit", suspendWhenHidden = FALSE)
                #                 outputOptions(output, "optimalAllocPlot", suspendWhenHidden = FALSE)
                #                 outputOptions(output, "optimalAlloc", suspendWhenHidden = FALSE)
            })
        })
        
        
        
        
    }
)