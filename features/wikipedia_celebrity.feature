@javascript
Feature: User adds a wikipedia celebrity

  Background:
    Given I am a logged in user
    Given I upgrade to the god plan 
    And the customer is a wikipedia celebrity

  Scenario: User adds a customer who is a wikipedia celebrity
    When I add the customer
    Then I should see that the customer is a celebrity