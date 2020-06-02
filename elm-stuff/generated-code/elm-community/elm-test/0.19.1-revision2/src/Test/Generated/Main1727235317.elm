module Test.Generated.Main1727235317 exposing (main)

import TemperatureConverterTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "TemperatureConverterTest" [TemperatureConverterTest.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 122098147013489, processes = 4, paths = ["/Users/juan/Development/elm-tag/elmo-world/tests/TemperatureConverterTest.elm"]}