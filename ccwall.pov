#include "ccglobal.inc"
#include "colors.inc"
#include "woods.inc"

#declare PLAIN=0;
#declare BLUE_DOOR=1;
#declare RED_DOOR=2;
#declare GREEN_DOOR=3;
#declare YELLOW_DOOR=4;

#declare WALL=0;
#declare BLOCK=1;
#declare BLUE_WALL=2;

#ifndef (WallType)
	#declare WallType=PLAIN;
#end

#ifndef (BlockType)
	#declare BlockType=WALL;
#end

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
  <-20, 20, -20> color White
//  fade_distance 20 fade_power 2
//  	parallel point_at <0, 0, 0>
}

light_source {
  <20, -20, -40> 
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


#macro Shave(R)
	difference {
		box {
			<1,1,1>,<-1,-1,-1>
		}
		/*
		cylinder {
			<1-R,1-R,1-R>,<1-R,-1+R,1-R>,R
		}
		cylinder {
			<-1+R,2,1-R>,<-1+R,-2,1-R>,R
		}
		*/
		cylinder {
			<1-R,2,-1+R>,<1-R,-2,-1+R>,R
		}
		cylinder {
			<-1+R,2,-1+R>,<-1+R,-2,-1+R>,R
		}
		box {
			<1.1,1.1,1.1>,<-1.1,-1.1,-1+R>
		}
		box {
			<1-R,1.1,1.1>,<-1+R,-1.1,-1.1>
		}
		scale 1.01
	}
#end

#macro Shave2(R)
	difference {
		box {
			<1,1,1>,<-1,-1,-1>
		}
		/*
		cylinder {
			<1-R,1-R,1-R>,<1-R,-1+R,1-R>,R
		}
		sphere {
			<1-R, 1-R, 1-R>, R
		}
		sphere {
			<1-R, -1+R, 1-R>, R
		}
		cylinder {
			<-1+R,1-R,1-R>,<-1+R,-1+R,1-R>,R
		}
		sphere {
			<-1+R,1-R,1-R>, R
		}
		sphere {
			<-1+R,-1+R,1-R>, R
		}
		*/
		cylinder {
			<1-R,1-R,-1+R>,<1-R,-1+R,-1+R>,R
		}
		sphere {
			<1-R,1-R,-1+R>, R
		}
		sphere {
			<1-R,-1+R,-1+R>, R
		}
		cylinder {
			<-1+R,1-R,-1+R>,<-1+R,-1+R,-1+R>,R
		}
		sphere {
			<-1+R,1-R,-1+R>, R
		}
		sphere {
			<-1+R,-1+R,-1+R>, R
		}
		box {
			<1.1,1.1,1.1>,<-1.1,-1.1,-1+R>
		}
		box {
			<1-R,1.1,1.1>,<-1+R,-1.1,-1.1>
		}
		scale 1.01
	}
#end

#macro Corner()
difference {
	box {
		<1,1,1>,<-1,-1,-1>
	}
	cylinder {
		<-1,-1,1.1>,<-1,-1,-1.1>,2
	}

	scale 1.01
}
#end

object {
	Corner()
	pigment {color Gray55}
	no_image	no_shadow
}

object {
	Shave(0.2)
	pigment {color Gray55}
	no_image	no_shadow
}

#macro Cube(R) 
superellipsoid {
	<R, R>
	 scale .5+R/4 
//	 translate V+.5
}
#end

#declare C = 0.5;
#declare S = 0.866;

#macro Hex()
difference {
prism {
    linear_sweep
    linear_spline
    0, // sweep the following shape from here ...
    1, // ... up through here
    7, // the number of points making up the shape ...
    <1,0>, <C,S>, <-C,S>, <-1,0>, <-C,-S>, <C,-S>, <1,0>
//    scale <5, 1, 5>
}
cylinder {
	<0,-0.1,0>,<0,1.1,0>,0.4
}
    rotate 90*x
    pigment { Green }
    finish {FShiny}
}
#end

#macro Diamond()
difference {
	box {
		<1,1,1>,<-1,-1,0>
	}
	cylinder {
		<0,0,-0.1>,<0,0,1.1>,0.4
	}
	rotate 45*z
	pigment { Cyan }
	finish {FShiny}
	scale <3.5, 3.5, 1>
}
#end

#macro Triangle()
difference {
	prism {
		linear_sweep
		linear_spline
		0, // sweep the following shape from here ...
		1, // ... up through here
		4, // the number of points making up the shape ...
		<0,-1>, <S,C>, <-S,C>, <0,-1>
	}
	cylinder {
		<0,-0.1,0>,<0,1.1,0>,0.2
	}
	rotate 90*x
	scale <5, 5, 1>
	pigment { Red }
	finish {FShiny}
}
#end

#macro Circle()
difference {
	cylinder {
		<0,0,0>,<0,0,1>,1
	}
	cylinder {
		<0,0,-0.1>,<0,0,1.1>,0.4
	}
	pigment { Yellow }
	finish {FShiny}
}
#end

// -----------------------------------------------------------

#declare CMGray1 = color_map {[0 rgb .5][1 rgb .4]}

difference {
	box {
		<1,1,1>, <-1,-1,-1>
	}
	object {
		Shave(0.5)
	}
	 object {
	 	Shave(0.5)
	 	rotate 90*z
	 }
	 // below is for the doors
	 #if(WallType != PLAIN & BlockType = WALL)
	 object {
	 	Cube(0.2)
	 	translate <0, 0, -1.4>
	 }
	 #end
	 #if (WallType = GREEN_DOOR)
	 object {
	 	Hex()
	 	scale <0.45,0.45,1>
	 	translate <0, 0, -1.8>
	 }
	 #end
	 #if (WallType = BLUE_DOOR)
	 object {
	 	Diamond()
	 	scale <0.1,0.1,1>
	 	translate <0, 0, -1.8>
	 }
	 #end
	 #if (WallType = RED_DOOR)
	 object {
	 	Triangle()
	 	scale <0.1,0.1,1>
	 	translate <0, -0.125, -1.8>
	 }
	 #end
	 #if (WallType = YELLOW_DOOR)
	 object {
	 	Circle()
	 	scale <0.4,0.4,1>
	 	translate <0, 0, -1.8>
	 }
	 #end
//	pigment{granite scale 1 colour_map{CMGray1}}
	#if (BlockType = WALL)
		pigment {color Gray40}
		finish{FShiny}
	#end
	#if (BlockType = BLOCK)
//		pigment {color rgb <211/255,185/255,149/255>}
		texture { 
			T_Wood20
			scale 4.0
  		rotate x*80
			rotate y*30
			rotate z*30
			translate x*0.3
			translate y*1
		}
		finish{FShiny}
	#end
	#if (BlockType = BLUE_WALL)
		pigment {color rgb <0/255,132/255,130/255>}
		finish{FShiny}
	#end
	scale 1.5
//	no_image	
	no_shadow
}
