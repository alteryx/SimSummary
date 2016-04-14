# Inputs ----
options(alteryx.wd = '%Engine.WorkflowDirectory%')
library(AlteryxRhelper)
config <- list(
  dependent = listInput('%Question.dependent%', "R_G"),
  independent = listInput('%Question.independent%', c("SLG", "OPS"))
)
inputs <- list(
  data = read.Alteryx2("#1", mode="data.frame")
)

# Functions (to be moved into the package) ----
# library(AlteryxSim)

#1. Scatter Plots ---
single.scat <- function(data, input, output) {
  plot(
    data[,input], 
    data[,output],
    main = paste(input, " vs ", output, " plot", sep = ""),
    xlab = input,
    ylab = output
  )
}

sa.scat <- function(data, inputs, outputs) {
  data <- data[c(inputs, outputs)]
  par(mfrow=c(length(outputs),length(inputs)))
  for (j in outputs) {
    for (i in inputs) {
      single.scat(data, i, j)
    }
  }
}

#2. Importance Index ---
sa.importance <- function(data, inputs, outputs) {
  data <- data[c(inputs, outputs)]
  results <- as.data.frame(outer(inputs, outputs, FUN=Vectorize(function(input, output) {
    var(data[,input])/var(data[,output])
    })))
	print(results)
  names(results) <- outputs
  results <- cbind(independent_variable = inputs, results)
}

#5. Pearson's R ---
sa.r <- function(data, inputs, outputs) {
  results <- as.data.frame(outer(inputs, outputs, FUN=Vectorize(function(input, output) {
    cor(data[,input],data[,output])
    })))
  names(results) <- outputs
  results <- cbind(independent_variable = inputs, results)
  return (results)
}

#8. Partial Correlation Coefficient ---
sa.pr.single <- function (data, inputs, output) {
  data <- data[union(inputs, c(output))]
  results <- as.data.frame(pcor(data)$estimate)
  names(results) <- union(inputs, c(output))
  results <- cbind(independent_variable = names(results), results)
  return (results)
}

sa.pr <- function(data, inputs, outputs) {
  full.results <- list()
  for (output in outputs) {
    new.results <- sa.pr.single(data, inputs, output)
    full.results[[length(full.results)+1]] <- new.results
  }
  names(full.results) <- outputs
  return (full.results)
}

sa.pr2 <- function(data) {
  library('ppcor')
	results <- as.data.frame(pcor(data)$estimate)
	names(results) <- names(data)
	results <- cbind(Variable = names(results), results)
	results
}


# Outputs ----

# Output 1: Scatter Plot
AlteryxGraph2({
   sa.scat(inputs$data, config$independent, config$dependent)
 }, 1, width=576*length(config$independent), height=576*length(config$dependent)
)


# Output 2: Importance Index
importances <- sa.importance(inputs$data, config$independent, config$dependent)
for (factor in names(importances)) {
	importances[,factor] <- as.character(importances[,factor])
}
write.Alteryx2(importances, 2)

# Output 3: Pearson's R
the.Rs <- sa.r(inputs$data, config$independent, config$dependent)
for (factor in names(the.Rs)) {
	the.Rs[,factor] <- as.character(the.Rs[,factor])
}
write.Alteryx2(the.Rs, 3)

print(str(inputs$data))
# Output 4: Partial Correlation Coefficients
the.prs <- as.data.frame(sa.pr2(inputs$data[,c(config$independent, config$dependent)]))
for (factor in names(the.prs)) {
	the.prs[,factor] <- as.character(the.prs[,factor])
}
write.Alteryx2(the.prs, 4)

