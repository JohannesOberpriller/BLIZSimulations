# library(r3PG)
# 
library(ncdf4)


time_intervals = c("2000","2050","2100")
sites = readRDS("Environment/General/Env_data.rds")



simulation_sites = sites$simulation_sites
longitude_coordintaes = sites$avail_long 
latitudinal_coordinates = sites$avail_lat

projections = list.files("Bavarian_Data/")[-1]

for(projection in projections){
  print(projection)
  for(scenario in c("rcp26", "rcp85")){
    print(scenario)
    folder = paste0("Bavarian_Data/",projection)
    target_folder = paste0(folder,"/Monthly/",scenario,"/")
    precip_nc = ncdf4::nc_open(paste0(target_folder,"pr.nc"))
    precip <- ncvar_get(precip_nc, "pr") 
    frostdays_nc = ncdf4::nc_open(paste0(target_folder,"frostdays.nc"))
    frostdays <- ncvar_get(frostdays_nc, "tasmin") 
    tasmin_nc = ncdf4::nc_open(paste0(target_folder,"tasmin.nc"))
    tasmin <- ncvar_get(tasmin_nc, "tasmin") 
    tasmax_nc = ncdf4::nc_open(paste0(target_folder,"tasmax.nc"))
    tasmax <- ncvar_get(tasmax_nc, "tasmax") 
    for(time_interval in time_intervals){
      climate = list()
      for(site in 1:nrow(simulation_sites)){
        lat_index = which(latitudinal_coordinates == simulation_sites[site,1])
        lon_index = which(longitude_coordintaes == simulation_sites[site,2])
        if(time_interval == "2000"){
          timepoints = 1:(12*50)
          years = rep(1951:2000,each = 12)
          months = rep(1:12, 50)
        }
        else if(time_interval == "2050"){
          timepoints = 1:(12*50) + 600
          years = rep(2001:2050,each = 12)
          months = rep(1:12, 50)
        }
        else{
          timepoints = 1:(12*50) + 1200
          years = rep(2051:2100,each = 12)
          months = rep(1:12, 50)
        }
        climate_site = matrix(nrow = 600, ncol = 5)
        colnames(climate_site) = c("year","month","tmp_min","tmp_max","prcp","srad","frost_days")
        
        climate_site[,"year"] = years
        cliamte_site[,"month"] = months
        climate_site[,"tmp_min"] = tasmin[lon_index,lat_index, timepoints]-273.15
        climate_site[,"tmp_max"] = tasmax[lon_index,lat_index, timepoints]-273.15
        climate_site[,"prcp"] = precip[lon_index,lat_index, timepoints]
        #climate_site[,"srad"] = tasmin[lon_index,lat_index, timepoints]
        climate_site[,"frost_days"] = frostdays[lon_index,lat_index, timepoints]
        climate[[site]] = climate_site
      }
      saveRDS(climate,paste0("Environment/",projection,"/",scenario,"/",time_interval,"/climatedata.rds"))
    }
    nc_close(precip_nc)
    nc_close(frostdays_nc)
    nc_close(tasmin_nc)
    nc_close(tasmax_nc)
  }
}
