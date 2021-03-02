# Script to generate tileset image
# requires: 
# * ImageMagick (uses `convert` and `composite`, for mac: `brew install imagemagick`)
# * PovRAY (intel mac binary in the `povray` dir)

shifter=0
FLOOR=$((1 << shifter++))
FORCE=$((1 << shifter++))
ICE=$((1 << shifter++))
GRAVEL=$((1 << shifter++))
DIRT=$((1 << shifter++))
WATER=$((1 << shifter++))
FIRE=$((1 << shifter++))
BOMB=$((1 << shifter++))
TRAP=$((1 << shifter++))
THIEF=$((1 << shifter++))
HINT=$((1 << shifter++))
BUTTONS=$((1 << shifter++))
TELEPORT=$((1 << shifter++))
WALL=$((1 << shifter++))
THIN_WALLS=$((1 << shifter++))
BLUE_BLOCK=$((1 << shifter++))
TOGGLE_WALLS=$((1 << shifter++))
POPUP=$((1 << shifter++))
CLONE_MACHINE=$((1 << shifter++))
DOORS=$((1 << shifter++))
SOCKET=$((1 << shifter++))
EXIT=$((1 << shifter++))
COMPUTER_CHIP=$((1 << shifter++))
KEYS=$((1 << shifter++))
FOOTWEAR=$((1 << shifter++))
CHIP=$((1 << shifter++))
BLOCK=$((1 << shifter++))    # also for block cloners
TANK=$((1 << shifter++))
BALL=$((1 << shifter++))
GLIDER=$((1 << shifter++))
FIREBALL=$((1 << shifter++))
BUG=$((1 << shifter++))
PARAMECIUM=$((1 << shifter++))
TEETH=$((1 << shifter++))
BLOB=$((1 << shifter++))
WALKER=$((1 << shifter++))
CLONE_BLOCK=$((1 << shifter++))

TILE=$(( (1 << shifter) - 1 ))

BASEDIR=$(pwd)
POVRAY=${BASEDIR}/povray/povray
echo "povray is ${POVRAY}"

OUTPUT_FILE=cc.png

WORK_DIR=work
mkdir -p $WORK_DIR

# povray include files
cp povray/colors.inc $WORK_DIR
cp povray/gamma.inc $WORK_DIR
cp povray/textures.inc $WORK_DIR
cp povray/finish.inc $WORK_DIR
cp povray/woods.inc $WORK_DIR
cp povray/woodmaps.inc $WORK_DIR
cp ccglobal.inc $WORK_DIR

# from here on out, everything happens in the work dir
cd $WORK_DIR

TWLYNX=1
TWMS=2
MS=3
CC2=4

SETTYPE=$TWLYNX
#SETTYPE=$MS

REPLACE=1
FORCE_REPLACE=0
DO_RENDER=1
DO_INSTALL=0

while getopts ":rt:s:ci:" opt; do
  case $opt in
    t)
      if [ $REPLACE == 1 ]; then
        TILE=0
        REPLACE=0
      fi
      TILE=$((TILE | (1 << OPTARG)))
      ;;
    r)
      FORCE_REPLACE=1
      ;;
    c)
      # compsite only
      DO_RENDER=0
      ;;
    s)
      case $OPTARG in
        "twlynx")
          SETTYPE=$TWLYNX
          ;;
        "twms")
          SETTYPE=$TWMS
          ;;
        "cc2")
          SETTYPE=$CC2
          ;;
        *)
          SETTYPE=$MS
          ;;
      esac
      ;;
    i)
      DO_INSTALL=1
      INSTALL_DESTINATION=${OPTARG}
      ;;
  esac
done

case $SETTYPE in
  $TWLYNX)
    IMG_SIZE=48
    TILE_SIZE=48
    ORIG_TILES=twatiles-orig.bmp
    MASK_COLOR="rgb(255,0,255)"
    ;;
  $TWMS)
    IMG_SIZE=48
    TILE_SIZE=48
    ORIG_TILES=twtiles-orig.bmp
    MASK_COLOR="rgb(255,0,255)"
    ;;
  $MS)
    IMG_SIZE=64
    TILE_SIZE=32
    ORIG_TILES=tileset-orig.png
    MASK_COLOR="rgb(255,255,255)"
    ;;
  $CC2)
    IMG_SIZE=64
    TILE_SIZE=32
    ORIG_TILES=cc2-tiles-orig.bmp
    MASK_COLOR="rgb(82,206,107)"
    ;;
esac 
    
if [ $FORCE_REPLACE == 1 ]; then
  REPLACE=1
fi

#echo Tile: $TILE
#echo Replace: $REPLACE
echo original tiles: ${ORIG_TILES}
echo tile size: $TILE_SIZE

if [ $REPLACE == 1 ]; then
  echo Starting with original tiles
  convert ../${ORIG_TILES} ${OUTPUT_FILE}
fi

# ------------------------------------------
# render tiles

render() {
  local in=../$1
  local out=$2
  local extra=$3
  $POVRAY -i$in.pov +fn +UA -H$IMG_SIZE -W$IMG_SIZE -D +A -o$out.png $extra > last-render.out 2>&1

  if [ $? -ne 0 ]; then
    cat last-render.out
    exit 1
  fi
}

addFloorLines() {
  local file=$1

  local e=$(( $TILE_SIZE - 1 ))
  local size=${TILE_SIZE}x${TILE_SIZE}

  convert $file.png -resize $size $file.png
  convert $file.png -stroke "rgb(249,249,249)" -draw "line 0,$e 0,0 line 0,0 $e,0" $file.png
  convert $file.png -stroke "rgb(200,200,200)" -draw "line 0,$e $e,$e line $e,$e $e,0" $file.png
}

if [ $DO_RENDER == 1 ]; then

echo Rendering...

# floor
if [ $((TILE & FLOOR)) == $FLOOR ]; then
  echo - floor
  render ccfloor cc-floor
  addFloorLines cc-floor
fi

# ice
if [ $((TILE & ICE)) == $ICE ]; then
  echo - ice corners
  render ccicecorner cc-ice-se Declare=WallType=0
  render ccicecorner cc-ice-sw Declare=WallType=1
  render ccicecorner cc-ice-nw Declare=WallType=2
  render ccicecorner cc-ice-ne Declare=WallType=3
fi

# bomb
if [ $((TILE & BOMB)) == $BOMB ]; then
  echo - bomb
  if [ $SETTYPE == $TWLYNX ]; then
    cp -f ../spark-ax.png .
    cp -f ../spark-bx.png .
    cp -f ../spark-cx.png .
    cp -f ../spark-dx.png .
    render ccbomb cc-bomb-1 Declare=Step=1
    render ccbomb cc-bomb-2 Declare=Step=2
    render ccbomb cc-bomb-3 Declare=Step=3
    render ccbomb cc-bomb-4 Declare=Step=4
  else
    cp -f ../spark-ax.png .
    render ccbomb cc-bomb Declare=Step=1
  fi
fi

# trap
if [ $((TILE & TRAP)) == $TRAP ]; then
  echo - trap
  render cctrap cc-trap
fi

# thief
if [ $((TILE & THIEF)) == $THIEF ]; then
  echo - quicksand
  cp -f ../tile-quicksand.png .
  render ccfloor cc-quicksand Declare=FloorType=8
fi

# hint
if [ $((TILE & HINT)) == $HINT ]; then
  echo - hint
  cp -f ../ChalkboardBold.ttf .
  render ccfloor cc-hint Declare=FloorType=5
fi

# buttons
if [ $((TILE & BUTTONS)) == $BUTTONS ]; then
  echo - buttons
  render ccfloor cc-blue-button Declare=FloorType=4
  render ccfloor cc-green-button Declare=FloorType=1
  render ccfloor cc-red-button Declare=FloorType=2
  render ccfloor cc-brown-button Declare=FloorType=3
fi

# teleport
if [ $((TILE & TELEPORT)) == $TELEPORT ]; then
  echo - teleport
  cp -f ../tile-teleport.png .
  if [ $SETTYPE == $TWLYNX ]; then
    render ccfloor cc-teleport-a "Declare=FloorType=6 Declare=Step=0"
    render ccfloor cc-teleport-b "Declare=FloorType=6 Declare=Step=1"
    render ccfloor cc-teleport-c "Declare=FloorType=6 Declare=Step=2"
    render ccfloor cc-teleport-d "Declare=FloorType=6 Declare=Step=3"
  else
    render ccfloor cc-teleport "Declare=FloorType=6 Declare=Step=0"
  fi
fi

# wall
if [ $((TILE & WALL)) == $WALL ]; then
  echo - wall
  render ccwall cc-wall Declare=WallType=0
fi

# thin walls
if [ $((TILE & THIN_WALLS)) == $THIN_WALLS ]; then
  echo - thin walls
  render ccthinwall cc-thin-n Declare=WallType=0
  render ccthinwall cc-thin-w Declare=WallType=1
  render ccthinwall cc-thin-s Declare=WallType=2
  render ccthinwall cc-thin-e Declare=WallType=3
  render ccthinwall cc-thin-se Declare=WallType=4
fi

# blue wall
if [ $((TILE & BLUE_BLOCK)) == $BLUE_BLOCK ]; then
  echo - blue wall
  render ccwall cc-blue-wall Declare=BlockType=2
fi

# toggle walls
if [ $((TILE & TOGGLE_WALLS)) == $TOGGLE_WALLS ]; then
  echo - toggles
  if [ $SETTYPE == $TWLYNX ]; then
    render cctoggle-outline cc-toggle-outline-off-a "Declare=OutlineType=0 Declare=Step=0"
    render cctoggle-outline cc-toggle-outline-off-b "Declare=OutlineType=0 Declare=Step=1"
    render cctoggle-outline cc-toggle-outline-off-c "Declare=OutlineType=0 Declare=Step=2"
    render cctoggle-outline cc-toggle-outline-off-d "Declare=OutlineType=0 Declare=Step=3"
    render cctoggle-outline cc-toggle-outline-on-a "Declare=OutlineType=1 Declare=Step=0"
    render cctoggle-outline cc-toggle-outline-on-b "Declare=OutlineType=1 Declare=Step=1"
    render cctoggle-outline cc-toggle-outline-on-c "Declare=OutlineType=1 Declare=Step=2"
    render cctoggle-outline cc-toggle-outline-on-d "Declare=OutlineType=1 Declare=Step=3"
  else
    render cctoggle-outline cc-toggle-outline-off "Declare=OutlineType=0 Declare=Step=0"
    render cctoggle-outline cc-toggle-outline-on "Declare=OutlineType=1 Declare=Step=0"
  fi
fi

# popup
if [ $((TILE & POPUP)) == $POPUP ]; then
  echo - popup
  render ccfloor cc-passonce Declare=FloorType=7
fi

# clone machine
if [ $((TILE & CLONE_MACHINE)) == $CLONE_MACHINE ]; then
  echo - clone machine
  cp -f ../lightning.pov .
  if [ $SETTYPE == $TWLYNX ]; then
    render ccclone cc-clonemachine-a "Declare=CloneType=0 Declare=Step=0"
    render ccclone cc-clonemachine-b "Declare=CloneType=0 Declare=Step=1"
    render ccclone cc-clonemachine-c "Declare=CloneType=0 Declare=Step=2"
    render ccclone cc-clonemachine-d "Declare=CloneType=0 Declare=Step=3"
  else
    render ccclone cc-clonemachine "Declare=CloneType=0 Declare=Step=0"
  fi
fi

# doors
if [ $((TILE & DOORS)) == $DOORS ]; then
  echo - doors
  render ccwall cc-red-door Declare=WallType=2
  render ccwall cc-blue-door Declare=WallType=1
  render ccwall cc-yellow-door Declare=WallType=4
  render ccwall cc-green-door Declare=WallType=3
fi

# socket
if [ $((TILE & SOCKET)) == $SOCKET ]; then
  echo - socket
  render ccgate cc-gate
fi

# exit
if [ $((TILE & EXIT)) == $EXIT ]; then
  echo - exit
  cp -f ../tile-exit.png .
  if [ $SETTYPE == $TWLYNX ]; then
    render ccfloor cc-exit-a "Declare=FloorType=9 Declare=Step=0"
    render ccfloor cc-exit-b "Declare=FloorType=9 Declare=Step=1"
    render ccfloor cc-exit-c "Declare=FloorType=9 Declare=Step=2"
    render ccfloor cc-exit-d "Declare=FloorType=9 Declare=Step=3"
  else
    render ccfloor cc-exit "Declare=FloorType=9 Declare=Step=0"
  fi
fi

# computer chip
if [ $((TILE & COMPUTER_CHIP)) == $COMPUTER_CHIP ]; then
  echo - computer chip
  cp -f ../tile-embosschip.png .
  render cccoin cc-computerchip
fi

# keys
if [ $((TILE & KEYS)) == $KEYS ]; then
  echo - keys
  render cckeys cc-red-key Declare=KeyType=2
  render cckeys cc-blue-key Declare=KeyType=1
  render cckeys cc-yellow-key Declare=KeyType=4
  render cckeys cc-green-key Declare=KeyType=3
fi

# footwear
if [ $((TILE & FOOTWEAR)) == $FOOTWEAR ]; then
  echo - footwear
  cp -f ../boot-geom.inc .
  render ccboot cc-fire-boot Declare=BootType=1
  render ccboot cc-ice-skate Declare=BootType=2
  render ccboot cc-force-boot Declare=BootType=3
fi

# chip
if [ $((TILE & CHIP)) == $CHIP ]; then
  echo - chip
  if [ $SETTYPE == $TWLYNX ]; then
    render ccwill cc-will-n-a "Declare=Mode=1 Declare=Direction=0 Declare=Step=0"
    render ccwill cc-will-n-b "Declare=Mode=1 Declare=Direction=0 Declare=Step=1"
    render ccwill cc-will-n-c "Declare=Mode=1 Declare=Direction=0 Declare=Step=2"
    render ccwill cc-will-w-a "Declare=Mode=1 Declare=Direction=1 Declare=Step=0"
    render ccwill cc-will-w-b "Declare=Mode=1 Declare=Direction=1 Declare=Step=1"
    render ccwill cc-will-w-c "Declare=Mode=1 Declare=Direction=1 Declare=Step=2"
    render ccwill cc-will-s-a "Declare=Mode=1 Declare=Direction=2 Declare=Step=0"
    render ccwill cc-will-s-b "Declare=Mode=1 Declare=Direction=2 Declare=Step=1"
    render ccwill cc-will-s-c "Declare=Mode=1 Declare=Direction=2 Declare=Step=2"
    render ccwill cc-will-e-a "Declare=Mode=1 Declare=Direction=3 Declare=Step=0"
    render ccwill cc-will-e-b "Declare=Mode=1 Declare=Direction=3 Declare=Step=1"
    render ccwill cc-will-e-c "Declare=Mode=1 Declare=Direction=3 Declare=Step=2"
    
    render ccwill cc-will-push-n-a "Declare=Mode=1 Declare=Direction=0 Declare=Step=0 Declare=Push=1"
    render ccwill cc-will-push-n-b "Declare=Mode=1 Declare=Direction=0 Declare=Step=1 Declare=Push=1"
    render ccwill cc-will-push-n-c "Declare=Mode=1 Declare=Direction=0 Declare=Step=2 Declare=Push=1"
    render ccwill cc-will-push-w-a "Declare=Mode=1 Declare=Direction=1 Declare=Step=0 Declare=Push=1"
    render ccwill cc-will-push-w-b "Declare=Mode=1 Declare=Direction=1 Declare=Step=1 Declare=Push=1"
    render ccwill cc-will-push-w-c "Declare=Mode=1 Declare=Direction=1 Declare=Step=2 Declare=Push=1"
    render ccwill cc-will-push-s-a "Declare=Mode=1 Declare=Direction=2 Declare=Step=0 Declare=Push=1"
    render ccwill cc-will-push-s-b "Declare=Mode=1 Declare=Direction=2 Declare=Step=1 Declare=Push=1"
    render ccwill cc-will-push-s-c "Declare=Mode=1 Declare=Direction=2 Declare=Step=2 Declare=Push=1"
    render ccwill cc-will-push-e-a "Declare=Mode=1 Declare=Direction=3 Declare=Step=0 Declare=Push=1"
    render ccwill cc-will-push-e-b "Declare=Mode=1 Declare=Direction=3 Declare=Step=1 Declare=Push=1"
    render ccwill cc-will-push-e-c "Declare=Mode=1 Declare=Direction=3 Declare=Step=2 Declare=Push=1"
  else
    render ccwill cc-will-n "Declare=Mode=0 Declare=Direction=0 Declare=Step=0"
    render ccwill cc-will-w "Declare=Mode=0 Declare=Direction=1 Declare=Step=0"
    render ccwill cc-will-s "Declare=Mode=0 Declare=Direction=2 Declare=Step=0"
    render ccwill cc-will-e "Declare=Mode=0 Declare=Direction=3 Declare=Step=0"
  fi
  
  render ccwill cc-will-exit "Declare=Mode=0 Declare=Direction=4 Declare=Step=0"
fi

# block
if [ $((TILE & BLOCK)) == $BLOCK ]; then
  echo - block
  render ccwall cc-block Declare=BlockType=1
fi

# tank
if [ $((TILE & TANK)) == $TANK ]; then
  echo - tank
  render cctank cc-tank-n Declare=Angle=0
  render cctank cc-tank-w Declare=Angle=90
  render cctank cc-tank-s Declare=Angle=180
  render cctank cc-tank-e Declare=Angle=270
fi

# ball
if [ $((TILE & BALL)) == $BALL ]; then
  echo - ball
  if [ $SETTYPE == $TWLYNX ]; then
    render ccball cc-ball-v-a "Declare=Direction=1 Declare=Step=0"
    render ccball cc-ball-v-b "Declare=Direction=1 Declare=Step=1"
    render ccball cc-ball-v-c "Declare=Direction=1 Declare=Step=2"
    render ccball cc-ball-v-d "Declare=Direction=1 Declare=Step=3"
    render ccball cc-ball-h-a "Declare=Direction=0 Declare=Step=0"
    render ccball cc-ball-h-b "Declare=Direction=0 Declare=Step=1"
    render ccball cc-ball-h-c "Declare=Direction=0 Declare=Step=2"
    render ccball cc-ball-h-d "Declare=Direction=0 Declare=Step=3"
  else
    render ccball cc-ball "Declare=Direction=0 Declare=Step=2"
  fi
fi

# glider
if [ $((TILE & GLIDER)) == $GLIDER ]; then
  echo - glider
  render ccglider cc-glider-n Declare=Angle=0
  render ccglider cc-glider-w Declare=Angle=90
  render ccglider cc-glider-s Declare=Angle=180
  render ccglider cc-glider-e Declare=Angle=270
fi

# bug
if [ $((TILE & BUG)) == $BUG ]; then
  echo - bug
  if [ $SETTYPE == $TWLYNX ]; then
    render ccbug cc-bug-n-a "Declare=Angle=0 Declare=Step=0"
    render ccbug cc-bug-n-b "Declare=Angle=0 Declare=Step=1"
    render ccbug cc-bug-n-c "Declare=Angle=0 Declare=Step=2"
    render ccbug cc-bug-w-a "Declare=Angle=90 Declare=Step=0"
    render ccbug cc-bug-w-b "Declare=Angle=90 Declare=Step=1"
    render ccbug cc-bug-w-c "Declare=Angle=90 Declare=Step=2"
    render ccbug cc-bug-s-a "Declare=Angle=180 Declare=Step=0"
    render ccbug cc-bug-s-b "Declare=Angle=180 Declare=Step=1"
    render ccbug cc-bug-s-c "Declare=Angle=180 Declare=Step=2"
    render ccbug cc-bug-e-a "Declare=Angle=-90 Declare=Step=0"
    render ccbug cc-bug-e-b "Declare=Angle=-90 Declare=Step=1"
    render ccbug cc-bug-e-c "Declare=Angle=-90 Declare=Step=2"
  else
    render ccbug cc-bug-n "Declare=Angle=0 Declare=Step=1"
    render ccbug cc-bug-w "Declare=Angle=90 Declare=Step=1"
    render ccbug cc-bug-s "Declare=Angle=180 Declare=Step=1"
    render ccbug cc-bug-e "Declare=Angle=-90 Declare=Step=1"
  fi
fi

# paramecium
if [ $((TILE & PARAMECIUM)) == $PARAMECIUM ]; then
  echo - paramecium
  if [ $SETTYPE == $TWLYNX ]; then
    render ccparamecium cc-paramecium-e-a "Declare=Angle=0 Declare=Step=0"
    render ccparamecium cc-paramecium-e-b "Declare=Angle=0 Declare=Step=1"
    render ccparamecium cc-paramecium-e-c "Declare=Angle=0 Declare=Step=2"
    render ccparamecium cc-paramecium-e-d "Declare=Angle=0 Declare=Step=3"
    render ccparamecium cc-paramecium-n-a "Declare=Angle=90 Declare=Step=0"
    render ccparamecium cc-paramecium-n-b "Declare=Angle=90 Declare=Step=1"
    render ccparamecium cc-paramecium-n-c "Declare=Angle=90 Declare=Step=2"
    render ccparamecium cc-paramecium-n-d "Declare=Angle=90 Declare=Step=3"
    render ccparamecium cc-paramecium-w-a "Declare=Angle=180 Declare=Step=0"
    render ccparamecium cc-paramecium-w-b "Declare=Angle=180 Declare=Step=1"
    render ccparamecium cc-paramecium-w-c "Declare=Angle=180 Declare=Step=2"
    render ccparamecium cc-paramecium-w-d "Declare=Angle=180 Declare=Step=3"
    render ccparamecium cc-paramecium-s-a "Declare=Angle=-90 Declare=Step=0"
    render ccparamecium cc-paramecium-s-b "Declare=Angle=-90 Declare=Step=1"
    render ccparamecium cc-paramecium-s-c "Declare=Angle=-90 Declare=Step=2"
    render ccparamecium cc-paramecium-s-d "Declare=Angle=-90 Declare=Step=3"
  else
    render ccparamecium cc-paramecium-h "Declare=Angle=0 Declare=Step=0"
    render ccparamecium cc-paramecium-v "Declare=Angle=90 Declare=Step=0"
  fi
fi

# teeth
if [ $((TILE & TEETH)) == $TEETH ]; then
  echo - teeth
  if [ $SETTYPE == $TWLYNX ]; then
    render ccteeth cc-teeth-s-a "Declare=Angle=0 Declare=Step=0"
    render ccteeth cc-teeth-s-b "Declare=Angle=0 Declare=Step=1"
    render ccteeth cc-teeth-s-c "Declare=Angle=0 Declare=Step=2"
    render ccteeth cc-teeth-w-a "Declare=Angle=90 Declare=Step=0"
    render ccteeth cc-teeth-w-b "Declare=Angle=90 Declare=Step=1"
    render ccteeth cc-teeth-w-c "Declare=Angle=90 Declare=Step=2"
    render ccteeth cc-teeth-n-a "Declare=Angle=180 Declare=Step=0"
    render ccteeth cc-teeth-n-b "Declare=Angle=180 Declare=Step=1"
    render ccteeth cc-teeth-n-c "Declare=Angle=180 Declare=Step=2"
    render ccteeth cc-teeth-e-a "Declare=Angle=-90 Declare=Step=0"
    render ccteeth cc-teeth-e-b "Declare=Angle=-90 Declare=Step=1"
    render ccteeth cc-teeth-e-c "Declare=Angle=-90 Declare=Step=2"
  else
    render ccteeth cc-teeth-n "Declare=Angle=180 Declare=Step=1"
    render ccteeth cc-teeth-w "Declare=Angle=60 Declare=Step=1"
    render ccteeth cc-teeth-s "Declare=Angle=0 Declare=Step=1"
    render ccteeth cc-teeth-e "Declare=Angle=-60 Declare=Step=1"
  fi
fi

# blob
if [ $((TILE & BLOB)) == $BLOB ]; then
  echo - blob
  if [ $SETTYPE == $TWLYNX ]; then
    render ccblob cc-blob-v-a "Declare=Step=0 Declare=Dir=0"
    render ccblob cc-blob-v-b "Declare=Step=1 Declare=Dir=0"
    render ccblob cc-blob-v-c "Declare=Step=2 Declare=Dir=0"
    render ccblob cc-blob-h-a "Declare=Step=0 Declare=Dir=1"
    render ccblob cc-blob-h-b "Declare=Step=1 Declare=Dir=1"
    render ccblob cc-blob-h-c "Declare=Step=2 Declare=Dir=1"
  else
    render ccblob cc-blob "Declare=Dir=0 Declare=Step=2"
  fi
fi

# walker
if [ $((TILE & WALKER)) == $WALKER ]; then
  echo - walker
  if [ $SETTYPE == $TWLYNX ]; then
    render ccwalker cc-walker-v-a "Declare=Step=0 Declare=WalkerType=0"
    render ccwalker cc-walker-v-b "Declare=Step=1 Declare=WalkerType=0"
    render ccwalker cc-walker-v-c "Declare=Step=2 Declare=WalkerType=0"
    render ccwalker cc-walker-h-a "Declare=Step=0 Declare=WalkerType=1"
    render ccwalker cc-walker-h-b "Declare=Step=1 Declare=WalkerType=1"
    render ccwalker cc-walker-h-c "Declare=Step=2 Declare=WalkerType=1"
  else
    render ccwalker cc-walker-h "Declare=WalkerType=0 Declare=Step=1"
    render ccwalker cc-walker-v "Declare=WalkerType=1 Declare=Step=1"
  fi
fi

# clone block
if [ $((TILE & CLONE_BLOCK)) == $CLONE_BLOCK ]; then
  echo - clone blocks
  if [ $SETTYPE != $TWLYNX ]; then
    cp -f ../electric.inc .
    render ccclone cc-cloneblock-n Declare=CloneType=1
    render ccclone cc-cloneblock-w Declare=CloneType=2
    render ccclone cc-cloneblock-s Declare=CloneType=3
    render ccclone cc-cloneblock-e Declare=CloneType=4
  fi
fi

else
  echo "Skipping render"
fi

# --------------------------------------------------------------------
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# --------------------------------------------------------------------

# composite tileset image

_x() {
  local x=$(( $1 * $TILE_SIZE ))
  if [ $SETTYPE == $TWLYNX ]; then
    # tw has an extra pixel on the left
    x=$(( $x + 1 ))
  fi
  echo $x
}

_y() {
  local y=$(( $1 * $TILE_SIZE ))
  if [ $SETTYPE == $TWLYNX ]; then
    if [ $1 -le 2 ]; then 
      # first 3 rows get one extra pixel above
      y=$(( $y + $1 + 1 ))
    else
      # beyond 3, only every other row gets one extra pixel above
      # 0   -> 1
      # 1   -> 2
      # 2   -> 3
      # 3/4 -> 4
      # 5/6 -> 5
      # 7/8 -> 6
      y=$(( $y + ($1 - 3) / 2 + 4 ))
    fi
  fi
  echo $y
}

# if a source image exists (vs a rendered one), grab it
_checkForPng() {
  if [ -f ../$1.png ]; then
    cp ../$1.png .
  fi
}

# scale the specified image and put it on the tileset at x,y
place() {
  local file=$1
  local x=$(_x $2)
  local y=$(_y $3)
  local size=${TILE_SIZE}x${TILE_SIZE}
  _checkForPng $file
  convert $file.png -resize $size $file.png
  composite $file.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

# flood fill background as white with 10% fuzz, make white (therefore the background) transparent
# used for source file without white in it (otherwise white becomes transparent)
_makeBackgroundTransparent() {
  local file=$1
  local size=${TILE_SIZE}x${TILE_SIZE}

  convert $file.png -resize $size -fill white -fuzz 10% -draw "color 0,0 floodfill" -transparent white $file-trans.png
}

# fill background with transparency and place directly over whatever is there
# transparency is done differently than in _makeBackgroundTransparent
# because in that function it does the convert in one step, which for some reason
# lets more transparency bleed through - beats me
placeTransparent() {
  local file=$1
  local x=$(_x $2)
  local y=$(_y $3)
  local size=${TILE_SIZE}x${TILE_SIZE}
  _checkForPng $file

  convert $file.png -fill white -fuzz 10% -draw 'color 0,0 floodfill' $file-white.png
  convert $file-white.png -transparent white -resize $size $file-trans.png
  composite $file-trans.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

# fill destination with mask color, place tile with transparent background
placeWithMask() {
  local file=$1
  local x=$(_x $2)
  local y=$(_y $3)
  local xx=$(( $x + $TILE_SIZE - 1 ))
  local yy=$(( $y + $TILE_SIZE - 1 ))
  _checkForPng $file
  
  convert ${OUTPUT_FILE} -fill "${MASK_COLOR}" -draw "rectangle $x,$y $xx,$yy" ${OUTPUT_FILE}
  # you might think to use placeTransparent here, but that one uses a different
  # transparency generation
  _makeBackgroundTransparent $file
  composite $file-trans.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

# flood fill background as pink with fuzz%
_fillBackground() {
  local file=$1
  local fuzz=$2
  local size=${TILE_SIZE}x${TILE_SIZE}
  local h=$((TILE_SIZE - 1))
  convert $file.png -resize $size -fill "${MASK_COLOR}" -fuzz $fuzz% -draw "color 0,0 floodfill" -draw "color 0,$h floodfill" -draw "color $h,0 floodfill" -draw "color $h,$h floodfill" $file-trans.png
  # convert $file.png -resize $size -fill "${MASK_COLOR}" -fuzz $fuzz% -draw "color 0,0 floodfill" -draw "color $h,$h floodfill" $file-trans.png
  # convert $file.png -resize $size -fill "${MASK_COLOR}" -fuzz $fuzz% -draw "color 0,0 floodfill" $file-trans.png
}

# fill background with mask color and place directly over whatever is there
placeFillBackground() {
  local file=$1
  local fuzz=$2
  local x=$(_x $3)
  local y=$(_y $4)
  _checkForPng $file

  _fillBackground $file $fuzz
  composite $file-trans.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

# put down floor first, then place tile with transparent background
placeOnFloor() {
  local file=$1
  local x=$(_x $2)
  local y=$(_y $3)
  composite cc-floor.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
  placeTransparent $1 $2 $3 $4 $5
}

# put down floor first, then place tile with transparent background
placeDirectlyOnFloor() {
  local file=$1
  local x=$(_x $2)
  local y=$(_y $3)
  local size=${TILE_SIZE}x${TILE_SIZE}
  _checkForPng $file

  convert $file.png -resize $size $file.png
  composite cc-floor.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
  composite $file.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

placeTopHalf() {
  local file=$1
  local h=$(( $TILE_SIZE / 2 ))
  local x=$(( $2 * $TILE_SIZE ))
  local y=$(( $3 * $TILE_SIZE + ($h / 2) ))
  if [ "$4" != "" ]; then
      x=$(( $x + $4 ))
      y=$(( $y + $5 ))
  fi
  local size=${TILE_SIZE}x${h}
  _makeBackgroundTransparent $file
  convert -extract ${TILE_SIZE}x${h}+0+0 $file-trans.png $file-top.png
  composite $file-top.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

# -------------------------------------
# Lynx specific

# for monsters that stretch as they move (i.e. blobs and walkers)
placeVert() {
  local file=$1
  local x=$(_x $2)
  local y=$(_y $3)
  local offset=$4
  local w=$TILE_SIZE
  local h=$((TILE_SIZE * 2))
  local xx=$(( x + w - 1 ))
  local yy=$(( y + h - 1 ))
  local py=$(echo "$y + ($h * $offset)" | bc)
  convert ${OUTPUT_FILE} -fill "${MASK_COLOR}" -draw "rectangle $x,$y $xx,$yy" ${OUTPUT_FILE}
  _fillBackground $file 10
  composite $file-trans.png -geometry +$x+$py ${OUTPUT_FILE} ${OUTPUT_FILE}
}

# for monsters that stretch as they move (i.e. blobs and walkers)
placeHoriz() {
  local file=$1
  local x=$(_x $2)
  local y=$(_y $3)
  local offset=$4
  local w=$((TILE_SIZE * 2))
  local h=$TILE_SIZE
  local xx=$(( x + w - 1 ))
  local yy=$(( y + h - 1 ))
  local px=$(echo "$x + ($w * $offset)" | bc)
  convert ${OUTPUT_FILE} -fill "${MASK_COLOR}" -draw "rectangle $x,$y $xx,$yy" ${OUTPUT_FILE}
  _fillBackground $file 10
  composite $file-trans.png -geometry +$px+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

# -------------------------------------
# MS specific

_createMaskMS() {
  local file=$1
  local size=${TILE_SIZE}x${TILE_SIZE}
  if [ "$2" = "" ]; then
    local fuzz="10"
    local threshold="97"
  else
    local fuzz=$2
    local threshold=$3
  fi
  convert $file.png -fill white -fuzz ${fuzz}% -draw 'color 0,0 floodfill' $file-white.png
  convert $file-white.png -transparent white -resize $size $file-trans.png
  convert $file-white.png -threshold ${threshold}% -negate -alpha off -resize $size $file-mask.png
  convert $file-white.png -resize $size $file-white.png
}

_placeWithMaskMS() {
  local file=$1
  local x=$(( $2 * $TILE_SIZE ))
  local y=$(( $3 * $TILE_SIZE ))
  composite cc-floor.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
  composite $file-trans.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
  x=$(( ($2 + 3) * $TILE_SIZE ))
  composite $file-white.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
  x=$(( ($2 + 6) * $TILE_SIZE ))
  composite $file-mask.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

placeWithMaskMS() {
  local file=$1
  local x=$2
  local y=$3
  _checkForPng $file
  _createMaskMS $file $4 $5
  _placeWithMaskMS $file $x $y
}

# -------------------------------------
# CC2 specific

placeWithReveal() {
  local file=$1
  local x=$(_x $2)
  local y=$(_y $3)
  x=$(( $x - 1 ))
  # local x1=$(( $TILE_SIZE / 4 - 1 ))
  # local y1=$(( $TILE_SIZE / 4 ))
  # local x2=$(( $TILE_SIZE / 2 + $x1 - 1 ))
  # local y2=$(( $TILE_SIZE / 2 + $y1 - 1 ))

  # echo convert $file.png -fill "${MASK_COLOR}" -draw "rectangle $x1,$y1 $x2,$y2" $file-hollow.png
  # convert $file.png -fill "${MASK_COLOR}" -draw "rectangle $x1,$y1 $x2,$y2" $file-hollow.png
  # convert $file-hollow.png -fill none -stroke "${MASK_COLOR}" -draw "stroke-antialias 0 stroke-dasharray 1 1 path 'M 4,4 L 28,4'" $file-hollow.png
  place $file $2 $3
  composite ../cc2-reveal-mask.png -geometry +$x+$y ${OUTPUT_FILE} ${OUTPUT_FILE}
}

# -------------------------------------

echo Building tileset image...

doForceFloors() {
  place tile-force-n-a 1 0 1 1
  place tile-force-n-b 2 0 1 1
  place tile-force-n-c 3 0 1 1
  place tile-force-n-d 4 0 1 1

  convert tile-force-n-a.png -rotate -90 tile-force-w-1.png
  convert tile-force-n-b.png -rotate -90 tile-force-w-2.png
  convert tile-force-n-c.png -rotate -90 tile-force-w-3.png
  convert tile-force-n-d.png -rotate -90 tile-force-w-4.png
  place tile-force-w-1 5 0 1 1
  place tile-force-w-2 6 0 1 1
  place tile-force-w-3 7 0 1 1
  place tile-force-w-4 8 0 1 1

  convert tile-force-n-a.png -rotate 180 tile-force-s-1.png
  convert tile-force-n-b.png -rotate 180 tile-force-s-2.png
  convert tile-force-n-c.png -rotate 180 tile-force-s-3.png
  convert tile-force-n-d.png -rotate 180 tile-force-s-4.png
  place tile-force-s-1 9 0 1 1
  place tile-force-s-2 10 0 1 1
  place tile-force-s-3 11 0 1 1
  place tile-force-s-4 12 0 1 1

  convert tile-force-n-a.png -rotate 90 tile-force-e-1.png
  convert tile-force-n-b.png -rotate 90 tile-force-e-2.png
  convert tile-force-n-c.png -rotate 90 tile-force-e-3.png
  convert tile-force-n-d.png -rotate 90 tile-force-e-4.png
  place tile-force-e-1 13 0 1 1
  place tile-force-e-2 14 0 1 1
  place tile-force-e-3 15 0 1 1
  place tile-force-e-4 16 0 1 1

  convert ../tile-force-random-a.png -swirl 180 tile-force-random-1.png
  convert ../tile-force-random-b.png -swirl 180 tile-force-random-2.png
  convert ../tile-force-random-c.png -swirl 180 tile-force-random-3.png
  convert ../tile-force-random-d.png -swirl 180 tile-force-random-4.png
  place tile-force-random-1 17 0 1 1
  place tile-force-random-2 18 0 1 1
  place tile-force-random-3 19 0 1 1
  place tile-force-random-4 20 0 1 1
}

doWater() {
  convert ../tile-water.png -roll +32+32 tile-water-1.png
  convert ../tile-water.png -roll +64+64 tile-water-2.png
  convert ../tile-water.png -roll +96+96 tile-water-3.png
  convert ../tile-water.png -roll +128+128 tile-water-4.png
  convert ../tile-water.png -roll +160+160 tile-water-5.png
  convert ../tile-water.png -roll +192+192 tile-water-6.png
  convert ../tile-water.png -roll +224+224 tile-water-7.png

  place tile-water 28 0 1 1
  place tile-water-1 29 0 1 1
  place tile-water-2 30 0 1 1
  place tile-water-3 31 0 1 1
  place tile-water-4 32 0 1 1
  place tile-water-5 33 0 1 1
  place tile-water-6 34 0 1 1
  place tile-water-7 35 0 1 1
}

# floor
if [ $((TILE & FLOOR)) == $FLOOR ]; then
  echo - floor
  case $SETTYPE in
    $TWLYNX)
      place cc-floor 0 0
      ;;
    $TWMS)
      place cc-floor 0 0
      # invis wall no appear (floor)
      place cc-floor 0 5
      # invis wall appear (floor)
      place cc-floor 2 12
      # I'm leaving unused floors (2,0 3,6 3,7 3,8) alone
      ;;
    $MS)
      place cc-floor 0 0
      # invis wall no appear (floor)
      place cc-floor 0 5
      # invis wall appear (floor)
      place cc-floor 2 12
      # unused (floor)
      place cc-floor 2 0
      place cc-floor 3 6
      place cc-floor 3 7
      place cc-floor 3 8
      ;;
    $CC2)
      place cc-floor 0 2
      ;;
  esac
fi

# force floors
if [ $((TILE & FORCE)) == $FORCE ]; then
  echo - force floors
  case $SETTYPE in
    $TWLYNX)
      doForceFloors
      ;;
    $TWMS|$MS)
      place tile-force-n-a 1 2
      convert ../tile-force-n-a.png -rotate -90 tile-force-w.png
      place tile-force-w 1 4
      convert ../tile-force-n-a.png -rotate 180 tile-force-s.png
      place tile-force-s 0 13
      convert ../tile-force-n-a.png -rotate 90 tile-force-e.png
      place tile-force-e 1 3
      convert ../tile-force-random-a.png -swirl 180 tile-force-random.png
      place tile-force-random 3 2
      ;;
  esac
fi

# ice
if [ $((TILE & ICE)) == $ICE ]; then
  echo - ice
  case $SETTYPE in
    $TWLYNX)
      place tile-ice 21 0 1 1
      place tile-ice 22 0 1 1
      place cc-ice-nw 22 0 1 1
      place tile-ice 23 0 1 1
      place cc-ice-ne 23 0 1 1
      place tile-ice 24 0 1 1
      place cc-ice-sw 24 0 1 1
      place tile-ice 25 0 1 1
      place cc-ice-se 25 0 1 1
      ;;
    $TWMS|$MS)
      place tile-ice 0 12
      place tile-ice 1 10
      place cc-ice-se 1 10
      place tile-ice 1 11
      place cc-ice-sw 1 11
      place tile-ice 1 12
      place cc-ice-nw 1 12
      place tile-ice 1 13
      place cc-ice-ne 1 13
      ;;
    $CC2)
      place tile-ice 10 1
      place tile-ice 11 1
      place cc-ice-nw 11 1
      place tile-ice 12 1
      place cc-ice-ne 12 1
      place tile-ice 13 1
      place cc-ice-sw 13 1
      place tile-ice 14 1
      place cc-ice-se 14 1
      ;;
  esac
fi

# gravel
if [ $((TILE & GRAVEL)) == $GRAVEL ]; then
  echo - gravel
  case $SETTYPE in
    $TWLYNX)
      place tile-gravel 26 0 1 1
      ;;
    $TWMS|$MS)
      place tile-gravel 2 13
      ;;
  esac
fi

# dirt
if [ $((TILE & DIRT)) == $DIRT ]; then
  echo - dirt
  case $SETTYPE in
    $TWLYNX)
      place tile-dirt 27 0 1 1
      ;;
    $TWMS|$MS)
      place tile-dirt 0 11
      ;;
  esac
fi

# water
if [ $((TILE & WATER)) == $WATER ]; then
  echo - water
  case $SETTYPE in
    $TWLYNX)
      doWater
      place tile-splash 28 2 1 3
      ;;
    $TWMS|$MS)
      place tile-water 0 3
      place tile-splash 3 3
      ;;
  esac
fi

# fire
if [ $((TILE & FIRE)) == $FIRE ]; then
  echo - fire
  case $SETTYPE in
    $TWLYNX)
      place tile-fire-a 0 1 1 2
      place tile-fire-c 1 1 1 2
      place tile-fire-e 2 1 1 2
      place tile-fire-f 3 1 1 2
      place tile-fire-d 4 1 1 2
      place tile-fire-b 5 1 1 2
      ;;
    $TWMS|$MS)
      place tile-fire 0 4
      ;;
  esac
fi

# bomb
if [ $((TILE & BOMB)) == $BOMB ]; then
  echo - bomb
  case $SETTYPE in
    $TWLYNX)
      placeOnFloor cc-bomb-2 6 1
      placeOnFloor cc-bomb-3 7 1
      placeOnFloor cc-bomb-4 8 1
      placeOnFloor cc-bomb-3 9 1
      ;;
    $TWMS|$MS)
      placeOnFloor cc-bomb 2 10
      ;;
  esac
fi

# trap
if [ $((TILE & TRAP)) == $TRAP ]; then
  echo - trap
  case $SETTYPE in
    $TWLYNX)
      placeOnFloor cc-trap 10 1
      ;;
    $TWMS|$MS)
      placeOnFloor cc-trap 2 11
      ;;
  esac
fi

# thief
if [ $((TILE & THIEF)) == $THIEF ]; then
  echo - quicksand
  addFloorLines cc-quicksand
  case $SETTYPE in
    $TWLYNX)
      place cc-quicksand 11 1 1 2
      ;;
    $TWMS|$MS)
      place cc-quicksand 2 1
      ;;
  esac
fi

# hint
if [ $((TILE & HINT)) == $HINT ]; then
  echo - hint
  addFloorLines cc-hint
  case $SETTYPE in
    $TWLYNX)
      place cc-hint 12 1 1 2
      ;;
    $TWMS|$MS)
      place cc-hint 2 15
      ;;
  esac
fi

# buttons
if [ $((TILE & BUTTONS)) == $BUTTONS ]; then
  echo - buttons
  addFloorLines cc-blue-button
  addFloorLines cc-green-button
  addFloorLines cc-red-button
  addFloorLines cc-brown-button
  case $SETTYPE in
    $TWLYNX)
      place cc-blue-button 13 1 1 2
      place cc-green-button 14 1 1 2
      place cc-red-button 15 1 1 2
      place cc-brown-button 16 1 1 2
      ;;
    $TWMS|$MS)
      place cc-green-button 2 3
      place cc-red-button 2 4
      place cc-brown-button 2 7
      place cc-blue-button 2 8
      ;;
  esac
fi

# teleport
if [ $((TILE & TELEPORT)) == $TELEPORT ]; then
  echo - teleport
  case $SETTYPE in
    $TWLYNX)
      addFloorLines cc-teleport-a
      addFloorLines cc-teleport-b
      addFloorLines cc-teleport-c
      addFloorLines cc-teleport-d
      place cc-teleport-a 17 1 1 2
      place cc-teleport-b 18 1 1 2
      place cc-teleport-c 19 1 1 2
      place cc-teleport-d 20 1 1 2
      ;;
    $TWMS|$MS)
      addFloorLines cc-teleport
      place cc-teleport 2 9
      ;;
  esac
fi

# wall
if [ $((TILE & WALL)) == $WALL ]; then
  echo - wall
  case $SETTYPE in
    $TWLYNX)
      place cc-wall 21 1 1 2
      ;;
    $TWMS|$MS)
      place cc-wall 0 1
      ;;
  esac
fi

# thin walls
if [ $((TILE & THIN_WALLS)) == $THIN_WALLS ]; then
  echo - thin walls
  case $SETTYPE in
    $TWLYNX)
      placeDirectlyOnFloor cc-thin-n 22 1
      placeDirectlyOnFloor cc-thin-w 23 1
      placeDirectlyOnFloor cc-thin-s 24 1
      placeDirectlyOnFloor cc-thin-e 25 1
      placeDirectlyOnFloor cc-thin-se 26 1
      ;;
    $TWMS|$MS)
      placeDirectlyOnFloor cc-thin-n 0 6
      placeDirectlyOnFloor cc-thin-w 0 7
      placeDirectlyOnFloor cc-thin-s 0 8
      placeDirectlyOnFloor cc-thin-e 0 9
      placeDirectlyOnFloor cc-thin-se 3 0
      ;;
  esac
fi

# blue wall
if [ $((TILE & BLUE_BLOCK)) == $BLUE_BLOCK ]; then
  echo - blue wall
  case $SETTYPE in
    $TWLYNX)
      place cc-blue-wall 27 1 1 2
      ;;
    $TWMS|$MS)
      place cc-blue-wall 1 14
      place cc-blue-wall 1 15
      ;;
  esac
fi

# toggle walls
if [ $((TILE & TOGGLE_WALLS)) == $TOGGLE_WALLS ]; then
  echo - toggles
  case $SETTYPE in
    $TWLYNX)
      # open
      place cc-floor 28 1 1 2
      place cc-toggle-outline-on-a 28 1 1 2
      place cc-floor 29 1 1 2
      place cc-toggle-outline-on-b 29 1 1 2
      place cc-floor 30 1 1 2
      place cc-toggle-outline-on-c 30 1 1 2
      place cc-floor 31 1 1 2
      place cc-toggle-outline-on-d 31 1 1 2
      #closed
      place cc-wall 32 1 1 2
      place cc-toggle-outline-off-a 32 1 1 2
      place cc-wall 33 1 1 2
      place cc-toggle-outline-off-b 33 1 1 2
      place cc-wall 34 1 1 2
      place cc-toggle-outline-off-c 34 1 1 2
      place cc-wall 35 1 1 2
      place cc-toggle-outline-off-d 35 1 1 2
      ;;
    $TWMS|$MS)
      place cc-wall 2 5
      place cc-toggle-outline-off 2 5
      place cc-floor 2 6
      place cc-toggle-outline-on 2 6
      ;;
  esac
fi

# popup
if [ $((TILE & POPUP)) == $POPUP ]; then
  echo - popup
  addFloorLines cc-passonce
  case $SETTYPE in
    $TWLYNX)
      place cc-passonce 0 2 1 3
      ;;
    $TWMS|$MS)
      place cc-passonce 2 14
      ;;
  esac
fi

# clone machine
if [ $((TILE & CLONE_MACHINE)) == $CLONE_MACHINE ]; then
  echo - clone machine
  case $SETTYPE in
    $TWLYNX)
      placeOnFloor cc-clonemachine-a 1 2
      placeOnFloor cc-clonemachine-b 2 2
      placeOnFloor cc-clonemachine-c 3 2
      placeOnFloor cc-clonemachine-b 4 2
      ;;
    $TWMS|$MS)
      placeOnFloor cc-clonemachine 3 1
      ;;
    $CC2)
      placeOnFloor cc-clonemachine 15 1
      ;;
  esac
fi

# doors
if [ $((TILE & DOORS)) == $DOORS ]; then
  echo - doors
  case $SETTYPE in
    $TWLYNX)
      place cc-red-door 5 2 1 3
      place cc-blue-door 6 2 1 3
      place cc-yellow-door 7 2 1 3
      place cc-green-door 8 2 1 3
      ;;
    $TWMS|$MS)
      place cc-blue-door 1 6
      place cc-red-door 1 7
      place cc-green-door 1 8
      place cc-yellow-door 1 9
      ;;
    $CC2)
      place cc-red-door 0 1
      place cc-blue-door 1 1
      place cc-yellow-door 2 1
      place cc-green-door 3 1
      ;;
  esac
fi

# socket
if [ $((TILE & SOCKET)) == $SOCKET ]; then
  echo - socket
  case $SETTYPE in
    $TWLYNX)
      placeOnFloor cc-gate 9 2
      ;;
    $TWMS|$MS)
      placeOnFloor cc-gate 2 2
      ;;
  esac
fi

# exit
if [ $((TILE & EXIT)) == $EXIT ]; then
  echo - exit
  case $SETTYPE in
    $TWLYNX)
      place cc-exit-a 10 2 1 3
      place cc-exit-b 11 2 1 3
      place cc-exit-c 12 2 1 3
      place cc-exit-d 13 2 1 3
    
      place cc-exit-a 23 2 1 3
      place cc-exit-c 24 2 1 3
      ;;
    $TWMS|$MS)
      place cc-exit 1 5
      place cc-exit 3 10
      place cc-exit 3 11
      ;;
  esac
fi

# computer chip
if [ $((TILE & COMPUTER_CHIP)) == $COMPUTER_CHIP ]; then
  echo - computer chip
  case $SETTYPE in
    $TWLYNX)
      placeOnFloor cc-computerchip 14 2
      ;;
    $TWMS|$MS)
      placeOnFloor cc-computerchip 0 2
      ;;
  esac
fi

# keys
if [ $((TILE & KEYS)) == $KEYS ]; then
  echo - keys
  case $SETTYPE in
    $TWLYNX)
      placeWithMask cc-red-key 15 2
      placeWithMask cc-blue-key 16 2
      placeWithMask cc-yellow-key 17 2
      placeWithMask cc-green-key 18 2
      ;;
    $TWMS)
      placeWithMask cc-blue-key 6 4
      placeWithMask cc-red-key 6 5
      placeWithMask cc-green-key 6 6
      placeWithMask cc-yellow-key 6 7
      ;;
    $MS)
      placeWithMaskMS cc-blue-key 6 4
      placeWithMaskMS cc-red-key 6 5
      placeWithMaskMS cc-green-key 6 6
      placeWithMaskMS cc-yellow-key 6 7
      ;;
    $CC2)
      placeWithMask cc-red-key 4 1
      placeWithMask cc-blue-key 5 1
      placeWithMask cc-yellow-key 6 1
      placeWithMask cc-green-key 7 1
      ;;
  esac
fi

# footwear
if [ $((TILE & FOOTWEAR)) == $FOOTWEAR ]; then
  echo - footwear
  case $SETTYPE in
    $TWLYNX)
      placeWithMask cc-ice-skate 19 2 1 3
      placeWithMask cc-force-boot 20 2 1 3
      placeWithMask cc-fire-boot 21 2 1 3
      placeWithMask tile-flipper 22 2 1 3
      ;;
    $TWMS)
      placeWithMask tile-flipper 6 8
      placeWithMask cc-fire-boot 6 9
      placeWithMask cc-ice-skate 6 10
      placeWithMask cc-force-boot 6 11
      ;;
    $MS)
      placeWithMaskMS tile-flipper 6 8
      placeWithMaskMS cc-fire-boot 6 9
      placeWithMaskMS cc-ice-skate 6 10
      placeWithMaskMS cc-force-boot 6 11
      ;;
  esac
fi

# chip
if [ $((TILE & CHIP)) == $CHIP ]; then
  echo - chip
  case $SETTYPE in
    $TWLYNX)
      # running
      placeWithMask cc-will-n-a 0 3 1 4
      placeWithMask cc-will-n-b 1 3 1 4
      placeWithMask cc-will-n-c 2 3 1 4
      placeWithMask cc-will-n-b 3 3 1 4
      placeWithMask cc-will-w-a 4 3 1 4
      placeWithMask cc-will-w-b 5 3 1 4
      placeWithMask cc-will-w-c 6 3 1 4
      placeWithMask cc-will-w-b 7 3 1 4
      placeWithMask cc-will-s-a 0 4 1 4
      placeWithMask cc-will-s-b 1 4 1 4
      placeWithMask cc-will-s-c 2 4 1 4
      placeWithMask cc-will-s-b 3 4 1 4
      placeWithMask cc-will-e-a 4 4 1 4
      placeWithMask cc-will-e-b 5 4 1 4
      placeWithMask cc-will-e-c 6 4 1 4
      placeWithMask cc-will-e-b 7 4 1 4
    
      # pushing
      placeWithMask cc-will-push-n-a 8 3 1 4
      placeWithMask cc-will-push-n-b 9 3 1 4
      placeWithMask cc-will-push-n-c 10 3 1 4
      placeWithMask cc-will-push-n-b 11 3 1 4
      placeWithMask cc-will-push-w-a 12 3 1 4
      placeWithMask cc-will-push-w-b 13 3 1 4
      placeWithMask cc-will-push-w-c 14 3 1 4
      placeWithMask cc-will-push-w-b 15 3 1 4
      placeWithMask cc-will-push-s-a 8 4 1 4
      placeWithMask cc-will-push-s-b 9 4 1 4
      placeWithMask cc-will-push-s-c 10 4 1 4
      placeWithMask cc-will-push-s-b 11 4 1 4
      placeWithMask cc-will-push-e-a 12 4 1 4
      placeWithMask cc-will-push-e-b 13 4 1 4
      placeWithMask cc-will-push-e-c 14 4 1 4
      placeWithMask cc-will-push-e-b 15 4 1 4
        
      # burned chip
      convert cc-will-s-b.png -colorspace Gray cc-will-burned.png
      place tile-fire 25 2 1 3
      placeTransparent cc-will-burned 25 2 1 3
      placeOnFloor cc-will-burned 26 2
    
      # chip in exit
      place cc-exit-a 27 2 1 3
      placeTransparent cc-will-exit 27 2 1 3
      
      # chip swimming
      place tile-water 29 2 1 3
      placeTopHalf cc-will-n-b 29 2 1 3
      place tile-water 30 2 1 3
      placeTopHalf cc-will-w-b 30 2 1 3
      place tile-water 31 2 1 3
      placeTopHalf cc-will-s-b 31 2 1 3
      place tile-water 32 2 1 3
      placeTopHalf cc-will-e-b 32 2 1 3

      ;;
    $TWMS)
      # walking
      placeWithMask cc-will-n 6 12
      placeWithMask cc-will-w 6 13
      placeWithMask cc-will-s 6 14
      placeWithMask cc-will-e 6 15

      # burned chip
      convert cc-will-s.png -colorspace Gray cc-will-burned.png
      place tile-fire 3 4
      placeTransparent cc-will-burned 3 4
      placeOnFloor cc-will-burned 3 5

      # chip in exit
      place cc-exit 3 9
      placeTransparent cc-will-exit 3 9
      
      # chip swimming
      place tile-water 3 12
      placeTopHalf cc-will-n 3 12
      place tile-water 3 13
      placeTopHalf cc-will-w 3 13
      place tile-water 3 14
      placeTopHalf cc-will-s 3 14
      place tile-water 3 15
      placeTopHalf cc-will-e 3 15
      ;;
    $MS)
      # walking
      placeWithMaskMS cc-will-n 6 12
      placeWithMaskMS cc-will-w 6 13
      placeWithMaskMS cc-will-s 6 14
      placeWithMaskMS cc-will-e 6 15

      # burned chip
      convert cc-will-s.png -colorspace Gray cc-will-burned.png
      place tile-fire 3 4
      placeTransparent cc-will-burned 3 4
      placeOnFloor cc-will-burned 3 5

      # chip in exit
      place cc-exit 3 9
      placeTransparent cc-will-exit 3 9
      
      # chip swimming
      place tile-water 3 12
      placeTopHalf cc-will-n 3 12
      place tile-water 3 13
      placeTopHalf cc-will-w 3 13
      place tile-water 3 14
      placeTopHalf cc-will-s 3 14
      place tile-water 3 15
      placeTopHalf cc-will-e 3 15
      ;;
  esac

fi

# block
if [ $((TILE & BLOCK)) == $BLOCK ]; then
  echo - block
  case $SETTYPE in
    $TWLYNX)
      place cc-block 16 3 1 4
      place cc-block 16 4 1 4
      ;;
    $TWMS|$MS)
      place cc-block 0 10
      # placeOnFloor cc-block 0 10
      ;;
    $CC2)
      place cc-block 8 1
      placeWithReveal cc-block 9 1
      ;;
  esac
fi

# tank
if [ $((TILE & TANK)) == $TANK ]; then
  echo - tank
  case $SETTYPE in
    $TWLYNX)
      placeWithMask cc-tank-n 17 3 1 4
      placeWithMask cc-tank-w 18 3 1 4
      placeWithMask cc-tank-s 17 4 1 4
      placeWithMask cc-tank-e 18 4 1 4
      ;;
    $TWMS)
      placeWithMask cc-tank-n 4 12
      placeWithMask cc-tank-w 4 13
      placeWithMask cc-tank-s 4 14
      placeWithMask cc-tank-e 4 15
      ;;
    $MS)
      placeWithMaskMS cc-tank-n 4 12
      placeWithMaskMS cc-tank-w 4 13
      placeWithMaskMS cc-tank-s 4 14
      placeWithMaskMS cc-tank-e 4 15
      ;;
  esac
fi

# ball
if [ $((TILE & BALL)) == $BALL ]; then
  echo - ball
  case $SETTYPE in
    $TWLYNX)
      placeFillBackground cc-ball-v-a 10 19 3 1 4
      placeFillBackground cc-ball-v-b 10 20 3 1 4
      placeFillBackground cc-ball-v-c 10 21 3 1 4
      placeFillBackground cc-ball-v-d 10 22 3 1 4
      placeFillBackground cc-ball-v-c 10 19 4 1 4
      placeFillBackground cc-ball-v-b 10 20 4 1 4
      placeFillBackground cc-ball-v-a 10 21 4 1 4
      placeFillBackground cc-ball-v-d 10 22 4 1 4
      placeFillBackground cc-ball-h-a 10 23 3 1 4
      placeFillBackground cc-ball-h-b 10 24 3 1 4
      placeFillBackground cc-ball-h-c 10 25 3 1 4
      placeFillBackground cc-ball-h-d 10 26 3 1 4
      placeFillBackground cc-ball-h-c 10 23 4 1 4
      placeFillBackground cc-ball-h-b 10 24 4 1 4
      placeFillBackground cc-ball-h-a 10 25 4 1 4
      placeFillBackground cc-ball-h-d 10 26 4 1 4
      ;;
    $TWMS)
      placeWithMask cc-ball 4 8
      placeWithMask cc-ball 4 9
      placeWithMask cc-ball 4 10
      placeWithMask cc-ball 4 11
      ;;
    $MS)
      placeWithMaskMS cc-ball 4 8
      placeWithMaskMS cc-ball 4 9
      placeWithMaskMS cc-ball 4 10
      placeWithMaskMS cc-ball 4 11
      ;;
  esac
fi

# glider
if [ $((TILE & GLIDER)) == $GLIDER ]; then
  echo - glider
  case $SETTYPE in
    $TWLYNX)
      placeWithMask cc-glider-n 27 3 1 4
      placeWithMask cc-glider-n 28 3 1 4
      placeWithMask cc-glider-n 29 3 1 4
      placeWithMask cc-glider-n 30 3 1 4
      placeWithMask cc-glider-w 31 3 1 4
      placeWithMask cc-glider-w 32 3 1 4
      placeWithMask cc-glider-w 33 3 1 4
      placeWithMask cc-glider-w 34 3 1 4
      placeWithMask cc-glider-s 27 4 1 4
      placeWithMask cc-glider-s 28 4 1 4
      placeWithMask cc-glider-s 29 4 1 4
      placeWithMask cc-glider-s 30 4 1 4
      placeWithMask cc-glider-e 31 4 1 4
      placeWithMask cc-glider-e 32 4 1 4
      placeWithMask cc-glider-e 33 4 1 4
      placeWithMask cc-glider-e 34 4 1 4
      ;;
    $TWMS)
      placeWithMask cc-glider-n 5 0
      placeWithMask cc-glider-w 5 1
      placeWithMask cc-glider-s 5 2
      placeWithMask cc-glider-e 5 3
      ;;
    $MS)
      placeWithMaskMS cc-glider-n 5 0
      placeWithMaskMS cc-glider-w 5 1
      placeWithMaskMS cc-glider-s 5 2
      placeWithMaskMS cc-glider-e 5 3
      ;;
  esac
fi

# fireball
if [ $((TILE & FIREBALL)) == $FIREBALL ]; then
  echo - fireball
  case $SETTYPE in
    $TWLYNX)
      placeFillBackground tile-fireball-x-a 30 0 6 1 5
      placeFillBackground tile-fireball-x-b 30 1 6 1 5
      placeFillBackground tile-fireball-x-c 30 2 6 1 5
      placeFillBackground tile-fireball-x-d 30 3 6 1 5
    
      convert tile-fireball-x-a-trans.png -rotate 90 tile-fireball-w-a-trans.png
      convert tile-fireball-x-b-trans.png -rotate 90 tile-fireball-w-b-trans.png
      convert tile-fireball-x-c-trans.png -rotate 90 tile-fireball-w-c-trans.png
      convert tile-fireball-x-d-trans.png -rotate 90 tile-fireball-w-d-trans.png
      place tile-fireball-w-a-trans 4 5 1 5
      place tile-fireball-w-b-trans 5 5 1 5
      place tile-fireball-w-c-trans 6 5 1 5
      place tile-fireball-w-d-trans 7 5 1 5
    
      convert tile-fireball-x-a-trans.png -rotate -90 tile-fireball-e-a-trans.png
      convert tile-fireball-x-b-trans.png -rotate -90 tile-fireball-e-b-trans.png
      convert tile-fireball-x-c-trans.png -rotate -90 tile-fireball-e-c-trans.png
      convert tile-fireball-x-d-trans.png -rotate -90 tile-fireball-e-d-trans.png
      place tile-fireball-e-a-trans 4 6 1 5
      place tile-fireball-e-b-trans 5 6 1 5
      place tile-fireball-e-c-trans 6 6 1 5
      place tile-fireball-e-d-trans 7 6 1 5
    
      convert tile-fireball-x-a-trans.png -rotate 180 tile-fireball-n-a-trans.png
      convert tile-fireball-x-b-trans.png -rotate 180 tile-fireball-n-b-trans.png
      convert tile-fireball-x-c-trans.png -rotate 180 tile-fireball-n-c-trans.png
      convert tile-fireball-x-d-trans.png -rotate 180 tile-fireball-n-d-trans.png
      place tile-fireball-n-a-trans 0 5 1 5
      place tile-fireball-n-b-trans 1 5 1 5
      place tile-fireball-n-c-trans 2 5 1 5
      place tile-fireball-n-d-trans 3 5 1 5
      ;;
    $TWMS)
      placeFillBackground tile-fireball-x-a 30 4 6

      convert tile-fireball-x-a.png -rotate 90 tile-fireball-w-a.png
      placeFillBackground tile-fireball-w-a 30 4 5

      convert tile-fireball-x-a.png -rotate -90 tile-fireball-e-a.png
      placeFillBackground tile-fireball-e-a 30 4 7

      convert tile-fireball-x-a.png -rotate 180 tile-fireball-n-a.png
      placeFillBackground tile-fireball-n-a 30 4 4
      ;;
    $MS)
      placeWithMaskMS tile-fireball-x-a 4 6 30 99

      convert tile-fireball-x-a.png -rotate 90 tile-fireball-w-a.png
      placeWithMaskMS tile-fireball-w-a 4 5 30 99

      convert tile-fireball-x-a.png -rotate -90 tile-fireball-e-a.png
      placeWithMaskMS tile-fireball-e-a 4 7 30 99

      convert tile-fireball-x-a.png -rotate 180 tile-fireball-n-a.png
      placeWithMaskMS tile-fireball-n-a 4 4 30 99
      ;;
  esac
fi

# bug
if [ $((TILE & BUG)) == $BUG ]; then
  echo - bug
  case $SETTYPE in
    $TWLYNX)
      placeWithMask cc-bug-n-a 8 5 1 5
      placeWithMask cc-bug-n-b 9 5 1 5
      placeWithMask cc-bug-n-c 10 5 1 5
      placeWithMask cc-bug-n-b 11 5 1 5
      placeWithMask cc-bug-w-a 12 5 1 5
      placeWithMask cc-bug-w-b 13 5 1 5
      placeWithMask cc-bug-w-c 14 5 1 5
      placeWithMask cc-bug-w-b 15 5 1 5
      placeWithMask cc-bug-s-a 8 6 1 5
      placeWithMask cc-bug-s-b 9 6 1 5
      placeWithMask cc-bug-s-c 10 6 1 5
      placeWithMask cc-bug-s-b 11 6 1 5
      placeWithMask cc-bug-e-a 12 6 1 5
      placeWithMask cc-bug-e-b 13 6 1 5
      placeWithMask cc-bug-e-c 14 6 1 5
      placeWithMask cc-bug-e-b 15 6 1 5
      ;;
    $TWMS)
      placeWithMask cc-bug-n 4 0
      placeWithMask cc-bug-w 4 1
      placeWithMask cc-bug-s 4 2
      placeWithMask cc-bug-e 4 3
      ;;
    $MS)
      placeWithMaskMS cc-bug-n 4 0
      placeWithMaskMS cc-bug-w 4 1
      placeWithMaskMS cc-bug-s 4 2
      placeWithMaskMS cc-bug-e 4 3
      ;;
  esac
fi

# paramecium
if [ $((TILE & PARAMECIUM)) == $PARAMECIUM ]; then
  echo - paramecium
  case $SETTYPE in
    $TWLYNX)
      placeWithMask cc-paramecium-n-a 16 5 1 5
      placeWithMask cc-paramecium-n-b 17 5 1 5
      placeWithMask cc-paramecium-n-c 18 5 1 5
      placeWithMask cc-paramecium-n-d 19 5 1 5
      placeWithMask cc-paramecium-w-a 20 5 1 5
      placeWithMask cc-paramecium-w-b 21 5 1 5
      placeWithMask cc-paramecium-w-c 22 5 1 5
      placeWithMask cc-paramecium-w-d 23 5 1 5
      placeWithMask cc-paramecium-s-a 16 6 1 5
      placeWithMask cc-paramecium-s-b 17 6 1 5
      placeWithMask cc-paramecium-s-c 18 6 1 5
      placeWithMask cc-paramecium-s-d 19 6 1 5
      placeWithMask cc-paramecium-e-a 20 6 1 5
      placeWithMask cc-paramecium-e-b 21 6 1 5
      placeWithMask cc-paramecium-e-c 22 6 1 5
      placeWithMask cc-paramecium-e-d 23 6 1 5
      ;;
    $TWMS)
      placeWithMask cc-paramecium-v 6 0
      placeWithMask cc-paramecium-h 6 1
      placeWithMask cc-paramecium-v 6 2
      placeWithMask cc-paramecium-h 6 3
      ;;
    $MS)
      placeWithMaskMS cc-paramecium-v 6 0
      placeWithMaskMS cc-paramecium-h 6 1
      placeWithMaskMS cc-paramecium-v 6 2
      placeWithMaskMS cc-paramecium-h 6 3
      ;;
  esac
fi

# teeth
if [ $((TILE & TEETH)) == $TEETH ]; then
  echo - teeth
  case $SETTYPE in
    $TWLYNX)
      placeWithMask cc-teeth-n-a 24 5 1 5
      placeWithMask cc-teeth-n-b 25 5 1 5
      placeWithMask cc-teeth-n-c 26 5 1 5
      placeWithMask cc-teeth-n-b 27 5 1 5
      placeWithMask cc-teeth-w-a 28 5 1 5
      placeWithMask cc-teeth-w-b 29 5 1 5
      placeWithMask cc-teeth-w-c 30 5 1 5
      placeWithMask cc-teeth-w-b 31 5 1 5
      placeWithMask cc-teeth-s-a 24 6 1 5
      placeWithMask cc-teeth-s-b 25 6 1 5
      placeWithMask cc-teeth-s-c 26 6 1 5
      placeWithMask cc-teeth-s-b 27 6 1 5
      placeWithMask cc-teeth-e-a 28 6 1 5
      placeWithMask cc-teeth-e-b 29 6 1 5
      placeWithMask cc-teeth-e-c 30 6 1 5
      placeWithMask cc-teeth-e-b 31 6 1 5
      ;;
    $TWMS)
      placeWithMask cc-teeth-n 5 4
      placeWithMask cc-teeth-w 5 5
      placeWithMask cc-teeth-s 5 6
      placeWithMask cc-teeth-e 5 7
      ;;
    $MS)
      placeWithMaskMS cc-teeth-n 5 4
      placeWithMaskMS cc-teeth-w 5 5
      placeWithMaskMS cc-teeth-s 5 6
      placeWithMaskMS cc-teeth-e 5 7
      ;;
  esac
fi

# blob
if [ $((TILE & BLOB)) == $BLOB ]; then
  echo - blob
  case $SETTYPE in
    $TWLYNX)
      placeVert cc-blob-v-a 0 7 0.4
      placeVert cc-blob-v-b 1 7 0.25
      placeVert cc-blob-v-a 2 7 0.1
      placeVert cc-blob-v-c 3 7 0
      placeVert cc-blob-v-a 4 7 0.1
      placeVert cc-blob-v-b 5 7 0.25
      placeVert cc-blob-v-a 6 7 0.4
      placeVert cc-blob-v-c 7 7 0.5
      placeHoriz cc-blob-h-a 8 7 0.4
      placeHoriz cc-blob-h-b 10 7 0.25
      placeHoriz cc-blob-h-a 12 7 0.1
      placeHoriz cc-blob-h-c 14 7 0
      placeHoriz cc-blob-h-a 8 8 0.1
      placeHoriz cc-blob-h-b 10 8 0.25
      placeHoriz cc-blob-h-a 12 8 0.4
      placeHoriz cc-blob-h-c 14 8 0.5
      ;;
    $TWMS)
      placeWithMask cc-blob 5 12
      placeWithMask cc-blob 5 13
      placeWithMask cc-blob 5 14
      placeWithMask cc-blob 5 15
      ;;
    $MS)
      placeWithMaskMS cc-blob 5 12
      placeWithMaskMS cc-blob 5 13
      placeWithMaskMS cc-blob 5 14
      placeWithMaskMS cc-blob 5 15
      ;;
  esac
fi

# walker
if [ $((TILE & WALKER)) == $WALKER ]; then
  echo - walker
  case $SETTYPE in
    $TWLYNX)
      placeVert cc-walker-v-a 16 7 0.4
      placeVert cc-walker-v-b 17 7 0.25
      placeVert cc-walker-v-c 18 7 0.1
      placeVert cc-walker-v-b 19 7 0
      placeVert cc-walker-v-a 20 7 0.1
      placeVert cc-walker-v-b 21 7 0.25
      placeVert cc-walker-v-c 22 7 0.4
      placeVert cc-walker-v-b 23 7 0.5
      placeHoriz cc-walker-h-a 24 7 0.4
      placeHoriz cc-walker-h-b 26 7 0.25
      placeHoriz cc-walker-h-c 28 7 0.1
      placeHoriz cc-walker-h-b 30 7 0
      placeHoriz cc-walker-h-a 24 8 0.1
      placeHoriz cc-walker-h-b 26 8 0.25
      placeHoriz cc-walker-h-c 28 8 0.4
      placeHoriz cc-walker-h-b 30 8 0.5
      ;;
    $TWMS)
      placeWithMask cc-walker-h 5 8
      placeWithMask cc-walker-v 5 9
      placeWithMask cc-walker-h 5 10
      placeWithMask cc-walker-v 5 11
      ;;
    $MS)
      placeWithMaskMS cc-walker-h 5 8
      placeWithMaskMS cc-walker-v 5 9
      placeWithMaskMS cc-walker-h 5 10
      placeWithMaskMS cc-walker-v 5 11
      ;;
  esac
fi

# clone block
if [ $((TILE & CLONE_BLOCK)) == $CLONE_BLOCK ]; then
  echo - clone blocks
  case $SETTYPE in
    $TWLYNX)
      ;;
    $TWMS|$MS)
      place cc-block 0 14
      place cc-block 0 15
      place cc-block 1 0
      place cc-block 1 1
      ;;
  esac
fi


if [ $DO_INSTALL == 1 ]; then
  echo "Installing to ${INSTALL_DESTINATION}"
  cp -f ${OUTPUT_FILE} ${INSTALL_DESTINATION}
fi

echo Done!
