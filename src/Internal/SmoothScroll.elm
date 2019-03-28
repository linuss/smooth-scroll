module Internal.SmoothScroll exposing (animationSteps)

import Ease


animationSteps : Int -> Ease.Easing -> Float -> Float -> List Float
animationSteps speed easing start stop =
    let
        diff =
            abs <| start - stop

        frames =
            Basics.max 1 <| round diff // speed

        framesFloat =
            toFloat frames

        weights =
            List.map (\i -> easing (toFloat i / framesFloat)) (List.range 0 frames)

        operator =
            if start > stop then
                (-)

            else
                (+)
    in
    if speed <= 0 || start == stop then
        []

    else
        List.map (\weight -> operator start (weight * diff)) weights
