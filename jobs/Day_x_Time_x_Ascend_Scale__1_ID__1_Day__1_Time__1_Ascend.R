rstan::rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
t <- Sys.time()
load("../data/SDs_reduced.rda")
load("../data/form_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time__1_Ascend.rda")
load("../data/priors_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time__1_Ascend.rda")

# Modelling --------------------------------------------------------------------

m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time__1_Ascend <- brms::brm(form_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time__1_Ascend,
                                                                        data = SDs_reduced,
                                                                        prior = priors_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time__1_Ascend,
                                                                        sample_prior = "yes",
                                                                        inits = 0,
                                                                        control = list(adapt_delta = 0.9))

# Loo-ing --------------------------------------------------------------------

m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time__1_Ascend <- brms::add_criterion(m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time__1_Ascend,
                                                                                  "loo",
                                                                                  reloo = TRUE)

# Saving --------------------------------------------------------------------

usethis::use_data(m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day__1_Time__1_Ascend,
                  overwrite = TRUE)

print(Sys.time() - t)
