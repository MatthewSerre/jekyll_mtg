# frozen_string_literal: true

require 'jekyll'
require 'net/http'
require_relative 'utils'

module JekyllMtg
  # Links cards
  class LinkCard < Liquid::Tag
    include Utils

    def initialize(tag_name, card_info, tokens)
      super

      @card_info = card_info
    end

    attr_reader :card_info

    def render(_context)
      parsed_card_info = parse_card_info(card_info)
      response = fetch_card(parsed_card_info)

      text = parsed_card_info[:contents] || parsed_card_info[:card_name]
      if response['scryfall_uri']
        "<a href='#{response["scryfall_uri"]}'>#{text}</a>"
      else
        text
      end
    end
  end
end

Liquid::Template.register_tag('link_card', JekyllMtg::LinkCard)
