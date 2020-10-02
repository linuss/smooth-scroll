module ExampleInner exposing (main)

import Browser exposing (Document)
import Browser.Dom as Dom
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SmoothScroll exposing (scrollToWithOptions, defaultConfig, containerElement)
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
    | SmoothScroll String String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SmoothScroll containerId targetId ->
            ( model
            , targetId
                |> scrollToWithOptions { defaultConfig | speed = 15, container = containerElement containerId }
                |> Task.attempt (always NoOp)
            )


view : Model -> Document Msg
view model =
    { title = "Foo"
    , body =
        [ div [ style "position" "fixed", style "top" "0", style "height" "40px", style "left" "0", style "right" "0", style "display" "flex", style "justify-content" "space-around" ]
            [ div []
                [ button [ onClick (SmoothScroll "left-half" "anchor-left-100") ] [ text "100" ]
                , button [ onClick (SmoothScroll "left-half" "anchor-left-25")] [ text "25" ]
                , button [ onClick (SmoothScroll "left-half" "anchor-left-1")] [ text "1" ]
                ]
            , div []
                [ button [ onClick (SmoothScroll "right-half" "anchor-right-100") ] [ text "100" ]
                , button [ onClick (SmoothScroll "right-half" "anchor-right-25")] [ text "25" ]
                , button [ onClick (SmoothScroll "right-half" "anchor-right-1")] [ text "1" ]
                ]
            ]
        , div [ style "font-size" "18px", style "font-family" "sans-serif",  style "position" "fixed", style "top" "40px", style "bottom" "0", style "left" "0", style "right" "0", style "display" "flex" ]
            [ div [  id "left-half", style "flex-grow" "1", style "overflow-y" "scroll", style "border" "1px solid #ccc", style "background" "cornflowerblue" ]
                [ ul [  ]
                    (List.range 1 100
                        |> List.map (\num -> li [ String.fromInt num |> String.append "anchor-left-" |> id ] [ text <| String.fromInt num ])
                    )
                ]
            , div [  id "right-half", style "flex-grow" "1", style "overflow-y" "scroll", style "border" "1px solid #ccc", style "background" "wheat" ]
                [ ul [  ]
                    (List.range 1 100
                        |> List.map (\num -> li [ String.fromInt num |> String.append "anchor-right-" |> id ] [ text <| String.fromInt num ])
                    )
                ]
            ]
        ]

    }
