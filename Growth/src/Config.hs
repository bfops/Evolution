-- | Settings are stored in this module
module Config ( viewDist
              , title
              , windowSize
              , bgColor
              ) where

import Prelude ()
import Util.Prelewd

-- | Viewing distance of the camera
viewDist :: Int
viewDist = 16

-- | Title of the game window
title :: String
title = "Game"

-- | Dimensions of the game window
windowSize :: Integral a => (a, a)
windowSize = (800, 600)

-- | Background color
bgColor :: Num a => (a, a, a, a)
bgColor = (0, 175, 200, 0)
