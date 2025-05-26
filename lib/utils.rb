# frozen_string_literal: true

require_relative 'jekyll_mtg/version'

module JekyllMtg
  # Provides shared methods
  module Utils
    DEFAULT_REQUEST_FORMAT = 'json'
    SCRYFALL_BASE_URI = 'https://api.scryfall.com/'
    SCRYFALL_FUZZY_PATH = '/cards/named'

    def parse_card_info(card_info)
      args = {}

      card_info.scan(/(\w+)="([^\"]*)"/) do |key, value|
        args[key.to_sym] = value # Store as symbols for convenience
      end

      { card_name: args[:name], set_code: args[:set], contents: args[:contents] }
    end

    def fetch_card(parsed_card_info)
      uri = URI(SCRYFALL_BASE_URI)
      uri.path = SCRYFALL_FUZZY_PATH
      params = { fuzzy: parsed_card_info[:card_name], set: parsed_card_info[:set_code], format: DEFAULT_REQUEST_FORMAT }
      uri.query = URI.encode_www_form(params)
      headers = { 'Accept' => 'application/json', 'User-Agent' => "JekyllMTG/#{JekyllMtg::VERSION}" }
      response = Net::HTTP.get(uri, headers)
      JSON.parse(response)
    end
  end
end
