#include "ccglobal.inc"
#include "colors.inc"
#include "textures.inc"

#declare CamLoc = <0, 0, -50>;

camera {
  location CamLoc
  look_at  <0, -0.1, 0>
    focal_point <0, -1, 0>
    angle 30
    up <0,1,0>
    right <1,0,0>    
}

light_source {
	<-10, 10, -100> color rgb 1
	shadowless
}

light_source {
  <20, 20, -10> 
  color rgb 0.1
  shadowless
}

plane {
	-z, -1
	pigment { color rgb 1 }
	finish { ambient 0.1 diffuse 1.05 }
}

#declare _width = 19;
#declare _x = -7.9;
#declare _bottom = -10;
#declare _verticalThickness = 0.8;
#declare _num = 0;
#declare _count = 6;
#declare _pointBaseWidth = 1.2;
#declare _pointHeight = 5;
//#declare _top = array[10] {5, 5.2, 5.8, 6.5, 8,   8, 6.5, 5.8, 5.2, 5}
#declare _top = array[6] {5, 5.2, 5.8, 5.8, 5.2, 5}

#while (_num < _count)
cylinder {
	<_x, _bottom, 0>, <_x, _top[_num], 0>, _verticalThickness
	pigment {Gray50}
}
cone {
	<_x, _top[_num], 0>, _pointBaseWidth, <_x, _top[_num]+_pointHeight, 0>, 0
	pigment {Gray50}
}
sphere {
	<_x, _bottom-0.4, 0>, 1
	pigment {Gray50}
}
	
#declare _num = _num + 1;
#declare _x = _x + (_width / _count);
#end

// crossbars
cylinder {
	<-11, 3, 0>, <11, 3, 0>, 0.4
	pigment {Gray50}
}
cylinder {
	<-11, -6.3, 0>, <11, -6.3, 0>, 0.4
	pigment {Gray50}
}
cylinder {
	<-11, -8.3, 0>, <11, -8.3, 0>, 0.4
	pigment {Gray50}
}

#declare _postRadius = 1;

// posts
union {
	box {
		<_postRadius, -10, _postRadius>, <-1, 10, -_postRadius>
	}
	sphere {
		<0, 11, 0>, _postRadius*1.5
	}
	translate <-11, -1.5, 0>
	texture {Rusty_Iron}
//	pigment {Black}
}

union {
	box {
		<_postRadius, -10, _postRadius>, <-_postRadius, 10, -_postRadius>
	}
	sphere {
		<0, 11, 0>, _postRadius*1.5
	}
	translate <11, -1.5, 0>
	texture {Rusty_Iron}
}

