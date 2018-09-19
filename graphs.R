library("incidence")
library("projections")
library("distcrete")
library("epitrix")
library("earlyR")
library("outbreaks")
library("ape")
library("pegas")

library("ggplot2")
library("svglite")
library("here")

yellow1 <- "#e8c271b2"
yellow2 <- "#968155ff"
blue1   <- "#8b96b4ff"
blue2   <- "#1d2027ff"
PALETTE <- list(color_1 = c("#90C1A1", "#53AA71", "#3F6E4F", "#1E2A22", "#153420"), 
                color_2 = c("#8B96B4", "#55689C", "#3E4965", "#1D2027", "#161D30"), 
                color_3 = c("#FFEABE", "#E8C271", "#968155", "#3A3429", "#483A1C"), 
                color_4 = c("#FFC8BE", "#E88471", "#965F55", "#3A2C29", "#48231C")
               )


# Incidence fit chart ---------------------------------------------------------
e   <- ebola_sim$linelist$date_of_onset
i7  <- incidence(e, interval = "week")
fi7 <- fit(i7[1:25])
p   <- plot(i7[1:25], color = yellow1, border = yellow2, labels_iso = FALSE, fit = fi7)
ggsave(p + theme_void(), file = here("charts", "incidence-fit.svg"), width = 2, height = 1)

# serial interval distribution ------------------------------------------------
mu <- 15.3
sigma <- 9.3
cv <- sigma / mu
params <- gamma_mucv2shapescale(mu, cv)
params
si <- distcrete("gamma", shape = params$shape,
                scale = params$scale,
                interval = 1, w = 0)
si
{
p <- ggplot(data.frame(x = 1:50, y = si$d(1:50)), 
	    mapping = aes(x = x, y = y)) + 
            geom_col(fill = blue1, 
		     color = blue2,
		     width = 0.5,
		     size = 0.5) 
}
ggsave(p + theme_void(), file = here("charts", "serial-interval.svg"), 
       width = 4, height = 2)
# projections -----------------------------------------------------------------
set.seed(1)
i    <- incidence(e)
pred <- project(i[1:100], R = 1.5, si = si, n_days = 50, n_sim = 1000)
library(magrittr)
p <- plot(i[1:120], color = blue1, border = blue2) %>% 
	add_projections(pred, ribbon_color = yellow1, quantiles = 0.95, ribbon_alpha = 0.65) + 
	scale_color_manual(values = c(yellow2, yellow2)) +
	theme(legend.position = "none")
ggsave(p + theme_void(), file = here("charts", "predictions.svg"),
       width = 4, height = 2)

# trees -----------------------------------------------------------------------
set.seed(9)
the_tree <- ladderize(rtree(10))
svglite::svglite(file = here("charts", "tree.svg"), 
                 width = 4, height = 3)
plot.phylo(the_tree, show.tip.label = FALSE, edge.width = 3)
dev.off()

# network ---------------------------------------------------------------------
data(woodmouse)
set.seed(9)
x <- woodmouse[sample(15, size = 110, replace = TRUE), ]
h <- haplotype(x)
net <- haploNet(h)
attr(net, "freq")[c(1, 4, 5)] <- c(6, 25, 15)/1.5
svglite::svglite(file = here("charts", "network.svg"),
                 width = 4, height = 4)
plot(net,
     bg = PALETTE$color_4[1:3], 
     col.link = grey(runif(15, max = 0.5)),
     lwd = 3,
     labels = FALSE,
     show.mutation = FALSE,
     size = attr(net, "freq"))
dev.off()

# R0 estimation ---------------------------------------------------------------
svglite::svglite(file = here("charts", "R0.svg"),
                 width = 3, height = 3)
x <- seq(0, 5, length.out = 1000)
dg <- dgamma(x, shape = 1.5)
my <- max(dg)
mx <- x[which.max(dg)]
plot(x,
     dg,
     type = "l",
     xlim = c(0, 5),
     ylim = c(0, 0.5),
     main = "",
     xlab = "",
     ylab = "",
     lwd  = 3,
     col  = PALETTE$color_2[3])
polygon(c(x, 5.001), c(dg, 0), col = PALETTE$color_2[1])
abline(h = my, lty = 2, col = PALETTE$color_4[2], lwd = 3)
points(mx, my, col = PALETTE$color_4[2], pch = 19)
dev.off()
