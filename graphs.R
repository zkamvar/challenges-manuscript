library("incidence")
library("projections")
library("distcrete")
library("epitrix")
library("earlyR")
library("outbreaks")

library("ggplot2")
library("svglite")
library("here")

yellow1 <- "#e8c271b2"
yellow2 <- "#968155ff"
blue1   <- "#8b96b4ff"
blue2   <- "#1d2027ff"

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
