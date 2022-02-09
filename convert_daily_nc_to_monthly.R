library(reader)


## This converts the daily LfU data to monthly values 

projections = list.files("Bavarian_Data/")[-1]
projection = projections[1]
scenario = "rcp26"
for(projection in projections){
  for(scenario in c("rcp26", "rcp85")){
  folder = paste0("Bavarian_Data/",projection)
  file_folder = paste0(folder,"/Daily/",scenario,"/")
  file_list = list.files(file_folder)
  target_folder = paste0(folder,"/Monthly/",scenario,"/")
  prec = file_list[1]
  tas = file_list[3]
  tasmax = file_list[4]
  tasmin = file_list[5]
  solrad = file_list[2]
  system(paste0("rm -r ",getwd(),"/",target_folder,"*"))
  system(paste0("cdo monmean ", getwd(),"/",file_folder,tas," ",target_folder,"tas.nc"))
  system(paste0("cdo monmean ", getwd(),"/",file_folder,tasmax," ",target_folder,"tasmax.nc"))
  system(paste0("cdo monmean ", getwd(),"/",file_folder,tasmin," ",target_folder,"tasmin.nc"))
  system(paste0("cdo monsum ", getwd(),"/",file_folder,prec," ",target_folder,"pr.nc"))
  # tasmin is given in K so we have to use the threshold of 273.15 
  system(paste0("cdo monsum -lec,273.15 ", getwd(),"/",file_folder,tasmin," ",target_folder,"frostdays.nc"))
  ## this is still in units of W need to convert this to MJ/d
  system(paste0("cdo monmean ", getwd(),"/",file_folder,solrad," ",target_folder,"solrad.nc"))
  }
}
