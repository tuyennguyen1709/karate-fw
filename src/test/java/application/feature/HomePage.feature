@ignore
Feature: Tests for the home page

  Background:
    Given url apiUrl

  Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains ['implementations','welcome']
    And match response.tags !contains 'coding'
    And match response.tags == '#array'
    And match each response.tags == '#string'
    And match response.tags contains any ['implementations','vihoang']

  Scenario: Get all articles
    * def isTimeValidator = read('classpath:helpers/TimeValidator.js')
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles == '#[6]'
    And match response.articlesCount == 6
    And match response.articlesCount != 5
    And match response == {"articles": "#array", "articlesCount": 6}
    And match response.articles[0].createdAt contains '2022'
    And match response.articles[*].favoritesCount contains 842
    And match response..bio contains null
    And match each response..following == false
    And match each response..following == '#boolean'
    And match each response.articles..favoritesCount == '#number'
    And match each response..bio == '##string'
    And match each response.articles ==
        """
            {
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "createdAt": "#? isTimeValidator(_)",
                "updatedAt": "#? isTimeValidator(_)",
                "tagList": "#array",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": '#boolean'
                },
                "favoritesCount": '#number',
                "favorited": '#boolean'
            }
        """

