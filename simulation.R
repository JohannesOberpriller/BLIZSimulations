library(r3PG)


sites = readRDS("Environment/General/Env_data.rds")
simulation_sites = sites$simulation_sites


simulate_3pg = function(site_number, parameters){
  

  input = prepare_input(site = site[[site_number]], 
                        species = species,
                        climate = climate[[site_number]],
                        thinning = thinning,size_dist = size_dist,
                        parameters = parameters)

  settings = list(light_model = 1, transp_model = 1, phys_model = 1, 
                    height_model = 2, correct_bias = 0, calculate_d13c = 0)


  
  out_3pg = run_3PG(site = input$site,
                    species = input$species,
                    climate = input$climate,
                    thinning = input$thinning,
                    size_dist = input$size_dist,
                    parameters = input$parameters,
                    settings = settings,
                    check_input = F, df_out = T)

  
  simulated = out_3pg[out_3pg$variable == "biom_stem","value"]
  simulated = simulated[length(simulated)]
  
  return(simulated)
}

potential_species = c("fagus","picea","pinus")
climate_models = c("ECEARTH-RACMO","MIROC-CLM","MPI-WETTREG","MPI-CLM","ECEARTH-CLM")
time_simulations = c("2000","2050","2100")
scenarios = c("rcp26","rcp85")

for(actual_species in potential_species){
  parameters = readRDS(paste0("Parameters/",actual_species,"_parameters.rds"))
  thinning = readRDS(paste0("thinning/thinning_",actual_species,".rds"))
  size_dist = readRDS(paste0("sizedist/",actual_species,"_size_dist.rds"))
  for(time_simulation in time_simulations){
    site = readRDS(paste0("sitedata/",time_simulation,"/site_data.rds"))
    species = readRDS(paste0("species/",time_simulation,"/species_",actual_species,".rds"))
    for(climate_model in climate_models){
      for(scenario in scenarios){
        climate = readRDS(paste0("Environment/",climate_model,"/",scenario,"/",time_simulation,"/climatedata.rds"))
        sim.df <- sapply(X = 1:nrow(simulation_sites),FUN =simulate_3pg, parameters= parameters)
        saveRDS(sim.df, paste0("Results/",climate_model,"/",scenario,"/",time_simulation,"/",actual_species,"_results.rds"))
      }
    }
  }
}


