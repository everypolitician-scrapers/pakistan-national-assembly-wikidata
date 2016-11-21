#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

constituency_members = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_the_14th_National_Assembly_of_Pakistan',
  before: '//span[@id="Reserved_seats_for_women"]',
  xpath: '//table[.//th[.="Constituency"]]//td[4]//a[not(@class="new")][1]/@title',
)

non_constituency_members = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_the_14th_National_Assembly_of_Pakistan',
  after: '//span[@id="Reserved_seats_for_women"]',
  xpath: '//table[.//th[.="Name"]]//td[3]//a[not(@class="new")][1]/@title',
)

EveryPolitician::Wikidata.scrape_wikidata(names: { en: constituency_members | non_constituency_members })

