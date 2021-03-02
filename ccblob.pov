#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare CamLoc = <0, 0, -23>;

#ifndef (Dir)
	#declare Dir=0;
#end

#ifndef (Step)
	#declare Step=0;
#end

#declare Stretch = array[3] {1.2,1.4,1};
#declare Squish = array[3] {0.9,0.7,1};

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

blob {
	threshold 0.1
	sphere {
		<0, 1, 0>, 2, 2
	}
	sphere {
		<-2, 0, 0>, 2, 2
	}
	sphere {
		<-2, -1, 0>, 2, 2
	}
	sphere {
		<0.5, -0.5, 0>, 2.5, 2
	}
	sphere {
		<2, 0.5, 0>, 2, 2
	}
	sphere {
		<2, -2, 0>, 2, 2
	}
	sphere {
		<-2, -2.5, 0>, 2.5, 2
	}
	sphere {
		<0, -2, 0>, 2, 2
	}
	pigment {Green}
	material {M_Glass3}
	translate 1*y
	#if (Dir=0)
		scale <Squish[Step], Stretch[Step], 1>
	#else
		scale <Stretch[Step], Squish[Step], 1>
	#end
	finish {FShiny}
}
