#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare SE=0;
#declare SW=1;
#declare NW=2;
#declare NE=3;

#ifndef (WallType)
	#declare WallType=NW;
#end

// #declare CamLoc = <0, 0, -4.16>;  // 0.98 threshold
#declare CamLoc = <0, 0, -4.32>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <0, 10, -4> color rgb 0.7
//  fade_distance 20 fade_power 2
//  	parallel point_at <0, 0, 0>
}

light_source {
  <-10, 0, -4> color rgb 0.7
}

light_source {
  <20, -20, -20> 
  color rgb 0.5
}

#declare Reflect = 0.85;

#declare FShiny =
finish{
  ambient 0.075
  specular .2 roughness 3e-4
  phong .5 phong_size 5
  reflection .1*Reflect diffuse .9
}

#macro Corner(T,S)
blob {
	threshold T
	cylinder {
		<-1,-1,0>,<1,-1,0>,1,S
		
	}
	cylinder {
		<1,-1,0>,<1,1,0>,1,S
	}
	sphere {
		<1,-1,0>,1,-S
	}
//	pigment {color rgb <0.61,0.91,0.93>}
//	pigment {color rgb <130/255,206/255,210/255>}
	pigment {Cyan}
	finish {FShiny}
//	texture {Glass}
	no_shadow
}
#end

//background {color White}

object {
	Corner(0.96, 1)
	#if (WallType=SE)
		rotate 180*z
	#end
	#if (WallType=SW)
		rotate 90*z
	#end
	#if (WallType=NE)
		rotate -90*z
	#end
}
