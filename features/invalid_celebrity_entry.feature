@javascript
Feature: User adds an invalid celebrity

  Background:
    Given I am a logged in user
    Given I upgrade to the god plan 

  Scenario: User adds a customer who has a common name
    Given the customer has a common name
    When I add the customer
    And I wait 2 seconds
    Then I should see that the customer is not a celebrity

  Scenario: User adds a customer who is dead
    Given the customer is dead
    When I add the customer
    And I wait 2 seconds
    Then I should see that the customer is not a celebrity