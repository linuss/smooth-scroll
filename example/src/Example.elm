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
