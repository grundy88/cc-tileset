#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare MACHINE=0;
#declare BLOCK_N=1;
#declare BLOCK_W=2;
#declare BLOCK_S=3;
#declare BLOCK_E=4;


#ifndef (CloneType)
	#declare CloneType=MACHINE;
//	#declare CloneType=BLOCK_N;
#end

#ifndef (Step)
	#declare Step=3;
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
	<-10, 10, -50> color rgb 0.7
//	shadowless
}

light_source {
  <-20, 20, -50> 
  color rgb 0.5
  shadowless
}
/*
plane {
	-z, 0
	pigment { color rgb 1 }
	finish { ambient 0.1 diffuse 1.05 }
}
*/

//#declare T=0.65;
//#declare S=1;
//#declare D=2.5;


#macro Thing(T,D,S)
union {
	blob {
		threshold T
		cylinder {
			<-D,D,0>,<D,D,0>,1,S
		}
	}
	blob {
		threshold T
		cylinder {
			<-D,D,0>,<-D,-D,0>,1,S
		}
	}
	blob {
		threshold T
		cylinder {
			<-D,-D,0>,<D,-D,0>,1,S
		}
	}
	blob {
		threshold T
		cylinder {
			<D,-D,0>,<D,D,0>,1,S
		}
	}
	no_shadow
}
#end

#declare Reflect = 0.85;

#declare FShiny =
finish{
  ambient 0.075
  specular .2 roughness 3e-4
  phong .5 phong_size 5
  reflection .1*Reflect diffuse .9
}
/*
#declare MeshWidth = 2.5;
#declare MeshRadius = 0.2;
#declare MeshCount = 5;

object {
	Thing(0.85,MeshWidth,1.5)
	pigment { Gray55 }
//	texture {Glass}
	finish {FShiny}
}

#local _i = MeshWidth;

#while (_i > -MeshWidth)
cylinder {
	<-MeshWidth, _i, 0>, <MeshWidth, _i, 0>, MeshRadius
	pigment {Blue}
	finish {ambient 0.2}
}
cylinder {
	<_i, -MeshWidth, 0>, <_i, MeshWidth, 0>, MeshRadius
	pigment {Blue}
	finish {ambient 0.2}
}
#local _i = _i - (MeshWidth * 2 / MeshCount);
#end
*/
#macro Cube(R) 
superellipsoid {
	<R, R>
	 scale .5+R/4 
//	 translate V+.5
}
#end
/*
object {
	Cube(0.2)
	pigment {Gray50}
	finish {FShiny}
}
*/
/*
box {
	<0.55,0.55,0>,<-0.55,-0.55,-0.5>
	pigment {Gray20}
	finish {FShiny}
}
*/
/*
object {
	Cube(0.2)
	scale <19, 19, 19>
	pigment {Blue}
	finish {FShiny}
}
*/
difference {
object {
	Cube(0.2)
	scale <15, 15, 15>
	translate <0, 0, -5>
}
object {
	Cube(0.2)
	scale <11, 11, 11>
	translate <0, 0, -18>
}
#if (CloneType = MACHINE)
	pigment {Gray20}
#else
	pigment {Orange}
#end
	finish {FShiny}
}

#if (CloneType = MACHINE)

#declare MeshWidth = 6.2;
#declare MeshRadius = 0.2;
#declare MeshCount = 5;
#declare MeshZ = -12.5;

#local _i = MeshWidth;

#while (_i > -MeshWidth)
cylinder {
	<-MeshWidth, _i, MeshZ>, <MeshWidth, _i, MeshZ>, MeshRadius
	pigment {Red}
	finish {ambient 0.2}
}
cylinder {
	<_i, -MeshWidth, MeshZ>, <_i, MeshWidth, MeshZ>, MeshRadius
	pigment {Red}
	finish {ambient 0.2}
}
#local _i = _i - (MeshWidth * 2 / MeshCount);
#end

#else

#macro Shave(R)
	difference {
		box {
			<1,1,1>,<-1,-1,-1>
		}
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

#macro Block()
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
	pigment {color rgb <211/255,185/255,149/255>}
}
#end

object {
	Block()
	scale <6, 6, 6>
	translate <0, 0, -10>
}
#end

#declare CB = 8;
#declare CT = 8;
#declare CBZ = 0;
#declare CTZ = -15;
#declare CR = 1;
#declare CAmbience = 0.5;
#declare CPigment = Orange;

#if (CloneType = MACHINE | CloneType = BLOCK_N | CloneType = BLOCK_W)
cylinder {
	<-CB, CB, CBZ>, <-CT, CT, CTZ>, CR
	pigment {CPigment}
	finish {ambient CAmbience}
	no_shadow
}
#end

#if (CloneType = MACHINE | CloneType = BLOCK_N | CloneType = BLOCK_E)
cylinder {
	<CB, CB, CBZ>, <CT, CT, CTZ>, CR
	pigment {CPigment}
	finish {ambient CAmbience}
	no_shadow
}
#end

#if (CloneType = MACHINE | CloneType = BLOCK_S | CloneType = BLOCK_E)
cylinder {
	<CB, -CB, CBZ>, <CT, -CT, CTZ>, CR
	pigment {CPigment}
	finish {ambient CAmbience}
	no_shadow
}
#end

#if (CloneType = MACHINE | CloneType = BLOCK_S | CloneType = BLOCK_W)
cylinder {
	<-CB, -CB, CBZ>, <-CT, -CT, CTZ>, CR
	pigment {CPigment}
	finish {ambient CAmbience}
	no_shadow
}
#end

// -----------------------------------------------------------------------
// lightning bolts around the edges
#include "lightning.pov"

#macro Bolt(Seed)
    #declare b = Make_Bolt(500, Seed, 0.1, CT/2, 0.0, 0.1, 0.1, 0.1)
    union {
        object{
          b
          translate y*-CT/2
        }
        object{
          b
          rotate x*180
          translate y*CT/2
        }
        pigment{color rgb <125/255,249/255,255/255>}
        interior{media{emission<3,3,5>*5}}
        hollow
        no_shadow
        scale <2, 2, 2>
        translate z*(CTZ+1)
    }
#end

#if (CloneType = MACHINE | CloneType = BLOCK_N)
    object {
        //Bolt(11211+Step)
				Bolt(Step)
        rotate z*90
        translate y*CT
    }        
#end
#if (CloneType = MACHINE | CloneType = BLOCK_W)
    object {
        //Bolt(11311+Step)
				Bolt(Step)
        translate x*CT
    }        
#end
#if (CloneType = MACHINE | CloneType = BLOCK_S)
    object {
        //Bolt(11411+Step)
				Bolt(Step)
        rotate z*90
        translate y*-CT
    }        
#end
#if (CloneType = MACHINE | CloneType = BLOCK_E)
    object {
        //Bolt(11511+Step)
				Bolt(Step)
        translate x*-CT
    }        
#end
