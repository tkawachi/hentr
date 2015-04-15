module Main where

import Filesystem.Path.CurrentOS
import System.FSNotify
import Control.Concurrent (threadDelay)
import Control.Monad (forever)
import System.IO
import qualified Data.Text as T

{-
Haskell version of entr command.
-}
main :: IO ()
main =
  withManager $ \mgr -> do
    watchDir
      mgr
      -- TODO read from command line args
      (decodeString ".")
      (const True)
      printEventPath
    forever $ threadDelay maxBound

-- print an event path to stdout.
printEventPath :: Event -> IO()
printEventPath event = case toText (eventPath event) of
  Right path -> putStrLn $ T.unpack path
  Left path -> warn $ T.unpack path

warn :: String -> IO ()
warn = hPutStrLn stderr
