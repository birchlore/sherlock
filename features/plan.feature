@javascript
Feature: User changes plan

  Background:
    Given I am a logged in user

  Scenario: User upgrades to basic plan
    Given I am at the homepage
    When I upgrade to the basic plan
    Then I should see my plan is upgraded