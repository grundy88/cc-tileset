#include "ccglobal.inc"
#include "colors.inc"

#declare OFF=0;
#declare ON=1;

#ifndef (OutlineType)
	#declare OutlineType=ON;
#end

#ifndef (Step)
	#declare Step=0;
#end

//#declare CamLoc = <0, 0, -12.1>;
#declare CamLoc = <0, 0, -12.3>;

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
#declare T=0.85;
#declare S=1;
#declare D=3;

union {
	blob {
		threshold T
		cylinder {
			<-D,D,0>,<D,D,0>,1,S
		}
		pigment {
			checker 
				pigment {Green}, 
				pigment {Black}
				#if (OutlineType = ON)
				translate <-0.5,0.5,0.5>
				#else
				translate <0.5,0.5,0.5>
				#end
				translate -0.5*Step*x
		}
		#if (OutlineType = ON)
			finish {ambient 0.5}
		#end
	}
	blob {
		threshold T
		cylinder {
			<-D,D,0>,<-D,-D,0>,1,S
		}
		pigment {
			checker 
				pigment {Green}, 
				pigment {Black}
				#if (OutlineType = ON)
				translate <-0.5,0.5,0.5>
				#else
				translate <0.5,0.5,0.5>
				#end
				translate -0.5*Step*y
		}
		#if (OutlineType = ON)
			finish {ambient 0.5}
		#end
	}
	blob {
		threshold T
		cylinder {
			<-D,-D,0>,<D,-D,0>,1,S
		}
		pigment {
			checker 
				pigment {Green}, 
				pigment {Black}
				#if (OutlineType = ON)
				translate <-0.5,0.5,0.5>
				#else
				translate <0.5,0.5,0.5>
				#end
				translate 0.5*Step*x
		}
		#if (OutlineType = ON)
			finish {ambient 0.5}
		#end
	}
	blob {
		threshold T
		cylinder {
			<D,-D,0>,<D,D,0>,1,S
		}
		pigment {
			checker 
				pigment {Green}, 
				pigment {Black}
				#if (OutlineType = ON)
				translate <-0.5,0.5,0.5>
				#else
				translate <0.5,0.5,0.5>
				#end
				translate 0.5*Step*y
		}
		#if (OutlineType = ON)
			finish {ambient 0.5}
		#end
	}
//	pigment {
//		checker 
//			pigment {Green}, 
//			pigment {Black}
//		#if (OutlineType = ON)
//			translate <-0.5,0.5,0.5>
//		#else
//			translate <0.5,0.5,0.5>
//		#end
//	}
	no_shadow
}
