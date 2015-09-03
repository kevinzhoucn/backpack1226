Feature: Encrpty
    Scenario: User password encrypt with MD5
        Given there is User with account email "iot@iot.com" and user email "iot@iot.com"
        Then should use our hashing mechanism, not the default bcrypt
