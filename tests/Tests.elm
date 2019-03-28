module Tests exposing (suite)

import Ease
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Internal.SmoothScroll exposing (animationSteps)
import Test exposing (..)


suite : Test
suite =
    describe "Animation steps"
        [ test "start < stop" <|
            \_ ->
                let
                    steps =
                        animationSteps 100 Ease.linear 0 100000
                in
                Expect.equal (List.sort steps) steps
        , test "stop < start" <|
            \_ ->
                let
                    steps =
                        animationSteps 100 Ease.linear 100000 0
                in
                Expect.equal (List.reverse (List.sort steps)) steps
        , test "negative speed is no steps" <|
            \_ ->
                let
                    steps =
                        animationSteps -100 Ease.linear 100000 0
                in
                Expect.equal steps []
        , test "zero speed is no steps" <|
            \_ ->
                let
                    steps =
                        animationSteps 0 Ease.linear 100000 0
                in
                Expect.equal steps []
        , test "start == stop is no steps" <|
            \_ ->
                let
                    steps =
                        animationSteps 100 Ease.linear 0 0
                in
                Expect.equal steps []
        ]
