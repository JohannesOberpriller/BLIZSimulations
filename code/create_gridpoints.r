set.seed(42)
library(sf)
library(sp)
library(raster)
library(tidyverse)

Germany = st_as_sf(getData(country="Germany", level =1))
BY = Germany %>%  filter(NAME_1 == "Bayern") 
BY = BY %>% st_transform(5514) 
sizes = c(1000, 3000, 5000, 10000)
names(sizes) = c("1x1", "3x3", "5x5", "10x10")
for(i in 1:4) {
  sizes = c(1000, 3000, 5000, 10000)
  
  grid <- BY %>% 
    st_make_grid(cellsize = c(sizes[i], sizes[i]), square=TRUE, what = "centers")  %>% 
    st_intersection(BY) %>% 
    st_sf()
  saveRDS(sf::st_coordinates(st_transform(grid, "WGS84")), paste0("../gridpoints/grid_points_", sizes[i], "_.RDS"))
}