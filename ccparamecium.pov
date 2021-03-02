#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#ifndef (Angle)
	#declare Angle = 180;
#end

#ifndef (Step)
	#declare Step = 0;
#end

#declare Squish = array[4][5] {
	{1,1,1,1,1},
	{1,1,0.9,0.8,1},
	{1,0.9,0.8,0.9,1},
	{1,0.8,0.9,1,1},
}

#declare CamLoc = <0, 0, -70>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-25, 100, -75> color White
  area_light <0, 50, 0>, <-50, 0, 0>, 5, 5 jitter
//  shadowless
}

light_source {
  <0, 0, -40> 
  color rgb 0.3
  shadowless
}

/*
light_source {
	<0, 0, -20>
	color rgb 1
	shadowless
}
*/

plane {
  -z, -1
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.3 diffuse 1.05 }
  }
}

#declare Reflect = 0.85;

#declare FShiny =
finish{
  ambient 0.075
  specular .2 roughness 3e-4
  phong .5 phong_size 5
  reflection .1*Reflect diffuse .9
}

union {

#local _x = 10;
#local a = 0;
#while (a < 5)
	union {
		sphere {
			<0, 0, 0>, 3.5
			pigment {color rgb <0.9, 0.5, 0.2>}
			finish {FShiny}
			scale <Squish[Step][a], 1.7, 1>
		}
		blob {
			threshold 0.2
			cylinder {
				<0, 0, 0>, <0, 5, 0>, 0.8, 1
			}
			pigment {Black}
			translate 5*y
		}
		blob {
			threshold 0.2
			cylinder {
				<0, 0, 0>, <0, -5, 0>, 0.8, 1
			}
			pigment {Black}
			translate -5*y
		}
		#if (a = 0)
			#local f = 30;
			#while (f <= 150)
				blob {
					threshold 0.2
					cylinder {
						<0, 0, 0>, <0, 5, 0>, 0.8, 1
					}
					pigment {Black}
					translate 5*y
					rotate -f*z
					scale <0.8,1,1>
				}
				#local f = f + 30;
			#end
		#end
		#if (a = 4)
			#local f = 30;
			#while (f <= 150)
				blob {
					threshold 0.2
					cylinder {
						<0, 0, 0>, <0, 5, 0>, 0.8, 1
					}
					pigment {Black}
					translate 5*y
					rotate f*z
					scale <0.8,1,1>
				}
				#local f = f + 30;
			#end
		#end
		translate <_x,0,0>
	}
	#local _d = min(Squish[Step][a], Squish[Step][min(a+1,4)]);
	#local _x = _x - (5*_d);
	#local a = a + 1;
#end

cylinder {
	<10, 0, 0>, <_x+5, 0, 0>, 2.9
	pigment {Black}
	scale <1, 1.7, 1>
}

//#local a = -4;
//#while (a <= 4)
//	blob {
//		threshold 0.2
//		cylinder {
//			<a, 0, 0>, <a, 5, 0>, 0.8, 1
//		}
//		pigment {Black}
//		translate 5*y
//	}
//	blob {
//		threshold 0.2
//		cylinder {
//			<a, 0, 0>, <a, -5, 0>, 0.8, 1
//		}
//		pigment {Black}
//		translate -5*y
//	}
//	#local a = a + 4;
//#end

//#local a = 0;
//#while (a <= 180)
//	blob {
//		threshold 0.2
//		cylinder {
//			<0, 0, 0>, <0, 5, 0>, 0.8, 1
//		}
//		pigment {Black}
//		translate 5*y
//		rotate a*z
//		translate -8*x
//	}
//	blob {
//		threshold 0.2
//		cylinder {
//			<0, 0, 0>, <0, 5, 0>, 0.8, 1
//		}
//		pigment {Black}
//		translate 5*y
//		rotate -a*z
//		translate 8*x
//	}
//	#local a = a + 30;
//#end

rotate Angle*z
}
