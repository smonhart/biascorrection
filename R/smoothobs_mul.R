#' Multiplicative de-biasing with smoothed obs. climatology
#' 
#' Computes multiplicative de-biasing with loess smoothing (obs. only)
#' 
#' @param fcst n x m x k array of n lead times, m forecasts, of k ensemble 
#'   members
#' @param obs n x m matrix of veryfing observations
#' @param fcst.out array of forecast values to which bias correction should be 
#'   applied (defaults to \code{fcst})
#' @param span the parameter which controls the degree of smoothing (see 
#'   \code{\link{loess}})
#' @param ... additional arguments for compatibility with other bias correction 
#'   methods
#'   
#' @details The bias corrected forecast is scaled by the lead-time dependent
#'   ratio of observed to forecast climatology, where the observed climatology
#'   is smoothed using a loess smoothing.
#'   
#' @seealso smooth_mul smoothobs
#'   
#' @examples
#' ## initialise forcast observation pairs
#' signal <- outer(1.5 + sin(seq(0,4,length=215)), rnorm(30)**2, '*')
#' fcst <- array(rnorm(length(signal)*15)**2, c(dim(signal), 15)) * c(signal)
#' obs <- rnorm(length(signal), mean=1.4)**2 * signal 
#' fcst.debias <- biascorrection:::smoothobs_mul(fcst[,1:20,], obs[,1:20], fcst.out=fcst, span=0.5)
#' 
#' @keywords util
smoothobs_mul <- function(fcst, obs, fcst.out=fcst, span=min(1, 31/nrow(fcst)), ...){
  fcst.ens <- rowMeans(fcst, dims=2)
  fcst.ens[is.na(obs)] <- NA
  fcst.mn <- rowMeans(fcst.ens, dims=1, na.rm=T)
  obs.mn <- rowMeans(obs, dims=1, na.rm=T)
  obs.clim <- pmax(sloess(obs.mn, span=span), 0)
  mulcor <- pmin(obs.clim / fcst.mn, 10)
  mulcor[obs.clim == 0 & fcst.mn == 0] <- 1
  fcst.debias <- fcst.out * mulcor
  return(fcst.debias)
}
