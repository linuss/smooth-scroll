module SmoothScroll exposing (Config, scrollTo, scrollToWithOptions)

import Browser.Dom as Dom
import Ease
import Internal.SmoothScroll exposing (animationSteps)
import Task exposing (Task)


{-|


# scrollTo

@docs scrollTo

-}
type alias Config =
    { offset : Int
    , speed : Int
    , easing : Ease.Easing
    }


defaultConfig : Config
defaultConfig =
    { offset = 12
    , speed = 200
    , easing = Ease.outQuint
    }


scrollTo : String -> Task Dom.Error (List ())
scrollTo =
    scrollToWithOptions defaultConfig


scrollToWithOptions : Config -> String -> Task Dom.Error (List ())
scrollToWithOptions config id =
    let
        tasks from to =
            List.map (Dom.setViewport 0)
                (animationSteps config.speed config.easing from (to - toFloat config.offset))
                |> Task.sequence
    in
    Task.map2 Tuple.pair Dom.getViewport (Dom.getElement id)
        |> Task.andThen (\( { viewport }, { element } ) -> tasks viewport.y element.y)
