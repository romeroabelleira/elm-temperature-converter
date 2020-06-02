module Main exposing (Model, Msg, update, view, subscriptions, init)

import Html exposing (..)
import Browser


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
    }


type alias Model =
    { tasks : List
    }


init : Model
init =
    Model []


type Msg
    = AddTask
    | RemoveTask


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddTask ->
            model

        RemoveTask ->
            model


view : Model -> Html Msg
view model =
    div []
        [ text "New Sandbox" ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
