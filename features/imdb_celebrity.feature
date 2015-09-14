@javascript
Feature: User adds a customer manually

  Background:
    Given I am a logged in user

  Scenario: User adds a customer who is a imdb celebrity
    Given the customer is a imdb celebrity
    And I have enabled imdb
    When I add the customer
    Then I should see that the customer is a celebrity
