
$fn=100;

module ring(){
    difference(){
        translate([0,0,2]) linear_extrude(3) circle(r=22);
        linear_extrude(5) circle(r=15.5);
    } 
}   
module angle(){
    difference(){
        translate([0,0,2]) rotate([180,0,0]) cylinder(16,20);
        translate([0,0,-28])  linear_extrude(25) circle(15);
        translate([0,0,8])rotate([0,180,0]) cylinder(22,21);
    }
}     

module bottom(){
    translate([9,9,-52]) cylinder(h=49,r=1.5);
    translate([9,-9,-52]) cylinder(h=49,r=1.5);
    translate([-9,9,-52]) cylinder(h=49,r=1.5);
    translate([-9,-9,-52]) cylinder(h=49,r=1.5);
    translate([-1,-1,-65]) rotate([0,45,45]) cylinder(h=20,r=1.5);
    translate([1,-1,-65]) rotate([0,45,135]) cylinder(h=20,r=1.5);
    translate([1,1,-65]) rotate([0,45,225]) cylinder(h=20,r=1.5);
    translate([-1,1,-65]) rotate([0,45,315]) cylinder(h=20,r=1.5);
    translate([0,0,-64])sphere(2.5);
    translate([9,9,-51])sphere(2);
    translate([-9,-9,-51])sphere(2);
    translate([9,-9,-51])sphere(2);
    translate([-9,9,-51])sphere(2);
}



    /*difference(){
        translate([0,0,-27]) cube([20,20,48], center = true);
        translate([-15,-7,-64]) cube([30,14,65]);
        translate([-7,-15,-64]) cube([14,30,65]);
        translate([0,0,-65]) linear_extrude(30) circle(7);
        translate([0,0,8])rotate([0,180,0]) cylinder(10,11);
    }
         translate([-1,-3,-63])   rotate([0,45,45])  cube([3,3,17]);
}*/
   
ring();
angle();
bottom();
