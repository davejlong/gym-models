include <utils.scad>;

assembled = $preview;

module Sleeve() {
    difference() {
        union() {
            // Sleeve
            cylinder(h=ci(17), d=ci(1.97)); // 4.83

            // Collar
            cylinder(h=ci(2), d=ci(3));
        }
        
        translate([0, 0, -0.1])
            cylinder(h=ci(12)+2, d=ci(1.22)+0.5);
    }
}

// Handle
module handle_part(h, knurled=false) {
    if (knurled) {
        if($preview) {
            color("red") cyl(d=ci(1.22), h=h, center=false);
        } else {
            linear_sweep(circle(d=ci(1.22)), h=h, center=false,
                texture="trunc_pyramids", tex_size=[0.25, 0.25], tex_depth=0.125, tex_inset=true);
        } 
    } else {
        cyl(d=ci(1.22), h=h, center=false);
    }
}

module make_parts(parts, index, offset) {
    height = parts[index][0];
    knurled = parts[index][1];
    echo("Height", height, "Knurled", knurled, "Offset", offset);
    
    translate([0, 0, offset]) handle_part(h=ci(height), knurled=knurled);
    
    if (index < len(parts)-1) {
        make_parts(parts, index+1, offset+ci(height));
    }
}

module Handle() {
    parts = [
        [12.25, false], [10.675, true], [0.25, false], [8.875, true], [4, false],
        [4, true],
        [4, false], [8.875, true], [0.25, false], [10.675, true], [12.25, false]
    ];
    union() {
        make_parts(parts, 0, 0);
    }
}

if(assembled) {
	translate([0, 0, ci(5)]) Handle();
	translate([0, 0, ci(69)]) Sleeve();
    translate([0, 0, ci(17)])
    rotate([180, 0, 0])
        Sleeve();
} else {
    Handle();
    translate([0, ci(3), 0])
    	Sleeve();
}
