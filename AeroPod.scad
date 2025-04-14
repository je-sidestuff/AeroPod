
$fn=16;

LARGE_VALUE = 1000000;
SMALL_VALUE = 0.00000000001;
FULL_CIRCLE = 360;

ap_ring_outer_rad = 22;
ap_ring_inner_rad = 15.5;
ap_ring_height = 3;

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

ap_height_to_leg = ap_ring_height + ap_angle_height + ap_leg_vertical_length;
ap_total_height = ap_height_to_leg - ap_leg_diag_vertical_offset;

ap_use_walls = true;
ap_wall_thickness = 0.5;

ap_irrigator_rad = 3;

ap_number_legs = 6;
ap_number_of_segments = 3;
ap_segment_slip_gap = 0.25;

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
}     

module bottom(){
    
    leg_angle = FULL_CIRCLE/ap_number_legs;
    segment_angle = FULL_CIRCLE - FULL_CIRCLE/ap_number_of_segments;
    
    for(angle = [0 : leg_angle : FULL_CIRCLE-1]) {
        rotate([0, 0, angle]) 
            translate([ap_leg_distance, 0, ap_leg_start - ap_leg_vertical_length/2]) 
                cylinder(h = ap_leg_vertical_length, r = ap_leg_radius, center = true);
        
        if (ap_use_walls) {
            hull() {
                rotate([0, 0, angle]) 
                    translate([ap_leg_distance, 0, ap_leg_start - ap_leg_vertical_length/2]) 
                        cylinder(h = ap_leg_vertical_length, r = ap_wall_thickness/2, center = true);
                rotate([0, 0, angle + leg_angle]) 
                    translate([ap_leg_distance, 0, ap_leg_start - ap_leg_vertical_length/2]) 
                        cylinder(h = ap_leg_vertical_length, r = ap_wall_thickness/2, center = true);
            }
        }
        
        rotate([0, 0, angle - 45])
            translate([-1,-1,ap_leg_start + ap_leg_diag_vertical_offset - ap_leg_vertical_length])
                rotate([0,45,45])
                    cylinder(h = ap_leg_diag_length, r = ap_leg_radius);
        
        rotate([0, 0, angle])
            translate([ap_leg_distance, 0, ap_leg_start - ap_leg_vertical_length])
                sphere(ap_leg_elbow_ball_rad);
        
        if (ap_use_walls) {
            hull() {
                rotate([0, 0, angle])
                    translate([ap_leg_distance, 0, ap_leg_start - ap_leg_vertical_length])
                        sphere(ap_wall_thickness/2);
                rotate([0, 0, angle + leg_angle])
                    translate([ap_leg_distance, 0, ap_leg_start - ap_leg_vertical_length])
                        sphere(ap_wall_thickness/2);
                translate([0, 0,
                            ap_leg_start + ap_leg_diag_vertical_offset + 
                            ap_leg_tip_ball_z_offset - ap_leg_vertical_length])
                    sphere(ap_wall_thickness/2);
            }
        }
    }
    
    translate([ 0, 0,
                ap_leg_start + ap_leg_diag_vertical_offset + 
                ap_leg_tip_ball_z_offset - ap_leg_vertical_length])
        sphere(ap_leg_tip_ball_rad);
    
    if(ap_use_walls) {
        if (ap_number_of_segments > 1) {
            hull() {
                translate ([0, 0, ap_total_height/-2])
                    cylinder(h = ap_total_height, r = ap_wall_thickness + ap_segment_slip_gap/2, center = true);
                translate ([ap_leg_distance, 0, ap_height_to_leg/-2])
                    cylinder(h = ap_height_to_leg, r = ap_wall_thickness + ap_segment_slip_gap/2, center = true);
            }
            hull() {
                translate ([ap_angle_lower_inner_rad, 0, ap_leg_start/2])
                    cylinder(h = -ap_leg_start, r = ap_wall_thickness + ap_segment_slip_gap/2, center = true);
                translate ([ap_angle_upper_outer_rad, 0, ap_ring_height/-2])
                    cylinder(h = ap_ring_height, r = ap_wall_thickness + ap_segment_slip_gap/2, center = true);
            }
        }
        
        hull() {
        }
    }
}

module segmented() {
    
    segment_angle = FULL_CIRCLE - FULL_CIRCLE/ap_number_of_segments;
    segment_half_angle = segment_angle/2;
    
    difference() {
        children([0]);
        if (ap_number_of_segments > 1) {
            hull() {
                cylinder(h = LARGE_VALUE, r = ap_segment_slip_gap/2, center = true);
                translate([LARGE_VALUE, 0, 0])
                    cylinder(h = LARGE_VALUE, r = ap_segment_slip_gap/2, center = true);
                rotate([0, 0, segment_half_angle]) translate([LARGE_VALUE, 0, 0])
                    cylinder(h = LARGE_VALUE, r = ap_segment_slip_gap/2, center = true);
            }
            hull() {
                cylinder(h = LARGE_VALUE, r = ap_segment_slip_gap/2, center = true);
                rotate([0, 0, segment_half_angle]) translate([LARGE_VALUE, 0, 0])
                    cylinder(h = LARGE_VALUE, r = ap_segment_slip_gap/2, center = true);
                rotate([0, 0, segment_angle]) translate([LARGE_VALUE, 0, 0])
                    cylinder(h = LARGE_VALUE, r = ap_segment_slip_gap/2, center = true);
            }
        }
    }
}

module aero_pod_segment() {
    segmented()
        rotate([180, 0, 0]) {
            ring();
            angle();
            bottom();
        }
}

aero_pod_segment();