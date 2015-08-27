Feature: Datapoint 
  Scenario: Get Date Time String Array
    Given the date time input "20150810T120504P112"
    When the data filter is run
    Then the date time output should be "20 15 08 10 12 05 04 112"

  Scenario: Get Date Time String
    Given the date time input "20150810T120504P112"
    When the data string filter is run
    Then the date time string output should be "1439208304000"

  Scenario: Get Date Time String
    Given the date time input "1439208304"
    When the data string convert is run
    Then the date time string output should be "2015-08-10 20:05:04.000000000 +0800"


  Scenario: Get Date Time String
    Given the date time input "100-20150810T120504P112||110-20150810T120508P112||115-20150810T120513P112||120-20150810T120516P112"
    When the data points convert is run
    Then the date time string output should be "2015-08-10 20:05:04.000000000 +0800"  