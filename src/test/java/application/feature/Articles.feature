@ignore
Feature: Articles

  Background: Define URL
    Given url apiUrl

  Scenario: Create a new article
    Given path 'articles'
    And request {"article": {"tagList": [],"title": "Articles-12343","description": "des","body": "body"}}
    When method Post
    Then status 200
    And match response.article.title == 'Articles-12343'

  Scenario: Create and Delete a scenario
    Given path 'articles'
    And request {"article": {"tagList": [],"title": "Articles-Deleted","description": "des","body": "body"}}
    When method Post
    Then status 200
    And match response.article.title == 'Articles-Deleted'
    * def articleId = response.article.slug

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title == 'Articles-Deleted'

    Given path 'articles',articleId
    When method Delete
    Then status 204

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title != 'Articles-Deleted'


