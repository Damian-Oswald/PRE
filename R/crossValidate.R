#' @title Perform `k`-fold cross-validation
#' 
#' @description A function to run an `r` times repeated `k`-fold cross validation of any sort of model `FUN`.
#' 
#' @param FUN The model to repeatedly use as a function. Needs to take exactly four matrix arguments: `x_train`, `y_train`, `x_test`, and `y_test`. The function should return whatever evaluation metric we want to use.
#' @param x An \eqn{n * p} design matrix of the features to be used by the model.
#' @param y An \eqn{n * 1} matrix of the labels to be used by the model.
#' @param k Number of parts in which the data is split for the cross validation process.
#' @param r Number of times the cross validation process is repeated.
#' @param ... Additional arguments to be passed to the model `FUN`. Any hyperparameters to be evaluated can be passed via this function.
#' 
#' @examples
#' library(PRE)
#' 
#' f <- function(x_train, x_test, y_train, y_test) {
#'       model <- lm(y_train ~ ., data = as.data.frame(x_train))
#'       y_hat <- predict(model, newdata = as.data.frame(x_test))
#'       return(mean((y_test - y_hat)^2))
#' }
#' 
#' results <- crossValidate(FUN = f,
#'                          x = mtcars[,-1],
#'                          y = mtcars[,1,drop=FALSE],
#'                          k = 5, r = 100
#' )
#' @export
crossValidate <- function (FUN, x, y, k = nrow(x), r = 1, ...) {
   
   # create an empty data frame for the results of the cross-validation
   results <- data.frame()
   
   # repeat the k-fold cross-validation `r` times
   for (R in 1:r) {
      
      # create a matrix with random indices; the dimensions of the matrix match `k` and the (maximum) fold sizes
      I <- matrix(c(sample(1:nrow(x)), rep(NA, k - nrow(x)%%k)), ncol = k, byrow = TRUE)
      
      # loop over every fold
      for (K in 1:k) {
         
         # save the indices for this specific fold
         i <- na.omit(I[,K])
         
         # run the function `FUN` with the specific observations of this fold
         result <- cbind(cost = FUN(x_train = x[-i,], y_train = y[-i,], x_test = x[i,], y_test = y[i,], ...), r = R, k = K)
         
         # attach the results of this model run to the overall results
         results <- rbind(results, result)
      }
   }
   
   # return the results of the cross validation
   return(results)
}