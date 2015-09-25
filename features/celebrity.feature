@javascript
Feature: User adds a celebrity

  Background:
    Given I am a logged in user

  Scenario: User adds a customer who is not a celebrity
    Given the customer is not a celebrity
    When I add the customer
    Then I should see that the customer is not a celebrity

  Scenario: User adds a customer with trailing or leading whitespaces
    Given the customer is a celebrity with incorrect whitespaces
    When I add the customer
    Then I should see that the customer is a celebrity

  Scenario: User adds a customer with miscapitalization
    Given the customer is a celebrity with incorrect capitalization
    When I add the customer
    Then I should see that the customer is a celebrity

  Scenario: Valid celebrity is saved to the database
    Given the customer is a wikipedia celebrity
    When I add the customer
    And I wait 5 seconds
    Then the customer should be saved to the database

  Scenario: Invalid celebrity is not saved to the database
    Given the customer is not a celebrity
    When I add the customer
    And I wait 5 seconds
    Then the customer should not be saved to the database