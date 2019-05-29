{-# LANGUAGE OverloadedStrings #-}

module Colabzy.Utils.Views where

import Control.Monad
import qualified Control.Monad.IO.Class as IOM
import qualified Web.Scotty as SC
import qualified Colabzy.Utils.Domain as DM
import qualified Data.UUID as UUID
import qualified Data.UUID.V4 as V4


getAction :: IO (SC.ActionM ()) -> SC.ActionM ()
getAction = join . IOM.liftIO


serveMeetingId :: IO(SC.ActionM ())
serveMeetingId = SC.json <$> DM.getMeetingId

