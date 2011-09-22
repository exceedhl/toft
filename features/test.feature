Feature: Search courses
  In order to ensure better utilization of courses
  Potential students should be able to search for courses

  Scenario: Search by topic
    Given there are 240 courses which do not have the topic "biology"
    And there are 2 courses A001, B205 that each have "biology" as one of the topics
    When I search for "biology"
    Then I should see the following courses: