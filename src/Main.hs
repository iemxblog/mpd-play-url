{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Data.Text.Lazy.Encoding (decodeUtf8)
import Data.Text.Lazy
import System.Process
import Control.Monad
import Control.Monad.Trans

main :: IO ()
main = scotty 3000 $ do

    get "/" $ do
        html "<p>URL du podcast :</p><form method=POST action=\"podcast\"><input type=text name=podcast_url><input type=submit></form>"

    post "/podcast" $ do
        url <- liftM decodeUtf8 $ param "podcast_url"
        out1 <- liftIO $ readProcess "mpc" ["add", unpack url] ""
        out2 <- liftIO $ readProcess "mpc" ["play"] ""
        text $ pack $ out1 ++ out2
