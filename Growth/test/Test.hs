module Main (main) where

import Test.Framework

import qualified Queue
import qualified Vector
import qualified Indeterminate

main = defaultMain
        [ Queue.test
        , Vector.test
        , Indeterminate.test
        ]
