module SmoothScroll exposing
    ( Config
    , defaultConfig
    , scrollTo
    , scrollToWithOptions
    )

{-|


# Config

@docs Config
@docs defaultConfig


# Scrolling

@docs scrollTo
@docs scrollToWithOptions

-}

import Browser.Dom as Dom
import Ease
import Internal.SmoothScroll exposing (animationSteps)
import Task exposing (Task)


{-| Configuration options for smooth scrolling. Has three options:

  - offset: The amount of space in pixels between the element to scroll to and the top of the viewport that is to remain after scrolling
  - speed: The higher this number, the faster the scrolling!
  - easing: The easing function to use. Check out the [easing functions](https://package.elm-lang.org/packages/elm-community/easing-functions/latest/) package for more information.

-}
type alias Config =
    { offset : Int
    , speed : Int
    , easing : Ease.Easing
    }


{-|

    import SmoothScroll

    defaultConfig : Config
    defaultConfig =
        { offset = 12
        , speed = 200
        , easing = Ease.outQuint
        }

-}
defaultConfig : Config
defaultConfig =
    { offset = 12
    , speed = 200
    , easing = Ease.outQuint
    }


{-| Scroll to the element with the given id, using the default configuration

    import SmoothScroll

    scrollTo "article"

-}
scrollTo : String -> Task Dom.Error (List ())
scrollTo =
    scrollToWithOptions defaultConfig


{-| Scroll to the element with the given id, using a custom configuration

    import SmoothScroll exposing (defaultConfig)

    scrollToWithOptions { defaultConfig | offset = 60 } "article"

-}
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
