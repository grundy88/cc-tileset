#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare NORTH=0;
#declare WEST=1;
#declare SOUTH=2;
#declare EAST=3;
#declare SOUTHEAST=4;

#ifndef (WallType)
	#declare WallType=SOUTHEAST;
#end

#declare CamLoc = <0, 0, -4.35>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <0, 10, 0> color rgb 0.7
//  fade_distance 20 fade_power 2
//  	parallel point_at <0, 0, 0>
}

light_source {
  <-10, 0, 0> color rgb 0.7
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

#macro Wall(R)
union {
	cylinder {
		<-1,0,0>,<1,0,0>,R
	}
	sphere {
		<-1,0,0>,R
	}
	sphere {
		<1,0,0>,R
	}
	pigment {Gray50}
	finish {FShiny}
}
#end

//background {color White}

#if (WallType != SOUTHEAST)
object {
	Wall(0.15)
	#if (WallType = NORTH)
		translate <0,1.005,0>
	#end
	#if (WallType = SOUTH)
		translate <0,-1.00,0>
	#end
	#if (WallType = WEST)
		rotate 90*z
		translate <-1.00,0,0>
	#end
	#if (WallType = EAST)
		rotate 90*z
		translate <1,0,0>
	#end
}
#else
union {
	object {
		Wall(0.15)
		rotate 90*z
		translate <1,0,0>
	}
	object {
		Wall(0.15)
		translate <0,-1,0>
	}
}	
#end