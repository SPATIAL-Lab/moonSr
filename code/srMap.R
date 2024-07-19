library(terra)

geo = vect("Shapefiles/GeoUnits.shp")

crs(geo)
names(geo)

ages = data.frame("unit" = unique(geo$FIRST_Un_1), 
                  "age" = c(2.0, 3.5, 3.9, 4.2, 0.5, 3.7, 3))
units = data.frame("unit" = unique(geo$FIRST_Unit),
                   "source" = c("p", "p", "l", "m", "l", "l", "l", "p", "l",
                                "l", "l", "p", "p", "l", "l", "m", "p", "p",
                                "l", "l", "l", "l", "m", "l", "l", "p", "l",
                                "l", "l", "l", "l", "l", "l", "l", "p", "l",
                                "l", "m", "l", "l", "l", "l", "l", "l", "p",
                                "p", "l", "l", "l"))

lambda = log(2) / 49.23

i_8786_l = 0.6994
rbsr_l = 0.0078

i_8786_m = 0.69944
rbsr_m = 0.0937

i_8786_p = 0.7
rbsr_p = 1

geo = merge(geo, ages, by.x = "FIRST_Un_1", by.y = "unit")
geo = merge(geo, units, by.x = "FIRST_Unit", by.y = "unit")

geo$Sr_8786 = numeric()
geo$Sr_8786[geo$source == "l"] = i_8786_l + 
  rbsr_l * (exp(lambda *  geo$age[geo$source == "l"]) - 1)
geo$Sr_8786[geo$source == "m"] = i_8786_m + 
  rbsr_m * (exp(lambda *  geo$age[geo$source == "m"]) - 1)
geo$Sr_8786[geo$source == "p"] = (1 * (i_8786_p + 
  rbsr_p * (exp(lambda *  4.7) - 1)) + 2 * (i_8786_l + 
  rbsr_l * (exp(lambda *  geo$age[geo$source == "p"]) - 1))) / 3

moonSr = rast(geo, resolution = 1e4)
moonSr = rasterize(geo, moonSr, "Sr_8786")

png("out/moonSr.png", width = 9, height = 5, units = "in", res = 600)
plot(moonSr, mar = c(1, 1, 1, 6))
mtext(expression(""^{87}*"Sr/"^{86}*"Sr bioavailable"), 4, line = 0.5)
dev.off()

writeRaster(moonSr, "out/moonSr.tif", overwrite = TRUE)
