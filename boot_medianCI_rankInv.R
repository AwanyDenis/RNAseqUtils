
# Function to perform non-parametric bootstrap and 
# calculate median and confidence interval  by the 
# rank inversion.

boot_medianCI_rankInv <- function(x, B = 1000, alpha = 0.05) {
  set.seed(123)  # for reproducibility
  n <- length(x)
  medians <- numeric(B)

  # Function to calculate median by rank inversion
    median_by_rank_inversion <- function(x) {
        n <- length(x)
        ranks <- rank(x)
        inverted_ranks <- n + 1 - ranks
        median_value <- x[which.max(inverted_ranks >= (n + 1) / 2)]
        return(median_value)
    }

  for (i in 1:B) {
    resample <- sample(x, replace = TRUE)
    medians[i] <- median_by_rank_inversion(resample)
  }

  lower_bound <- quantile(medians, alpha / 2)
  upper_bound <- quantile(medians, 1 - alpha / 2)

  return(data.frame(median = median_by_rank_inversion(x), ci_lower = lower_bound, ci_upper = upper_bound))
}
