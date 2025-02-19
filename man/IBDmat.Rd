% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IBDmat.R
\name{IBDmat}
\alias{IBDmat}
\title{Realized IBD relationship}
\usage{
IBDmat(
  data,
  dominance = 1,
  epistasis = FALSE,
  spacing = 1,
  chrom = NULL,
  n.core = 1
)
}
\arguments{
\item{data}{Variable inheriting from class \code{\link{diallel_geno}}}

\item{dominance}{One of 1,2,3,4}

\item{epistasis}{TRUE/FALSE}

\item{spacing}{spacing between marker bins, in cM}

\item{chrom}{Optional, vector of chromosome names to include}

\item{n.core}{number of cores for parallel execution}
}
\value{
Relationship matrix
}
\description{
Calculates realized relationship matrices from founder genotype probabilities
}
\details{
Parameter \code{dominance} refers to 1 = additive, 2 = digenic, 3 = trigenic, 4 = quadrigenic.  Can specify to use only a subset of the chromosomes (by default, all chromosomes are used). If \code{epistasis} is TRUE, then \code{dominance} must be 1 (additive x additive epistasis). Only pairs of markers on different chromosomes are used for epistasis.
}
\examples{
\dontrun{
  IBD_example = IBDmat(data = diallel_example, dominance=1) #additive
  IBD_example = IBDmat(data = diallel_example, dominance=2) #digenic dominance
  IBD_example = IBDmat(data = diallel_example, epistasis=TRUE) #additive x additive epistasis
}


}
