
d2 <- nested_dat$data[[2]] %>% mutate(SID = 10497) %>%
  mutate_at(vars(emo_value), lst(mean = mean), na.rm = T)
d2 <- as.data.frame(d2) 

model_3_trial <- ctModel(
  type = "stanct"
  , manifestNames = c("emo_value")
  , latentNames   = c("E")
  , LAMBDA        = matrix(c(1), nrow = 1, byrow = T)
  , DRIFT         = matrix(c("beta_E + beta_e3 * ergoal_value"), nrow = 1, byrow = T)
  , CINT          = matrix(c("mu_E"), nrow = 1, byrow = T)
  , MANIFESTMEANS = matrix(c(0), nrow = 1)
  , MANIFESTVAR   = matrix(c(0), nrow = 1)
  , T0MEANS       = matrix(c(3))
  , DIFFUSION     = matrix(c("sigma_E"), nrow = 1, byrow = T)
  , TDpredNames = c("ergoal_value")
  , TDPREDEFFECT = matrix(c("beta_ER"))
  # , n.TDpred  = 2
  , id            = "SID"
  , time          = "time"
  , PARS = c("beta_E", "beta_e3")
  # , Tpoints       = tp
)
ctModelLatex(model_3_trial)

model_3_trial$pars$indvarying <- FALSE

fit_mod <- ctStanFit(
  data = d2
  , model_3_trial
)

ctModelLatex(fit_mod)

summary(fit_mod)$popmeans


data<-d2

 
  # Posterior Coefficient Data Frame
  
  pars <- data.frame(fit_mod$stanfit$transformedpars$popmeans) %>%
    sample_n(500) %>%
    set_names(c("sigma_E", "mu_E", "beta_ER", "beta_E", "beta_e3")) %>%
    select(-sigma_E) %>%
    select(beta_E, beta_ER, beta_e3, mu_E)
 
  # Predictor Data Frame
  
  obs_data <- crossing(
    emo = seq(0,1,1)
    , er_goal = c(-5, -2.5, 0, 2.5, 5)
  ) %>%
    mutate(
      inter_emo_erg = emo*er_goal,
      intercept = 1
    )
  
  n_obs <- length(obs_data$emo)
  
  # Changes Prediction
  
  dt_pred <- data.frame( as.matrix(pars) %*% as.matrix(t(obs_data)) ) 
  
  dt_pred <- dt_pred %>%
    median_qi() %>%
    select(-.width, -.point, -.interval) %>%
    pivot_longer(
      cols = everything(),
      values_to = "change",
      names_to = c("qi")
    )
  
  simslope_data <- data.frame(
    "dt" = dt_pred$change
    , "qi" = rep(c("M", "lower", "upper"), times = n_obs)
    , "emo_value" = rep(obs_data$emo, each = 3)
    , "er_goal" = rep(obs_data$er_goal, each = 3)
  ) %>%
    pivot_wider(
      names_from = "qi"
      , values_from = "dt"
    )%>%
    pivot_wider(names_from=c("emo_value"),values_from=c("M","lower","upper"))%>%
    mutate(emo_slope = M_1-M_0)

  

  
  

  
  
  

