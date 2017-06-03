##
# Simulation of a sequence X
##
# We want to simulate x_i_plus_1 knowing x_i, i.e. to simulate under the
# distribution B(x_i, 1) (the whole ball centered in x_i with radius 1).
#
# This is a little tricky, because we want the uniform distribution on a disc
# See here: http://mathworld.wolfram.com/DiskPointPicking.html
#
# Here two examples, showing uniform distribution on the disk B(0,1),
# and then on the disk B(0, 10).
#
# n=10000
# r=runif(n, 0, 1)
# theta=runif(n, -pi, pi)
# plot(sqrt(r)*cos(theta), sqrt(r)*sin(theta))
#
# n=10000
# radius=10
# rSq=runif(n, 0, radius^2)
# theta=runif(n, -pi, pi)
# plot(sqrt(rSq)*cos(theta), sqrt(rSq)*sin(theta))
# circle(radius=radius, origin=c(Re(xi),Im(xi)))

# Simulation of x_{i+1} knowing x_i, each step being uniform on B(x_i, 1)
x_i_plus_1 = function(xi) {
  rSq = runif(1, 0, 1)
  theta = runif(1, -pi, pi)
  return(Re(xi) + sqrt(rSq)*cos(theta) + 1i*(Im(xi) + sqrt(rSq)*sin(theta))) 
}

# Simulation of the whole hidden sequence X
sample_X = function(m) {
  x = rep(NA, m)
  x[1] = x_i_plus_1(0)
  for(i in 1:(m-1)) {
    x[[i+1]] = x_i_plus_1(x[[i]])
  }
  return(x)
}

##
# Simulation of a sequence Y (knowing the hidden sequence X)
##
sample_Y = function(x, sigma = 0.1) {
 y = Arg(x) + rnorm(length(x), 0, sigma)
 y = to_minus_pi_pi(y)
 return(y)
}

# Convert value to [-pi, pi]
to_minus_pi_pi = function(y) {
  y = y %% (2*pi)
  y = ifelse(y > pi, y-2*pi, y)
  return(y)
}

##
# Sample of X and Y
##
sampleXY = function(m, seed, sigma = 0.1) {
  if(seed == "beamer") {
    if(m == 100 & sigma == 0.1) {
      return(sample_beamer())
    } else {
      stop(paste('seed == "beamer" is only here to retrieve the sample shown',
                 'in the beamer presentation.'))
    }
  }
  
  set.seed(seed)
  X = sample_X(m)
  Y = sample_Y(X, sigma)
  return(list(X=X, Y=Y))
}

##
# Sample (X, Y) used in the presentation
##
# obtained with m = 100 and sigma = 0.1
sample_beamer = function() {
  X=c(0.203+0.639i, 0.635-0.029i, -0.177+0.404i, 0.217+0.649i, 0.200+0.375i,
      0.350-0.110i, 0.458-0.890i, 0.356-1.368i, 0.959-1.967i, 0.345-1.951i,
      0.008-1.211i, -0.590-1.780i, -1.368-1.572i, -1.647-1.971i, -0.748-2.144i,
      -1.319-2.817i, -1.809-2.783i, -1.815-1.812i, -1.617-1.884i, -1.660-2.153i,
      -1.706-2.513i, -2.035-3.441i, -2.309-2.761i, -2.537-3.016i, -2.607-3.074i,
      -2.300-3.792i, -1.457-3.614i, -1.015-3.649i, -0.900-2.678i, -0.721-2.744i,
      -1.139-3.595i, -0.414-3.474i, -0.097-2.874i, -0.409-2.793i, 0.037-2.947i,
      -0.550-2.966i, 0.315-2.579i, 0.628-3.107i, 0.585-2.571i, 0.535-3.153i,
      0.808-3.555i, 1.704-3.593i, 1.531-3.837i, 0.692-3.810i, 0.902-4.288i,
      0.451-4.543i, -0.309-4.031i, -0.137-3.436i, 0.286-3.335i, -0.616-3.673i,
      -0.308-4.564i, -0.891-5.104i, -1.299-5.501i, -1.745-4.879i, -1.792-4.712i,
      -0.959-4.301i, -0.638-3.986i, -1.012-3.866i, -0.532-3.043i, -0.181-2.464i,
      -0.015-2.123i, -0.338-1.341i, -1.034-1.967i, -1.003-1.728i, -1.521-2.250i,
      -2.156-1.495i, -1.781-0.858i, -1.628-0.044i, -1.077-0.213i, -0.688-0.256i,
      -0.106+0.421i, 0.465+0.264i, 0.171+1.068i, -0.480+1.293i, -0.425+2.095i,
      -0.393+1.700i, -1.146+2.039i, -0.917+2.990i, -1.118+3.836i, -1.538+4.225i,
      -1.805+4.690i, -2.352+4.092i, -2.532+4.276i, -2.886+4.219i, -3.352+4.924i,
      -3.117+4.860i, -2.866+4.463i, -2.803+3.793i, -2.379+2.892i, -2.449+2.190i,
      -3.380+2.012i, -2.462+1.908i, -2.936+2.544i, -3.000+2.466i, -2.710+3.215i,
      -2.849+3.365i, -2.656+4.158i, -2.337+4.519i, -2.985+4.043i, -2.651+3.562i)
  
  Y=c(1.278, 0.075, 2.089, 1.258, 1.099, 
      -0.371, -0.930, -1.326, -1.103, -1.476,
      -1.517, -1.724, -2.358, -2.408, -1.886,
      -2.106, -2.093, -2.394, -2.279, -2.313,
      -2.099, -2.142, -2.139, -2.343, -2.118,
      -2.110, -2.115, -1.762, -1.962, -1.703,
      -1.996, -1.530, -1.825, -1.761, -1.551,
      -1.675, -1.505, -1.458, -1.344, -1.332,
      -1.434, -1.216, -1.131, -1.343, -1.315,
      -1.502, -1.570, -1.644, -1.628, -1.474,
      -1.734, -1.663, -1.755, -1.854, -1.682,
      -1.862, -1.758, -1.794, -1.652, -1.569,
      -1.618, -1.676, -1.918, -2.158, -2.324,
      -2.660, -2.682, -3.096, -2.946, -2.780,
      1.806, 0.688, 1.460, 2.066, 1.819, 
      1.826, 1.984, 1.913, 1.768, 1.812, 
      1.878, 2.230, 2.011, 2.205, 2.258, 
      2.078, 2.186, 2.119, 2.283, 2.501, 
      2.321, 2.563, 2.408, 2.466, 2.187, 
      2.278, 2.061, 1.923, 2.155, 2.206)
  
  return(list(X=X, Y=Y))
}