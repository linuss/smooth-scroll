# Smooth Scroll

This library provides a function that allows for smooth scrolling to a DOM element.


## Usage

It depends on the [easing functions](https://package.elm-lang.org/packages/elm-community/easing-functions/latest/) package, although it does not use it directly. The `scrollTo` function takes four parameters:

* offset: The amount of space in pixels between the element to scroll to and the top of the viewport that is to remain after scrolling
* speed: The speed with which the scrolling is to take place. Experiment to find the value that works for you. 100 is a good starting point.
* easing: The easing function to use. Check out the [easing functions](https://package.elm-lang.org/packages/elm-community/easing-functions/latest/) package for more information. `Ease.outQuint` is good starting point.
* id: The id of the element to scroll to.

## Example
```elm
module Main

import Browser exposing (Document)
import Browser.Dom as Dom
import Ease
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Task exposing (Task)


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { foo = "bar" }, Cmd.none )


type alias Model =
    { foo : String }


type Msg
    = NoOp
    | SmoothScroll String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SmoothScroll id ->
            ( model, Task.attempt (always NoOp) (scrollTo 35 100 Ease.outQuint id) )


view : Model -> Document Msg
view model =
    { title = "Foo"
    , body =
        [ div []
            [ p
                [ id "p-one"
                , onClick (SmoothScroll "p-two")
                ]
                [ text "p one" ]
            , p
                [ id "p-two"
                , style "margin-top" "2500px"
                , onClick (SmoothScroll "p-one")
                ]
                [ text "p two" ]
            ]
        ]
    }

```
