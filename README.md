# Introduction to particle filters

This code introduces two algorithms for particle filtering: the Sequential Importance Sampling algorithm (SIS) and the Sequential Importance Sampling Resampling algorithm (SISR).

Those two algorithms are used to sample trajectories for a homemade toy model. We show how the algorithms work, and focus on the difference between them, especially through the weights degeneracy problem.

You can check out the related blog post and beamer presentation here: https://ahstat.github.io/Introduction-particle-filters/

**Description of the problem**

An object has a certain trajectory X on the plane. The observer only has partial observations Y of this trajectory. From the observer point of view, we want to sample possible trajectories of the object.

* Description of the object trajectory *

The object trajectory is modeled as a (continuous) Markov chain. Initially, the object is in position $$(0,0)$$. At each step, the object selects a position at distance at most 1 from the current position and move on. This selection is uniform on the unit disc.

The first positions of the object are, for example, as follows:

![First trajectory of the object](outputs/trajectory_x.png) 

* Description of the observations *

The observer stands in position (0,0) and only see the angle of the object. Also, there is a little uncertainty of measurement for this angle (modeled with a Normal distribution with standard deviation of 0.1).

The first observations are plotted in the following graph:

![First observations](outputs/trajectory_xy.png) 

**Results**

*Sampling with SIS*

![Step 1 SIS](outputs/sis/step_1.png) 

![Step 2 SIS](outputs/sis/step_2.png) 

![Step 3 SIS](outputs/sis/step_3.png) 


*Sampling with SISR*

![Step 1 before resampling SISR](outputs/sisr/step_1_before.png) 

![Step 1 after resampling SISR ](outputs/sisr/step_1_after.png) 

![Step 2 before resampling SISR](outputs/sisr/step_2_before.png) 

![Step 2 after resampling SISR](outputs/sisr/step_2_after.png) 


*Comparison of sampled trajectories between SIS and SISR*

![Sampled trajectories SIS](outputs/sis/step_end.png) 

![Sampled trajectories SISR](outputs/sisr/step_end.png) 


*Comparison of weights between SIS and SISR*

![Weights of particles SIS](outputs/sis/hist_weights.png) 

![Weights of particles SISR](outputs/sisr/hist_weights.png) 

*Comparison of the trajectory for the best particle with SIS and SISR*

![Best trajectory SIS](outputs/sis/best_particle_traj.png) 

![Best trajectory SISR](outputs/sisr/best_particle_traj.png) 



