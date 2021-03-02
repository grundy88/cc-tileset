#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare CamLoc = <2, 0, -6>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
	<-5, 5, -20> color rgb 1
  area_light <0, 10, 0>, <-10, 0, 0>, 5, 5 jitter
//	shadowless
}

light_source {
  <-2, 2, -10> 
  color rgb 0.1
  shadowless
}

plane {
	-z, -0
	pigment { color rgb 1 }
	finish { ambient 0.1 diffuse 1.05 }
}

cylinder {
	<0, 0, 0>, <0, 0, -0.3>, 1
//	pigment {Yellow}
//	texture {Silver_Metal}
	texture {New_Brass}
//	pigment {Silver}
//	finish {Metallic_Finish}
	normal {
		bump_map {
			png "tile-embosschip.png"
			once
			bump_size 0.5
		}
		scale <2.3,2.3,2.3>
		translate <-1.15, -1.15, 0>
	}
}

difference {
	cylinder {
		<0, 0, 0>, <0, 0, -0.6>, 1
	}
	cylinder {
		<0, 0, 2>, <0, 0, -2>, 0.8
	}
//	texture {Silver_Metal}
	texture {New_Brass}
}
