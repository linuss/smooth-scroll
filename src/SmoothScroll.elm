module SmoothScroll exposing
    ( Config
    , defaultConfig
    , containerElement
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
    , container : Container
    }


type Container
    = DocumentBody
    | InnerNode String


    import SmoothScroll

    defaultConfig : Config
    defaultConfig =
        { offset = 12
        , speed = 200
        , easing = Ease.outQuint
        , container = DocumentBody
        }

-}
defaultConfig : Config
defaultConfig =
    { offset = 12
    , speed = 200
    , easing = Ease.outQuint
    , container = DocumentBody
    }


{-| Configure which DOM node to scroll inside of

    import SmoothScroll exposing (scrollToWithOptions, defaultConfig, containerElement)

    scrollToWithOptions { defaultConfig | containerElement = "article-list" } "article-42"

-}
containerElement : String -> Container
containerElement elementId =
    InnerNode elementId


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
        ( getViewport, setViewport ) =
            case config.container of
                DocumentBody ->
                    ( Dom.getViewport, Dom.setViewport 0 )

                InnerNode containerId ->
                    ( Dom.getViewportOf containerId, Dom.setViewportOf containerId 0 )

        getContainerInfo =
            case config.container of
                DocumentBody ->
                    Task.succeed Nothing

                InnerNode containerId ->
                    Task.map Just (Dom.getElement containerId)

        scrollTask { scene, viewport } { element } container =
            let
                destination =
                    case container of
                        Nothing ->
                            element.y - toFloat config.offset

                        Just containerInfo ->
                            viewport.y + element.y - toFloat config.offset - containerInfo.element.y

                clamped =
                    destination
                        |> min (scene.height - viewport.height)
                        |> max 0
            in
            animationSteps config.speed config.easing viewport.y clamped
                |> List.map setViewport
                |> Task.sequence
    in
    Task.map3 scrollTask getViewport (Dom.getElement id) getContainerInfo
        |> Task.andThen identity
