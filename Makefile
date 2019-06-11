
all: queen-excluder.stl drone-excluder.stl

queen-excluder.stl: excluder.scad
	openscad -D'text="♀"' -D'gap_w=4.4' -o $@ $<

drone-excluder.stl: excluder.scad
	openscad -D'text="♂"' -D'gap_w=5.2' -o $@ $<

