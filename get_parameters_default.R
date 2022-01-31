library(BayesianTools)

parameters = readRDS("./../EnvironmentDependentParameters/preliminary_run_parameter/parameter_list.rds")
chain_fagus = readRDS("./../EnvironmentDependentParameters/Results/calib_normal_fagus_cluster.rds")
chain_picea = readRDS("./../EnvironmentDependentParameters/Results/calib_normal_picea_cluster.rds")
chain_pinus = readRDS("./../EnvironmentDependentParameters/Results/calib_normal_pinus_cluster.rds")


pinus_parameters = parameters[[1]]
picea_parameters = parameters[[110]] 
fagus_parameters = parameters[[180]] 


sample_fagus = getSample(chain_fagus, whichParameters = 1:8, numSamples = 1e5, start = 1e3)
sample_fagus[,"alphaCx"] = plogis(sample_fagus[,"alphaCx"])
fitted_parameters_fagus = apply(FUN = mean, 2, X =sample_fagus)
for(i in 1:length(fitted_parameters_fagus)){
  fagus_parameters[which(fagus_parameters$parameter == names(fitted_parameters_fagus)[i]),2] = fitted_parameters_fagus[i] 
}
colnames(fagus_parameters) = c("parameter", "Fagus.sylvatica")

sample_pinus = getSample(chain_pinus, whichParameters = 1:8, numSamples = 1e5, start = 1e3)
sample_pinus[,"alphaCx"] = plogis(sample_pinus[,"alphaCx"])
fitted_parameters_pinus = apply(FUN = mean, 2, X =sample_pinus)
for(i in 1:length(fitted_parameters_pinus)){
  pinus_parameters[which(pinus_parameters$parameter == names(fitted_parameters_pinus)[i]),2] = fitted_parameters_pinus[i] 
}
colnames(pinus_parameters) = c("parameter", "Pinus.sylvestris")

sample_picea = getSample(chain_picea, whichParameters = 1:8, numSamples = 1e5, start = 1e3)
sample_picea[,"alphaCx"] = plogis(sample_picea[,"alphaCx"])
fitted_parameters_picea = apply(FUN = mean, 2, X =sample_picea)
for(i in 1:length(fitted_parameters_picea)){
  picea_parameters[which(picea_parameters$parameter == names(fitted_parameters_picea)[i]),2] = fitted_parameters_picea[i] 
}
colnames(picea_parameters) = c("parameter", "Picea.abies")

saveRDS(pinus_parameters, "Parameters/pinus_parameters.rds")
saveRDS(picea_parameters, "Parameters/picea_parameters.rds")
saveRDS(fagus_parameters, "Parameters/fagus_parameters.rds")