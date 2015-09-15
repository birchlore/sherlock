@javascript
Feature: User adds a celebrity

  Background:
    Given I am a logged in user

  Scenario: Valid celebrity is saved to the database
    Given the customer is a wikipedia celebrity
    When I add the customer
    And I wait 2 seconds
    Then the customer should be saved to the database

  Scenario: Invalid celebrity is not saved to the database
    Given the customer is not a celebrity
    When I add the customer
    And I wait 2 seconds
    Then the customer should not be saved to the database