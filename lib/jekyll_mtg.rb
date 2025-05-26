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
      card_name, set_code = card_info.split('|')
      uri = URI(SCYRFALL_URI)
      uri.path = SCRYFALL_PATH
      params = { fuzzy: card_name, set: set_code, format: REQUEST_FORMAT }
      uri.query = URI.encode_www_form(params)
      headers = { 'Accept' => 'application/json', 'User-Agent' => "JekyllMTG/#{JekyllMTG::VERSION}" }
      response = Net::HTTP.get(uri, headers)
      response = JSON.parse(response)

      "<a href='#{response["scryfall_uri"]}'>#{card_name}</a>"
    end
  end
end

Liquid::Template.register_tag('link_card', JekyllMtg::LinkCard)
