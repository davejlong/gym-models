include <utils.scad>;

// TODO: Add 100# plate

module Base_Plate(d, h=1.5) {
    difference() {
        cylinder(h=ci(h), d=ci(d));
        
        // Center hole
        translate([0, 0, -0.1]) cylinder(h=ci(h*2), d=ci(2)+1);
        
        // Indent
        difference() {
            translate([0, 0, ci(h/2)])
                cylinder(h=ci(h), d=ci(d-1.5));
            
            cylinder(h=ci(h), d=ci(2+2));
        }
    }
}

module Plate_Text(path, chars, size=5, h=1.5) {
    color("white")
    translate([0, 0, ci(h/2)])
    path_text(path, chars,
        font="Ebrima:style=bold",
        center=true,
        thickness=ci(h),
        size=size,
        lettersize = size,
        normal=UP);
}

module Weight_Plate(d, h, words, textsize=5, wedges=false) {
    union() {
        Base_Plate(d, h=h);
        
        num_words = len(words);
                
        if (is_string(words)) {
            arc_d = ci(d/1.8);
            arc_path = path3d(arc(d=arc_d, angle=[360, 0]));
            textsize = path_length(arc_path)/len(words)-0.15;
          echo("Size", textsize);
            Plate_Text(
                arc_path,
                words,
                size=textsize,
                h=h-0.25
            );
        } else {
            arc_d = ci(d/1.6);
            arc_angle = 360 / num_words;
            
            for(i=[0:len(words)-1]) {
                Plate_Text(
                    path3d(arc(d=arc_d, angle=[arc_angle*(i+1), arc_angle*i])),
                    chars=words[i],
                    size=textsize,
                    h=h-0.25
                );
                rotate([0, 0, -360/(num_words+1)+arc_angle*i])
                translate([ci(-0.25), ci(1.9), ci(h/2-0.01)])
                    wedge([ci(0.5), ci(d/2-1.9-(h/2)), ci(h/2)]);
            }
        }
    }
}

// 100# Plate
//translate([ci(0), ci(0), 0])
//    Weight_Plate(d=17.72, h=2.52,
//        words=["STANDARD", "45.4KGS", "BARBELL", "100LBS"],
//        textsize=3);

// 45# Plate
translate([ci(25), 0, 0])
    Weight_Plate(d=17.72, h=1.22,
        words=["BARBELL", "45LBS", "20.4KGS"],
        textsize=3.6);

// 35# Plate
translate([0, 0, 0])
    Weight_Plate(d=14.17, h=1.3,
        words=["BARBELL", "35LBS", "15.9KGS"],
        textsize=2.7);


// 25# Plate
translate([0, ci(13), 0])
    Weight_Plate(d=10.71, h=1.5,
        words="BARBELL 25LBS 11.3KILOS");

// 10# Plate
translate([ci(10), ci(10), 0])
    Weight_Plate(d=8.94, h=0.83,
        words="BARBELL 10LBS 4.5KILOS");

// 5# Plate
translate([ci(11.5), 0, 0])
    Weight_Plate(d=7.87, h=0.75,
    words="BARBELL 5LBS 2.3KILOS");
