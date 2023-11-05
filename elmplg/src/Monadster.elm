module Monadster exposing (..)

{-
   https://fsharpforfunandprofit.com/posts/monadster/
-}


type alias Label =
    String


type alias VitalForce =
    { units : Int }


type M a
    = M (VitalForce -> ( a, VitalForce ))


get =
    let
        becomeAlive vf =
            ( vf, vf )
    in
    M becomeAlive


put newVF =
    let
        becomeAlive vf =
            ( (), newVF )
    in
    M becomeAlive


runM : M a -> VitalForce -> ( a, VitalForce )
runM (M f) vitalForce =
    f vitalForce


getVitalForce : VitalForce -> ( VitalForce, VitalForce )
getVitalForce vitalForce =
    let
        oneUnit =
            { units = 1 }

        remaining =
            { units = vitalForce.units - 1 }
    in
    ( oneUnit, remaining )


type DeadLeftLeg
    = DeadLeftLeg Label


type LiveLeftLeg
    = LiveLeftLeg ( Label, VitalForce )


makeLiveLeftLegM : DeadLeftLeg -> M LiveLeftLeg
makeLiveLeftLegM (DeadLeftLeg label) =
    let
        becomeAlive vitalForce =
            let
                ( oneUnit, remainingVitalForce ) =
                    getVitalForce vitalForce

                liveLeftLeg =
                    LiveLeftLeg ( label, oneUnit )
            in
            ( liveLeftLeg, remainingVitalForce )
    in
    M becomeAlive


type DeadLeftBrokenArm
    = DeadLeftBrokenArm Label


type LiveLeftBrokenArm
    = LiveLeftBrokenArm ( Label, VitalForce )


type LiveLeftArm
    = LiveLeftArm ( Label, VitalForce )


healBrokenArm (LiveLeftBrokenArm ( label, vf )) =
    LiveLeftArm ( label, vf )


map f m =
    return f
        |> apply m


mapM : (a -> b) -> M a -> M b
mapM f m =
    let
        transform vf =
            let
                ( a, remainingVF ) =
                    runM m vf

                b =
                    f a
            in
            ( b, remainingVF )
    in
    M transform


makeLiveLeftBrokenArmM : DeadLeftBrokenArm -> M LiveLeftBrokenArm
makeLiveLeftBrokenArmM (DeadLeftBrokenArm label) =
    let
        becomeAlive vf =
            let
                ( oneUnit, remainingVitalForce ) =
                    getVitalForce vf

                liveLeftBrokenArm =
                    LiveLeftBrokenArm ( label, oneUnit )
            in
            ( liveLeftBrokenArm, remainingVitalForce )
    in
    M becomeAlive


makeLiveLeftArmM : DeadLeftBrokenArm -> M LiveLeftArm
makeLiveLeftArmM =
    makeLiveLeftBrokenArmM >> map healBrokenArm


type DeadRightLowerArm
    = DeadRightLowerArm Label


type DeadRightUpperArm
    = DeadRightUpperArm Label


type LiveRightLowerArm
    = LiveRightLowerArm ( Label, VitalForce )


type LiveRightUpperArm
    = LiveRightUpperArm ( Label, VitalForce )


type alias LiveRightArm =
    { lowerArm : LiveRightLowerArm
    , upperArm : LiveRightUpperArm
    }


armSurgery lowerArm upperArm =
    { lowerArm = lowerArm
    , upperArm = upperArm
    }


map2 f m1 m2 =
    return f
        |> apply m1
        |> apply m2


map2M f m1 m2 =
    let
        becomeAlive vf =
            let
                ( v1, rvf1 ) =
                    runM m1 vf

                ( v2, rvf2 ) =
                    runM m2 rvf1

                v3 =
                    f v1 v2
            in
            ( v3, rvf2 )
    in
    M becomeAlive


makeLiveRightLowerArmM : DeadRightLowerArm -> M LiveRightLowerArm
makeLiveRightLowerArmM (DeadRightLowerArm label) =
    let
        becomeAlive vf =
            let
                ( oneUnit, remainingVitalForce ) =
                    getVitalForce vf

                liveRightLowerArm =
                    LiveRightLowerArm ( label, oneUnit )
            in
            ( liveRightLowerArm, remainingVitalForce )
    in
    M becomeAlive


makeLiveRightUpperArmM : DeadRightUpperArm -> M LiveRightUpperArm
makeLiveRightUpperArmM (DeadRightUpperArm label) =
    let
        becomeAlive vf =
            let
                ( oneUnit, remainingVitalForce ) =
                    getVitalForce vf

                liveRightUpperArm =
                    LiveRightUpperArm ( label, oneUnit )
            in
            ( liveRightUpperArm, remainingVitalForce )
    in
    M becomeAlive


makeLiveRightArmM : DeadRightLowerArm -> DeadRightUpperArm -> M LiveRightArm
makeLiveRightArmM deadRightLowerArm deadRightUpperArm =
    map2 armSurgery (makeLiveRightLowerArmM deadRightLowerArm) (makeLiveRightUpperArmM deadRightUpperArm)


type DeadBrain
    = DeadBrain Label


type Skull
    = Skull Label


type LiveBrain
    = LiveBrain ( Label, VitalForce )


type alias LiveHead =
    { brain : LiveBrain
    , skull : Skull
    }


headSurgery brain skull =
    { brain = brain
    , skull = skull
    }


return : a -> M a
return x =
    let
        becomeAlive vf =
            ( x, vf )
    in
    M becomeAlive


makeLiveBrainM : DeadBrain -> M LiveBrain
makeLiveBrainM (DeadBrain label) =
    let
        becomeAlive vf =
            let
                ( oneUnit, remainingVitalForce ) =
                    getVitalForce vf

                liveBrain =
                    LiveBrain ( label, oneUnit )
            in
            ( liveBrain, remainingVitalForce )
    in
    M becomeAlive


makeLiveHeadM : DeadBrain -> Skull -> M LiveHead
makeLiveHeadM deadBrain skull =
    map2 headSurgery (makeLiveBrainM deadBrain) (return skull)


type DeadHeart
    = DeadHeart Label


type LiveHeart
    = LiveHeart ( Label, VitalForce )


type BeatingHeart
    = BeatingHeart ( LiveHeart, VitalForce )


makeLiveHeartM : DeadHeart -> M LiveHeart
makeLiveHeartM (DeadHeart label) =
    let
        becomeAlive vf =
            let
                ( oneUnit, remainingVitalForce ) =
                    getVitalForce vf

                liveHeart =
                    LiveHeart ( label, oneUnit )
            in
            ( liveHeart, remainingVitalForce )
    in
    M becomeAlive


makeBeatingHeartM : LiveHeart -> M BeatingHeart
makeBeatingHeartM liveHeart =
    let
        becomeAlive vf =
            let
                ( oneUnit, remainingVitalForce ) =
                    getVitalForce vf

                beatingHeart =
                    BeatingHeart ( liveHeart, oneUnit )
            in
            ( beatingHeart, remainingVitalForce )
    in
    M becomeAlive


andThen : (a -> M b) -> M a -> M b
andThen f ma =
    let
        becomeAlive vf =
            let
                ( a, rvf1 ) =
                    runM ma vf
            in
            runM (f a) rvf1
    in
    M becomeAlive


makeBeatingHeartFromDeatHeartM : DeadHeart -> M BeatingHeart
makeBeatingHeartFromDeatHeartM =
    makeLiveHeartM >> andThen makeBeatingHeartM


type alias LiveBody =
    { leftLeg : LiveLeftLeg
    , rightLeg : LiveLeftLeg
    , leftArm : LiveLeftArm
    , rightArm : LiveRightArm
    , head : LiveHead
    , heart : BeatingHeart
    }


apply : M a -> M (a -> b) -> M b
apply ma mf =
    let
        becomeAlive vf =
            let
                ( f, rvf1 ) =
                    runM mf vf

                ( a, rvf2 ) =
                    runM ma rvf1
            in
            ( f a, rvf2 )
    in
    M becomeAlive


createLiveBodyM deadLeftLeg deadRightLeg deadLeftBrokenArm ( deadRightLowerArm, deadRightUpperArm ) ( brain, skull ) heart =
    return LiveBody
        |> apply (makeLiveLeftLegM deadLeftLeg)
        |> apply (makeLiveLeftLegM deadRightLeg)
        |> apply (makeLiveLeftArmM deadLeftBrokenArm)
        |> apply (makeLiveRightArmM deadRightLowerArm deadRightUpperArm)
        |> apply (makeLiveHeadM brain skull)
        |> apply (makeBeatingHeartFromDeatHeartM heart)
