@listing
Feature: Show Listing

  Scenario: I can change the view method
    Given I am on the listing page:
      | parameter | value |
    Then  the articles should be shown in a table-view

    When  I follow "Listen-Ansicht"
    Then  the articles should be shown in a list-view

  @filter
  Scenario: I can filter the articles by supplier
    Given I am on the listing page:
      | parameter | value |
      | sPerPage  | 48    |
    When  I set the filter to:
      | filter     | value                |
      | Hersteller | Sonnenschirm Versand |
    Then I should see 5 articles

    When  I set the filter to:
      | filter     | value       |
      | Hersteller | Teapavilion |
    Then I should see 23 articles

    When I reset all filters
    Then I should see 48 articles

  @filter
  Scenario: I can filter the articles by custom filters
    Given I am on the listing page:
      | parameter | value |
      | sCategory | 21    |
    When  I set the filter to:
      | filter        | value     |
      | Geschmack     | mild      |
      | Flaschengröße | 0,5 Liter |
      | Alkoholgehalt | >30%      |
    Then I should see 4 articles

    When  I set the filter to:
      | filter          | value   |
      | Trinktemperatur | Gekühlt |
      | Farbe           | rot     |
    Then I should see 2 articles

    When I reset all filters
    Then I should see 10 articles

  @sort @javascript
  Scenario: I can change the sort
    Given I am on the listing page:
      | parameter | value |
      | sPerPage  | 12    |
      | sSort     | 1     |
    Then I should see "Kundengruppen Brutto / Nettopreise"

    When  I select "Beliebtheit" from "sSort"
    Then  I should see the article "ESD Download Artikel" in listing
    But  I should not see the article "Kundengruppen Brutto / Nettopreise" in listing

    When  I select "Niedrigster Preis" from "sSort"
    Then  I should see the article "Fliegenklatsche lila" in listing
    But   I should not see the article "ESD Download Artikel" in listing

    When  I select "Höchster Preis" from "sSort"
    Then  I should see the article "Dart Automat Standgerät" in listing
    But   I should not see the article "Fliegenklatsche lila" in listing

    When  I select "Artikelbezeichnung" from "sSort"
    Then  I should see the article "Artikel mit Abverkauf" in listing
    But   I should not see the article "Dart Automat Standgerät" in listing

    When  I select "Erscheinungsdatum" from "sSort"
    Then  I should see the article "Kundengruppen Brutto / Nettopreise" in listing
    But   I should not see the article "Artikel mit Abverkauf" in listing

  @perPage @javascript
  Scenario Outline: I can change the articles per page
    Given I am on the listing page:
      | parameter | value  |
      | sPerPage  | <from> |
    Then I should see <from> articles

    When I select "<to>" from "sPerPage"
    Then I should see <to> articles

  Examples:
    | from | to |
    | 12   | 24 |
    | 24   | 36 |
    | 36   | 48 |
    | 48   | 12 |

  @language @javascript
  Scenario: I can change the language
    Given I am on the listing page:
      | parameter | value |
      | sCategory | 69    |
    Then  I should see "Artikel mit ähnlichen Produkten"
    And  I should see "Artikel mit Zubehör"

    When  I select "English" from "__shop"
    Then  I should see "Articles with similar products"
    And  I should see "Articles with accessories"

    When I go to the listing page:
      | parameter | value |
      | sSupplier | 5     |
    Then  I should see "Suitcase set"

    When  I select "Deutsch" from "__shop"
    Then  I should see "Reisekoffer Set"

  @customergroups
  Scenario:
    Given I am on the page "Account"
    And   I log in successful as "Händler Kundengruppe-Netto" with email "mustermann@b2b.de" and password "shopware"
    And   I am on the listing page:
      | parameter | value |
      | sCategory | 30    |

    Then  The price of the article on position 1 should be "16,81 €"
    And   The price of the article on position 2 should be "42,02 €"
    And   The price of the article on position 3 should be "6,71 €"

    When  I am on the page "Account"
    And   I log me out
    And   I am on the listing page:
      | parameter | value |
      | sCategory | 30    |

    Then  The price of the article on position 1 should be "20,00 €"
    And   The price of the article on position 2 should be "50,00 €"
    And   The price of the article on position 3 should be "7,99 €"

  @browsing
  Scenario Outline: I can browse through the listing
    Given I am on the listing page:
      | parameter | value     |
      | sPage     | 4         |
      | sPerPage  | <perPage> |

    Then I should see <perPage> articles

    When I browse to "previous" page 3 times
    Then I should not be able to browse to "previous" page

    When I browse to "next" page <countNextPage> times
    Then I should see "ESD Download Artikel"
    And I should see "Sonnenbrille Speed Eyes"

    When I browse to page <lastPage>
    Then I should see <countLastPage> articles
    And  I should not be able to browse to "next" page
    And  I should not be able to browse to page 1

  Examples:
    | perPage | countNextPage | lastPage | countLastPage |
    | 12      | 6             | 8        | 12            |
    | 24      | 3             | 8        | 24            |
    | 36      | 2             | 6        | 16            |
    | 48      | 1             | 5        | 4             |