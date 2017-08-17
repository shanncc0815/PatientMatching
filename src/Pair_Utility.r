# or use tryCatch()  http://mazamascience.com/WorkingWithData/?p=912
orderPair <- function(Pair) {
  idx = which(Pair$V1 > Pair$V2);
  tmp = Pair$V1[idx]; Pair$V1[idx] = Pair$V2[idx]; Pair$V2[idx] = tmp
  Pair$idx = paste(Pair$V1,Pair$V2,sep="_")
  return(Pair)
}

diffPair <- function(allPairName,set1PairName,outPairName) {
  if (file.exists(allPairName) & file.exists(set1PairName)) {
    PA = read.csv(allPairName,header=F)
    P1 = read.csv(set1PairName,header=F)
    PA = orderPair(PA);
    P1 = orderPair(P1);
    commonID = intersect(P1$idx, PA$idx)
    P2 = setdiff(PA$idx,commonID)
    if(length(P2) > 0) {
      set2Pairs = data.frame(cbind(sapply(strsplit(P2, split="_"),function(x) x[1]),sapply(strsplit(P2, split="_"),function(x) x[2]),1))
      colnames(set2Pairs) = c("V1","V2","V3")
#    print(sprintf('Subset %s from allPair %s and store as %s.', set1PairName, allPairName, outPairName))
    
      print(sprintf('allPair file %s (%d pairs), set1Pair file %s (%d pairs), common %d pairs, additional %d pairs are stored in %s', allPairName, dim(PA)[1], set1PairName, dim(P1)[1], length(commonID), length(P2), outPairName))
      write.table(set2Pairs,file=outPairName,row.names=FALSE,col.names=F,append=F,quote=F,sep=",")

      commonPairs = data.frame(cbind(sapply(strsplit(commonID, split="_"),function(x) x[1]),sapply(strsplit(commonID, split="_"),function(x) x[2]),1))
      colnames(commonPairs) = c("V1","V2","V3")
      write.table(commonPairs,file=paste(outPairName,"common.csv",sep=""),row.names=FALSE,col.names=F,append=F,quote=F,sep=",")

    } else {
      print(sprintf('allPair file %s (%d pairs), set1Pair file %s (%d pairs), common %d pairs, no additional pairs are stored', allPairName, dim(PA)[1], set1PairName, dim(P1)[1], length(commonID)))
     set2Pairs = NULL
    }
  } else {
    print(sprintf('Either %s or %s does not exist.  Please check again', set1PairName, allPairName))
    stop("diffPair error")
  }
  return(set2Pairs)
}

# identifySubPair is to identify if subPair contains additional pairs that not covered in allPairs
identifySubPair <- function(allPairs,subPairs,outPairName) {
  subPairs = orderPair(subPairs)
  commonID = intersect(subPairs$idx, allPairs$idx)
  P2 = setdiff(subPairs$idx,commonID)
  if(length(P2) > 0) {
    set2Pairs = data.frame(cbind(sapply(strsplit(P2, split="_"),function(x) x[1]),sapply(strsplit(P2, split="_"),function(x) x[2]),1))
    colnames(set2Pairs) = c("V1","V2","V3")
    print(sprintf('Sub pairs: %d, common pairs: %d, additional pairs: [%d are stored as %s].', dim(subPairs)[1], length(commonID), length(P2), outPairName))
    write.table(set2Pairs,file=outPairName,row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
    return(set2Pairs)
  } else {
    print(sprintf('Sub pairs: %d, common pairs: %d, additional pairs: %d. [No file is saved].', dim(subPairs)[1], length(commonID), 0))
  }
}


examineCSV <- function(inputPairName, input_df) {
    f1 = read.csv(inputPairName,header=F)
    outf1 = paste(inputPairName, ".Examine.csv", sep="")

    write.csv(t(c("FIELD",colnames(input_df))), file = outf1, row.names=FALSE,append=F, quote=F)
    for (i in 1:dim(f1)[1]) {
      id1=match(f1$V1[i], input_df[,1])
      id2=match(f1$V2[i], input_df[,1])
      MyData = cbind(i,input_df[c(id1,id2),])
      write.csv(MyData, file = outf1, row.names=FALSE, append=T, quote=F)
      write.csv("", file = outf1, row.names=FALSE, append=T, quote=F)
    }

    fileNameCommon = paste(inputPairName,"common.csv",sep="")
    if (file.exists(fileNameCommon)) {
      f2 = read.csv(fileNameCommon,header=F)
      outf2 = paste(inputPairName, "common.Examine.csv", sep="")

      write.csv(t(c("FIELD",colnames(input_df))), file = outf2, row.names=FALSE,append=F, quote=F)
      for (i in 1:dim(f2)[1]) {
        id1=match(f2$V1[i], input_df[,1])
        id2=match(f2$V2[i], input_df[,1])
        MyData = cbind(i,input_df[c(id1,id2),])
        write.csv(MyData, file = outf2, row.names=FALSE, append=T, quote=F)
        write.csv("", file = outf2, row.names=FALSE, append=T, quote=F)
      }
    }
}




combinePair <- function(set1PairName,set2PairName,outPairName) {
  if (file.exists(set1PairName) & file.exists(set2PairName)) {
    P1 = read.csv(set1PairName,header=F)
    P2 = read.csv(set2PairName,header=F)
    P1 = orderPair(P1);
    P2 = orderPair(P2);
    P12 = rbind(P1,P2);
    PU = unique(P12$idx)
    cPair = data.frame(cbind(sapply(strsplit(PU, split="_"),function(x) x[1]),sapply(strsplit(PU, split="_"),function(x) x[2]),1))
    colnames(cPair) = c("V1","V2","V3")

    print(sprintf('Combine %s and %s and store as %s.', set1PairName, set2PairName, outPairName))
    write.table(cPair,file=outPairName,row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
  } else {
    print(sprintf('Either %s or %s does not exist.  Please check again', set1PairName, set2PairName))
    stop("combinePair error")
  }
  return(cPair)
}

