all: bn_generic_export.s

%.s: %.jinc
	jasminc $< -o $@

clean:
	rm -f *.s
