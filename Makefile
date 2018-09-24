ifndef RES
	RES=300
endif
all : fig1.png fig2.png fig1.pdf fig2.pdf

%.pdf : %.dot
	dot -Tpdf -o $@ $<

%.pdf : %.svg
	inkscape --file=$< --export-text-to-path --export-area-page --without-gui --export-pdf=$@

%.png : %.svg
	inkscape --file=$< --export-area-page --without-gui --export-dpi=$(RES) --export-png=$@

.PHONY: clean

clean :
	$(RM) $(wildcard *.pdf) $(wildcard *.png)

