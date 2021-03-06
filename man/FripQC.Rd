% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FRiPQC.R
\docType{methods}
\name{FRiPQC}
\alias{FRiPQC}
\alias{atacFripQC,ATACProc-method}
\alias{atacFripQC}
\alias{fripQC}
\title{Quality control for fraction of reads in peaks (FRiP)}
\usage{
atacFripQC(atacProcReads, atacProcPeak, bsgenome = NULL,
  reportOutput = NULL, readsBedInput = NULL, peakBedInput = NULL, ...)

\S4method{atacFripQC}{ATACProc}(atacProcReads, atacProcPeak, bsgenome = NULL,
  reportOutput = NULL, readsBedInput = NULL, peakBedInput = NULL, ...)

fripQC(readsBedInput, peakBedInput, bsgenome = NULL, reportOutput = NULL,
  ...)
}
\arguments{
\item{atacProcReads}{\code{\link{ATACProc-class}} object scalar.
It has to be the return value of upstream process:
\code{\link{atacSamToBed}}
\code{\link{samToBed}}
\code{\link{atacBedUtils}}
\code{\link{bedUtils}}}

\item{atacProcPeak}{\code{\link{ATACProc-class}} object scalar.
It has to be the return value of upstream process:
\code{\link{atacPeakCalling}},
\code{\link{peakCalling}}.}

\item{bsgenome}{\code{BSGenome} object scalar.
BSGenome object for specific species.}

\item{reportOutput}{\code{Character} scalar.
The report file path}

\item{readsBedInput}{\code{Character} scalar.
Reads BED file for peak calling.}

\item{peakBedInput}{\code{Character} scalar.
Peaks BED file}

\item{...}{Additional arguments, currently unused.}
}
\value{
An invisible \code{\link{fripQC}} object scalar for downstream analysis.
}
\description{
Calculate the fraction of reads falling within peak regions
}
\details{
The parameter related to input and output file path
will be automatically
obtained from \code{\link{ATACProc-class}} object(\code{atacProc}) or
generated based on known parameters
if their values are default(e.g. \code{NULL}).
Otherwise, the generated values will be overwrited.
If you want to use this function independently,
or you can use \code{fripQC} instead.
}
\examples{
library(R.utils)
library(magrittr)
td <- tempdir()
options(atacConf=setConfigure("tmpdir",td))

bedbzfile <- system.file(package="esATAC", "extdata", "chr20.50000.bed.bz2")
bedfile <- file.path(td,"chr20.50000.bed")
bunzip2(bedbzfile,destname=bedfile,overwrite=TRUE,remove=FALSE)

readsProc<-bedUtils(bedInput = bedfile,maxFragLen = 100, chrFilterList = NULL)
peaksProc<- readsProc \%>\% atacPeakCalling
library(BSgenome.Hsapiens.UCSC.hg19)

atacFripQC(readsProc,peaksProc,bsgenome=BSgenome.Hsapiens.UCSC.hg19)

}
\seealso{
\code{\link{atacSamToBed}}
\code{\link{atacBedUtils}}
}
\author{
Zheng Wei
}
