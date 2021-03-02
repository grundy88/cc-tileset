#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare BLUE=1;
#declare RED=2;
#declare GREEN=3;
#declare YELLOW=4;

#ifndef (KeyType)
	#declare KeyType=RED;
#end

#declare Reflect = 0.85;

#declare CamLoc = <0, 0, -32>;

background { color White }

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-10, 5, -10> color White
  area_light <0, 10, 0>, <-10, 0, 0>, 5, 5 jitter
}

light_source {
  <20, -20, -40> 
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

#declare C = 0.5;
#declare S = 0.866;

#macro Hex()
prism {
    linear_sweep
    linear_spline
    0, // sweep the following shape from here ...
    1, // ... up through here
    7, // the number of points making up the shape ...
    <1,0>, <C,S>, <-C,S>, <-1,0>, <-C,-S>, <C,-S>, <1,0>
    rotate 90*x
    scale <5, 5, 1>
}
#end

#macro Hex2()
difference {
	union {
		object {
			Hex()
			scale <1.1,1.1,1>
			translate <0,0,0.1>
			pigment {Black}
		}
		difference {
			object {
				Hex()
			}
			cylinder {
				<0,0,-0.1>,<0,0,1.1>,1.5
			}
		}
	}
	cylinder {
		<0,0,-0.1>,<0,0,1.1>,1.1
	}
	scale <1,1,1.5>
	translate <0,0,-0.2>
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

#macro Diamond2()
difference {
	union {
		box {
			<1.1,1.1,1>,<-1.1,-1.1,0>
			translate <0,0,0.1>
			pigment {Black}
		}
		difference {
			box {
				<1,1,1>,<-1,-1,0>
			}
			cylinder {
				<0,0,-0.1>,<0,0,1.1>,0.4
			}
		}
	}
	cylinder {
		<0,0,-0.1>,<0,0,1.1>,0.3
	}
	rotate 45*z
	pigment { Cyan }
	finish {FShiny}
	scale <3.5, 3.5, 1>
}
#end

#macro Circle2()
difference {
	union {
		cylinder {
			<0,0,0>,<0,0,-0.9>,1
			pigment {Black}
		}
		difference {
			cylinder {
				<0,0,0>,<0,0,-1>,0.9
			}
			cylinder {
				<0,0,0.1>,<0,0,-1.1>,0.3
			}
		}
	}
	cylinder {
		<0,0,0.1>,<0,0,-1.1>,0.2
	}
	scale <5, 5, 1.2>
	translate <0,0,1>
	pigment { Yellow }
	finish {FShiny}
}
#end

#macro Triangle()
prism {
    linear_sweep
    linear_spline
    0, // sweep the following shape from here ...
    1, // ... up through here
    4, // the number of points making up the shape ...
    <0,-1>, <S,C>, <-S,C>, <0,-1>
    rotate 90*x
    scale <5, 5, 1>
}
#end

#macro Triangle2()
difference {
	union {
		object {
			Triangle()
			scale <1.1,1.1,1>
			translate <0,0,0.1>
			pigment {Black}
		}
		difference {
			object {
				Triangle()
			}
			cylinder {
				<0,0,-0.1>,<0,0,1.1>,1.3
			}
		}
	}
	cylinder {
		<0,0,-1>,<0,0,2>,1
		pigment {Black}
	}
	scale <1.15,1.15,1.5>
	translate <0,-1.7,-0.5>
	pigment { Red }
	finish {FShiny}
}
#end

// ---------------------------------------

#if (KeyType = GREEN)
object {
	Hex2()
}
#end
#if (KeyType = BLUE)
object {
	Diamond2()
}
#end
#if (KeyType = RED)
object {
	Triangle2()
}
#end
#if (KeyType = YELLOW)
object {
	Circle2()
}
#end

plane {
  z, 1
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.1 diffuse 1.05 }
  }
}

/*
box {
        <10, 10, 0.7>, <-10, -10, 100>
        pigment {color White}
//      pigment{granite scale 1 colour_map{CMGray0} scale 5}
//      finish{FShiny}
}
*/
