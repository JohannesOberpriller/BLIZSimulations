library(BayesianTools)

size_dist = readRDS("./../EnvironmentDependentParameters/preliminary_run_parameter/sizedist_list.rds")

pinus_size_dist = size_dist[[1]]
picea_size_dist = size_dist[[110]] 
fagus_size_dist = size_dist[[180]] 

colnames(pinus_size_dist) = c("parameter", "Pinus.sylvestris")
colnames(picea_size_dist) = c("parameter", "Picea.abies")
colnames(fagus_size_dist) = c("parameter", "Fagus.sylvatica")

saveRDS(pinus_size_dist, "sizedist/pinus_size_dist.rds")
saveRDS(picea_size_dist, "sizedist/picea_size_dist.rds")
saveRDS(fagus_size_dist, "sizedist/fagus_size_dist.rds")

