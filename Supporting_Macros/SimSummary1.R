# Inputs ----
options(alteryx.wd = '%Engine.WorkflowDirectory%')
library(AlteryxRhelper)
library(AlteryxSim)
config <- list(
  dependent = listInput('%Question.dependent%', "R_G"),
  independent = listInput('%Question.independent%', c("SLG", "OPS"))
)
inputs <- list(
  data = read.Alteryx("#1", mode="data.frame")
)



# Output 1: Scatter Plot
AlteryxGraph(1, width=576*length(config$independent), height=576*length(config$dependent))
saScat(inputs$data, config$independent, config$dependent)

# Output 2: Importance Index
importances <- saImportance(inputs$data, config$independent, config$dependent)
for (factor in names(importances)) {
	importances[,factor] <- importances[,factor]
}
write.Alteryx2(importances, 2)

# Output 3: Pearson's R
the.Rs <- saR(inputs$data, config$independent, config$dependent)
for (factor in names(the.Rs)) {
	the.Rs[,factor] <- as.character(the.Rs[,factor])
}
write.Alteryx2(the.Rs, 3)

# Output 4: Partial Correlation Coefficients
the.prs <- as.data.frame(saPr2(inputs$data[,c(config$independent, config$dependent)]))
for (factor in names(the.prs)) {
	the.prs[,factor] <- as.character(the.prs[,factor])
}
write.Alteryx2(the.prs, 4)

