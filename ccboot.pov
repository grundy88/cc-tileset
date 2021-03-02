#include "ccglobal.inc"
#include "colors.inc"
#include "boot-geom.inc"

#declare FIRE_BOOT=1;
#declare ICE_SKATE=2;
#declare FORCE_BOOT=3;
#declare WATER_BOOT=4;
 
#ifndef (BootType)
//	#declare BootType=FIRE_BOOT;
//	#declare BootType=ICE_SKATE;
	#declare BootType=FORCE_BOOT;
#end

camera {
        perspective
        up <0,1,0>
        right -x*image_width/image_height
        location <0,150,206>
        look_at <0,45,0>
        angle 32.93461 // horizontal FOV angle
        }
 
light_source {
	<-200, 500, -200>
	color rgb <1,1,1>*1
//	area_light <0, 200, 0>, <-200, 0, 0>, 5, 5 jitter
}

light_source {
	<0, 50, 200>
	color rgb 1.5
	shadowless
}
 
 plane {
  y, -12
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.35 diffuse 1.05 }
  }
}

//Assembled object that is contained in Boot_POV_geom.inc
union {
	object{
//		Boot_
		CCBoot
		clipped_by {
			box {
				<300, -300, 300>, <-300, 55, -300>
			}
		}
//		no_image no_shadow
		#if (BootType = FIRE_BOOT)
			pigment {Orange}
		#end
		#if (BootType = ICE_SKATE)
			pigment {Cyan}
		#end
		#if (BootType = FORCE_BOOT)
			pigment {Green}
		#end
	}
	#if (BootType = ICE_SKATE)
	#local H=12;
	union {
		box {
			<35, 0, 0>, <-35, H, 3>
		}
		cylinder {
			<35, H/2, 0>, <35, H/2, 3>, H/2
		}
		difference {
			cylinder {
				<0, 0, 0>, <0, 0, 3>, H
			}
			cylinder {
				<H/2, H, -1>, <H/2, H, 4>, H*1.2
			}
			translate <-32, H, 0>
		}
		box {
			<25, H, 0>, <20, H*2, 3>
		}
		box {
			<-25, H, 0>, <-20, H*2, 3>
		}
		pigment {Gray60}
		rotate 90*y
		translate <0, -22, -1.5>
	}
	#end
	#if (BootType = FORCE_BOOT)
	cone {
		<0, 0, 0>, 15, <0, 10, 0>, 8
		pigment {rgb <0, 0.6, 0>}
		finish {ambient 0}
		translate <0, -8, 20>
	}
	cone {
		<0, 0, 0>, 15, <0, 10, 0>, 8
		pigment {rgb <0, 0.6, 0>}
		finish {ambient 0}
		translate <0, -8, -20>
	}
	#end
	scale 1.5
	rotate -60*y
	#if (BootType = ICE_SKATE)
		translate 20*y
	#end
	#if (BootType = FORCE_BOOT)
		translate 5*y
	#end
	finish {ambient 0.2}
}
