#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare HORIZONTAL=0;
#declare VERTICAL=1;

#ifndef (WalkerType)
	#declare WalkerType=VERTICAL;
#end

#ifndef (Step)
	#declare Step=2;
#end

#declare Angle = array[3] {20,0,-20}

#declare CamLoc = <0, 0, -7>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-100, 100, -250> color rgb 0.7
  area_light <0, 100, 0>, <-100, 0, 0>, 7, 7 jitter
}

light_source {
  <0, -0, -40> 
  color rgb 0.3
  shadowless
}

plane {
  -z, -1
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

sphere {
	<0, 0, 0>, 1
	pigment {color rgb <0, 1, 1>}
	finish {FShiny}
}

blob {
	threshold 0.1
	cylinder {
		<-1.55,0,0>,<1.55,0,0>,0.4,0.5
	}
	texture {Chrome_Metal}
	#if (WalkerType = VERTICAL)
		rotate 90*z
		rotate <Angle[Step], 0, Angle[Step]>
	#else
		rotate <0, Angle[Step], Angle[Step]>
	#end
}
