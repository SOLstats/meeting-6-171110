# Globe tossing example

# You want to know what proportion of the surface of the earth is water, and which proportion is land.
# You take a globe, the size of your hand, and toss it up in the air.
# When you catch the globe, you see what you have under your index finger: water (W) or land (L).

# After nine tosses, the data look like this:

globe=c("W","L","W","W","W","L","W","L","W") # six "W" and three "L".

# Based on these data, what are likely values of the proportion water (p)?

# Initially, p can take any value between 0 and 1.
# An estimate of this proportion is called the posterior distribution. 
# It is called posterior, because the estimate is conditional on the observations. p(water|observations).

# The way this is calculated follows Bayes' rule, that the conditional probability p(y|x) can be 
# deduced from the probability p(x|y) by the rule

#             p(x|y) * p(y)
# p(y|x) = -------------------
#                 p(x)

# The three elements on the righthand side of this equation are:
# 
# p(x|y): the likelihood of the data given different values of p.
# How likely is it to get six "W" and three "L" if the probability of "W" is 0.1, 0.2, 0.6, etc. 

# p(y): What are a priori likely or unlikely values of p? This is called the prior.

# The first two elements are the most important elements of the equation: Posterior is likelihood times prior.
# The third element p(x) is a factor that is used to ensure that the values of the posterior distribution 
# or the surface under the posterior distribution sums up to 1, making it a probability distribution.

# A relatively simple approach to the problem is to use grid approximation.
# This approach implies that instead of taking all values of p (infinitely many between zero and one)
# a finite number is taken:

p_grid = seq(0,1,length.out=100) # 100 values from 0 to 1.

# For each of these values the likelihood is determined, that the value produced the data.
# There are six out of nine "W" observations. This, for instance, makes it unlikely that p has a value
# close to zero. Also the values zero and 1 are excluded since both possiblities occur in the data.

# The likelihood for each of the 100 values of p is determined by the binomial distribution.
# This distribution tells you how likely an outcome is, given a certain value of a probability.
# For instance, how likely is to get nine heads out of ten tosses, assuming that the probability of 
# heads is 0.5?

dbinom(x=9,size=10,p=0.5) # Less than one percent.

# For the globe tossing experiment, these probabilities are calculated for every possible value of p:

likelihood=dbinom(6,size=9,prob=p_grid)
plot(p_grid, likelihood,pch=19,cex=0.5) 
abline(v=6/9) # The top of the curve is at 6/9 = 0.6667.

# The prior can be of different shapes.
# All values of p may be equally likely (uniform prior).
# prior=rep(1,100) # uniform prior
# prior=ifelse(p_grid<0.5,0,1) # second prior
prior=exp(-5*abs(p_grid-0.5)) # peaked prior

plot(p_grid,prior,pch=19,cex=0.5)

# The posterior is then calculated by multiplying the prior with the likelihood:

posterior = likelihood * prior
posterior=posterior/sum(posterior) # standardize so that the sum equals 1.
plot(p_grid,posterior,pch=19,cex=0.5)

# Once the posterior distribution is in place, you can start asking questions about it.
# These questions relate to point estimates (what is the mean) or interval estimates.

# One way of giving answers to such questions is to draw repeated samples from 
# the grid, relative to the posterior plausability of each value.

samples=sample(p_grid,size=1e5,replace=TRUE,prob=posterior) # 
mean(samples) # The mean
quantile(samples,c(0.1,0.9)) # 80% percentile interval

# What is the probability that the proportion of water is smaller than 0.5?
sum(posterior[p_grid<.5])

# How likely is it that the proportion of water is less than 0.5?
sum(posterior[p_grid<.5]) # 17%
