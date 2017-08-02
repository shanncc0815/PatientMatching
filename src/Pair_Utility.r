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
#    print(P1[1:10,])
    PA = orderPair(PA);
    P1 = orderPair(P1);
#    print(P1[1:10,])
    commonID = intersect(P1$idx, PA$idx)
    P2 = setdiff(PA$idx,commonID)
    set2Pairs = data.frame(cbind(sapply(strsplit(P2, split="_"),function(x) x[1]),sapply(strsplit(P2, split="_"),function(x) x[2]),1))
    colnames(set2Pairs) = c("V1","V2","V3")
    print(sprintf('Subset %s from allPair %s and store as %s.', set1PairName, allPairName, outPairName))
    write.table(set2Pairs,file=outPairName,row.names=FALSE,col.names=F,append=F,quote=F,sep=",")
  } else {
    print(sprintf('Either %s or %s does not exist.  Please check again', set1PairName, allPairName))
    stop("diffPair error")
  }
  return(set2Pairs)
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

