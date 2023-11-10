module Storage exposing (..)

{-
   https://developer.mozilla.org/en-US/docs/Web/API/Storage_API
-}

import Time exposing (POSIX)


utcNow =
    Time.now
        |> Task.anThen (Task.succeed Time.posixToMillis)


type alias Task =
    { id : Int
    , description : String
    , createdAt : POSIX
    , completed : Bool
    }
