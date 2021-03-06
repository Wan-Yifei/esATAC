setClass(Class = "FastQC",
         contains = "ATACProc"
)


setMethod(
    f = "initialize",
    signature = "FastQC",
    definition = function(.Object, atacProc, ..., input_file = NULL, output_file = NULL, editable = FALSE){
        .Object <- init(.Object,"FastQC",editable,list(arg1=atacProc))

        if((!is.null(atacProc)) && (class(atacProc)[1] == "UnzipAndMerge")){ # atacproc from UnzipAndMerge
            if(is.null(getParam(atacProc,"fastqOutput2"))){ # single end
                .Object@paramlist[["Input"]] <- c(as.vector(unlist(getParam(atacProc, "fastqOutput1"))))
            }else{ # paired end
                .Object@paramlist[["Input"]] <- c(as.vector(unlist(getParam(atacProc, "fastqOutput1"))),
                                                  as.vector(unlist(getParam(atacProc, "fastqOutput2"))))
            }
        }else if((!is.null(atacProc)) && (class(atacProc)[1] == "Renamer")){ # atacproc from renamer
            if(is.null(getParam(atacProc,"fastqOutput2"))){ # single end
                .Object@paramlist[["Input"]] <- c(as.vector(unlist(getParam(atacProc, "fastqOutput1"))))
            }else{ # paired end
                .Object@paramlist[["Input"]] <- c(as.vector(unlist(getParam(atacProc, "fastqOutput1"))),
                                                  as.vector(unlist(getParam(atacProc, "fastqOutput2"))))
            }
        }else if(((!is.null(atacProc)) && (class(atacProc)[1] != "UnzipAndMerge")) ||
                 ((!is.null(atacProc)) && (class(atacProc)[1] != "Renamer"))){
            stop("Input class must be got from 'UnzipAndMerge' or 'Renamer'!")
        }else{
            .Object@paramlist[["Input"]] <- input_file
        }

        if(is.null(output_file)){
            output_name <- paste(basename(tools::file_path_sans_ext(.Object@paramlist[["Input"]][1])),
                                 "_FastQC.pdf", sep = "")
            .Object@paramlist[["Output"]] <- file.path(.obtainConfigure("tmpdir"), output_name)
        }else{
            .Object@paramlist[["Output"]] <- output_file
        }

        paramValidation(.Object)
        .Object
    }
)


setMethod(
    f = "processing",
    signature = "FastQC",
    definition = function(.Object,...){
        .Object <- writeLog(.Object,paste0("processing file:"))
        .Object <- writeLog(.Object,sprintf("source:%s", .Object@paramlist[["Input"]]))
        .Object <- writeLog(.Object,sprintf("destination:%s", .Object@paramlist[["Output"]]))
        qQCReport(input = .Object@paramlist[["Input"]], pdfFilename = .Object@paramlist[["Output"]])
        .Object
    }
)


setMethod(
    f = "checkRequireParam",
    signature = "FastQC",
    definition = function(.Object,...){
        if(is.null(.Object@paramlist[["Input"]])){
            stop("Parameter input_file is required!")
        }
    }
)


setMethod(
    f = "checkAllPath",
    signature = "FastQC",
    definition = function(.Object,...){
        checkFileExist(.Object,.Object@paramlist[["Input"]])
        checkPathExist(.Object,.Object@paramlist[["Output"]])
    }
)


setMethod(
    f = "getReportValImp",
    signature = "FastQC",
    definition = function(.Object, item){
        if(item == "pdf"){
            return(.Object@paramlist[["Output"]])
        }
    }
)


setMethod(
    f = "getReportItemsImp",
    signature = "FastQC",
    definition = function(.Object){
        return(c("pdf"))
    }
)




#' @name FastQC
#' @title Quality control for ATAC-seq data.
#' @description
#' Generate quality control plots from fastq of ATAC-seq data.
#' @param atacProc \code{\link{ATACProc-class}} object scalar.
#' It has to be the return value of upstream process:
#' \code{\link{atacUnzipAndMerge}},
#' \code{\link{atacRenamer}}
#' @param input_file \code{Character} scalar.
#' Input file path. One or more(\code{vector}) fastq file path.
#' @param output_file \code{Character} scalar.
#' output file path. Defult:"input_file_QC.pdf" in the same
#' folder as your input file.
#' @param ... Additional arguments, currently unused.
#' @details Every highthroughput sequencing need quality control analysis, this
#' function provide QC for ATAC-seq, such as GC content.
#' @return An invisible \code{\link{ATACProc-class}} object scalar for downstream
#' analysis.
#' @author Wei Zhang
#' @examples
#'
#' library(R.utils)
#' fra_path <- system.file("extdata", "chr20_1.2.fq.bz2", package="esATAC")
#' fq1 <- as.vector(bunzip2(filename = fra_path,
#' destname = file.path(getwd(), "chr20_1.fq"),
#' ext="bz2", FUN=bzfile, overwrite=TRUE, remove = FALSE))
#' fra_path <- system.file("extdata", "chr20_2.2.fq.bz2", package="esATAC")
#' fq2 <- as.vector(bunzip2(filename = fra_path,
#' destname = file.path(getwd(), "chr20_2.fq"),
#' ext="bz2", FUN=bzfile, overwrite=TRUE, remove = FALSE))
#' \dontrun{
#' qcreport(input_file = c(fq1, fq2))
#' }
#'
#'
#' @seealso
#' \code{\link{atacUnzipAndMerge}},
#' \code{\link{atacRenamer}}


setGeneric("atacQCReport",function(atacProc,
                                   input_file = NULL,
                                   output_file = NULL, ...) standardGeneric("atacQCReport"))


#' @rdname FastQC
#' @aliases atacQCReport
#' @export
setMethod(
    f = "atacQCReport",
    signature = "ATACProc",
    definition = function(atacProc,
                          input_file = NULL,
                          output_file = NULL, ...){
        atacproc <- new(
            "FastQC",
            atacProc = atacProc,
            input_file = input_file,
            output_file = output_file)
        atacproc <- process(atacproc)
        invisible(atacproc)
    }
)


#' @rdname FastQC
#' @aliases qcreport
#' @export
qcreport <- function(input_file, output_file = NULL, ...){
    atacproc <- new(
        "FastQC",
        atacProc = NULL,
        input_file = input_file,
        output_file = output_file)
    atacproc <- process(atacproc)
    invisible(atacproc)
}
