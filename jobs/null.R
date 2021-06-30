rstan::rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
t <- Sys.time()
load("../data/SDs_reduced.rda")
load("../data/form_null.rda")
load("../data/priors_null.rda")

# Modelling --------------------------------------------------------------------

m_null <- brms::brm(form_null,
                    data = SDs_reduced,
                    prior = priors_null,
                    # iter = 20000,
                    # warmup = 2000,
                    control = list(adapt_delta = 0.8))

# Loo-ing --------------------------------------------------------------------

m_null <- brms::add_criterion(m_null,
                              "loo",
                              reloo = TRUE)

# Saving --------------------------------------------------------------------

usethis::use_data(m_null,
                  overwrite = TRUE)

print(Sys.time() - t)
