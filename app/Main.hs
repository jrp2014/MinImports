{-# LANGUAGE TemplateHaskell #-}
module A where

import Data.Maybe

a = ()
$(return [])


{-
module Main (main) where

import MinImports.Plugin (plugin)


main :: IO ()
main = undefined
-}
