library(rgbif)
library(r3PG)
library(Predictors)
library(sp)
library(raster)
library(dplyr)
library(sf)
library(rgdal)

sites = readRDS("Environment/General/Env_data.rds")

simulation_sites = as.data.frame(sites$simulation_sites)
colnames(simulation_sites) = c("lat","lon")
longitude_coordintaes = sites$avail_long 
latitudinal_coordinates = sites$avail_lat

elevations = rgbif::elevation(latitude = simulation_sites$lat,
                 longitude = simulation_sites$lon, 
                 elevation_model = "gtopo30",
                 username = "johannesoberpriller")


for(i in 1:nrow(simulation_sites)){
    monthly_values = paste0("0000-00-00")
    monthly_values = as.data.frame(cbind(monthly_values, i))
    colnames(monthly_values) = c("time_predictors","selected_clusters")
    coordinates = matrix(rep(as.numeric(simulation_sites[i,c(2,1)]), nrow(monthly_values)),ncol =2, byrow = T)
    new_thing = SpatialPointsDataFrame(coordinates, monthly_values)
    if(exists("spatial_R")){
      spatial_R = raster::union(spatial_R,new_thing)
    }
    else{
      spatial_R = new_thing
    }
  }

spatial_R@proj4string = CRS('+proj=longlat +datum=WGS84')
rownames(spatial_R@coords) = NULL

fc_data <- getPredictors(vars = "fc5_esdach", points = spatial_R, dir = "./../bigdata/Predictors")

wp_data <- getPredictors(vars = "wp5_esdach", points = spatial_R, dir = "./../bigdata/Predictors")

asw_max = (fc_data@data[,'fc5_esdach']-wp_data@data[,'wp5_esdach'])*1000
asw_max[which(is.na(asw_max))] = mean(asw_max, na.rm = T)

soil_class = getPredictors(vars = "textUSDA_esdact", points = spatial_R, dir = "./../bigdata/Predictors")

look_up_text_conversion = cbind(seq(1,12,1),
                                c(1,1,2,2,2,3,3,3,4,4,4,4))

colnames(look_up_text_conversion) = c("USDA_class","r3PG_class")


soil_classes_remaped = vector(length = length(soil_class@data$textUSDA_esdact))
for(i in 1:length(soil_class@data$textUSDA_esdact)){
  soil_classes_remaped[i] = look_up_text_conversion[soil_class@data$textUSDA_esdact[i],2]
}

time_intervals = c("2000","2050","2100")

for(time_interval in time_intervals){
  site_list = list()
  latitude = simulation_sites$lat
  altitude = elevations$elevation_geonames
  asw_min = 0
  asw_i = as.numeric(asw_max)/2
  if(time_interval == "2000"){
    from = "1951-01"
    to = "2000-12"
  }
  else if(time_interval == "2050"){
    from = "2001-01"
    to = "2050-12"
  }
  else{
    from = "2051-01"
    to = "2100-12"
  }
  for(i in 1:nrow(simulation_sites)){
   site_table = data.frame(as.numeric(latitude[i]), as.numeric(altitude[i]),
                            as.numeric(soil_classes_remaped[i]), as.numeric(asw_i[i]),
                            as.numeric(asw_min), as.numeric(asw_max[i]), from, to)
    colnames(site_table) = c("latitude","altitude", "soil_class","asw_i", "asw_min", "asw_max", "from", "to")
    site_list[[i]] = site_table
  }
  saveRDS(site_list,paste0("sitedata/",time_interval,"/site_data.rds"))
}





