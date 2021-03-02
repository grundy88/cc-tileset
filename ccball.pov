#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare CamLoc = <0, 0, -7>;

#declare HORIZONTAL=0;
#declare VERTICAL=1;

#ifndef (Direction)
	#declare Direction=VERTICAL;
#end

#ifndef (Step)
	#declare Step=3;
#end

#declare Angle = array[4] {0, 35, 90, 155};

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-130, 130, -250> color rgb 0.8
  area_light <0, 100, 0>, <-100, 0, 0>, 7, 7 jitter
}

light_source {
  <0, -0, -40> 
  color rgb 0.3
  shadowless
}

plane {
  -z, -0.5
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

#macro Spike()
cone {
	<0,0.5,0>,0
	<0,0,0>,0.2
}
#end

union {
	
sphere {
	<0, 0, 0>, 1
//	no_image
}

#declare Stripe=0.2;

difference {
	sphere {
		<0,0,0>, 1.01
	}
	box {
		<-Stripe,2,2>,<-2,-2,-2>
	}
	box {
		<Stripe,2,2>,<2,-2,-2>
	}
	#if (Direction = VERTICAL)
		rotate 90*z
	#end
	pigment {color rgb 0.9}
	finish {FShiny}
}


//#declare S=36;
//#declare M=10;
//
//#declare i=0;
//#while (i < M)
//
//#declare n=0;
//
//#while (n < M)
//object {
//	Spike()
//	translate 0.9*y
//	rotate -S*n*z
//	rotate S*i*y
//}
//#declare n=n+1;
//#end
//
//#declare i=i+1;
//#end

	pigment {color rgb <1, 0, 1>}
	finish {FShiny}
	#if (Direction=HORIZONTAL)
		rotate Angle[Step]*y
	#else
		rotate Angle[Step]*x
	#end
}