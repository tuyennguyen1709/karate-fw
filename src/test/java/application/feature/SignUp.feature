@debug
Feature: Sign up new user

  Background: Precondition
    * def dataGenerator = Java.type('helpers.DataGenerator')
    Given url apiUrl

  Scenario: New user signup successfully
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUser = dataGenerator.getRandomUsername()
    Given path 'users'
    And request
    """
    {
      "user": {
        "email": "#(randomEmail)",
        "password": "Kms@123",
        "username": "#(randomUser)"
      }
    }
    """
    When method Post
    Then status 200
    And match response ==
    """
      {
        "user": {
            "email": "#(randomEmail)",
            "username": "#(randomUser)",
            "bio": "##string",
            "image": "#string",
            "token": "#string"
        }
      }
    """

  Scenario Outline: New user signup unsuccessfully
    Given path 'users'
    And request
    """
    {
      "user": {
        "email": "<email>",
        "password": "<password>",
        "username": "<username>"
      }
    }
    """
    When method Post
    Then status 422
    And match response == <errorResponse>
    Examples:
      | email                             | password | username            | errorResponse                                                                            |
      | tuyenngocnguyen3490@fakegmail.com | Kms@2019 | tuyenngocnguyen3490 | {"errors": {"email": ["has already been taken"],"username": ["has already been taken"]}} |
      | tuyenngocnguyen3490@fakegmail.com | Kms@2019 | test15161718022022    | {"errors": {"email": ["has already been taken"]}}                                        |
      | test15161718022022                 | Kms@2019 | tuyenngocnguyen3490 | {"errors": {"username": ["has already been taken"]}}                                     |
      |                                   | Kms@2019 | tuyenngocnguyen3490 | {"errors": {"email": ["can't be blank"]}}                                                |
      | tuyenngocnguyen3490@fakegmail.com | Kms@2019 |                     | {"errors": {"username": ["can't be blank"]}}
      | tuyenngocnguyen3490@fakegmail.com |          | tuyenngocnguyen3490 | {"errors": {"password": ["can't be blank"]}}                                             |



