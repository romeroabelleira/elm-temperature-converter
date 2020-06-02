module TemperatureConverterTest exposing (suite)

import Expect exposing (FloatingPointTolerance(..))
import Fuzz exposing (Fuzzer, custom)
import Random
import Shrink exposing (Shrinker, map)
import TemperatureConverter exposing (Temperature, TemperatureUnit(..), absolute_max_temp, absolute_min_temp, convertTemp)
import Test exposing (Test, describe, fuzz, test)


accuracy : FloatingPointTolerance
accuracy =
    Relative 0.001


fuzzyKelvin : Fuzzer Temperature
fuzzyKelvin =
    let
        generator =
            Random.map
                (\x -> Temperature x Kelvin)
                (Random.float absolute_min_temp.value absolute_max_temp.value)

        shrinker : Shrinker Temperature
        shrinker t =
            Shrink.float t.value |> Shrink.map (\x -> Temperature x Kelvin)
    in
    Fuzz.custom generator shrinker


fuzzyDegreesCelsius : Fuzzer Temperature
fuzzyDegreesCelsius =
    let
        generator =
            Random.map
                (\x -> Temperature x DegreesCelsius)
                (Random.float (absolute_min_temp.value - 273.15) (absolute_max_temp.value - 273.15))

        shrinker : Shrinker Temperature
        shrinker t =
            Shrink.float t.value |> Shrink.map (\x -> Temperature x DegreesCelsius)
    in
    Fuzz.custom generator shrinker


fuzzyDegreesFahrenheit : Fuzzer Temperature
fuzzyDegreesFahrenheit =
    let
        -- Avoid "RangeError: Maximum call stack size exceeded"
        generator =
            Random.map
                (\x -> Temperature x DegreesFahrenheit)
                (Random.float (absolute_min_temp.value * 9 / 5 - 459.67) (1000 * 9 / 5 - 459.67))

        shrinker : Shrinker Temperature
        shrinker t =
            Shrink.float t.value |> Shrink.map (\x -> Temperature x DegreesFahrenheit)
    in
    Fuzz.custom generator shrinker


suite : Test
suite =
    describe "The TemperatureConverter module"
        [ describe "convertTemp"
            [ test "0 K is -273.15 °C" <|
                \_ ->
                    Expect.equal (convertTemp absolute_min_temp DegreesCelsius) (Temperature -273.15 DegreesCelsius)
            , test "0 °C is 32 °F" <|
                \_ ->
                    (convertTemp (Temperature 0 DegreesCelsius) DegreesFahrenheit).value |> Expect.within accuracy 32
            , test "0°F is 255.37_2_ K" <|
                \_ ->
                    (convertTemp (Temperature 0 DegreesFahrenheit) Kelvin).value |> Expect.within accuracy (459.67 * 5 / 9)
            , fuzz
                fuzzyKelvin
                "min K to max K to °C"
                (\k ->
                    (convertTemp k DegreesCelsius).value
                        |> Expect.within accuracy (k.value - 273.15)
                )
            , fuzz
                fuzzyDegreesCelsius
                "min °C to max °C to K"
                (\c ->
                    (convertTemp c Kelvin).value
                        |> Expect.within accuracy (c.value + 273.15)
                )
            , fuzz
                fuzzyKelvin
                "min K to max K to °F"
                (\k ->
                    (convertTemp k DegreesFahrenheit).value
                        |> Expect.within accuracy (k.value * 9 / 5 - 459.67)
                )
            , fuzz
                fuzzyDegreesFahrenheit
                "min °F to max °F to K"
                (\f ->
                    (convertTemp f Kelvin).value
                        |> Expect.within accuracy ((f.value + 459.67) * 5 / 9)
                )
            ]
        ]
