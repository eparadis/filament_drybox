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

tray(
  X = footprint_width_narrow,
  Y = footprint_length_narrow
);

