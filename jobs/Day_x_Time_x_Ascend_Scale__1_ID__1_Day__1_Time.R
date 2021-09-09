rstan::rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
t <- Sys.time()
load("../data/SDs_reduced.rda")
load("../data/form_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time.rda")
load("../data/priors_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time.rda")

# Modelling --------------------------------------------------------------------

m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time <- brms::brm(form_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time,
                                                              data = SDs_reduced,
                                                              prior = priors_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time,
                                                              sample_prior = "yes",
                                                              inits = 0,
                                                              control = list(adapt_delta = 0.9))

# Loo-ing --------------------------------------------------------------------

m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time <- brms::add_criterion(m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time,
                                                                        "loo",
                                                                        reloo = TRUE)

# Saving --------------------------------------------------------------------

usethis::use_data(m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time,
                  overwrite = TRUE)

print(Sys.time() - t)
