#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

original_members = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_the_14th_National_Assembly_of_Pakistan',
  before: '//span[@id="Membership_changes"]',
  xpath: '//table[.//th[.="Constituency"]]//td[4]//a[not(@class="new")][1]/@title',
)

changes = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_the_14th_National_Assembly_of_Pakistan',
  after: '//span[@id="Membership_changes"]',
  xpath: '//table[.//th[.="Member"]]//td[4]//a[not(@class="new")][1]/@title',
)

# Find all P39s of the 14th Assembly
query = <<EOS
  SELECT DISTINCT ?item
  WHERE
  {
    BIND(wd:Q20760546 AS ?membership)
    BIND(wd:Q29068722 AS ?term)

    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 ?membership .
    ?position_statement pq:P2937 ?term .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)


EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { en: original_members | changes })

