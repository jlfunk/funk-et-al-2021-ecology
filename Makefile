# -- MODELS

.PHONY: multilevel-fits
multilevel-fits: fit-multilevel.R
	parallel -j3 Rscript ./fit-multilevel.R {} ::: 1 2 3 4 5 6 7 8 9 10 11 12

.PHONY: anova-fits
anova-fits: fit-anova.R
	parallel -j3 Rscript ./fit-anova.R {} ::: 1 2 3 4 5 6 7 8 9 10 11 12

.PHONY: ppc
ppc:
	parallel Rscript ./posterior-predictive-checks.R {} ::: 1 2 3 4 5 6 7 8 9 10 11 12


# -- FIGURES

.PHONY: figures
figures: \
	results/figure-variance-partitioning.pdf \
	results/figure-anova-trait-effects.pdf \
	results/figure-posterior-intervals-for-key-traits.pdf \
	results/figure-posterior-intervals-for-alt-traits.pdf

results/figure-variance-partitioning.pdf: generate_variance_partitioning_figure.R
	Rscript $^

results/figure-anova-trait-effects.pdf: generate_anova_trait_effects_figure.R
	Rscript $^

results/figure-posterior-intervals-for-key-traits.pdf results/figure-posterior-intervals-for-alt-traits.pdf: generate_key_traits_posterior_intervals_figure.R
	Rscript $^


# -- PDF -> TIFF conversion

.PHONY: tiffs
tiffs: results/figure-posterior-intervals-for-key-traits.tiff \
  results/figure-posterior-intervals-for-alt-traits.tiff \
  results/figure-variance-partitioning.tiff

results/figure-posterior-intervals-for-key-traits.tiff: results/figure-posterior-intervals-for-key-traits.pdf
	convert -density 2400 $< -resize 5% $@

results/figure-posterior-intervals-for-alt-traits.tiff: results/figure-posterior-intervals-for-alt-traits.pdf
	convert -density 2400 $< -resize 5% $@

results/figure-variance-partitioning.tiff: results/figure-variance-partitioning.pdf
	convert -density 2400 $< -resize 5% $@


.PHONY: clean
clean:
	rm -rf results/*.pdf results/*.tiff
