module Storage exposing (..)

{-
   https://developer.mozilla.org/en-US/docs/Web/API/Storage_API
-}

import Time exposing (POSIX)


type alias Task =
    { id : Int
    , description : String
    , createdAt : POSIX
    , completed : Bool
    }
