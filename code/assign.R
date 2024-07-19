library(assignR)

moonSr = rast("out/moonSr.tif")
moonSr.sd = moonSr
values(moonSr.sd) = rep(0.005)
moonSr = c(moonSr, moonSr.sd)

mam = data.frame("ID" = "Dead mammoth", "Sr_8786" = 0.7149)

post = pdRaster(moonSr, mam)

png("out/mast.png", width = 9, height = 5, units = "in", res = 600)
options(scipen = -999)
plot(post * 1e6, mar = c(1, 1, 1, 5))
mtext("Posterior probability (* 1e6)", 4, line = 0.5)
dev.off()
