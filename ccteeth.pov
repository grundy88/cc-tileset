#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#ifndef (Angle)
	#declare Angle = 90;
#end

#ifndef (Step)
	#declare Step=2;
#end

#declare LegAngle = array[3] {30,0,-30};
#declare ArmAngle = array[3] {30,0,-30};

#declare MScale = array[3] {0.6,0.45,0.3};
#declare MRotate = array[3] {31,26,21};
#declare MTrans = array[3] {0.55,0.475,0.4};

#declare CamLoc = <0, 10, -50>;

camera {
  location CamLoc
  look_at  <0, -2, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-25, 100, -100> color White
  area_light <0, 50, 0>, <-50, 0, 0>, 5, 5 jitter
//  shadowless
}

light_source {
  <0, 0, -40> 
  color rgb 0.3
  shadowless
}

/*
light_source {
	<0, 0, -20>
	color rgb 1
	shadowless
}
*/

plane {
  -z, -100
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.1 diffuse 1.05 }
  }
}

plane {
  y, -15
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

#macro Shave(_radius)
difference {
	sphere {
		<0, 0, 0>, _radius*2
	}
	sphere {
		<0, 0, 0>, _radius
	}
}
#end

#macro Eye(_whiteRadius, _irisRadius)
difference {
	union {
		sphere {
			<0, 0, 0>, _whiteRadius
			pigment {White}
		}
		difference {
			cylinder {
				<0, 0, 0>, <0, 0, -_whiteRadius>, _irisRadius
			}
			object {
				Shave(_whiteRadius)
			}
			pigment {Red}
			translate <0, 0, -0.01>
		}
	}
	box {
		<1, 1, 0>, <-1, -1, -1>
		pigment {Black}
		translate <0, 0, -0.95>
	}
}
#end

//#declare W=0.13;
//#declare H=0.6;
#declare TH=1;

#macro Tooth(_w, _h, _s)
	polygon {
		4, <-_w,0>,<_w,0>,<0,_h>,<-_w,0>
		scale <1,_s,1>
	}
#end

#macro Jaw(_w, _h)
	#local a=0;
	#local m=1;

	union {
	#while (a <= 75)
		object {
			Tooth(_w, _h, m)
			rotate -20*x
			translate <0,TH,1>
			rotate y*a
		}
		object {
			Tooth(_w, _h, m)
			rotate -20*x
			translate <0,TH,1>
			rotate -y*a
		}
		#declare a=a+15;
		#declare m=m-0.15;
	#end
	}
#end

#macro Leg()
		blob {
			threshold 0.2
			cylinder {
				<0, -1, 0>, <0, 1, 0>, 1, 1
			}
			cylinder {
				<0, -1, 0.5>, <0, -1, -1>, 1, 1
			}
			sphere {
				<0, -1, 0>, 1, -1
			}
		}
#end

union {
	difference {
		sphere {
			<0, 0, 0>, 1
			pigment {Green}
		}
		prism {
			-1, 1,
			4, <1, 0>, <0, 1>, <-1, 0>, <1, 0>
			pigment {Gray20}
			scale <MScale[Step], 1, 1>
			rotate 90*z
			translate -1*z
		}
	}
	object {
		Jaw(0.13, 0.45)
		rotate 180*y
		rotate -MRotate[Step]*x
		translate <0, -0.85, MTrans[Step]>
		pigment {White}
	}
	object {
		Jaw(0.13, 0.55)
		rotate 180*z
		rotate 180*y
		rotate MRotate[Step]*x
		translate <0, 0.85, MTrans[Step]>
		pigment {White}
	}
	object {
		Eye(1, 0.7)
		scale 0.3
		translate <-0.4, 0.8, -0.6>
	}
	object {
		Eye(1, 0.7)
		scale 0.3
		translate <0.4, 0.8, -0.6>
	}
	object {
		Leg()
		scale <0.25, 0.25, 0.25>
		rotate 30*y
		rotate -20*z
		translate <-0.5, -1.1, 0>
		rotate -LegAngle[Step]*x
		pigment {Red}
	}
	object {
		Leg()
		scale <0.25, 0.25, 0.25>
		rotate -30*y
		rotate 20*z
		translate <0.5, -1.1, 0>
		rotate LegAngle[Step]*x
		pigment {Red}
	}
	blob {
		threshold 0.2
		cylinder {
			<0, 0, 0>, <0, 1, 0>, 1, 1
			scale <0.25, 0.25, 0.25>
			rotate 80*z
			rotate -ArmAngle[Step]*y
			translate <-1, 0.25, 0>
			pigment {Red}
		}
	}
	blob {
		threshold 0.2
		cylinder {
			<0, 0, 0>, <0, 1, 0>, 1, 1
			scale <0.25, 0.25, 0.25>
			rotate -80*z
			rotate -ArmAngle[Step]*y
			translate <1, 0.25, 0>
			pigment {Red}
		}
	}
	scale 9
	rotate Angle*y
}
