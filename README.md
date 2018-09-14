# Challenges and opportunities in outbreak response analysis

This repository contains the source code for the figures presented
in this manuscript by Jombart et al.


# Color Palette

The color palette I have landed on is [a four-color palette from Paletton](http://paletton.com/#uid=72W0S0kdPiS8cz9gnt9957fjh8+) 
that's not too disgusting to look at. It's located in the [palette.gpl](palette.gpl) 
file. To use this in inkscape, you can do the following:

```sh
cp palette.gpl ~/.config/inkscape/palettes/challenges.gpl
```

Then you can select the palette in the lower right-hand corner of inkscape. The
one that says `challenges #Color palette by Paletton.com #72W0S0kdPiS8cz9gnt9957fjh8+Columns: 4`

The font family we are using is [Sawasdee]()https://fontinfo.opensuse.org/families/Sawasdee.html), 
which happens to be the font for the RECON logo. 

# Components to work on

We have decided on a model where we are creating a directed graph with inputs
and outputs being represented as hexagons and processes having associated
graphics. The outputs will have undirected nodes with comments on what they are
useful for estimating. Some of these will be obvious.

### Linear Models

 - Inputs: Linelist
 - Outputs: R, growth rate

### Graphs

 - Inputs: Linelist && Contacts

### Delay Distribution fitting

 - Inputs: Contacts

### Compartmental Models

 - Inputs: Linelist && Contacts

### R estimation (Likelihood/Bayesian)

 - Inputs: Linelist || Contacts

### Branching Processes (projections)

 - Inputs: Linelist

### Phylogenies

 - Inputs: Sequence Data (WGS)

### Clustering

 - Inputs: Sequence Data (WGS)

### Transmission Tree Reconstruction

 - Inputs; Linelist && Contacts && Sequence Data (WGS)
