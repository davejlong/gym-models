include <utils.scad>

color("red")
    linear_sweep(circle(d=3), h=4, center=false,
			texture="trunc_pyramids", tex_size=[0.25, 0.25],
            tex_depth=0.125, tex_inset=true);

color("blue")
    rotate([180, 0, 90])
    linear_sweep(circle(d=3), h=4, center=false,
			texture="trunc_pyramids", tex_size=[0.25, 0.25],
            tex_depth=0.125, tex_inset=true);