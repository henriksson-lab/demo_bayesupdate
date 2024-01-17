data {
  int<lower=0> N;
  vector[N] y;
}

parameters {
  real mu;
  real sigma;
} 

model {
# maybe overcomplicating it
# but it is possible to store a compiled model!
#  mu ~ normal()
  y ~ normal(mu, sigma);
}  