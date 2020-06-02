ip <- as.data.frame(installed.packages()[,c(1,3:4)])
ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]
write.table(ip, quote=FALSE, sep="==", row.names=FALSE, col.names=FALSE)