#' smooth_scale
#' 
#' Computes mean de-biasing with loess smoothing and adjusts variance
#' 
#' @param fcst array of forecast values (nyear, nlead, nens)
#' @param obs array of observations (nyear, nlead)
#' @param fcst.out array of forecast values to which bias correction
#' should be applied (defaults to \code{fcst})
#' @param span the parameter which controls the degree of smoothing (see \code{\link{loess}})
#' @param ... additional arguments for compatibility with other bias correction methods
#' 
#' @examples
#' ## initialise forcast observation pairs
#' fcst <- array(rnorm(215*30*51, mean=3, sd=0.2), c(215, 30, 51)) + 
#' 0.5*sin(seq(0,4,length=215))
#' obs <- array(rnorm(215*30, mean=2), c(215, 30)) + 
#' sin(seq(0,4, length=215))
#' fcst.debias <- smooth_scale(fcst[,1:20,], obs[,1:20], fcst.out=fcst, span=0.5)
#' 
#' @keywords util
#' @export
smooth_scale <- function(fcst, obs, fcst.out=fcst, span=min(1, 31/nrow(fcst)), ...){
  fcst.ens <- rowMeans(fcst, dims=2)
  fcst.ens[is.na(obs)] <- NA
  fcst.mn <- rowMeans(fcst.ens, dims=1, na.rm=T)
  obs.mn <- rowMeans(obs, dims=1, na.rm=T)
  fcst.clim <- loess(fcst.mn ~ seq(along=fcst.mn), span=span)$fit
  obs.clim <- loess(obs.mn ~ seq(along=obs.mn), span=span)$fit
  obs.sd <- apply(obs, 1, sd, na.rm=T)
  obs.sdsmooth <- loess(obs.sd ~ seq(along=obs.sd), span=span)$fit
  fcst.sd <- apply(fcst, 1, sd, na.rm=T)
  fcst.sdsmooth <- loess(fcst.sd ~ seq(along=fcst.sd), span=span)$fit
  fcst.debias <- (fcst.out - fcst.clim) * obs.sdsmooth / fcst.sdsmooth + obs.clim
  return(fcst.debias)
}