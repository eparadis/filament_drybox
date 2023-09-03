// a filament spool holder to fit inside a snapware food container

include <BOSL2/std.scad>

footprint_width_narrow = 181;
footprint_length_narrow = 221.5;
profile_width = 10;
base_thickness = 2;

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


module tray_profile(outside_wall_distance) {
  T = outside_wall_distance/2 - profile_width;
  translate([-T,0]) tray_half_profile();

  // mirror for the other half
  mirror([1,0,0])
    translate([-T,0])
      tray_half_profile();
}

module tray_corner() {
  mirror([1,0,0])
    rotate_extrude(angle=-90, convexity=10)
      tray_half_profile();
}

module tray(X, Y) {
  // long sides
  translate([0,Y/2-profile_width,0])
    rotate([90,0,0])
      linear_extrude(Y - profile_width*2)
        tray_profile( X);

  // short sides
  translate([-(X/2-profile_width),0,0])
    rotate([90,0,90])
      linear_extrude(X - profile_width*2)
        tray_profile( Y);

  // corners
  Xc = X/2-profile_width;
  Yc = Y/2-profile_width;
  translate([Xc,Yc,0])
    tray_corner();

  translate([-Xc,Yc,0])
    mirror([1,0,0])
      tray_corner();

  translate([Xc,-Yc,0])
    mirror([0,1,0])
      tray_corner();

  translate([-Xc,-Yc,0])
    mirror([1,1,0])
      tray_corner();

  // base
  translate([0,0,base_thickness/2])
    cube([Xc*2,Yc*2,base_thickness], center=true);
}

module b_tray(X, Y) {
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

tray(
  X = footprint_width_narrow,
  Y = footprint_length_narrow
);

translate([0,0,20])
color("yellow")
b_tray(
  X = footprint_width_narrow,
  Y = footprint_length_narrow
);
