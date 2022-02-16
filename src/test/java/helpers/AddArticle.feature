Feature: Add Article

  Background: Precondition
    * def dataGenerator = Java.type('helpers.DataGenerator')
    Given url apiUrl

  Scenario: Add Article
    Given path 'articles'
    * def randomTitle = dataGenerator.getRandomTitle()
    And request {"article": {"tagList": [],"title": "#(randomTitle)","description": "des","body": "body"}}
    When method Post
    Then status 200
    * def titleArticleRes = response.article.title
    * def slugArticleRes = response.article.slug
    * def favoritesCountArticleRes = response.article.favoritesCount