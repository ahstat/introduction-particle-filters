##
# Compute SISR particles
##
SISR = function(N, y, sd = 0.1, resampling = TRUE) {
  m = length(y)
  
  ##
  # Empty matrices
  ##
  colnames=paste("partic", 1:N, sep="")
  dimnames = list(0:(m-1), colnames)
  
  # M[i,j] represents x_i for particle j
  M = matrix(NA, nrow=m, ncol=N, dimnames=dimnames)
  
  # M_weights[i,j] represents related unnormalized weights
  M_weights = M
  
  # M_WEIGHTS[i,j] represents normalized weights
  M_WEIGHTS = M
  
  # If there is resampling, M contains the trajectory of resampled particles
  # To keep a look on old trajectories, 
  # M_save[i,j] represents x_i at step i before resampling, for particle j
  if(resampling) {
    M_save = M
  }
  
  for(i in 1:m) {
    print(paste(i, "/", m, sep = ""))
    
    for(j in 1:N) {
      # Simulate x_{1} from the initial position x_{0} = 0
      x_i_j = ifelse(i == 1, 0, M[i-1,j])
      M[i,j] = x_i_plus_1(x_i_j)
      
      # Compute the weight for this new position
      w_i_minus_1_j = ifelse(i == 1, 1,  M_weights[i-1, j])
      M_weights[i,j] = update_weights(M[i,j], y[i], w_i_minus_1_j, sd)
    }
    
    # Normalize the weights
    M_WEIGHTS[i,]=M_weights[i,]/(sum(M_weights[i,]))
    
    if(resampling) {
      M_save[i,] = M[i,]
      resample_idx = resample_idx_func(M_WEIGHTS[i,])
      M = M[, resample_idx]
      M_weights[i,] = rep(1, N)
    }
  }
  
  if(resampling) {
    return(list(M=M, M_weights=M_weights, M_WEIGHTS=M_WEIGHTS, M_save=M_save))
  } else {
    return(list(M=M, M_weights=M_weights, M_WEIGHTS=M_WEIGHTS))
  }
}

##
# Compute SIS particles
##
SIS = function(N, y, sd = 0.1) {
  return(SISR(N, y, sd = 0.1, resampling = FALSE))
}

##
# Get p(y_i | x_i)
##
# y_i should be computed from a Arg(x_i) + N(0, sd)
# So y_i - Arg(x_i) should have density dnorm(0, sd)
w = function(x, y, sd = 0.1) {
  if(x==0) { #initial weight
    return(1)
  } else {
    # Get weight for current observation y given x 
    z = y - Arg(x)
    z = to_minus_pi_pi(z)
    return(dnorm(z, mean=0, sd=sd))
  }
}

##
# Update weights knowing previous weights
##
update_weights = function(x_i_j, y_i, w_i_minus_1_j, sd) {
  w_i_j = w_i_minus_1_j * w(x_i_j, y_i, sd)
  
  # To prevent computation problem with degeneracy weights
  if(!is.finite(w_i_j)) {
    w_i_j = 0
  }
  
  return(w_i_j)
}

##
# Resample the particle according to the current normalized weights
## 
resample_idx_func = function(M_WEIGHTS_i) {
  N = length(M_WEIGHTS_i)
  
  # Sample N particles from the weights
  draw=rmultinom(1, size=N, M_WEIGHTS_i)
  resample_idx = unlist(sapply(1:N, function(j){rep(j, draw[j])}))
  return(resample_idx)
}