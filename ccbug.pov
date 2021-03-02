#include "ccglobal.inc"
#include "colors.inc"

#ifndef (Angle)
	#declare Angle = 0;
#end

#ifndef (Step)
	#declare Step = 0;
#end

#declare MaxStep=2;

#declare FrontAngle1 = array[3] {-20,20,40};
#declare FrontAngle2 = array[3] {-90,-60,-70};
#declare MidAngle1 = array[3] {-40,10,20};
#declare MidAngle2 = array[3] {120,140,110};
#declare BackAngle1 = array[3] {-50,5,45};
#declare BackAngle2 = array[3] {90,70,80};


#declare CamLoc = <0, 0, -40>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-75, 100, -125> color White
  area_light <0, 50, 0>, <-50, 0, 0>, 5, 5 jitter
}

light_source {
  <0, 0, -40> 
  color rgb 0.3
  shadowless
}

plane {
  -z, 0
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.1 diffuse 1.05 }
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

#macro Dot(_x, _y)
		difference {
			cylinder {
				<0, 0, 0>, <0, 0, -1.5>, 0.1
				translate <_x, _y, 0>
			}
			difference {
				sphere {
					<0, 0, 0>, 2
				}
				sphere {
					<0, 0, 0>, 1.02
				}
			}
			pigment {Black}
			finish {FShiny}
		}
#end

#macro Leg(_len1, _angle1, _len2, _angle2, _size)
union {
	cylinder {
		<0, 0, 0>, <_len1, 0, 0>, _size
		rotate _angle1*z
	}
	sphere {
		<0, 0, 0>, _size
		translate <_len1*cos(radians(_angle1)), _len1*sin(radians(_angle1)), 0>
	}
	cylinder {
		<0, 0, 0>, <-_len2, 0, 0>, _size
		rotate _angle2*z
		translate <_len1*cos(radians(_angle1)), _len1*sin(radians(_angle1)), 0>
	}
}
#end

union {
	union {
		sphere {
			<0, 0, 0>, 1
			pigment {Magenta}
			finish {FShiny}
		}
		difference {
			sphere {
				<0, 0, 0>, 1
			}
			box {
				<2, 0.4, 2>, <-2, 2, -2>
			}
			box {
				<1, 1, 1>, <-1, -1, -1>
				rotate 45*z
				translate -1.02*y
			}
			scale 1.01
			pigment {Yellow}
			finish {FShiny}
		}
		object {
			Dot(-0.45, 0.25)
		}
		object {
			Dot(0.45, 0.25)
		}
		object {
			Dot(-0.7, -0.05)
		}
		object {
			Dot(0.7, -0.05)
		}
		scale 5
		scale <1,1.2,1>
	}
	sphere {
		<0, 0, 0>, 2.5
		scale <1,0.7,1>
		translate 5.5*y
		pigment {Black}
		finish {FShiny}
	}
	// right front
	object {
		Leg(3, FrontAngle1[Step], 4.5, FrontAngle2[Step], 0.5)
		translate <3, 4, 0>
		pigment {Black}
		finish {FShiny}
	}
	// left front
	object {
		Leg(3, FrontAngle1[MaxStep-Step], 4.5, FrontAngle2[MaxStep-Step], 0.5)
		rotate 180*y
		translate <-3, 4, 0>
		pigment {Black}
		finish {FShiny}
	}
	// right mid
	object {
		Leg(2, MidAngle1[MaxStep-Step], 2, MidAngle2[MaxStep-Step], 0.5)
		translate <4.5, 2, 0>
		pigment {Black}
		finish {FShiny}
	}
	// left mid
	object {
		Leg(2, MidAngle1[Step], 2, MidAngle2[Step], 0.5)
		rotate 180*y
		translate <-4.5, 2, 0>
		pigment {Black}
		finish {FShiny}
	}
	// right back
	object {
		Leg(2.3, BackAngle1[Step], 6, BackAngle2[Step], 0.5)
		translate <4.5, -2, 0>
		pigment {Black}
		finish {FShiny}
	}
	// left back
	object {
		Leg(2.3, BackAngle1[MaxStep-Step], 7, BackAngle2[MaxStep-Step], 0.5)
		rotate 180*y
		translate <-4.5, -2, 0>
		pigment {Black}
		finish {FShiny}
	}
	rotate Angle*z				
//	no_image no_shadow
}
