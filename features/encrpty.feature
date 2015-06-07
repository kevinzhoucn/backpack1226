Feature: Encrpty
    Scenario: Get Encrpty string
        Given the input "datetime=20150522T220355P123&dev_id=iot02&random=1234567890ABCDEF"
        Given the key "D7iTLeFCRv8KSCUf"
        When the encrypt is run
        Then the output should be "94d0b47a95326dd1dd408881d14265bc787e92be253d7c8ea1a540da23b41adedf4f0fd2ce3ca32c5ae15b643ba7cd7b2568f0aa365ba5120c8ed19e507c59908485cab2"

    Scenario: Get Decrypt string
        Given the input "94d0b47a95326dd1dd408881d14265bc787e92be253d7c8ea1a540da23b41adedf4f0fd2ce3ca32c5ae15b643ba7cd7b2568f0aa365ba5120c8ed19e507c59908485cab2"
        Given the key "D7iTLeFCRv8KSCUf"
        When the decrypt is run
        Then the output should be "datetime=20150522T220355P123&dev_id=iot02&random=1234567890ABCDEF"

    Scenario: User encrpty with own key
        Given there is User with account email "iot@iot.com" and user email "iot@iot.com"
        Given there is Device with device id "dev02"
        Given there is string "dev_id=dev02&random=1234567890ABCDEF"
        When visit the "datetime" path 
        Then the page expect result should be "0,datetime,random"

    Scenario: User encrpty with wrong dev id
        Given there is User with account email "iot@iot.com" and user email "iot@iot.com"
        Given there is Device with device id "dev02"
        Given there is string "dev_id=dev03&random=1234567890ABCDEF"
        When visit the "datetime" path 
        Then the page expect result should be "2,,random"

    Scenario: User encrpty with cmdquery
        Given there is User with account email "iot@iot.com" and user email "iot@iot.com"
        Given there is Device with device id "dev02"
        Given there is string "dev_id=dev02&random=1234567890ABCDEF"
        When visit the "cmdquery" path 
        Then the page expect result should be "0,cmdquery,random"

    Scenario: User encrpty with cmdquery no user
        Given there is User with account email "iot@iot.com" and user email "iot2@iot.com"
        Given there is Device with device id "dev02"
        Given there is string "dev_id=dev02&random=1234567890ABCDEF"
        When visit the "cmdquery" path 
        Then the page expect result should be "fail"