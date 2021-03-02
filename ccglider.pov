#include "ccglobal.inc"
#include "colors.inc"

#ifndef (Angle)
	#declare Angle = 90;
#end

#declare CamLoc = <0, 0, -55>;

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
  area_light <0, 100, 0>, <-100, 0, 0>, 7, 7 jitter
}

light_source {
  <0, 0, -40> 
  color rgb 0.3
  shadowless
}

plane {
  -z, -4
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.2 diffuse 1.05 }
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

#macro Shave()
difference {
	cylinder {
		<0, 0, 0>, <0, 1, 0>, 1
	}
	torus {
		1, 0.5
		translate 0.5*y
	}
}
#end

#local R=2;
#local X1=2;
#local Y1=10;
#local X2=10;
#local Y2=2;
#local Y3=-10;

union {
	difference {
		union {
			cylinder {
				<-X1, Y1, 0>, <X1, Y1, 0>, R
			}
			sphere {
				<-X1, Y1, 0>, R
			}
			cylinder {
				<-X1, Y1, 0>, <-X2, Y2, 0>, R
			}
			sphere {
				<-X2, Y2, 0>, R
			}
			cylinder {
				<-X2, Y2, 0>, <-X2, Y3, 0>, R
			}
			sphere {
				<-X2, Y3, 0>, R
			}
			sphere {
				<X1, Y1, 0>, R
			}
			cylinder {
				<X1, Y1, 0>, <X2, Y2, 0>, R
			}
			sphere {
				<X2, Y2, 0>, R
			}
			cylinder {
				<X2, Y2, 0>, <X2, Y3, 0>, R
			}
			sphere {
				<X2, Y3, 0>, R
			}
			sphere {
				<0, Y3, 0>, R
			}
			prism {
				-R, R,
				7, <X1,Y1>, <-X1,Y1>, <-X2,Y2>, <-X2,Y3>, <X2,Y3>, <X2,Y2>, <X1,Y1>
				rotate -90*x
			}
		}
		object {
			Shave()
			rotate -90*x
			scale <8, 8, R*2+0.02>
			translate <-X2/2, Y3-1.8, R+0.01>
		}
		object {
			Shave()
			rotate -90*x
			scale <8, 8, R*2+0.02>
			translate <X2/2, Y3-1.8, R+0.01>
		}
		pigment {Black}
		finish {FShiny}
	}
	prism {
		0, 0.1,
		5, <0, 0>, <0, 1>, <0.2, 0.8>, <0.2, -0.1>, <0, 0>
		rotate -90*x
		scale <14, 12, 10>
		translate <1.5, -4, -R-0.01>
		pigment {Red}
		finish {FShiny}
	}
	prism {
		0, 0.1,
		5, <0, 0>, <0, 1>, <0.2, 0.8>, <0.2, -0.1>, <0, 0>
		rotate -90*x
		rotate 180*y
		scale <14, 12, 10>
		translate <-1.5, -4, -R-0.01>
		pigment {Red}
		finish {FShiny}
	}
	rotate Angle*z
}
