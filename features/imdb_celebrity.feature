@javascript
Feature: User adds an IMDB customer

  Background:
    Given I am a logged in user
    Given I upgrade to the stalker plan 

  Scenario: User adds a customer who is a imdb celebrity
    Given the customer is a imdb celebrity
    And I have enabled imdb
    When I add the customer
    Then I should see that the customer is a celebrity
