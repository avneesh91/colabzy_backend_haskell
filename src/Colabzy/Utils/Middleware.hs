{-# LANGUAGE OverloadedStrings #-}

module Colabzy.Utils.Middleware where

import qualified Web.Scotty as SC
import qualified Data.Default as DF
import qualified Network.Wai as WA
import qualified Control.Monad.IO.Class as IO
import qualified Network.Wai.Middleware.Static as MS
import qualified Network.Wai.Middleware.Gzip as MGZ
import qualified Network.Wai.Middleware.RequestLogger as MLG


--compressionMiddleware :: M.Middlware
compressionMiddleware = MGZ.gzip $ MGZ.def {MGZ.gzipFiles = MGZ.GzipCompress}


--loggerMiddleware :: SC.Middleware
loggerMiddleware =  MLG.mkRequestLogger DF.def { MLG.outputFormat = MLG.Apache MLG.FromHeader }


staticMiddleware :: WA.Middleware
staticMiddleware = MS.staticPolicy (MS.noDots MS.>-> MS.addBase "build")



