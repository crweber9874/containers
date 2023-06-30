
syntheticRegression <- function(n, slope, intercept, sd) {
  x <- rnorm(n)
  y <- slope * x + intercept + rnorm(n, sd = sd)
  data.frame(x = x, y = y)
}
syntheticRegression(1000, 2, 1, 1)
write.csv(syntheticRegression(1000, 2, 1, 1), "syntheticRegression.csv")
