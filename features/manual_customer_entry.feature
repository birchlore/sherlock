@javascript

Feature: User adds a customer manually

  Background:
    Given I am a logged in user

  
  Scenario: User adds a customer who is a twitter celebrity
    Given the customer is a twitter celebrity
    When I add the customer
    Then I should see that the customer is a celebrity

  Scenario: User adds a customer who is a wikipedia celebrity
    Given the customer is a wikipedia celebrity
    When I add the customer
    Then I should see that the customer is a celebrity

  Scenario: User adds a customer who is a imdb celebrity
    GGiven the customer is a imdb celebrity
    When I add the customer
    Then I should see that the customer is a celebrity

  Scenario: User adds a customer who is not a celebrity
    Given the customer does not have a Wikipedia page, IMDB page, or Twitter following
    When I add the customer
    Then I should not see that the customer is a celebrity

  Scenario: User adds a customer with trailing or leading whitespaces
    Given the customer is a celebrity with incorrect whitespaces
    When I add the customer
    Then I should see that the customer is a celebrity

  Scenario: User adds a customer with miscapitalization
    Given the customer is a celebrity with incorrect capitalization
    When I add the customer
    Then I should see that the customer is a celebrity


