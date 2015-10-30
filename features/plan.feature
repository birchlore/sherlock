@javascript
Feature: User changes plan

  Background:
    Given I am a logged in user


  Scenario: User upgrades to free plan
    Given I am at the homepage
    When I upgrade to the free plan
    Then I should see my plan is upgraded
    Then I should have 20 imdb scans remaining
    Then I should have no social scans remaining
    Then I should not be able to bulk scan
    Then I should see the teaser scan description

  Scenario: User upgrades to basic plan
    Given I am at the homepage
    When I upgrade to the basic plan
    Then I should see my plan is upgraded
    Then I should have unlimited imdb scans remaining
    Then I should have no social scans remaining
    Then I should not be able to bulk scan
    Then I should see the teaser scan description


  Scenario: User upgrades to pro plan
    Given I am at the homepage
    When I upgrade to the pro plan
    Then I should see my plan is upgraded
    Then I should have unlimited imdb scans remaining
    Then I should have 200 social scans remaining
    Then I should not be able to bulk scan
    Then I should not see the teaser scan description


  Scenario: User upgrades to stalker plan
    Given I am at the homepage
    When I upgrade to the stalker plan
    Then I should see my plan is upgraded
    Then I should have unlimited imdb scans remaining
    Then I should have 1000 social scans remaining
    Then I should be able to bulk scan
    Then I should not see the teaser scan description


  Scenario: User upgrades to god plan
    Given I am at the homepage
    When I upgrade to the god plan
    Then I should see my plan is upgraded
    Then I should have unlimited imdb scans remaining
    Then I should have 2500 social scans remaining
    Then I should be able to bulk scan
    Then I should not see the teaser scan description
