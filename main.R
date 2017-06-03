rm(list = ls())
setwd("E:/gitperso/introduction-particle-filters/")
#setwd("E:/to/your/directory/")
source("helpers/sampleXY.R") # to sample sequences X and Y
source("helpers/SISR_particles.R") # to sample particles looking for Y
source("helpers/plots_trajectory.R") # to plot sequences X and Y
source("helpers/plots_particles.R") # to plot particles and results

options(digits=3)
dir.create("outputs", showWarnings = FALSE)

###############################
# Sample of sequences X and Y #
###############################
m = 100
XY = sampleXY(m, seed = "beamer")
x = XY$X
y = XY$Y

###########################
# Plots of the trajectory #
###########################
##
# Processus to sample X, step by step
##
# (see beamer presentation pages 6, 7, 8, 9, 10, 11)
dir.create("outputs/circles_x", showWarnings = FALSE)
pdf_circles_x(x, k_max = 3, xlim = c(-2,2), ylim = c(-2,2))

##
# Trajectory of X from 0 to 9
##
# (see beamer presentation page 12)
pdf(paste("outputs/trajectory_x.pdf", sep = ""))
plot_trajectory(x[1:10], xlim = c(-2,2), ylim = c(-2,2))
dev.off()

##
# Y observations and X trajectory from 0 to 9
##
# (see beamer presentation page 15)
pdf(paste("outputs/trajectory_xy.pdf",sep=""))
plot_y(x[1:10], y[1:10], xlim = c(-4,4), ylim = c(-4,4), plot_x = TRUE)
dev.off()

##
# Y observations without X trajectory
##
# (see beamer presentation page 16)
pdf(paste("outputs/trajectory_y.pdf",sep=""))
plot_y(x[1:10], y[1:10], xlim = c(-4,4), ylim = c(-4,4), plot_x = FALSE)
dev.off()

##
# Plot of the whole hidden trajectory
##
# (see beamer presentation page 35)
pdf(paste("outputs/trajectory_x_all.pdf", sep = ""))
plot(x, type = "o", col = "red", xlab="abs", ylab="ord")
text(Re(x), Im(x), 1:m-1, pos = 3)
lines(0, 0, type="p", pch=3)
dev.off()

#######
# SIS # (20 particles)
#######
N = 20

##
# Simulation with SIS
##
set.seed(4)
out = SIS(N, y)
M = out$M # trajectory of particles
M_WEIGHTS = out$M_WEIGHTS # normalized weights

##
# Trajectory after first steps
##
# (see beamer presentation pages 24, 25, 26)
dir.create("outputs/sis", showWarnings = FALSE)
for(i in 1:3) {
  add_text = add_text_func(M_WEIGHTS,i)
  col = col_func(M_WEIGHTS,i)
  
  pdf(paste("outputs/sis/step_", i, ".pdf", sep = ""))
  plot_SISR(M[1:5,], i, add_text, col, x)
  dev.off()
}

#######
# SIS # (10000 particles)
#######
N = 10000

##
# Simulation with SIS
##
set.seed(8)
out = SIS(N, y)
M = out$M
M_WEIGHTS = out$M_WEIGHTS

##
# Trajectory after many steps
##
# (see beamer presentation page 36)
# 68 is selected instead of 100, because after this step weight degeneracy
# makes us unable to normalize weights.
i = 68
add_text = add_text_func(M_WEIGHTS,i)
col = col_func(M_WEIGHTS,i)

png(paste("outputs/sis/step_end.png", sep = ""), 600, 600)
plot_SISR(M, i, add_text, col, x)
dev.off()

##
# Histogram of weights (all weights are 0 expect one)
##
png(paste("outputs/sis/hist_weights.png", sep = ""), 600, 600)
hist_weights(M_WEIGHTS[i,], main = "Histogram of weights in SIS")
dev.off()

##
# Trajectory for the best particle, compared to the true trajectory
##
# (see beamer presentation page 38)
pdf(paste("outputs/sis/best_particle_traj.pdf", sep = ""))
best_particle_obs(M, M_WEIGHTS, y, i)
dev.off()

########
# SISR # (20 particles)
########
N = 20

##
# Simulation with SISR
##
set.seed(81)
out = SISR(N, y[1:2])
M = out$M # trajectory of particles
M_WEIGHTS = out$M_WEIGHTS # normalized weights
M_save = out$M_save # trajectory at each site i before resampling

##
# Trajectory after first steps
##
# (see beamer presentation pages 30, 31, 32, 33)
dir.create("outputs/sisr", showWarnings = FALSE)
xlim = c(-1.2, 1.2); ylim = xlim # size of the plot window

for(i in 1:2) {
  ##
  # Trajectories before resampling at step i
  ##
  # M_new contains the trajectory at step 2 before resampling, combining
  # M[1,] the trajectory at step 1 AFTER resampling,
  # M_save[2,] the trajectory at step 2 BEFORE resampling.
  # (this works only for i in 1:2)
  add_text = add_text_func(M_WEIGHTS,i)
  col = col_func(M_WEIGHTS,i)
  M_new = M
  M_new[i,] = M_save[i,]
  
  pdf(paste("outputs/sisr/step_", i, "_before.pdf", sep = ""))
  plot_SISR(M_new, i, add_text, col, x, xlim = xlim, ylim = ylim)
  dev.off()
  
  ##
  # Trajectories after resampling at step i
  ##
  add_text = rep(round(1/N, 2), N)
  col = rep("black", N)
  
  pdf(paste("outputs/sisr/step_", i, "_after.pdf", sep = ""))
  plot_SISR(M, i, add_text, col, x, xlim = xlim, ylim = ylim)
  dev.off()
}

########
# SISR # (10000 particles)
########
N = 10000

##
# Simulation with SISR
##
set.seed(64)
out = SISR(N, y)
M = out$M
M_WEIGHTS = out$M_WEIGHTS
M_save = out$M_save

##
# Trajectory after many steps
##
# (see beamer presentation page 37)
i = 100
add_text = add_text_func(M_WEIGHTS,i)
col = col_func(M_WEIGHTS,i)

png(paste("outputs/sisr/step_end.png", sep=""), 600, 600)
plot_SISR(M, i, add_text, col, x)
dev.off()

##
# Histogram of weights
##
png(paste("outputs/sisr/hist_weights.png", sep = ""), 600, 600)
hist_weights(M_WEIGHTS[i,], main = "Histogram of weights in SISR")
dev.off()

##
# Trajectory for the best particle, compared to the true trajectory
##
# (see beamer presentation page 39)
pdf(paste("outputs/sisr/best_particle_traj.pdf", sep = ""))
best_particle_obs(M, M_WEIGHTS, y, i)
dev.off()