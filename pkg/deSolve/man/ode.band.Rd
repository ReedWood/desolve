\name{ode.band}
\alias{ode.band}
\title{Solver for ordinary differential equations; assumes a banded jacobian}
\description{Solves a system of ordinary differential equations. 
    \cr Assumes a banded jacobian matrix, but does not rearrange the state variables (in contrast to ode.1D). 
  Suitable for 1-D models that include transport only between adjacent layers and that model only one species}
\usage{ode.band(y, times, func, nspec=NULL, 
  bandup=nspec, banddown=nspec, method="lsode",...)}
\arguments{
  \item{y }{the initial (state) values for the ODE system, a vector. If \code{y} has a name attribute, the names will be used to label the output matrix.}
  \item{times }{time sequence for which output is wanted; the first value of \code{times} must be the initial time}
  \item{func }{either a user-supplied function that computes the values of the derivatives in the ODE system (the model definition) at time t, or a character string giving the name of a compiled function in a dynamically loaded shared library. 
       		See details}
  \item{nspec }{the number of *species* (components) in the model. }
  \item{bandup }{the number of nonzero bands above the jacobian diagonal}
  \item{banddown }{the number of nonzero bands below the jacobian diagonal}
  \item{method }{the integrator to use, one of "vode", "lsode", "lsoda", "lsodar" }
  \item{... }{additional arguments passed to the integrator}
}
\value{
  A matrix with up to as many rows as elements in \code{times} and as many columns as elements in \code{y} plus the number of "global" values returned 
      in the second element of the return from \code{func}, plus an additional column (the first) for the time value. 
      There will be one row for each element in \code{times} unless the integrator returns with an unrecoverable error. 
      If \code{y} has a names attribute, it will be used to label the columns of the output value. 
      
      The output will have the attributes \code{istate} and \code{rstate}, two vectors with several elements. See the help for the selected integrator for details.
      the first element of istate returns the conditions under which the last call to vode returned. Normal is istate = 2.
      If \code{verbose} = TRUE, the settings of istate and rstate will be written to the screen    
  
}
\author{Karline Soetaert <k.soetaert@nioo.knaw.nl>}
\examples{# The Aphid model from Soetaert and Herman, book in prep.
  # 1-D diffusion model
  #==================#
  # Model equations  #
  #==================#
  Aphid <-function(t,APHIDS,parameters)
   {
      deltax     <- c (0.5,rep(1,numboxes-1),0.5)    
      Flux       <- -D*diff(c(0,APHIDS,0))/deltax
      dAPHIDS    <- -diff(Flux)/delx  + APHIDS*r
  
      # the output
        list(dAPHIDS )
    }  # end of model
    
  #==================#
  # Model application#
  #==================#
  # the model parameters: #
  
  D         <- 0.3    # m2/day  diffusion rate
  r         <- 0.01   # /day    net growth rate
  delx      <- 1      # m       thickness of boxes
  numboxes  <- 60 
  
  # distance of boxes on plant, m, 1 m intervals
  Distance  <- seq(from=0.5,by=delx,length.out=numboxes)  
  
  # Initial conditions:  # ind/m2   
  # aphids present only on two central boxes 
  APHIDS        <- rep(0,times=numboxes)      
  APHIDS[30:31] <- 1
  state         <- c(APHIDS=APHIDS)      # initialise state variables 
                    
  # RUNNING the model:   #
  times     <-seq(0,200,by=1)   # output wanted at these time intervals           
  out       <- ode.band(state,times,Aphid,parms=0,nspec=1)  
  
  #==================#
  # Plotting output  #
  #==================#
  # the data in 'out' consist of: 1st col times, 2-41: the density
  # select the density data
  DENSITY   <- out[,2:(numboxes  +1)]
  
  filled.contour(x=times,y=Distance,DENSITY,color= topo.colors,
                 xlab="time, days", ylab= "Distance on plant, m",
                 main="Aphid density on a row of plants")}
\details{This is the method of choice for single-species 1-D reactive transport models. 
  
  For multi-species 1-D models, this method can only be used if the state variables are arranged per box, per species (e.g. A[1],B[1],A[2],B[2],A[3],B[3],.... for species A, B). 
  By default, the *model* function will have the species arranged as A[1],A[2],A[3],....B[1],B[2],B[3],.... 
  in this case, use ode.1D 
  
  See the selected integrator for the additional options}
\seealso{\item \code{\link{ode.1D}}, for integrating, when the jacobian matrix is banded, and where the state variables need to be rearranged}
\keyword{math}
