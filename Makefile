TARGETS := $(wildcard *.dot)
PDF     := $(patsubst %.dot,%.pdf,$(TARGETS))

all : $(PDF)

%.pdf : %.dot
	dot -Tpdf -o $@ $<

.PHONY: clean

clean :
	$(RM) $(PDF)

