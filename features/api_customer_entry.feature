Feature: Customer is added via API

  Background:
    Given the app is installed

  @javascript
  Scenario: Customer is a celebrity
    When a celebrity is added
    Then I should get an email notification that the customer is a celebrity
    Then the celebrity should be added to my celebrities list in the app


  @javascript
  Scenario: Customer is not a celebrity
    When a non-celebrity is added
    Then I should not get an email notification that the customer is a celebrity
    Then the celebrity should not be added to my celebrities list in the app




