rstan::rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
t <- Sys.time()
load("../data/SDs_reduced.rda")
load("../data/form_Day_x_Time_x_Ascend_Scale__1_ID__1_Day.rda")
load("../data/priors_Day_x_Time_x_Ascend_Scale__1_ID__1_Day.rda")

# Modelling --------------------------------------------------------------------

m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day <- brms::brm(form_Day_x_Time_x_Ascend_Scale__1_ID__1_Day,
                                                      data = SDs_reduced,
                                                      prior = priors_Day_x_Time_x_Ascend_Scale__1_ID__1_Day,
                                                      # iter = 10000,
                                                      # warmup = 2000,
                                                      control = list(adapt_delta = 0.8))

# Loo-ing --------------------------------------------------------------------

m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day <- brms::add_criterion(m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day,
                                                                "loo",
                                                                reloo = TRUE)

# Saving --------------------------------------------------------------------

usethis::use_data(m_Day_x_Time_x_Ascend_Scale__1_ID__1_Day,
                  overwrite = TRUE)

print(Sys.time() - t)
