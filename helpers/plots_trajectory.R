##
# Illustration of the process to sample X with unit circles 
##
# Draw a circle, function by Jan Graffelman
circle = function (radius = 1, origin = c(0, 0), col="black") {
  t <- seq(-pi, pi, by = 0.01)
  a <- origin[1]
  b <- origin[2]
  r <- radius
  x <- a + r * cos(t)
  y <- b + r * sin(t)
  points(x, y, type = "l", col=col)
  return(NULL)
}

# Plot circles of radius 1 around all x[i] up to i = k.
# The last circle (for i == k) is plotted if last_circle = TRUE
plot_circles_x_up_to = function(k, x, last_circle = FALSE, ...) {
  plot(x, type = "n", xlab="abs", ylab="ord", asp = 1, ...)
  circle(radius=1, origin=c(0,0), col="gray")
  for(i in 1:k) {
    col = ifelse(i==k, "black", "gray")
    points(x[i], col=col)
    text(Re(x[i]), Im(x[i]), i-1, pos=3, col=col)
    if(i != k | last_circle == TRUE) {
      circle(radius=1, origin=c(Re(x[i]),Im(x[i])), col=col)
    }
  }
}

# Plot and save as pdf the processus to sample x, step by step
pdf_circles_x = function(x, k_max = 3, ...) {
  # Circle at step 0
  pdf(paste("outputs/circles_x/", 1, ".pdf", sep = ""))
  plot(x, type = "n", xlab="abs", ylab="ord", asp = 1, ...)
  circle(radius=1, origin=c(0,0), col="black")
  dev.off()
  
  # Circles at step k
  for(k in 1:k_max) {
    print(k)
    pdf(paste("outputs/circles_x/", 2*k, ".pdf", sep = ""))
    plot_circles_x_up_to(k, x, last_circle = FALSE, ...)
    dev.off()
    
    pdf(paste("outputs/circles_x/", 2*k+1, ".pdf", sep = ""))
    plot_circles_x_up_to(k, x, last_circle = TRUE, ...)
    dev.off()
  }
}

##
# Trajectory of X
##
plot_trajectory = function(x, ...) {
  plot(x, col="gray", type = "l", xlab="abs", ylab="ord", ...)
  lines(x, type="p")
  text(Re(x), Im(x), 0:(length(x)-1), pos=3, col="black")
}

##
# Y observations
##
plot_y = function(x, y, r_y = 3, plot_x = TRUE, ...) {
  plot(x, type = "n", xlab="abs", ylab="ord", asp = 1, ...)
  lines(0, 0, type="p", pch=3)
  circle(radius=r_y, origin=c(0,0), col="cyan")
  
  vect = 1:length(x)
  
  # Trajectory
  if(plot_x) {
    points(x, col="black")
    lines(x, col="gray")
    text(Re(x), Im(x), vect-1, pos=3, col="black")
  }
  
  # Trajectory on Y
  lines(r_y*cos(y), r_y*sin(y), type="p", col="blue")
  text(r_y*cos(y), r_y*sin(y), vect-1, pos=3, col="blue")
}