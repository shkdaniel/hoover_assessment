Feature: Hoover service
  As a Test Engineer,
  I want to verify whether the hoover implementation behaves according to specifications.

  Scenario Outline: Basic API functionality
    Given the hoover API is posted with data <roomSize>, <coords>, <patches> and <instructions>
    Then the response status code is "<statusCode>"
    And the response contains results for "<coordsFinal>" and "<patchesCount>"

    Examples: Normal functionality for different routes
      | roomSize | coords | patches             | instructions | statusCode | coordsFinal | patchesCount |
      | [5,5]    | [1,2]  | [[1,0],[2,2],[2,3]] | NNESEESWNWW  | 200        | [1,3]       | 1            |
      | [5,5]    | [2,2]  | [[4,3],[1,3],[2,4]] | EESWWNEESWW  | 200        | [2,1]       | 1            |

    Examples: Driving into walls
      | roomSize | coords | patches             | instructions | statusCode | coordsFinal | patchesCount |
      | [5,5]    | [2,2]  | []                  | EEEEEEEEEEE  | 200        | [4,2]       | 0            |
      | [5,5]    | [2,2]  | []                  | WWWWWWWWWWW  | 200        | [0,2]       | 0            |
      | [5,5]    | [0,0]  | []                  | NNNNNNNNNNN  | 200        | [0,4]       | 0            |
      | [5,5]    | [2,2]  | []                  | SSSSSSSSSSS  | 200        | [2,0]       | 0            |

    Examples: Boundary tests: hoover location is out of room space
      | roomSize | coords | patches             | instructions | statusCode | coordsFinal | patchesCount |
      | [5,5]    | [5,2]  | []                  | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [5,5]    | [6,2]  | []                  | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [5,5]    | [2,5]  | []                  | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [5,5]    | [2,7]  | []                  | NNESEESWNWW  | 400        | [0,0]       | 0            |

    Examples: Boundary tests: patches location is out of room space / number of patches bigger than room space
      | roomSize | coords | patches             | instructions | statusCode | coordsFinal | patchesCount |
      | [1,1]    | [0,0]  | [[0,0],[1, 1]]      | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [1,1]    | [0,0]  | [[0,1]]             | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [1,1]    | [0,0]  | [[0,0],[1, 0]]      | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [1,1]    | [0,0]  | [[5, 5]]            | NNESEESWNWW  | 400        | [0,0]       | 0            |

    Examples: Negative tests: invalid inputs
      | roomSize | coords | patches             | instructions | statusCode | coordsFinal | patchesCount |
      | ['a',-5] | [0,0]  | [[0,0],[1, 1]]      | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [1,1]    | [-1,-1]| [[0,0],[0, 1]]      | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [5,5]    | [0,0]  | [['a',0],[1,'b']]   | NNESEESWNWW  | 400        | [0,0]       | 0            |
      | [5,5]    | [0,0]  | [[4, 4]]            | POSDRTYBNML  | 400        | [0,0]       | 0            |

