
$fn=128;

LARGE_VALUE = 1000000;
SMALL_VALUE = 0.00000000001;
FULL_CIRCLE = 360;

ap_ring_outer_rad = 22;
ap_ring_inner_rad = 15.5;
ap_ring_height = 3;

ap_number_legs = 4;

ap_angle_height = 5;
ap_angle_upper_inner_rad = 15.5455;
ap_angle_upper_outer_rad = 20;
ap_angle_lower_inner_rad = 11;
ap_angle_lower_outer_rad = 14.0625;

ap_leg_start = -ap_ring_height - ap_angle_height;
ap_leg_distance = 12.7279220613578554392151985;
ap_leg_radius = 1.5;
ap_leg_vertical_length = 49;
ap_leg_diag_length = 20;
ap_leg_diag_vertical_offset = (-sqrt(2)/2) * ap_leg_diag_length;
ap_leg_elbow_ball_rad = 2;
ap_leg_tip_ball_z_offset = 1;
ap_leg_tip_ball_rad = 2.5;

module ring(){
    difference(){
        translate([0,0, -ap_ring_height]) linear_extrude(ap_ring_height) circle(r=ap_ring_outer_rad);
        translate([0,0, -ap_ring_height - 1]) linear_extrude(ap_ring_height + 2) circle(r=ap_ring_inner_rad);
    } 
}

module angle(){
    translate([0,0, -ap_ring_height - ap_angle_height/2]) {
        difference(){
            cylinder(
                r1 = ap_angle_lower_outer_rad,
                r2 = ap_angle_upper_outer_rad,
                h = ap_angle_height,
                center = true);
            cylinder(
                r1 = ap_angle_lower_inner_rad,
                r2 = ap_angle_upper_inner_rad,
                h = ap_angle_height,
                center = true);
        }
    }

// Figure out what positional arguments are driving in a cylinder...
//        translate([40,0,8])rotate([0,180,0]) cylinder(22,21);
//        translate([45,0,8])rotate([0,180,0]) cylinder(h = 22, r1 = 21, r2 = 1);
//        translate([40,-40,2]) rotate([180,0,0]) cylinder(16,20);
//        translate([45,-40,2]) rotate([180,0,0]) cylinder(r1=20,r2=1, h = 16);
}     

module bottom(){
    
    for(angle = [0 : FULL_CIRCLE/ap_number_legs : FULL_CIRCLE-1]) {
        rotate([0, 0, angle]) 
            translate([ap_leg_distance, 0, ap_leg_start - ap_leg_vertical_length/2]) 
                cylinder(h = ap_leg_vertical_length, r = ap_leg_radius, center = true);
        
        rotate([0, 0, angle - 45])
            translate([-1,-1,ap_leg_start + ap_leg_diag_vertical_offset - ap_leg_vertical_length])
                rotate([0,45,45])
                    cylinder(h = ap_leg_diag_length, r = ap_leg_radius);
        
        rotate([0, 0, angle])
            translate([ap_leg_distance, 0, ap_leg_start - ap_leg_vertical_length])
                sphere(ap_leg_elbow_ball_rad);
    }
    translate([ 0, 0,
                ap_leg_start + ap_leg_diag_vertical_offset + 
                ap_leg_tip_ball_z_offset - ap_leg_vertical_length])
        sphere(ap_leg_tip_ball_rad);
}

rotate([180, 0, 0]) {
    ring();
    angle();
    bottom();
}