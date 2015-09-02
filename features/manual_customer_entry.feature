Feature: User adds a customer manually

  Background:
    Given I am a logged in user

  @javascript
  Scenario: User adds a customer who is a twitter celebrity
    Given the customer is a twitter celebrity
    When I add the customer
    Then I should see that the customer is a celebrity

  @javascript
  Scenario: User adds a customer who is in Wikipedia
    Given the customer has a wikipedia page
    When I add the customer
    Then I should see that the customer is a celebrity

  @javascript
  Scenario: User adds a customer who is in IMDB
    Given the customer has an IMDB page
    When I add the customer
    Then I should see that the customer is a celebrity

  @javascript
  Scenario: User adds a customer who is not a celebrity
    Given the customer does not have a Wikipedia page, IMDB page, or Twitter following
    When I add the customer
    Then I should not see that the customer is a celebrity

  @javascript
  Scenario: User adds a customer with trailing or leading whitespaces
    Given the customer is a celebrity with incorrect whitespaces
    When I add the customer
    Then I should see that the customer is a celebrity

  @javascript
  Scenario: User adds a customer with miscapitalization
    Given the customer is a celebrity with incorrect capitalization
    When I add the customer
    Then I should see that the customer is a celebrity


