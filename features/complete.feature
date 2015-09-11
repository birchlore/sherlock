Feature: Working example

  Background:
    Given I am a logged in user

  @javascript @vcr
  Scenario: An example of VCR
    Then I should see " Or try adding one manually to see how it work"
