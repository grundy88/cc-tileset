#include "ccglobal.inc"
#include "colors.inc"

#ifndef (Step)
  #declare Step=1;
#end

#declare CamLoc = <0, 0, -7>;

camera {
  location CamLoc
  look_at  <-0.2, 0.5, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-100, 100, -100> color White
}

light_source {
  <0, -0, -40> 
  color rgb 0.5
  shadowless
}

plane {
  -z, 0.1
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

#declare S=0.8;

union {
	sphere {
		<0, 0, 0>, 1
	}
	cylinder {
		<0, 0, 0>, <0, 1.3, 0>, 0.4
	}
	cylinder {
		<0, 0, 0>, <0, 2, 0>, 0.1
		pigment {Black}
		no_shadow
	}
	cylinder {
		<0.05, 1.95, 0>, <-0.7, 2.1, 0>, 0.08
		pigment {Black}
		no_shadow
	}
	polygon {
		5, <S,S>,<S,-S>,<-S,-S>,<-S,S>,<S,S>
		pigment {
			image_map {
				#if (Step = 1)
					png "spark-ax.png"
				#end
				#if (Step = 2)
					png "spark-bx.png"
				#end
				#if (Step = 3)
					png "spark-cx.png"
				#end
				#if (Step = 4)
					png "spark-dx.png"
				#end
			}
			translate <0.5,0.5,0>
			scale S*2
		}
		scale 0.6
		translate <-0.6, 2.2, -0.2>
		finish { ambient 0.7 diffuse 0.8 }
		no_shadow
//		no_image
	}
	rotate x*-40
	rotate z*20
	pigment {Red}
//	finish { ambient 0.3 diffuse 0.8 }
}
