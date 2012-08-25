module Game.Interact ( interact
                     ) where

import Game.Object

interact :: Set Object -> Object
interact objs
        | objs == fromList [0, 1]

affinity :: Set Object -> Integer
affinity (Object 0) (Object 2) = 1
affinity (Object 2) (Object 0) = 0
affinity (Object 2) (Object 2) = 2
affinity (Object 0) (Object 0) = 3
affinity _ _ = 0
