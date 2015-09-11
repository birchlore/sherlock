  @javascript

  Feature: Find if a customer is a celebrity

  Background:
    Given the app is installed

  Scenario: Shop receives a customer who is not a celebrity
    When a non celebrity customer is added
    Then the customer should not be saved to the database
