# Smooth Scroll

This library provides a function that allows for smooth scrolling to a DOM element.


## Usage

See the `example` directory for a working example. The `scrollTo` function results in cool scrolling behaviour
by default. If you want more control over the scrolling however, you can create a `Config` record with the following options:

* offset: The amount of space in pixels between the element to scroll to and the top of the viewport that is to remain after scrolling. Defaults to 12.
* speed: The speed with which the scrolling is to take place. Experiment to find the value that works for you. 100 is the default.
* easing: The easing function to use. Check out the [easing functions](https://package.elm-lang.org/packages/elm-community/easing-functions/latest/) package for more information. `Ease.outQuint` is the default.
* container: Which element to scroll inside of. Defaults to the document body, but can be configured with `containerElement`.

You can then pass this config record to the `scrollToWithOptions` function.

## Example
```elm
module Example exposing (main)

import Browser exposing (Document)
import Browser.Dom as Dom
import Dict exposing (Dict)
import Ease
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SmoothScroll exposing (scrollTo)
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
            ( model, Task.attempt (always NoOp) (scrollTo id) )


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
