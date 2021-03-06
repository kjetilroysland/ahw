

MakeCensWeights <- function(fFit, cfFit, data, startTimeName, stopTimeName,
                             endStatusName, intStatusName, idName) {
        B <- aalenRes(fFit)
        names(B)[1] <- 'fRes.dM'
        B$'cfRes.dM' <- 0
        if(!is.null(cfFit)){
          cfRes <- aalenRes(cfFit)
          B$'cfRes.dM' <- cfRes$dM
        }
         
        colnames(B)[which(names(B) == 'time')] <- stopTimeName 
        colnames(B)[which(names(B) == 'id')] <- paste('temp',idName,sep='.')
        data[paste('temp',idName,sep='.')] <-  attr(fFit,'id')

        data <- RefineTimeScale(data, startTimeName, stopTimeName, 
                                sort(unique(B[,stopTimeName])), endStatusName, 
                                intStatusName)
        
        data <- merge(data, B, by=c(paste('temp', idName, sep='.'), stopTimeName),
                      all.x=T, sort=T)
        data$fRes.dM[is.na(data$fRes.dM)] <- 0
        data$cfRes.dM[is.na(data$cfRes.dM)] <- 0
        LR <-  cumProdGroup( 1 - data$fRes.dM + data$cfRes.dM, data[,idName]) #Obs: fortegn var feil!!!
        data$weights <- rightShiftGroup(LR, data[,idName],
                                        initVal=rep(1,ncol(fFit$residuals$dM)))
        
        data <- data[-which(names(data) %in% c(paste('temp', idName, sep='.'),
                                       'fRes.dM', 'cfRes.dM'))]
        return(data)
}




