@javascript
Feature: User adds an twitter celebrity

  Background:
    Given I am a logged in user

  Scenario: User adds a customer who is a twitter celebrity
    Given the customer is a twitter celebrity
    When I add the customer
    Then I should see that the customer is a celebrity