{-# LANGUAGE TemplateHaskell #-}
module A where

a = ()
$(return [])


{-
module Main (main) where

import MinImports.Plugin (plugin)


main :: IO ()
main = undefined
-}
