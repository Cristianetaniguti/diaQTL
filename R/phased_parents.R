#' Visualize phased SNPs of parents
#' 
#' Visualize phased SNPs of parents
#' 
#' The solid circles in the figure represent the allele counted by dosage. 
#' 
#' @param filename Name of CSV input file
#' @param interval Vector of length 2 with the first and last marker names
#' @param markers Vector of marker names to plot
#' @param parents Vector of parent names to plot
#' 
#' @return ggplot2 object
#' 
#' @export
#' @importFrom tidyr pivot_longer
#' @import ggplot2
#' @import ggfittext
#' @importFrom utils read.csv write.csv
#' @importFrom rlang .data

phased_parents <- function(filename,interval,markers,parents) {
  #x1=x2=y1=y2=xend=y=yend=x3=y3=x4=value=ymin=ymax=NULL #to avoid NOTE while doing R check
  
  x <- read.csv(filename,as.is=T,check.names=F)
  interval <- match(interval,x$marker)
  if (any(is.na(interval))) {
    stop("Markers are not in the file.")
  }
  map <- x[interval[1]:interval[2],]
  if (length(unique(map$chrom))>1) {
    stop("Markers are not on the same chromosome.")
  }
  map <- map[order(map$bp),]
  
  m <- nrow(map)
  map$y1 <- map$cM - map$cM[m]
  map$y1 <- map$y1/map$y1[1]
  map$y2 <- map$bp - map$bp[m]
  map$y2 <- map$y2/map$y2[1]
  map$x1 <- 1
  map$x2 <- 2
  
  features <- markers
  nf <- length(features)
  ix <- match(features,map$marker)
  iz <- order(ix)
  ix <- ix[iz]
  features <- features[iz]
  map2 <- data.frame(x2=2,x3=3,x4=5,y2=map$y2[ix],y3=seq(0.9,0.1,length.out=nf))
  
  stopifnot(all(parents %in% colnames(map)))
  iu <- match(parents,colnames(map))
  n.parents <- length(parents)
  if (n.parents==1) {
    tmp <- strsplit(map[ix,iu],split="|",fixed=T)
    ploidy <- length(tmp[[1]])
    ans <- list(matrix(as.integer(unlist(tmp)),nrow=nf,ncol=ploidy,byrow=T))
  } else {
    tmp <- apply(map[ix,iu],2,strsplit,split="|",fixed=T)
    ploidy <- length(tmp[[1]][[1]])
    ans <- lapply(tmp,function(z){matrix(as.integer(unlist(z)),ncol=ploidy,nrow=nf,byrow=T)})
  }
  
  p <- ggplot(data=map) + geom_segment(aes(x=.data$x1,xend=.data$x2,y=.data$y1,yend=.data$y2),colour="grey50") + geom_segment(data=data.frame(x=c(1,2),y=c(0,0),yend=c(1,1),xend=c(1,2)),aes(x=.data$x,xend=.data$xend,y=.data$y,yend=.data$yend)) + geom_segment(data=map2,aes(x=.data$x2,xend=.data$x3,y=.data$y2,yend=.data$y3),colour="blue") + theme_classic() + theme(axis.line=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank()) + xlab("") + ylab("")
  
  #Text labeling
  p <- p + geom_fit_text(data=map2,mapping=aes(xmin=.data$x3,xmax=.data$x4,y=.data$y3,label=features),place="left") + geom_text(data=data.frame(x=rep(0.97,2),y=c(1,1.05)),aes(x=.data$x,y=.data$y,label=c(map$cM[1],"cM"),hjust=1,vjust=0)) + geom_text(data=data.frame(x=0.97,y=0),aes(x=.data$x,y=.data$y,label=map$cM[m],hjust=1,vjust=1)) + geom_text(data=data.frame(x=rep(2.03,2),y=c(1,1.05)),aes(x=.data$x,y=.data$y,label=c(map$bp[1],"bp"),hjust=0,vjust=0)) + geom_text(data=data.frame(x=2.03,y=0),aes(x=.data$x,y=.data$y,label=map$bp[m],hjust=0,vjust=1))
  
  #SNP dots
  tmp2 <- NULL
  haplotypes <- NULL
  for (i in 1:n.parents) {
    tmp <- pivot_longer(data.frame(y=map2$y3,ans[[i]]),cols=2:(ploidy+1),names_to="haplotype")
    tmp$x <- (as.integer(factor(tmp$haplotype))-1)/2 + 5.2 + (i-1)*ploidy/2
    tmp2 <- rbind(tmp2,tmp)
    haplotypes <- c(haplotypes,paste(parents[i],1:ploidy,sep="."))
  }
  tmp2$value <- factor(tmp2$value)
  p <- p + geom_point(data=tmp2,mapping=aes(x=.data$x,y=.data$y,shape=.data$value)) + scale_shape_manual(values=c(1,16),guide=NULL) + geom_fit_text(data=data.frame(x=(1:(ploidy*n.parents))/2+4.7,ymin=0.95,ymax=1.3),mapping=aes(x=.data$x,ymin=.data$ymin,ymax=.data$ymax,label=haplotypes,angle=90),place="bottom")

  return(p)
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       