# Smooth Scroll

This library provides a function that allows for smooth scrolling to a DOM element.


## Usage

It depends on the [easing functions](https://package.elm-lang.org/packages/elm-community/easing-functions/latest/) package, although it does not use it directly. The `scrollTo` function takes four parameters:

* offset: The amount of space in pixels between the element to scroll to and the top of the viewport that is to remain after scrolling
* speed: The speed with which the scrolling is to take place. Experiment to find the value that works for you. 100 is a good starting point.
* easing: The easing function to use. Check out the [easing functions](https://package.elm-lang.org/packages/elm-community/easing-functions/latest/) package for more information. `Ease.outQuint` is good starting point.
* id: The id of the element to scroll to.
