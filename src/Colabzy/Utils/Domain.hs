{-# LANGUAGE OverloadedStrings #-}

module Colabzy.Utils.Domain where


import qualified Data.UUID as UUID
import qualified Data.UUID.V4 as V4
import Data.Aeson as AES

data MeetingId = MeetingId UUID.UUID
    deriving(Show)

instance ToJSON MeetingId where
    toJSON (MeetingId id) = 
        AES.object ["meetingId" AES..= UUID.toString id] 

getMeetingId :: IO MeetingId
getMeetingId = MeetingId <$> V4.nextRandom

