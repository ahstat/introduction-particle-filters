##
# Plot particle trajectories (and the original trajectory)
##
# * particles are in the matrix M,
# * particles are plotted from site 1 to i,
# * for each particle, there is a text indicating its weight in add_text,
# * the color of each particle is col,
# * the original trajectory is x
plot_SISR = function(M, i, add_text, col, x, ...) {
  # Plot frame
  plot(M, type="n", xlab="abs", ylab="ord", ...)
  
  # Sort indexes to plot black curves (highest weights) at the end
  idx_gray = which(col == "gray")
  idx_black = which(col == "black")
  idx = c(idx_gray, idx_black)
  
  # Each particle will be plotted from sites 1 to i
  vectDraw = 1:i
  
  # Plot each particle k
  for(k in idx) {
    # particle trajectory
    lines(M[vectDraw, k], type="o", col = col[k])
    # weight related to this particle
    text(Re(M[i,k]), Im(M[i,k]), add_text[k], pos=3, col=col[k])
  }
  
  # True particle trajectory
  lines(x[vectDraw], type="o", col="red")

  # (0, 0) position
  lines(0, 0, type="p", pch=3)
}

##
# Plot the true observations, and the observations for the best particle
##
# The best particle is defined as the particle with the highest weight
# at site i (usually for i the last site).
best_particle_obs = function(M, M_WEIGHTS, y, i = NA) {
  # set i as last step, if not provided
  i = ifelse(is.na(i), nrow(M), i)

  # take the particle with the highest weight at site i
  best_particle = which.max(M_WEIGHTS[i,])
  
  # plot observations for this particle
  plot(Arg(M[, best_particle]),
       xlab="site m", ylab="angle", 
       main="Observations (red) and angles for the 'best' particle (black)",
       ylim = range(y))
  lines(y, col="red")
}

##
# Histogram of weights
##
hist_weights = function(w_i, ...) {
  hist(w_i, breaks=50, freq=TRUE,
       xlab="Normalized weights", ylab="Number of particles", 
       ...)
}

##
# Text added for each particle (indicating weights)
##
add_text_func = function(M_WEIGHTS, i) {
  return(sprintf("%4.2f", M_WEIGHTS[i,]))
}

##
# Color for each particle trajectory
##
col_func = function(M_WEIGHTS, i, threshold = 1/N) {
  return(ifelse(M_WEIGHTS[i,] < 1/N, "gray", "black"))
}