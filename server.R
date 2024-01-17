library(plotly)
library(Cairo)

options(shiny.usecairo=T)


#library(rstan)

if(FALSE){
  install.packages("matlib")
}



if(FALSE){
  #To run this app
  library(shiny)
  runApp(".")
}


server <- function(input, output, session) {

  minx <- -10
  maxx <- 10
  

  ##############################################################################
  ########### Update controllers as needed #####################################
  ##############################################################################

    
  ##############################################################################
  ########### Distribution functions ###########################################
  ##############################################################################
  
  
  ### Parse input data
  getNewData <- reactive({
    newdata <- input$newdata
    newdata <- strsplit(newdata,",")[[1]]
    unname(sapply(newdata, function(x) as.double(x)))
  })

  
    
  #### fixed variance, random mean
  getPosterior <- reactive({
    
    # Solution from
    # https://people.eecs.berkeley.edu/~jordan/courses/260-spring10/lectures/lecture5.pdf
    # eq 12
    
    ### Prior
    mu0 <- input$mu0
    sigma0 <- input$sigma0
    sigma <- input$sigma
    
    newdat <- getNewData()
    n <- length(newdat)
    if(n==0){
      ### Return prior as posterior
      list(mu=mu0, sigma=sigma0)
    } else {
      
      ### Distribution of new data
      xbar <- mean(newdat)
      #sigma <- sd(newdat)

      ### Compute posterior, mu distributed as:
      divisor <- sigma**2/n + sigma0**2
      list(
        mu=sigma0**2*xbar/divisor + sigma**2*mu0/divisor,
        sigma=sqrt( 1/(1/sigma0**2 + n/sigma**2) )
      )    
    }
  })
  
  
  
  
  
  ##############################################################################
  ########### Plot distributions ###############################################
  ##############################################################################
  
  
  output$plotPDF <- renderPlot({
    newdat <- getNewData()
    
    
    ### Prior    
    dat_prior <- data.frame(
      x=seq(from=minx, to=maxx, length.out=5000),
      distribution="prior"
    )
    dat_prior$p <- dnorm(dat_prior$x, input$mu0, input$sigma0)

    ### Posterior    
    posterior_param <- getPosterior()
    dat_posterior <- data.frame(
      x=seq(from=minx, to=maxx, length.out=5000),
      distribution="posterior"
    )
    dat_posterior$p <- dnorm(dat_posterior$x, posterior_param$mu, posterior_param$sigma)

    alldat <- rbind(dat_prior,dat_posterior)

    ### Classic estimate    
    if(length(newdat)>1){
      dat_freq <- data.frame(
        x=seq(from=minx, to=maxx, length.out=5000),
        distribution="classic"
      )
      dat_freq$p <- dnorm(dat_freq$x, mean(newdat), sd(newdat))
      alldat <- rbind(alldat,dat_freq)    
    }
    
    ### Make the plot
    alldat$distribution <- factor(alldat$distribution, levels=c("prior","posterior","classic"))
    totp <- ggplot(alldat, aes(x,p, color=distribution)) + geom_line() +
      ylab("Probability density")+
      xlim(c(minx,maxx))
    
    if(length(newdat)>0){
      allpoint <- data.frame(
        x=newdat, 
        y=newdat*0+0.5
      )
      totp <- totp + geom_point(data = allpoint, aes(x,y), color="black")
    }
            
    totp
  })
  
  
  
}





