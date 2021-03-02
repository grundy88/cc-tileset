#include "ccglobal.inc"
#include "colors.inc"

#declare CamLoc = <0, 20, -50>;

camera {
  location CamLoc
  look_at  <0, 0, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-100, 100, 100> color White
}

light_source {
  <0, 10, -40> 
  color rgb 0.5
  shadowless
}

plane {
  y, 0
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.4 diffuse 1 }
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

#declare W=1.3;
#declare H=3;
#declare TH=1;

#macro Tooth(m)
	polygon {
		4, <-W,0>,<W,0>,<0,H>,<-W,0>
		scale <1,m,1>
	}
#end

#declare a=0;
#declare m=1;

union {
	difference {
		cylinder {
			<0,0,0>,<0,TH,0>,10
		}
		cylinder {
			<0,-0.1,0>,<0,TH+0.1,0>,9.9
		}
	}
	cylinder {
		<0,TH/2,10>,<0,TH/2,-10>,0.5
	}
	
	#while (a <= 90)
		object {
			Tooth(m)
			translate <0,TH,-10>
			rotate y*a
		}
		object {
			Tooth(m)
			translate <0,TH,10>
			rotate y*a
		}
		object {
			Tooth(m)
			translate <0,TH,-10>
			rotate -y*a
		}
		object {
			Tooth(m)
			translate <0,TH,10>
			rotate -y*a
		}
		#declare a=a+15;
		#declare m=m+0.1;
	#end

	translate <-8,0,-14>
	rotate y*-30
	scale 0.8
	pigment {color rgb 0.7}
//	pigment {Silver}
	finish {FShiny}
}
