Feature: Datapoint 
  Scenario: Get Date Time String
    Given the date time input "20150810T120504P112"
    When the data filter is run
    Then the date time output should be "2015 08 10 12 05 04 112"
