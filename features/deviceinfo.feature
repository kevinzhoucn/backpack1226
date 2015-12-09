Feature: Deviceinfo
    Scenario: Upload Device Info String
        Given there is User with account email "iot@iot.com" and user email "iot@iot.com"
        Given there is Device with device id "dev01"
        Given there is string "IOTmodule=JM100-W&Version=1.0&SN=348jgldfkgj&dev_id=dev01&random=1234567890ABCDEF"
        When visit the "devinfo" path 
        Then the page expect result should be "0,random"
