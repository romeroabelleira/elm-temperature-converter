module TemperatureConverter exposing (Model, Msg, Temperature, TemperatureUnit(..), absolute_max_temp, absolute_min_temp, convertTemp, init, subscriptions, update, view)

import Browser
import Html exposing (Html, input, label, li, ol, text)
import Html.Attributes exposing (for, id, max, min, placeholder, step, style, type_, value)
import Html.Events exposing (onInput)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { inputKelvin : String
    , inputDegreesCelsius : String
    , inputDegreesFahrenheit : String
    }


init : Model
init =
    Model "0" (String.fromFloat (convertTemp absolute_min_temp DegreesCelsius).value) (String.fromFloat (convertTemp absolute_min_temp DegreesFahrenheit).value)


type Msg
    = ConvertKelvin String
    | ConvertCelsius String
    | ConvertFahrenheit String


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> Model
update msg model =
    case msg of
        ConvertKelvin s ->
            { model
                | inputKelvin = s
                , inputDegreesCelsius =
                    String.fromFloat (convertTemp (Temperature (Maybe.withDefault 0 (String.toFloat s)) Kelvin) DegreesCelsius).value
                , inputDegreesFahrenheit =
                    String.fromFloat (convertTemp (Temperature (Maybe.withDefault 0 (String.toFloat s)) Kelvin) DegreesFahrenheit).value
            }

        ConvertCelsius s ->
            { model
                | inputKelvin = String.fromFloat (convertTemp (Temperature (Maybe.withDefault 0 (String.toFloat s)) DegreesCelsius) Kelvin).value
                , inputDegreesCelsius = s
                , inputDegreesFahrenheit = String.fromFloat (convertTemp (Temperature (Maybe.withDefault 0 (String.toFloat s)) DegreesCelsius) DegreesFahrenheit).value
            }

        ConvertFahrenheit s ->
            { model
                | inputKelvin = String.fromFloat (convertTemp (Temperature (Maybe.withDefault 0 (String.toFloat s)) DegreesFahrenheit) Kelvin).value
                , inputDegreesCelsius = String.fromFloat (convertTemp (Temperature (Maybe.withDefault 0 (String.toFloat s)) DegreesFahrenheit) DegreesCelsius).value
                , inputDegreesFahrenheit = s
            }


view : Model -> Html Msg
view model =
    ol []
        [ li []
            [ input
                [ type_ "number"
                , id "kelvin"
                , placeholder (String.fromFloat absolute_min_temp.value)
                , value model.inputKelvin
                , Html.Attributes.min (String.fromFloat absolute_min_temp.value)
                , Html.Attributes.max (String.fromFloat absolute_max_temp.value)
                , step "0.01"
                , onInput ConvertKelvin
                ]
                []
            , label [ for "kelvin", style "padding-left" "0.5em" ] [ text "K" ]
            ]
        , li []
            [ input
                [ type_ "number"
                , id "celsius"
                , placeholder (String.fromFloat (convertTemp absolute_min_temp DegreesCelsius).value)
                , value model.inputDegreesCelsius
                , Html.Attributes.min (String.fromFloat (convertTemp absolute_min_temp DegreesCelsius).value)
                , Html.Attributes.max (String.fromFloat (convertTemp absolute_max_temp DegreesCelsius).value)
                , step "0.01"
                , onInput ConvertCelsius
                ]
                []
            , label [ for "celsius", style "padding-left" "0.5em" ] [ text "°C" ]
            ]
        , li []
            [ input
                [ type_ "number"
                , id "fahrenheit"
                , placeholder (String.fromFloat (convertTemp absolute_min_temp DegreesFahrenheit).value)
                , value model.inputDegreesFahrenheit
                , Html.Attributes.min (String.fromFloat (convertTemp absolute_min_temp DegreesFahrenheit).value)
                , Html.Attributes.max (String.fromFloat (convertTemp absolute_max_temp DegreesFahrenheit).value)
                , step "0.01"
                , onInput ConvertFahrenheit
                ]
                []
            , label [ for "fahrenheit", style "padding-left" "0.5em" ] [ text "°F" ]
            ]
        ]


absolute_min_temp : Temperature
absolute_min_temp =
    Temperature 0.0 Kelvin


absolute_max_temp : Temperature
absolute_max_temp =
    Temperature (1.4168 * 10 ^ 32) Kelvin


type alias Temperature =
    { value : Float
    , unit : TemperatureUnit
    }


type TemperatureUnit
    = Kelvin
    | DegreesCelsius
    | DegreesFahrenheit


tempToString : Temperature -> String
tempToString temperature =
    String.fromFloat temperature.value


convertTemp : Temperature -> TemperatureUnit -> Temperature
convertTemp temperature unit =
    case unit of
        Kelvin ->
            case temperature.unit of
                DegreesCelsius ->
                    Temperature (temperature.value + 273.15) Kelvin

                DegreesFahrenheit ->
                    Temperature ((temperature.value + 459.67) * 5 / 9) Kelvin

                Kelvin ->
                    temperature

        DegreesCelsius ->
            case temperature.unit of
                DegreesCelsius ->
                    temperature

                DegreesFahrenheit ->
                    convertTemp (convertTemp temperature Kelvin) DegreesCelsius

                Kelvin ->
                    Temperature (temperature.value - 273.15) DegreesCelsius

        DegreesFahrenheit ->
            case temperature.unit of
                DegreesCelsius ->
                    convertTemp (convertTemp temperature Kelvin) DegreesFahrenheit

                DegreesFahrenheit ->
                    temperature

                Kelvin ->
                    Temperature (temperature.value * 9 / 5 - 459.67) DegreesFahrenheit
