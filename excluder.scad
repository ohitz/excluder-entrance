// Queen/drohne excluding entrance
//
// Oliver Hitz <oliver@net-track.ch>

// Text printed on wall
// text = "♂";
text = "♀";

// Width of the gaps:
// - for queens: 4.4
// - for drones: 5.2
gap_w = 4.4;

// Thickness of the grid
grid_thickness = 1.5;

// Additional space between the grid cutouts.
grid_sp = 1;

// Number of cutout lines
grid_lines = 6;

// Size of the entire box
body_l = 150;
body_w = 60;
body_h = 16;

// Wall thickness
body_wall = 1.5;

// Size of the entrance cutout
body_cutout_l = 0.8 * body_l;
body_cutout_h = 10;

// Border around the grid, for to reinforce the structure.
grid_border = 4;
grid_border_thickness = 1;

// Rounded edges diameter of the grid border
grid_border_round = 3;

// Rounded edges diameter
body_round = 10;

// Font size
text_size = body_h - 2;

// Text depth
text_depth = 1;

$fn = 32;

// Defines one grid cutout.
module cutout(x1, x2) {
	hull() {
		translate([x1, 0, 3*grid_thickness/4])
			cylinder(d1=gap_w, d2=gap_w+grid_thickness/2, h=grid_thickness/4);
		translate([x2, 0, 3*grid_thickness/4])
			cylinder(d1=gap_w, d2=gap_w+grid_thickness/2, h=grid_thickness/4);
	}
	hull() {
		translate([x1, 0, 0])
			cylinder(d=gap_w, h=grid_thickness);
		translate([x2, 0, 0])
			cylinder(d=gap_w, h=grid_thickness);
	}
	hull() {
		translate([x1, 0, 0])
			cylinder(d2=gap_w, d1=gap_w+grid_thickness/2, h=grid_thickness/4);
		translate([x2, 0, 0])
			cylinder(d2=gap_w, d1=gap_w+grid_thickness/2, h=grid_thickness/4);
	}
}

// One cutout line
module cutout_line(n, l, y) {
	translate([l/24, y, 0]) {
		if (0 == n % 2) {
			// Even lines.
			cutout(0*l/12+grid_sp, 3*l/12-grid_sp);
			cutout(4*l/12+grid_sp, 7*l/12-grid_sp);
			cutout(8*l/12+grid_sp, 11*l/12-grid_sp);
		} else {
			// Odd lines
			cutout(0*l/12+grid_sp, 1*l/12-grid_sp);
			cutout(2*l/12+grid_sp, 5*l/12-grid_sp);
			cutout(6*l/12+grid_sp, 9*l/12-grid_sp);
			cutout(10*l/12+grid_sp, 11*l/12-grid_sp);
		}
	}
}

module body() {
	hull() {
		cube([1, 1, body_h]);
		translate([body_round/2, body_w-body_round/2, 0])
			cylinder(d=body_round, h=body_h);
		translate([body_l-1, 0, 0])
			cube([1, 1, body_h]);
		translate([body_l-body_round/2, body_w-body_round/2, 0])
			cylinder(d=body_round, h=body_h);
	}
}

module grid(l, w) {
	for (i = [0:grid_lines-1]) {
		cutout_line(i, l, ((w/grid_lines)/2)+i*w/grid_lines);
	}
}

module grid_border() {
	hull() {
		translate([grid_border_round/2, grid_border_round/2, 0])
			cylinder(d=grid_border_round, grid_border_thickness);
		translate([grid_border_round/2, body_w-(2*grid_border)-grid_border_round/2, 0])
			cylinder(d=grid_border_round, grid_border_thickness);

		translate([(body_l-(3*grid_border))/2-grid_border_round/2, grid_border_round/2, 0])
			cylinder(d=grid_border_round, grid_border_thickness);
		translate([(body_l-(3*grid_border))/2-grid_border_round/2, body_w-(2*grid_border)-grid_border_round/2, 0])
			cylinder(d=grid_border_round, grid_border_thickness);
	}
}

difference() {
	union() {
		// Main body
		difference() {
			body();

			translate([body_wall, body_wall, grid_thickness+grid_border_thickness])
				resize(newsize=[body_l - body_wall*2, body_w-2*body_wall, body_h-(grid_thickness+grid_border_thickness)])
					body();
		}
	}
	
	// Cutout
	translate([(body_l-body_cutout_l)/2, 0, body_h-body_cutout_h])
		cube([body_cutout_l, body_wall, body_cutout_h]);
	
	// Left grid
	translate([grid_border, grid_border, grid_thickness])
		grid_border();
	translate([grid_border, grid_border, 0])
		grid((body_l-(3*grid_border))/2, body_w-(2*grid_border));

	// Right grid
	translate([2*grid_border+(body_l-(3*grid_border))/2, grid_border, grid_thickness])
		grid_border();
	translate([2*grid_border+(body_l-(3*grid_border))/2, grid_border, 0])
		grid((body_l-(3*grid_border))/2, body_w-(2*grid_border));
}

// Add text
translate([body_l/2, body_w+text_depth/2, body_h/2])
	mirror([0,0,1])
	rotate([90,0,0])
	linear_extrude(text_depth, center=true)
	resize([0, text_size, 0], auto=true)
	text(text, font="Arial Bold", halign="center", valign="center");

