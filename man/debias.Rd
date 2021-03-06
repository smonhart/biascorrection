% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/debias.R
\name{debias}
\alias{debias}
\title{Calibration of daily time series}
\usage{
debias(fcst, obs, method = "unbias", fcst.out = fcst, fc.time = NULL,
  fcout.time = fc.time, crossval = FALSE, blocklength = 1,
  forward = FALSE, nforward = floor(ncol(fcst)/2), ...)
}
\arguments{
\item{fcst}{n x m x k array of n lead times, m forecasts, of k ensemble
members}

\item{obs}{n x m matrix of veryfing observations}

\item{method}{character string with bias correction method name}

\item{fcst.out}{array of forecast values to which bias correction should be
applied (defaults to \code{fcst})}

\item{fc.time}{forecast dates of class 'Date' (for monthly correction, see
\code{\link{monthly}})}

\item{fcout.time}{forecast dates of class 'Date' (for monthly correction, see
\code{\link{monthly}})}

\item{crossval}{logical, should leave-one-out crossvalidation be used (see
details)?}

\item{blocklength}{block length for moving blocks crossvalidation (defaults
to 1 for leave-one-out crossvalidation)}

\item{forward}{logical, should only past hindcasts be used for calibration?}

\item{nforward}{number of forecasts to debias backwards in forward mode (see
details).}

\item{...}{additional arguments passed to bias correction methods}
}
\description{
Applies bias correction derived from forecast and observation data to
forecast data set
}
\details{
No missing values are tolerated in either `obs` or `fcst` to ensure consistency
of calibration. Missing ensemble members, however, are tolerated in `fcst.out`,
thereby allowing calibration of non-homogeneous ensembles.

If \code{crossval} is set to \code{TRUE}, the debiasing for years in
block \code{i} are computed based on the forecast and observation data set
excluding years in block \code{i}. If, in addition, there are more years in
the output set \code{fcst.out} than in the input set \code{fcst}, the bias
correction for the remaining years in \code{fcst.out} is computed based on
all years in \code{fcst}.

If \code{forward} is set to \code{TRUE}, the debiasing for forecast \code{i}
is computed based on all previous forecast observation pairs. The first
\code{nforward} forecasts, however, are debiased backwards (i.e. forecast \code{i}
is calibrated with forecasts \code{i+1} to \code{n}).
}
\examples{
## initialise forcast observation pairs
fcst <- array(rnorm(30*215*51, mean=1, sd=rep(seq(0.5,2, length=30), each=215)),
c(215, 30, 51)) + 0.5*sin(seq(0,4,length=215))
obs <- array(rnorm(30*215, mean=2), c(215, 30)) + sin(seq(0,4, length=215))
fcst.debias <- debias(fcst, obs, 'unbias')
## should be exactly zero
range(rowMeans(obs, dims=1) - rowMeans(fcst.debias, dims=1))
}
\keyword{util}

