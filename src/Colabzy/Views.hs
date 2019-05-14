{-# LANGUAGE OverloadedStrings #-}

module Colabzy.Views where

import Data.Text
import Control.Monad
import Control.Concurrent
import qualified Data.Text as Text
import qualified Web.Scotty as SC
import qualified Data.Text as Txt
import qualified Network.Wai as Wai
import qualified Network.WebSockets as WS
import qualified Network.Wai.Middleware.Gzip as GZ
import qualified Network.Wai.Handler.Warp as Warp
import qualified Network.Wai.Handler.WebSockets as WaiWs



wsapp :: WS.ServerApp
wsapp pending = do
    conn <- WS.acceptRequest pending
    WS.forkPingThread conn 30

    msg <- WS.receiveData conn
    WS.sendTextData conn $ ("initial> " :: Text) <> msg


    forever $ do
        WS.sendTextData conn $ ("Loop Data" :: Text)
        threadDelay $ 1 * 10000
