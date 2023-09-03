// a filament spool holder to fit inside a snapware food container

footprint_width_narrow = 181;
footprint_length_narrow = 221.5;
profile_width = 10;

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

module tray() {
  // long sides
  translate([0,221.5/2-profile_width,0])
    rotate([90,0,0])
      linear_extrude(221.5 - profile_width*2)
        tray_profile( 181);

  // short sides
  translate([-181/2+profile_width,0,0])
    rotate([90,0,90])
      linear_extrude(181 - profile_width*2)
        tray_profile( 221.5);
}

tray_corner();

tray();
