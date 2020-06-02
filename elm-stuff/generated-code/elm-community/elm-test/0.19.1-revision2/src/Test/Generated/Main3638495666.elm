module Test.Generated.Main3638495666 exposing (main)

import TemperatureConverterTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "TemperatureConverterTest" [TemperatureConverterTest.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 25842325319603, processes = 4, paths = ["/Users/juan/Development/elm-tag/elmo-world/tests/TemperatureConverterTest.elm"]}