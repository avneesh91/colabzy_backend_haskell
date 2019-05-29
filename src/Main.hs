{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty as SC
import Data.Monoid (mconcat)

import Data.Default
import Control.Monad
import Control.Monad.IO.Class
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Static
import qualified Web.Scotty as SC
import qualified Colabzy.WebSocket.ColabzySocket as CCS
import qualified Colabzy.Utils.Middleware as ML
import qualified Network.Wai.Handler.Warp as Warp
import qualified Network.Wai.Handler.WebSockets as WaiWs
import qualified Network.WebSockets as WS
import qualified Network.Wai.Middleware.Gzip as GZ
import qualified Network.Wai as Wai
import qualified Colabzy.Utils.Views as VI

baseApp :: IO Wai.Application
baseApp = do
    logger <- liftIO $ mkRequestLogger def { outputFormat = Apache FromHeader }
    SC.scottyApp $ do

        -- Logging Middleware
        SC.middleware logger
        
        -- All the middlewares
        SC.middleware ML.compressionMiddleware
        SC.middleware ML.staticMiddleware

        -- Backend paths for serving shit
        SC.get "/" $ SC.file "./build/index.html"
        SC.get "/editor" $ SC.file "./build/index.html"

        -- Rest APIs
        SC.get "/newMeeting" $ VI.foo VI.serveMeetingId
    

main :: IO()
main = do
    let port = 3000
    let settings = Warp.setPort port Warp.defaultSettings
    sapp <- baseApp
    Warp.runSettings settings $ WaiWs.websocketsOr WS.defaultConnectionOptions CCS.wsapp sapp
