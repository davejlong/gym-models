include <utils.scad>

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

module upright(length) {
    difference() {
        // rect_tube(
        //    size=ci(3), wall=ci(0.12), h=ci(length),
        //    rounding=1);
        rect_tube(
            size=ci(3), wall=1, h=ci(length),
            rounding=1);
        for(i=[1:2:length-1]) {
            translate([0, ci(3), ci(i)])
            rotate([90, 0, 0])
                cylinder(h=ci(6), d=ci(1));
        }
        for(i=[2:2:length-2]) {
            translate([ci(-3), 0, ci(i)])
            rotate([0, 90, 0])
                cylinder(h=ci(6), d=ci(1));
        }       
    }
}


module cross_mount() {
    union() {
        mount_plate = square([ci(3), ci(8)], center=true);
        linear_extrude(ci(0.375)+0.01)
            polygon(round_corners(mount_plate, method="smooth", cut=1));

        translate([0, ci(-3), 0.01])
            union() {
                cylinder(h=ci(0.375+0.5), d=ci(1.5), $fn=6);
                cylinder(h=ci(0.375+1), d=ci(0.97));
            }
        translate([0, ci(3), 0.01])
            union() {
                cylinder(h=ci(0.375+0.5), d=ci(1.5), $fn=6);
                cylinder(h=ci(0.375+1), d=ci(0.97));
            }
    }
}

module cross_bar(length=30) {
    union() {
    translate([0, 0, ci(0.375)])
        upright(length=length-(0.375*2));

        cross_mount();
        
        translate([0, 0, ci(length)])
            rotate([180, 0, 0])
            cross_mount();
    }
    
    translate([0, ci(-3), ci(-3.749)])
        cylinder(h=ci(0.375+0.5), d=ci(1.5), $fn=6);
    
    translate([0, ci(3), ci(-3.749)])
        cylinder(h=ci(0.375+0.5), d=ci(1.5), $fn=6);
    
    translate([0, ci(-3), ci(length+2.9)])
        cylinder(h=ci(0.375+0.5), d=ci(1.5), $fn=6);
    
    translate([0, ci(3), ci(length+2.9)])
        cylinder(h=ci(0.375+0.5), d=ci(1.5), $fn=6);
}


module j_hook() {
    shape = [
        [0, 0],
        [ci(2), 0],
        [ci(3), ci(1.5)],
        [ci(3-0.375), ci(1.5)],
        [ci(2-(0.375/2)), ci(0.375)],
        [ci(0.375), ci(0.375)],
        [ci(0.375), ci(6-0.375)],
        [0, ci(6-0.375)]
    ];
    translate([ci(3), ci(3), 0])
    rotate([90, 0, 270])
    linear_extrude(ci(3))
        polygon(round_corners(shape, radius=0.4));
}



rack_height = 84;
color("gray")
union() {
// Side Panels
for(i=[0, 46]) {
    translate([ci(i), 0, ci(0.374)])
    union() {
        // Front Upright
        upright(length=rack_height);
        // Rear Upright
        translate([0, ci(33), 0]) upright(length=rack_height);

        // Lower Crossbar
        translate([0, ci(1.5), ci(1.5+2.5)])
        rotate([-90, 0, 0])
            cross_bar();

        // Upper Crossbar
        translate([0, ci(1.5), ci(rack_height-1.5-2.5)])
        rotate([-90, 0, 0])
            cross_bar();
    }
}


// Rear Crossbar
translate([ci(1.5), ci(33), ci(3+rack_height-8+0.374)])
    rotate([90,0, 90])
    cross_bar(length=43);

mount_plate = square([ci(6), ci(9), 0]);
translate([ci(-6+1.5), ci(-4.5), 0])
linear_extrude(ci(0.375)+0.01)
    polygon(round_corners(mount_plate, method="smooth", cut=1));

translate([ci(-6+1.5), ci(-4.5+33), 0])
linear_extrude(ci(0.375)+0.01)
    polygon(round_corners(mount_plate, method="smooth", cut=1));

translate([ci(1.5+43), ci(-4.5), 0])
linear_extrude(ci(0.375)+0.01)
    polygon(round_corners(mount_plate, method="smooth", cut=1));

translate([ci(1.5+43), ci(-4.5+33), 0])
linear_extrude(ci(0.375)+0.01)
    polygon(round_corners(mount_plate, method="smooth", cut=1));

translate([ci(-1.5), ci(28.51), ci(48)])   
j_hook();

translate([ci(-1.5+46), ci(28.51), ci(48)])   
j_hook();
}
