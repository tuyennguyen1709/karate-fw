@debug
Feature: Articles

  Background: Define URL
    Given url apiUrl

  Scenario: Create a new article successfully
    * def createdArticle = call read('classpath:helpers/AddArticle.feature')
    * def createdTitle = createdArticle.titleArticleRes
    * def randomTitle = createdArticle.randomTitle
    And match createdTitle == randomTitle

  Scenario: Create and Delete a article successfully
    * def createdArticle = call read('classpath:helpers/AddArticle.feature')
    * def createdTitle = createdArticle.titleArticleRes
    * def articleId = createdArticle.slugArticleRes
    * def randomTitle = createdArticle.randomTitle
    And match createdTitle == randomTitle

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title == '#(randomTitle)'

    Given path 'articles',articleId
    When method Delete
    Then status 204

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title != '#(randomTitle)'


