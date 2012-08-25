-- | Functions for dealing with game state
module Game.State ( State (..)
                  , Position
                  , initState
                  ) where

import Prelude ()
import Util.Prelewd hiding (id, empty)

import Data.Array.IArray

import Text.Show

import Game.Object

-- | Grid position
type Position = (Integer, Integer)

-- | Game state structure
data State = State { grid :: Array Position (Maybe Object)
                   }
    deriving (Show)

-- | Game state with nothing in it
initState :: State
initState = State { grid = listArray ((0, 0), (8, 8)) (repeat Nothing) }
