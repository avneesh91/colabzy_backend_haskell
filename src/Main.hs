{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty as SC
import Data.Monoid (mconcat)

import Data.Default
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

baseApp :: IO Wai.Application
baseApp = do
    logger <- liftIO $ mkRequestLogger def { outputFormat = Apache FromHeader }
    SC.scottyApp $ do
        SC.middleware ML.compressionMiddleware
        --SC.middleware ML.loggerMiddleware
        SC.middleware ML.staticMiddleware
        --SC.middleware $ GZ.gzip $ GZ.def {GZ.gzipFiles = GZ.GzipCompress }
        --SC.middleware logger
        --SC.middleware $ staticPolicy (noDots >-> addBase "build")       
        SC.get "/" $ SC.file "./build/index.html"
    

main :: IO()
main = do
    let port = 3000
    let settings = Warp.setPort port Warp.defaultSettings
    sapp <- baseApp
    Warp.runSettings settings $ WaiWs.websocketsOr WS.defaultConnectionOptions CCS.wsapp sapp
