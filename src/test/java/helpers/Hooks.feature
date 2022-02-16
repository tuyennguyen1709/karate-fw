
Feature: Hooks configuration

  Background:
    Given url apiUrl

  Scenario: Delete
    Given path 'articles',articleId
    When method Delete
    Then status 204