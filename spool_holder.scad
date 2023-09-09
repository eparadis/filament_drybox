// a filament spool holder to fit inside a snapware food container

include <BOSL2/std.scad>

footprint_width_narrow = 181;
footprint_length_narrow = 221.5;
profile_width = 10;
base_thickness = 2;

$fn=128;

module tray_half_profile() {
  /*
     D
     _
    | | E
  C | |
    | \ F  G
    \  \_____
  B  \_______| H
    B    A

    |--------| profile width
  */

  // the angled portions are at 45 degrees so their rise equals their run

  D = 2; // thickness of the walls of the tray
  H = 2; // thickness of the bottom of the tray
  B = 4; // not the length of the fillet, but the distance it covers along A (or C)
  A = profile_width-B; //footprint_width_narrow / 2 - D;
  C = 15;
  F = B; // (A+B) - (G+D); // like B, this is the 'sides' of the triangle, not the hypoteneus
  E = (C+B) - (H+F);
  G = (A+B) - (D+F);

  //profile = [[B,0], [0,B], [0,C+B], [D,C+B], [D,C+B-E], [D+F,H], [B+A,H], [B+A,0]];
  profile = [[0,0], [-A,0], [-(A+B),B], [-(A+B),B+C], [-(A+B)+D,B+C],
    [-(A+B)+D,C+B-E], [-(A+B)+D+F,H], [0,H]]; 
  
  polygon(profile);
}

module tray(X, Y) {
  Xi = X - 2*profile_width;
  Yi = Y - 2*profile_width;

  // it's worth noting you can provide values for chamfer and rounding
  path = rect([Xi,Yi], rounding=0, chamfer=0);

  path_extrude2d(path, caps=false, closed=true) {
    tray_half_profile();
  }

  // base
  linear_extrude(height=base_thickness)
    rect([Xi,Yi], rounding=0, chamfer=0);
}

module spool(center_height=100) {
  // modeled after the hatchbox PLA 1kg spools I use
  translate([0,67.78/2,center_height])
  rotate([90,0,0])
  difference() {
    union() {
      cylinder(d=60,h=67.78);
      cylinder(d=200, h=3);
      translate([0,0,67.78-3])
        cylinder(d=200, h=3);
    }
    cylinder(d=54.75, h=67.78);
  }

  if((center_height+100) > 234) {
    echo("WARNING!!! spool is too high and will not fit inside box!");
  }
}

module copy_corners() {
  children(); 
  mirror([0,1,0]) children();
  mirror([1,0,0]) children();
  mirror([0,1,0]) mirror([1,0,0]) children();
}

module rollers(height=0) {
  seperation = 100; // front-to-back distance
  roller_hub_dia = 20;
  spool_rim_dia = 200;
  cen_to_cen_dist = (roller_hub_dia + spool_rim_dia) / 2;
  
  // the angle at the spool center between lines to the center of the two rollers
  spread_angle = asin(seperation/2 / cen_to_cen_dist) * 2;
  echo(str("roller spread angle is ", spread_angle));
  hub_center_height = cos(spread_angle/2) * cen_to_cen_dist + height;
  echo(str("hub_center_height is ", hub_center_height));

  module roller() {
    ID = 5;
    translate([seperation/2, 65/2, height])
      rotate([90,0,0]) 
        difference() {
          union() {
            cylinder(d=roller_hub_dia, h=4, center=true);
            translate([0,0,3]) cylinder(d=25, h=2, center=true);
            translate([0,0,-3]) cylinder(d=25, h=2, center=true);
          }
          cylinder(d=ID, h=12, center=true);
        }
  }

  // put one in each corner
  copy_corners() roller(); 
}

module supports() {
  r_sep = 100;
  module support(r_ht=20) {
    W = 4;
    gap = 0.2;
    base_height = 2;
    dia = 5;
    difference() {
      union() {
        translate([r_sep/2, 65/2+(4+W/2+gap), 0])
          prismoid(size1=[30,W], size2=[20,W], h=r_ht+5);
        // translate([r_sep/2, 65/2-(4+W/2+gap), base_height])
        //   prismoid(size1=[30,W], size2=[20,W], h=r_ht+5-base_height);
      }
      translate([r_sep/2, 65/2, r_ht])
        rotate([90,0,0])
          hull() {
            cylinder(d=dia, h=30, center=true);
            translate([0,10,0]) cylinder(d=dia, h=30, center=true);
          }
    }
    translate([r_sep/2-15, 65/2-15+4+gap+4, 3]) {
      difference() {
        cube([30,15,4], center=false);
        translate([15,5,0]) cylinder(d=2.9, h=5);
      }
    }
  }

  copy_corners() support();
  // translate([r_sep/2,0,1.5]) cube([30, 65+8+8+.4, 3], center=true);
  path = turtle([ "left",90, "move",10, "right", 90,
    "move", 10, "arcleft", 10, "move",65/2-15+4+0.2+4-20+0.9, "arcright",10,
    "move", r_sep/2-30+15, "right",90, "move", 10, "arcright",10, "move",10, "arcleft",10,
    "untily", 0, "right",90, "untilx", 0
    ]);
  difference() {
    translate([0,0,-0.1]) copy_corners() linear_extrude(height = 3) polygon(path);
    copy_corners() translate([r_sep/2-15, 65/2-15+4+0.2+4, -3]) translate([15,5,0]) cylinder(d=2.9, h=10);
  }
  // stroke(path);
}

module spool_holder() {
  // %color("blue") spool(118);
  color("yellow") rollers(height=20);
  color("red") supports();
}

// %rotate([0,0,90])
// tray(
//   X = footprint_width_narrow,
//   Y = footprint_length_narrow
// );

// translate([0,40,0]) spool_holder();
// mirror([0,1,0]) translate([0,40,0]) 
spool_holder();
