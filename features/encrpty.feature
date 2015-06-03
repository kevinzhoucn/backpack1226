Feature: Encrpty
  Scenario: Get Encrpty sting
    Given the input "datetime=20150522T220355P123&dev_id=iot02&random=1234567890ABCDEF"
    Given the key "D7iTLeFCRv8KSCUf"
    When the encrypt is run
    Then the output should be "94d0b47a95326dd1dd408881d14265bc787e92be253d7c8ea1a540da23b41adedf4f0fd2ce3ca32c5ae15b643ba7cd7b2568f0aa365ba5120c8ed19e507c59908485cab2"
