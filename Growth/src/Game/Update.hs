-- | Game world tranformations over time
module Game.Update ( update
                   ) where

import Prelude ()
import Util.Prelewd hiding (id, empty)

import Game.State

-- | One update "tick"
update :: State -> State
update g = foldr ($) g
            [
            ]
