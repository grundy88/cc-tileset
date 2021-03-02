// http://www.geocities.ws/evilsnack/tut01.html

sphere { 0,2 hollow no_shadow
  texture { pigment { rgbt 1 } }
  interior {
    // fireball
    media { absorption 8 emission 8 method 3 samples 30,30 intervals 1
      density { spherical
        warp { turbulence .75*.3+.05 lambda 2.75 }
        density_map {
          [1-.99*.75 rgb <0,0,0>]
          [1-.99*.75 rgb <max(0,1-.75*1.5),max(0,1-.75*4.5),max(0,1-.75*6)>]
          [1 rgb <.75,.25,0>] }
      }
    }
   
    // smoke
    media { absorption 3 scattering { 1 .3 } method 3 samples 30,30 intervals 1
      density { spherical
        warp { turbulence .75*.3+.05 lambda 2.75 }
        density_map {
          [1-.99*.75 rgb 0]
          [1-.99*.75 rgb 1]
          [1-.49*.75 rgb 1]
          [1-.49*.75 rgb 0]
         }
      }
    }
  }
}

light_source { <1e4,1e4,0> 1 }

camera {
  location <0,0,-3>
  look_at <0,0,0>
}

background { rgb <.4,.7,1> }
