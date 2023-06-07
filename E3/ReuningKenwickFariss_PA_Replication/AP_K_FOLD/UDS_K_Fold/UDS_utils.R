
post_pred_corrs <- function(year_ids, real, draws, ngroups=max(real)){

  ids <- year_ids
  prev.ids <- df$prev.year[which(df$count.year.id%in%year_ids)]

  diffs <- matrix(NA, nrow=nrow(draws), ncol=sum(prev.ids!=0 & prev.ids %in% ids))
  change.real <- numeric(sum(prev.ids!=0 & prev.ids %in% ids))
  kk <- 1
  for(ii in 1:length(prev.ids)){
    if(prev.ids[ii]==0) next
    if(!(prev.ids[ii] %in% ids)) next
    change.real[kk] <- real[ii] - real[which(prev.ids[ii]==ids)]
    diffs[,kk] <- draws[,ii] - draws[,which(prev.ids[ii]==ids)]
    kk <- kk + 1
  }

  corrs <- numeric(nrow(diffs))
  for(ii in 1:nrow(diffs)){
    corrs[ii] <- cor(change.real, diffs[ii,])
  }

  return(list(mean=mean(corrs), ci=quantile(corrs, c(0.025, 0.975)), data=corrs))
}
