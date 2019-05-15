{-# LANGUAGE OverloadedStrings #-}

module Colabzy.Utils.Middleware where

import qualified Web.Scotty as SC
import qualified Data.Default as DF
import qualified Network.Wai as WA
import qualified Control.Monad.IO.Class as IO
import qualified Network.Wai.Middleware.Static as MS
import qualified Network.Wai.Middleware.Gzip as MGZ
import qualified Network.Wai.Middleware.RequestLogger as MLG


compressionMiddleware :: WA.Middleware
compressionMiddleware = MGZ.gzip $ MGZ.def {MGZ.gzipFiles = MGZ.GzipCompress}

staticMiddleware :: WA.Middleware
staticMiddleware = MS.staticPolicy (MS.noDots MS.>-> MS.addBase "build")
