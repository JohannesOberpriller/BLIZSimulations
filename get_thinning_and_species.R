thinning = readRDS("InputData/thinning.RDS")

thinning_fagus = thinning[which(thinning$species == "Fagus sylvatica"),]
thinning_fagus$species = "Fagus.sylvatica"

thinning_picea = thinning[which(thinning$species == "Picea abies"),]
thinning_picea$species = "Picea.abies"
thinning_picea = thinning_picea[-1,]


thinning_pinus = thinning[which(thinning$species == "Pinus sylvestris"),]
thinning_pinus$species = "Pinus.sylvestris"

saveRDS(thinning_fagus, "thinning/thinning_fagus.rds")
saveRDS(thinning_picea, "thinning/thinning_picea.rds")
saveRDS(thinning_pinus, "thinning/thinning_pinus.rds")

species = readRDS("InputData/species_initial.RDS")

species_fagus_2000 = species[1,]
species_fagus_2000$species = "Fagus.sylvatica"
species_fagus_2000$planted = "1949-01"

species_fagus_2050 = species[1,]
species_fagus_2050$species = "Fagus.sylvatica"
species_fagus_2050$planted = "1999-01"

species_fagus_2100 = species[1,]
species_fagus_2100$species = "Fagus.sylvatica"
species_fagus_2100$planted = "2049-01"

saveRDS(species_fagus_2000, "species/2000/species_fagus.rds")
saveRDS(species_fagus_2050, "species/2050/species_fagus.rds")
saveRDS(species_fagus_2100, "species/2100/species_fagus.rds")


species_pinus_2000 = species[3,]
species_pinus_2000$species = "Pinus.sylvestris"
species_pinus_2000$planted = "1949-01"

species_pinus_2050 = species[3,]
species_pinus_2050$species = "Pinus.sylvestris"
species_pinus_2050$planted = "1999-01"

species_pinus_2100 = species[3,]
species_pinus_2100$species = "Pinus.sylvestris"
species_pinus_2100$planted = "2049-01"

saveRDS(species_pinus_2000, "species/2000/species_pinus.rds")
saveRDS(species_pinus_2050, "species/2050/species_pinus.rds")
saveRDS(species_pinus_2100, "species/2100/species_pinus.rds")

species_picea_2000 = species[2,]
species_picea_2000$species = "Picea.abies"
species_picea_2000$planted = "1949-01"

species_picea_2050 = species[2,]
species_picea_2050$species = "Picea.abies"
species_picea_2050$planted = "1999-01"

species_picea_2100 = species[2,]
species_picea_2100$species = "Picea.abies"
species_picea_2100$planted = "2049-01"

saveRDS(species_picea_2000, "species/2000/species_picea.rds")
saveRDS(species_picea_2050, "species/2050/species_picea.rds")
saveRDS(species_picea_2100, "species/2100/species_picea.rds")

