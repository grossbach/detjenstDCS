rstan::rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
t <- Sys.time()
load("../data/SDs_reduced.rda")
load("../data/form_Day__1_ID.rda")
load("../data/priors_Day__1_ID.rda")

# Modelling --------------------------------------------------------------------

m_Day__1_ID <- brms::brm(form_Day__1_ID,
                         data = SDs_reduced,
                         prior = priors_Day__1_ID,
                         sample_prior = "yes",
                         inits = 0,
                         control = list(adapt_delta = 0.8))

# Loo-ing --------------------------------------------------------------------

m_Day__1_ID <- brms::add_criterion(m_Day__1_ID,
                                   "loo",
                                   reloo = TRUE)

# Saving --------------------------------------------------------------------

usethis::use_data(m_Day__1_ID,
                  overwrite = TRUE)

print(Sys.time() - t)
