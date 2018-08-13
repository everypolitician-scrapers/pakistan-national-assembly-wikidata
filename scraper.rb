#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

original_members = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_the_14th_National_Assembly_of_Pakistan',
  before: '//span[@id="Membership_changes"]',
  xpath: '//table[.//th[contains(.,"Constituency")]]//td[3]//a[not(@class="new")][1]/@title',
)

changes = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_the_14th_National_Assembly_of_Pakistan',
  after: '//span[@id="Membership_changes"]',
  xpath: '//table[.//th[contains(.,"Member")]]//td[3]//a[not(@class="new")][1]/@title',
)

# Find all P39s of the 14th Assembly
query = 'SELECT DISTINCT ?item WHERE { ?item wdt:P39 wd:Q33512801 }'
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { en: original_members | changes })

