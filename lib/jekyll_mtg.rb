# frozen_string_literal: true

require 'jekyll'
require 'net/http'
require_relative 'jekyll_mtg/version'

module JekyllMtg
  # Links cards
  class LinkCard < Liquid::Tag
    REQUEST_FORMAT = 'json'
    SCYRFALL_URI = 'https://api.scryfall.com/'
    SCRYFALL_PATH = '/cards/named'

    def initialize(tag_name, card_info, tokens)
      super

      @card_info = card_info
    end

    attr_reader :card_info

    def render(_context)
      parts = card_info.split('|')
      card_name = parts[0]
      set_code = parts[1]

      uri = URI(SCYRFALL_URI)
      uri.path = SCRYFALL_PATH
      params = { fuzzy: card_name, set: set_code, format: REQUEST_FORMAT }
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get(uri)
      response = JSON.parse(response)

      "<a href='#{response["scryfall_uri"]}>#{card_name}</a>"
    end
  end
end

Liquid::Template.register_tag('link_card', JekyllMtg::LinkCard)
