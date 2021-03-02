#include "ccglobal.inc"
#include "colors.inc"

#declare FLOOR=0;

#declare BUTTON_GREEN=1;
#declare BUTTON_RED=2;
#declare BUTTON_BROWN=3;
#declare BUTTON_BLUE=4;

#declare HINT=5;
#declare TELEPORT=6;

#declare PASS_ONCE=7;

#declare QUICKSAND=8;
#declare EXIT=9;

#ifndef (FloorType)
	#declare FloorType= FLOOR;
#end

#ifndef (Step)
	#declare Step=0;
#end

#declare Reflect = 0.85;

#declare CamLoc = <0, 0, -6.52>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
	<-10, 10, -20> color White
//	<0, 0, -2> color White
}

light_source {
  <-20, 10, -50> 
//  <-2, 2, -2> 
  color rgb 0.5
  shadowless
}

//Block finish
#declare FShiny =
finish{
  ambient 0.075
  specular .2 roughness 3e-4
  phong .5 phong_size 5
  reflection .1*Reflect diffuse .9
}

#macro Floor()
box {
	<10, 10, 6>, <-10, -10, 100>
	pigment {color White}
}
#end

#declare CMGray0 = color_map {[0 rgb .8][1 rgb .7]}

#if (FloorType = FLOOR)
object {
	Floor()
}
#end

#if (FloorType >= BUTTON_GREEN & FloorType <= BUTTON_BLUE)
union {
	object {
		Floor()
	}
	cone {
		<0, 0, 6>, 1.4, <0, 0, 5>, 0.8
	}
	sphere {
		<0, 0, 5>, 0.8
		#if (FloorType = BUTTON_GREEN)
			pigment {Green}
		#end
		#if (FloorType = BUTTON_BLUE)
			pigment {Blue}
		#end
		#if (FloorType = BUTTON_RED)
			pigment {Red}
		#end
		#if (FloorType = BUTTON_BROWN)
//			pigment {color rgb <211/255,185/255,149/255>}
			pigment {color rgb <120/255,94/255,68/255>}
		#end
		finish {FShiny}
		no_shadow
	}
	pigment {color White}
}
#end

#if (FloorType = HINT | FloorType = TELEPORT)
difference {
	object {
		Floor()
	}
	cone {
		<0, 0, 5.5>, 2.5, <0, 0, 7>, 2
	}
	pigment {color White}
}

cylinder {
	<0,0,7>,<0,0,6.9>,3
	pigment {Yellow}
}

#if (FloorType = HINT)
text {
	ttf "ChalkboardBold.ttf" "?" 0.01, 0
//	ttf "/Library/Fonts/Verdana Bold.ttf" "?" 0.01, 0
	scale 2.2
	translate <-0.45, -0.7, 0>
	no_shadow
}
#end

#if (FloorType = TELEPORT)
#declare S=1;
	polygon {
		5, <S,S>,<S,-S>,<-S,-S>,<-S,S>,<S,S>
		pigment {
			image_map {
				png "tile-teleport.png"
			}
			translate <S/2,S/2,0>
			scale S*2
		}
		rotate Step*30*z
		no_shadow
	}
#end

#end

#if (FloorType = PASS_ONCE)

#macro Cap()
difference {
	cylinder {
		<0,0,0>,<0,0.25,0>,1
	}
	cylinder {
		<0,-0.1,0>,<0,0.2,0>,0.8
	}
	torus {
		0.8, 0.2
	}
}
#end

union {
	object {
		Floor()
	}
	cone {
		<0, 0, 6>, 3, <0, 0, 5>, 1.9
	}

	difference {
		cylinder {
			<0,0,0>,<0,1,0>,1
		}
		object {
			Cap()
			translate <0, 0.801, 0>
			scale <1.01, 1, 1.01>
		}
		rotate -90*x
		scale <1.9, 1.9, 1>
		translate <0, 0, 5>
		pigment {Gray30}
		finish {FShiny}
	}
	pigment {White}
}

#end


#if (FloorType = QUICKSAND)
//light_source {
//	<3, 0, 8> color rgb 0.3
//}

difference {
	object {
		Floor()
	}
	prism {
		conic_sweep
		linear_spline
		0, // height 1
		1, // height 2
		5, // the number of points making up the shape...
		<1,1>,<-1,1>,<-1,-1>,<1,-1>,<1,1>
		rotate <-90, 0, 0>
		scale <5,5,5>
		translate <0, 0, 8.5>
//		pigment {color rgb <237/255,204/255,170/255>}
		pigment {color rgb <179/255,169/255,149/255>}
	}
	no_shadow
	pigment {color White}
}

#declare S=1;
	polygon {
		5, <S,S>,<S,-S>,<-S,-S>,<-S,S>,<S,S>
		pigment {
			image_map {
				png "tile-quicksand.png"
			}
			translate <S/2,S/2,0>
			scale S*2
		}
		no_shadow
	}
#end

#if (FloorType = EXIT)
difference {
	object {
		Floor()
		pigment {color rgb <241/255,241/255,241/255>}
	}
	prism {
		conic_sweep
		linear_spline
		0, // height 1
		1, // height 2
		5, // the number of points making up the shape...
		<1,1>,<-1,1>,<-1,-1>,<1,-1>,<1,1>
		rotate <-90, 0, 0>
		scale <5,5,5>
		translate <0, 0, 9.1>
//		pigment {color rgb <241/255,241/255,241/255>}
		pigment {color White}
	}
	no_shadow
	pigment {color White}
}

#declare S=1;
	polygon {
		5, <S,S>,<S,-S>,<-S,-S>,<-S,S>,<S,S>
		pigment {
			image_map {
				png "tile-exit.png"
			}
			translate <S/2,S/2,0>
			scale S*2
		}
		scale 4
		translate 6.25*z
		rotate -Step*(45/4)*z
		no_shadow
	}
#end
