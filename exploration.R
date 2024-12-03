library(tidyverse)
library(viridis)
library(sf)
library(terra)
library(tidyterra)
library(spData)
library(gridExtra)
library(gstat)
library(sp)

# Census Tract
censustract.dat <- read_csv('Downloads/thesis/data/2020_Census_Tracts_20241110.csv')
census.sf <- st_as_sf(censustract.dat, wkt = "the_geom") %>%
  st_set_crs(4326) %>%
  st_transform(2263)
census.sf %>% ggplot() +
  geom_sf() +
  labs(title='All NYC Census Tracts') +
  theme_minimal()

# BUILT ENVIRONMENT -----------------------------------------------------------
# Cooling Sites
coolsites.dat <- read_csv('Downloads/thesis/data/Cool_It__NYC_2020_-_Cooling_Sites_20241024.csv', show_col_types=FALSE)
coolsites.sf <- st_as_sf(coolsites.dat, coords=c('x', 'y'), 
                    crs='EPSG:2263')

coolsite.bar <- coolsites.dat %>%
  ggplot(aes(x=FeatureType)) +
  geom_bar() +
  labs(x='\nFeature Type', y='Count\n', title='Bar Chart of Cooling Site Feature Type')

coolsites.sf %>% ggplot() +
  geom_sf() +
  labs(title='Cooling Sites in NYC') +
  theme_minimal()

    # SOMETHING WRONG??
census.sf %>% ggplot() + geom_sf() + geom_sf(data = coolsites.sf) + theme_bw() +
  labs(title = 'Cool Sites in NYC', y = 'Latitude \n', x = '\n Longitude')

# Drinking Fountains
drinkfountains.dat <- read_csv('Downloads/thesis/data/Cool_It__NYC_2020_-_Drinking_Fountains_20241024.csv', show_col_types=FALSE)
drinkfountains.sf <- st_as_sf(drinkfountains.dat, coords=c('x', 'y'), 
                         crs='EPSG:2263')

drink.bar <- drinkfountains.dat %>%
  ggplot(aes(x="DF Activated")) +
  geom_bar() +
  labs(x='\nStatus', y='Count\n', title='Bar Chart of Drinking Fountain Status')

drinkfountains.sf %>% ggplot() +
  geom_sf() +
  labs(title='Drinking Fountains in NYC') +
  theme_minimal()

census.sf %>% ggplot() + geom_sf() + geom_sf(data = drinkfountains.sf, size=0.75) + theme_bw() +
  labs(title = 'Drinking Fountains in NYC', y = 'Latitude \n', x = '\n Longitude')

# Spray Showers
spray.dat <- read_csv('Downloads/thesis/data/Cool_It__NYC_2020_-_Spray_Showers_20241024.csv', show_col_types=FALSE)
spray.sf <- st_as_sf(spray.dat, coords=c('x', 'y'), 
                              crs='EPSG:2263')

spray.bar <- spray.dat %>%
  ggplot(aes(x=Status)) +
  geom_bar() +
  labs(x='\nStatus', y='Count\n', title='Bar Chart of Spray Shower Status')

spray.sf %>% ggplot() +
  geom_sf() +
  labs(title='Spray Showers in NYC') +
  theme_minimal()

census.sf %>% ggplot() + geom_sf() + geom_sf(data = spray.sf, size=0.75) + theme_bw() +
  labs(title = 'Spray Showers in NYC', y = 'Latitude \n', x = '\n Longitude')

# GREEN SPACE ------------------------------------------------------------------
# Vegetation Raster
path.green <- 'Downloads/thesis/data/Land_Cover/NYC_2017_LiDAR_LandCover.img'
green.raster <- rast(path.green)

# Transform data to sf object
green.sf <- st_as_sf(as.data.frame(green.raster, xy = TRUE), 
                   coords = c('x', 'y'))

# Plot
green.sf %>% ggplot() + geom_sf() +
  geom_raster(data = as.data.frame(green.raster, xy = TRUE), aes(x = x, y = y, fill = elevation)) + 
  scale_fill_terrain_c(direction=1) +theme_bw() +
  labs(title = 'Land Cover (New York City) \n', y = 'Latitude \n', x='\n Longitude')

# BLUE SPACE -------------------------------------------------------------------
# Water Occurrence
path.water <- 'Downloads/thesis/data/occurrence_80W_40Nv1_4_2021.tif'
water.raster <- rast(path.water)

# Transform data to sf object
lux.sf <- st_as_sf(as.data.frame(water.raster, xy = TRUE), 
                   coords = c('x', 'y')) # Error: vector memory limit of 16.0 Gb reached, see mem.maxVSize()

# Plot
lux.sf %>% ggplot() + geom_sf() +
  geom_raster(data = as.data.frame(lux.raster, xy = TRUE), aes(x = x, y = y, fill = elevation)) + 
  scale_fill_terrain_c(direction=1) +theme_bw() +
  labs(title = 'Luxembourg Elevation \n', y = 'Latitude \n', x='\n Longitude')
