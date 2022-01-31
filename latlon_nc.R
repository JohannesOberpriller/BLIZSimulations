library(ncdf4)

precip_nc = ncdf4::nc_open("Bavarian_Data/ECEARTH-RACMO/Monthly/rcp26/pr.nc")

get_lat_lon = function(values,lat,lon){
  
  values_slice = values[,,1]
  lat_lon = matrix(ncol= 2, nrow = 2867)
  k =1 
  for(i in 1:ncol(values_slice)){
    for(j in 1:nrow(values_slice)){
      if(!is.na(values_slice[j,i])){
        lat_lon[k,] = c(lat[i],lon[j])
        k = k +1
      }
    }
  }
  return(lat_lon)
}


# calculating the sum over the time

precip <- ncvar_get(precip_nc, "pr")
lat = ncvar_get(precip_nc, "lat")
lon = ncvar_get(precip_nc, "lon")

lat_lon = get_lat_lon(precip, lat,lon)

sites_data = list("simulation_sites" = lat_lon, 
                "avail_lat" = lat, 
                "avail_long" = lon)

saveRDS(sites_data,"Environment/General/Env_data.rds")

