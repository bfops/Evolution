-- | Render the game state
module Game.Render ( Drawable (..)
                   ) where

import Prelude ()
import Util.Prelewd

import Data.Array.IArray
import Data.Tuple

import Game.Object
import Game.State
import Util.IO

import Wrappers.OpenGL hiding (Position, color)

-- | Convert the game's vector to an OpenGL coordinate
toGLVertex :: Position -> Vertex2 GLdouble
toGLVertex = fmap realToFrac . uncurry Vertex2

-- | Things which can be drawn
class Drawable d where
    -- | Render the object to the screen
    draw :: d -> IO ()

instance Drawable State where
    draw = mapM_ (uncurry $ maybe (return ()) . locateDraw) . assocs . grid

locateDraw :: Position -> Object -> IO ()
locateDraw p obj = let (Vertex2 x y) = toGLVertex p
                       (Vertex2 x' y') = Vertex2 (x + 1/8) (y + 1/8 :: GLdouble)
                   in renderPrimitive Quads $ drawColored (color obj :: Color4 GLdouble)
                        [ Vertex2 x  y
                        , Vertex2 x  y'
                        , Vertex2 x' y
                        , Vertex2 x' y'
                        ]

color :: (GLColor c, ColorDef c) => Object -> c
color _ = green
