TARGETS := $(wildcard *.dot)
PDF     := $(patsubst %.dot,%.pdf,$(TARGETS))

all : $(PDF)

%.pdf : %.dot
	dot -Tpdf -o $@ $<

%.pdf : %.svg
	inkscape --file=$< --export-area-page --without-gui --export-pdf=$@

%.png : %.svg
	inkscape --file=$< --export-area-page --without-gui --export-dpi=300 --export-png=$@

.PHONY: clean

clean :
	$(RM) $(PDF)

