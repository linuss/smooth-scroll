module Main exposing (scrollTo)

import Browser exposing (Document)
import Browser.Dom as Dom
import Dict exposing (Dict)
import Ease
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List
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
