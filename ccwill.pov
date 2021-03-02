#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare NORTH=0;
#declare WEST=1;
#declare SOUTH=2;
#declare EAST=3;
#declare EXIT=4;

#ifndef (Direction)
	#declare Direction=EXIT;
#end

#ifndef (Step)
	#declare Step=0;
#end

#ifndef (Push)
	#declare Push=0;
#end

#declare MS=0;
#declare LYNX=1;
#ifndef (Mode)
  #declare Mode=MS;
#end

#switch (Direction)
#case (NORTH)
	#declare Angle=180;
	#declare HeadAngle=0;
	#break
#case (WEST)
  #if (Mode=MS)
	  #declare Angle=80;
  	#declare HeadAngle=-40;
  #else
	  #declare Angle=80;
  	#declare HeadAngle=-40;
	#end
	#break
#case (SOUTH)
	#declare Angle=0;
	#declare HeadAngle=0;
	#break
#case (EAST)
  #if (Mode=MS)
	  #declare Angle=-85;
  	#declare HeadAngle=45;
  #else
  	#declare Angle=-70;
	  #declare HeadAngle=30;
	#end
	#break
#case (EXIT)
	#declare Angle=0;
	#declare HeadAngle=0;
	#break
#end

#declare HeadRadius = 6;
#declare MouthZOffset = 0.9;
#declare MouthYOffset = 0.2;
#declare HeadYCenter = HeadRadius+1.2;
#declare BodyRatio = 0.8;
#declare BodyYTop = 2.5;
#declare BodyLength = 6.5;
#declare ArmSegmentLength = 3;
#declare ArmSize = 1.5;
#declare HandSize = 1.5;
#declare BeltWidth = 0.5;
#declare LegSegmentLength = 3.5;
#declare FootHeight = 1;

#if (Direction=EXIT)
	#declare RightArmTop = array[3] {160,160,160};
	#declare RightArmBottom = array[3] {160,160,160};
	#declare RightArmOutY = 0;
	#declare RightArmOutZ = 35;
	#declare LeftArmTop = array[3] {160,160,160};
	#declare LeftArmBottom = array[3] {160,160,160};
	#declare LeftArmOutY = 0;
	#declare LeftArmOutZ = -35;
	#declare RightLegTop = array[3] {0,0,0};
	#declare RightLegBottom = array[3] {0,0,0};
	#declare LeftLegTop = array[3] {0,0,0};
	#declare LeftLegBottom = array[3] {0,0,0};
  #declare BodyLean=0;
	#declare BodyShift=0;
#else
	#if (Push=0)
    #if (Mode=MS)
    	#declare RightArmTop = array[1] {85};
    	#declare RightArmBottom = array[1] {85};
    	#declare LeftArmTop = array[1] {-60};
    	#declare LeftArmBottom = array[1] {-60};
		#else
    	#declare RightArmTop = array[3] {-45,0,35};
    	#declare RightArmBottom = array[3] {-10,20,125};
    	#declare LeftArmTop = array[3] {35,0,-45};
    	#declare LeftArmBottom = array[3] {125,20,-10};
		#end
		#declare BodyLean=0;
		#declare BodyShift=0;
	#else
		#declare RightArmTop = array[3] {125,125,125};
		#declare RightArmBottom = array[3] {125,125,125};
		#declare LeftArmTop = array[3] {125,125,125};
		#declare LeftArmBottom = array[3] {125,125,125};
		#declare BodyLean=-30;
		#declare BodyShift=-3;
	#end
  #if (Mode=MS)
  	#declare RightArmOutY = 10;
  	#declare LeftArmOutY = 10;
    #declare RightLegTop = array[1] {-30};
    #declare RightLegBottom = array[1] {-50};
    #declare LeftLegTop = array[1] {70};
    #declare LeftLegBottom = array[1] {20};
  #else
  	#declare RightArmOutY = -10;
  	#declare LeftArmOutY = 10;
    #declare RightLegTop = array[3] {70,0,-30};
    #declare RightLegBottom = array[3] {20,0,-50};
    #declare LeftLegTop = array[3] {-30,0,70};
    #declare LeftLegBottom = array[3] {-50,0,20};
  #end
	#declare RightArmOutZ = 0;
	#declare LeftArmOutZ = 0;
#end

#if (Mode=MS)
  #declare CamLoc = <0, 10, -50>;
#else
  #declare CamLoc = <0, 30, -50>;
#end

camera {
  location CamLoc
  look_at  <0, 0.5, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
  <-30, 50, -125> color rgb 1
//  area_light <0, 20, 0>, <-20, 0, 0>, 5, 5 jitter
  shadowless
}

light_source {
  <-20, 20, 20> 
  color rgb 1
}

light_source {
  <0, 0, -40> 
  color rgb 0.3
  shadowless
}

light_source {
  <70, 0, 90> 
  color rgb 0.5
  shadowless
}

light_source {
  <-40, 0, 90> 
  color rgb 0.5
  shadowless
}

plane {
  -z, -100
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.1 diffuse 1.05 }
  }
}

plane {
  y, -15.5
  texture { 
    pigment { color rgb 1 }
    finish { ambient 0.5 diffuse 1.05 }
  }
}

#macro Shave(_radius)
difference {
	sphere {
		<0, 0, 0>, _radius*2
	}
	sphere {
		<0, 0, 0>, _radius
	}
	translate <0, 0, _radius-0.5>
}
#end

#macro Eye(_whiteRadius, _irisRadius, _pupilRadius, _curvatureRadius)
union {
	difference {
		cylinder {
			<0, 0, 0>, <0, 0, -1>, _whiteRadius
		}
		object {
			Shave(_curvatureRadius)
		}
		pigment {White}
	}
	difference {
		cylinder {
			<0, 0, 0>, <0, 0, -1>, _irisRadius
		}
		object {
			Shave(_curvatureRadius)
		}
		pigment {Blue}
		translate <0, 0, -0.01>
	}
	difference {
		cylinder {
			<0, 0, 0>, <0, 0, -1>, _pupilRadius
		}
		object {
			Shave(_curvatureRadius)
		}
		pigment {Black}
		translate <0, 0, -0.02>
	}
}
#end

#macro Mouth()
difference {
	cylinder {
		<0,0,0>, <0,0,-1>, 1
	}
	cylinder {
		<0,0,0.1>,<0,0,-1.1>, 0.7
	}
	difference {
		cylinder {
			<0,0,1>, <0,0,-2>, 10
		}
		cylinder {
			<0,0,1.1>,<0,0,-2.1>, 1.5
		}
		translate -2*y
	}
//	box {
//		<2,0,2>,<-2,2,-2>
//	}
	pigment {Black}
}
#end


union {
	
// upper body
union {
	
// head
union {
	
difference {
sphere {
	<0, 0, 0>, 1
	pigment {color rgb <250/255,220/255,170/255>}
	finish {ambient 0.3}
}
object {
	Mouth()
	scale <0.5, 0.4, 0.5>
	translate <0, -0.1, -0.5>
}
//box {
//	<10, -MouthYOffset, -MouthZOffset>, <-10, -MouthYOffset-0.1, -10>
//	pigment {Black}
//	rotate -10*x
//}
}

// hair
difference {
	sphere {
		<0, 0, 0>, 1
	}
	box {
		<1, 1, 1>, <-1, -1, -1>
		rotate 65*x
		translate <0, -0.82, -0.97>
	}
	box {
		<1, 1, 1>, <-1, -1, -1>
		translate <0, -0.5, -1.5>
	}
	pigment {Brown}
	scale <1.01, 1.01, 1.01>
	translate <0, 0.01, 0>
}

// eyes
object {
	Eye(1, 0.7, 0.4, 3)
	scale 0.2
	rotate 16*y
	rotate 7*x
	translate <-0.26, 0.1, -0.88>
}

object {
	Eye(1, 0.7, 0.4, 3)
	scale 0.2
	rotate -16*y
	rotate 7*x
	translate <0.26, 0.1, -0.88>
}

scale HeadRadius
rotate HeadAngle*y
translate <0, HeadYCenter, 0>
}

// body
cylinder {
	<0,0,0>, <0,-BodyLength,0>, 4.5
	scale <1, 1, BodyRatio>
	pigment {Blue}
	translate <0, BodyYTop, 0>
}

// right arm and hand
union {
	// shoulder
	sphere {
		<0, 0, 0>, ArmSize
		scale <1, BodyRatio, BodyRatio>
	}
	// upper arm
	cylinder {
		<0, 0, 0>, <0, -ArmSegmentLength, 0>, ArmSize
		scale <1, 1, BodyRatio>
		rotate RightArmTop[Step]*x
	}
	// elbow
	sphere {
		<0, 0, 0>, ArmSize
		scale <1, BodyRatio, BodyRatio>
		translate <0, -ArmSegmentLength*cos(radians(RightArmTop[Step])), -ArmSegmentLength*sin(radians(RightArmTop[Step]))>
	}
	union {
		// lower arm
		cylinder {
			<0, 0, 0>, <0, -ArmSegmentLength, 0>, ArmSize
			scale <1, 1, BodyRatio>
		}
		// hand
		sphere {
			<0, -ArmSegmentLength, 0>, HandSize
			pigment {color rgb <250/255,220/255,170/255>}
			translate <0, -0.7, 0>
			finish {ambient 0.3}
		}
		rotate RightArmBottom[Step]*x
		translate <0, -ArmSegmentLength*cos(radians(RightArmTop[Step])), -ArmSegmentLength*sin(radians(RightArmTop[Step]))>
	}
	pigment {Blue}
	rotate <0, RightArmOutY, RightArmOutZ>
	translate <-4.5, BodyYTop-1.5, 0>
}

// left arm and hand
union {
	// shoulder
	sphere {
		<0, 0, 0>, ArmSize
		scale <1, BodyRatio, BodyRatio>
	}
	// upper arm
	cylinder {
		<0, 0, 0>, <0, -ArmSegmentLength, 0>, ArmSize
		scale <1, 1, BodyRatio>
		rotate LeftArmTop[Step]*x
	}
	// elbow
	sphere {
		<0, 0, 0>, ArmSize
		scale <1, BodyRatio, BodyRatio>
		translate <0, -ArmSegmentLength*cos(radians(LeftArmTop[Step])), -ArmSegmentLength*sin(radians(LeftArmTop[Step]))>
	}
	union {
		// lower arm
		cylinder {
			<0, 0, 0>, <0, -ArmSegmentLength, 0>, ArmSize
			scale <1, 1, BodyRatio>
		}
		// hand
		sphere {
			<0, -ArmSegmentLength, 0>, HandSize
			pigment {color rgb <250/255,220/255,170/255>}
			translate <0, -0.7, 0>
			finish {ambient 0.3}
		}
		rotate LeftArmBottom[Step]*x
		translate <0, -ArmSegmentLength*cos(radians(LeftArmTop[Step])), -ArmSegmentLength*sin(radians(LeftArmTop[Step]))>
	}
	pigment {Blue}
	rotate <0, LeftArmOutY, LeftArmOutZ>
	translate <4.5, BodyYTop-1.5, 0>
}

// belt
cylinder {
	<0,0,0>, <0,-BeltWidth,0>, 4.5
	scale <1, 1, BodyRatio>
	pigment {White}
	translate <0, BodyYTop-BodyLength, 0>
}

rotate BodyLean*x
translate BodyShift*z
}

// right leg
union {
	sphere {
		<0, 0, 0>, 2.5
		scale <1, BodyRatio, BodyRatio>
	}
	cylinder {
		<0, 0, 0>, <0, -LegSegmentLength, 0>, 2.5
		scale <1, 1, BodyRatio>
		rotate RightLegTop[Step]*x
	}
	sphere {
		<0, 0, 0>, 2.5
		scale <1, BodyRatio, BodyRatio>
		translate <0, -LegSegmentLength*cos(radians(RightLegTop[Step])), -LegSegmentLength*sin(radians(RightLegTop[Step]))>
	}
	union {
		cylinder {
			<0, 0, 0>, <0, -LegSegmentLength, 0>, 2.5
			scale <1, 1, BodyRatio>
		}
		cylinder {
			<0, -LegSegmentLength, 0>, <0, -LegSegmentLength-FootHeight, 0>, 2.5
			scale <1.05, 1, BodyRatio+0.1>
			translate <0, 0, -0.2>
			pigment {Brown}
		}
		rotate RightLegBottom[Step]*x
		translate <0, -LegSegmentLength*cos(radians(RightLegTop[Step])), -LegSegmentLength*sin(radians(RightLegTop[Step]))>
	}
	pigment {Green}
	translate <-2, BodyYTop-BodyLength-BeltWidth, 0>
}

// left leg
union {
	sphere {
		<0, 0, 0>, 2.5
		scale <1, BodyRatio, BodyRatio>
	}
	cylinder {
		<0, 0, 0>, <0, -LegSegmentLength, 0>, 2.5
		scale <1, 1, BodyRatio>
		rotate LeftLegTop[Step]*x
	}
	sphere {
		<0, 0, 0>, 2.5
		scale <1, BodyRatio, BodyRatio>
		translate <0, -LegSegmentLength*cos(radians(LeftLegTop[Step])), -LegSegmentLength*sin(radians(LeftLegTop[Step]))>
	}
	union {
		cylinder {
			<0, 0, 0>, <0, -LegSegmentLength, 0>, 2.5
			scale <1, 1, BodyRatio>
		}
		cylinder {
			<0, -LegSegmentLength, 0>, <0, -LegSegmentLength-FootHeight, 0>, 2.5
			scale <1.05, 1, BodyRatio+0.1>
			translate <0, 0, -0.2>
			pigment {Brown}
		}
		rotate LeftLegBottom[Step]*x
		translate <0, -LegSegmentLength*cos(radians(LeftLegTop[Step])), -LegSegmentLength*sin(radians(LeftLegTop[Step]))>
	}
	pigment {Green}
	translate <2, BodyYTop-BodyLength-BeltWidth, 0>
}

#if (Mode=LYNX)
  scale 1.12
#end

rotate Angle*y
}
