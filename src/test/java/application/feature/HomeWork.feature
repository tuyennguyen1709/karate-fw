@debug
Feature: Validate favorite and comment function

  Background: Preconditions
    * url apiUrl
    * def isTimeValidator = read('classpath:helpers/TimeValidator.js')
    * def dataGenerator = Java.type('helpers.DataGenerator')

  Scenario: Favorite articles
        # Step 1: Add new article (optimize here - Create a AddArticle.feature)
    * def createdArticle = call read('classpath:helpers/AddArticle.feature')
        # Step 2: Get the favorites count and slug ID for the the article, save it to variables
    * def articleId = createdArticle.slugArticleRes
    * def favoritesCount = createdArticle.favoritesCountArticleRes
        # Step 3: Make POST request to increase favorites count for the article
    Given path 'articles',articleId,'favorite'
    When method Post
    Then status 200
        # Step 4: Verify response schema
    And match response.article ==
        """
        {
            "id": "#number",
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "createdAt": "#? isTimeValidator(_)",
            "updatedAt": "#? isTimeValidator(_)",
            "authorId": "#number",
             "tagList": "#array",
             "author": {
                    "username": "#string",
                    "bio": ##string,
                    "image": "#string",
                    "following": '#boolean'
                },
             "favoritedBy": [
                {
                    "id": "#number",
                    "email": "#string",
                    "username": "#string",
                    "password": "#string",
                    "image": "#string",
                    "bio": ##string,
                    "demo": '#boolean'
                }
             ],
             "favorited": '#boolean',
             "favoritesCount": '#number',
        }
        """
        # Step 5: Verify that favorites article incremented by 1
    And match response.article.favoritesCount == 1
        # Step 6: Get all favorite articles
    * def authorName = response.article.author.username
    Given params {limit: 10, offset: 0, favorited: #(authorName)}
    Given path 'articles'
    When method Get
    Then status 200
        # Step 7: Verify response schema
    And match each response.articles ==
        """
        {
            "slug": '#string',
            "title": '#string',
            "description": '#string',
            "body": '#string',
            "createdAt": '#string',
            "updatedAt": '#string',
            "tagList": '#array',
            "author":{
                "username": '#string',
                "bio": ##string,
                "image": '#string',
                "following": '#boolean'
            },
            "favoritesCount": '#number',
            "favorited": '#boolean'
         }
        """
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
    And match response.articles[*].slug contains articleId
        # Step 9: Delete the article (optimize here with afterScenario - create a Hook.feature)
    * configure afterScenario =
        """
        function(){
          var info = karate.info;
          karate.log('Delete:', info.scenarioName);
          karate.call('Hooks.feature', { caller: info.featureFileName });
        }
        """

  Scenario: Comment articles
        # Step 1: Add new article (optimize here - Create a AddArticle.feature)
    * def createdArticle = call read('classpath:helpers/AddArticle.feature')
        # Step 2: Get the slug ID for the article, save it to variable
    * def articleId = createdArticle.slugArticleRes
        # Step 3: Make a GET call to 'comments' end-point to get all comments
    Given path 'articles',articleId,'comments'
    When method Get
    Then status 200
        # Step 4: Verify response schema
    And match response ==
        """
            {
               "comments": "#array"
            }
        """
        # Step 5: Get the count of the comments array length and save to variable
    * def commentCount = response.comments.length
    * def randomTitle = dataGenerator.getRandomTitle()
    * def commentContent = "Content" + randomTitle
        # Step 6: Make a POST request to publish a new comment
    Given path 'articles', articleId, 'comments'
    And request {"comment": {"body": "#(commentContent)"}}
    When method Post
    Then status 200
    * def commentId = response.comment.id
        # Step 7: Verify response schema that should contain posted comment text
    And match response.comment.body contains commentContent
        # Step 8: Get the list of all comments for this article one more time
    Given path 'articles',articleId,'comments'
    When method Get
    Then status 200
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
    And response.comments.length == commentCount + 1
        # Step 10: Make a DELETE request to delete comment
    Given path 'articles', articleId, 'comments', commentId
    When method Delete
    Then status 204
        # Step 11: Get all comments again and verify number of comments decreased by 1
    Given path 'articles',articleId,'comments'
    When method Get
    Then status 200
    And response.comments.length == commentCount
        # Step 12: Delete the article (optimize here with afterScenario - create a Hook.feature)
    * configure afterScenario =
        """
        function(){
          var info = karate.info;
          karate.log('Delete:', info.scenarioName);
          karate.call('Hooks.feature', { caller: info.featureFileName });
        }
        """
