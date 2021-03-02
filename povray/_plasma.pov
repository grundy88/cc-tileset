// global settings: here, we specify which version of 
// POV-Ray this file was designed for, as well as our 
// default gamma settings for the scene
#version 3.6;
global_settings {
  assumed_gamma 1.0
  max_trace_level 5
}

// camera: this simple camera looks at the origin from 
// a slight angle. it is the same camera as used in the 
// default POV-Ray scene template  
camera {                        

  // this line allows us to create an animation. by 
  // changing the camera angle around the y axis based 
  // on the clock, the camera will orbit the origin
  rotate <0.0, 360*clock, 0.0>             
  
  location  <0.0, 0.5, -4.0>                  
  direction 1.5*z
  right     x*image_width/image_height
  look_at   <0.0, 0.0, 0.0>
}
                             
                             
// a simple, completely black sky sphere            
sky_sphere {
  pigment {
    rgb <0.0, 0.0, 0.0>
  }
}


// fireball: let's simulate an explosion. to do this, we're 
// going to use the media and turbulence commands to create 
// a plasma effect inside of an ordinary sphere.
sphere {
    0, 2.0
    
    // it's important to make the outer shell of your 
    // object transparent... if you can't see through the 
    // outside of the object, you won't be able 
    // to see the media inside it
    pigment { color rgbt <1, 1, 1, 1> }      
    
    // media is held within the interior of the object    
    interior {
    
        // we're going to create a single media object, with 
        // several different density maps inside it. this works 
        // similar to building a layered texture. "density" 
        // controls the thickness of the media at a particular 
        // point. density can be controlled independently on 
        // each color channel, allowing you to have colored 
        // media by emitting or blocking certain colors of light. 
        // density maps multiply--not add--the density of the 
        // layers together. this means that if a point has a zero
        // value on any layer, that the total density for that 
        // point will also be zero. this is extremely
        // useful for creating complex patterns and effects
        media {         
        
         // POV-Ray supports three types of media: emissive, 
         // absorbing, and scattering. "emission" is self-illuminated 
         // media. it will not cast light on other objects, but it 
         // has the appearance of glowing. "absorption" blocks light 
         // instead of emits light. absorbing media casts shadows on 
         // other objects. "scattering" media is lit by other 
         // light sources, and can scatter light. it is substantially 
         // slower to render than the other two types, however, it 
         // can be used with photons to create effects like 
         // visible sunbeams
         emission 1.0                  
         absorption .2   
         
         //
         // LAYER 1
         //
         // for our first layer, we'll blend the edge of the sphere 
         // to transparent. this will make edges less obvious and help 
         // hide the fact that the media is contained inside a sphere. 
         // we want it to look free-floating, so it's important to 
         // disguise the edges
         density { 
            spherical             
            density_map {
                [0.0 rgb <0.0, 0.0, 0.0>]                
                [1.0 rgb <1.0, 1.0, 1.0>]                                
            }            
         }
         
         //
         // LAYER 2
         //                                 
         // explosions usually have bright centers. for our second layer, 
         // we'll give the explosion a "hot" core by multiplying past 
         // the 1.0 range in the center... POV-Ray doesn't support HDRI
         // (the MegaPOV build does) but this trick works nonetheless
         density { 
            spherical             
            density_map {
                [0.7 rgb <1.0, 1.0, 1.0>]                                
                [1.0 rgb <8.0, 8.0, 8.0>]  
            }            
          }              

         //
         // LAYER 3
         //
         // now that we've blocked out the general shape of our media, 
         // for our third layer we want to get it looking more cloud-like 
         // and less like a ball. we'll do that by adding some soft, low 
         // frequency turbulence                           
         density { 
            spherical             
            density_map {
                [0.0 rgb <0.0, 0.0, 0.0>]                
                [0.2 rgb <0.5, 0.0, 0.0>]
                [0.4 rgb <0.8, 0.4, 0.0>]
                [0.9 rgb <1.0, 1.0, 1.0>]
            }      
 
            // here's where the magic happens... a low turbulence setting 
            // causes our media to take on a soft, cloud-like shape           
            warp {
                turbulence .6   
                lambda 1.5  
                
                // low omega values create soft, blurry results; 
                // higher values are crisp and wrinkly
                omega 0.25  
            }
            
            // this warp causes the explosion to look like the particulate 
            // is ejecting from the center by pulling in all of the color 
            // toward the center... I haven't tried it, but I bet you 
            // could do some nifty animations by adding a clock term to 
            // one of these values
            warp { 
                black_hole <0.0, 0.0, 0.0>, 2.0
                strength .95  
                falloff 2.5
            }                      
          }
          
          //
          // LAYER 4
          //
          // explosions have lots of detail, with many fine swirls and 
          // eddies. we can simulate this by using a high-frequency 
          // turbulence value. again, we'll multiply past 1.0 to keep 
          // the explosion "hot"
          density { 
            spherical             
            density_map {   
                [0.0 rgb <0.0, 0.0, 0.0>]                
                [0.1 rgb <1.0, 0.0, 0.0> * .75]
                [0.2 rgb <1.0, 0.5, 0.0> * .75]                
                [0.8 rgb <1.0, 1.0, 1.0> * 2.5]
            }           
            
            warp { 
                turbulence 1.5
                lambda 2.5
                omega 0.55
                octaves 7                
            }
            scale .75
            
            warp { 
                black_hole <0.0, 0.0, 0.0>, 2.0   
                strength .8
                falloff 2.0                                              
             }          
          }

          // if you find that you have glitches or black spots in 
          // your media, try turning up the number of samples. 
          // more samples will cause it to render slower, so don't 
          // turn it up more than you need to
          samples 20 
          scale 1.25
        } 
    }
    
    // THIS LINE IS VERY IMPORTANT! in order to hold the media, the object
    // needs to be hollow... if the object is solid, the default, then the
    // media won't show correctly. don't forget to include this command! 
    hollow
}
