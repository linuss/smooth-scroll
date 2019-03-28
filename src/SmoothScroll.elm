module SmoothScroll exposing (scrollTo)

import Browser.Dom as Dom
import Ease
import Task exposing (Task)


{-|


# scrollTo

@docs scrollTo

-}
animationSteps : Int -> Ease.Easing -> Float -> Float -> List Float
animationSteps speed easing start stop =
    let
        diff =
            abs <| start - stop

        n =
            Basics.max 1 <| round diff // speed

        weights =
            List.map (\i -> easing (toFloat i / toFloat n)) (List.range 0 n)

        operator =
            if start > stop then
                (-)

            else
                (+)
    in
    List.map (\weight -> operator start (weight * diff)) weights


scrollTo : Float -> Int -> Ease.Easing -> String -> Task Dom.Error (List ())
scrollTo offset speed easing id =
    let
        tasks from to =
            List.map (Dom.setViewport 0) (animationSteps speed easing from (to - offset))
                |> Task.sequence
    in
    Task.map2 Tuple.pair Dom.getViewport (Dom.getElement id)
        |> Task.andThen (\( { viewport }, { element } ) -> tasks viewport.y element.y)
