#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#ifndef (Angle)
	#declare Angle = 180;
#end

#declare CamLoc = <0, 0, -50>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-100, 100, -75> color White
  area_light <0, 100, 0>, <-100, 0, 0>, 5, 5 jitter
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
    finish { ambient 0.5 diffuse 1.05 }
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
cylinder {
	<-8, 0, 0>,<8, 0, 0>, 10
	scale <1, 1, 0.2>
	pigment {Blue}
	finish {FShiny}
}

cylinder {
	<8, 0, 0>,<12, 0, 0>, 8
	scale <1, 1, 0.2>
	translate <0, -1, 0>
	pigment {White}
}

cylinder {
	<-8, 0, 0>,<-12, 0, 0>, 8
	scale <1, 1, 0.2>
	translate <0, -1, 0>
	pigment {White}
}

sphere {
	<0, 0, -8>, 5
	scale <1, 1, 0.4>
	translate <0, -1, 0>
	pigment {Blue}
	finish {FShiny}
}

cylinder {
	<0,0,0>,<0,12,0>, 2
	translate <0, 0, -3>
	pigment {White}
	finish {Metal}
}
rotate Angle*z
}
