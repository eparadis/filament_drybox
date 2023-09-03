// a filament spool holder to fit inside a snapware food container

footprint_width_narrow = 181;
footprint_length_narrow = 221.5;

module tray_profile() {
  /*
     D
     _
    | | E
  C | |
    | \ F  G
    \  \_____
  B  \_______| H
    B    A
  */

  // the angled portions are at 45 degrees so their rise equals their run

  D = 2; // thickness of the walls of the tray
  H = 2; // thickness of the bottom of the tray
  A = footprint_width_narrow / 2 - D;
  B = 4; // not the length of the fillet, but the distance it covers along A (or C)
  C = 15;
  F = B; // (A+B) - (G+D); // like B, this is the 'sides' of the triangle, not the hypoteneus
  E = (C+B) - (H+F);
  G = (A+B) - (D+F);

  //profile = [[B,0], [0,B], [0,C+B], [D,C+B], [D,C+B-E], [D+F,H], [B+A,H], [B+A,0]];
  profile = [[0,0], [-A,0], [-(A+B),B], [-(A+B),B+C], [-(A+B)+D,B+C],
    [-(A+B)+D,C+B-E], [-(A+B)+D+F,H], [0,H]]; 

  polygon(profile);

  // mirror for the other half
  mirror([1,0,0])
    polygon(profile);
}

module tray() {
  rotate([90,0,0])
    linear_extrude(footprint_length_narrow)
      tray_profile();
}

tray();
