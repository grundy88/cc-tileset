//#version unofficial MegaPov 0.6;
#declare doRad = false;
#if(doRad)
global_settings
{
  assumed_gamma 1.0
  ambient_light 0
  radiosity{
    pretrace_start 0.08
    pretrace_end 0.02
    count 150
    nearest_count 5
    recursion_limit 4
    error_bound 1
    low_error_factor .5
    gray_threshold 0.0
    minimum_reuse 0.015
    brightness 50
    media on
  }
}
#end

#include "colors.inc"
//camera{location  <0, 0, -10.0> look_at   <0, 0, 0>}

//sphere{0, 4.75 pigment{bozo scale 0.1 color_map {[0.0 color rgb <0.1, 0.2,0.3>*.25] [1.0 color rgb <0.11, 0.3,0.4>*.25]}} scale<100,1,100> inverse finish{ambient 1}}

//plane { y, -1 pigment{ color rgb <0.7, 0.5, 0.3> }normal{bumps scale 3 }}

//plane { y, 0 pigment{bozo color_map{[0.0 color rgbt <0,0,0,1>][1.0 color rgbt <0.11, 0.3, 0.4,0>]} scale 0.1}normal{bumps scale<1,1,10>} rotate x*180 translate y*10}

//fog{distance 50 color rgb 0}

#macro Make_Bolt(LArraySize, LSeed, LWidth, LHeight, LSpread, LBranch, LCutoff, LSpike)
  #declare myArray = array[LArraySize]
  #declare checkCount = -1;
  #declare highCount = 0;
  #declare arrayCount = 0;
  #declare myArray[arrayCount] = <0,0,0>;
  #declare myRand = seed(LSeed);
  merge{
    #while (checkCount < highCount)
      #declare checkCount = checkCount + 1;
      #declare segPosA = myArray[arrayCount];
      #declare arrayCount = arrayCount + 1;
      #declare xPlus = (rand(myRand)-0.5)*LSpread;
      #declare zPlus = (rand(myRand)-0.5)*LSpread;
      #while(segPosA.y < LHeight)
        #declare xShift = segPosA.x + ((rand(myRand)-0.5)*LSpike) + xPlus;
        #declare yShift = segPosA.y + (rand(myRand)/5);
        #declare zShift = segPosA.z + ((rand(myRand)-0.5)*LSpike) + zPlus;
        #if (yShift > LHeight)
          #declare yShift = LHeight;
        #end
        #declare segPosB = <xShift, yShift, zShift>;
        cylinder{segPosA, segPosB, LWidth}
        #declare segPosA = segPosB;
        #declare randNum = rand(myRand);
        #if (randNum < LBranch & segPosA.y > LCutoff)
          #declare highCount = highCount + 1;
          #declare myArray[highCount] = segPosA;
        #end
        #declare LWidth = (LWidth*0.995)   ;
      #end
      #declare LWidth = (LWidth*0.9)   ;
    #end
  }
#end

/*
Make_Bolt(500, 11211, 0.03, 3, 0.0, 0.1, 0.1, 0.2)
object{
  Lightning_Bolt
  pigment{rgbt 1}
  interior{media{emission<3,3,5>*5}}
  hollow
  rotate x*180
  no_shadow
  translate y*3
}

object{
  Lightning_Bolt
  pigment{rgbt 1}
  interior{media{emission<3,3,5>*5}}
  hollow
  no_shadow
  translate y*-3
}
*/