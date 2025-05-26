# frozen_string_literal: true

RSpec.describe JekyllMtg do
  Jekyll.logger.log_level = :error

  it 'has a version number' do
    expect(JekyllMtg::VERSION).not_to be nil
  end

  def extract_link(contents, card_name)
    card_link_regex = %r{<a href='([^']+)'[^>]*?>#{card_name}</a>}
    contents.match(card_link_regex)
  end

  def generate_regex_for_expected(card_name)
    %r{^https://scryfall\.com/card/[a-zA-Z0-9]+/\d+/#{card_name.downcase.gsub(" ", "-")}\?utm_source=api$}
  end

  context 'LinkCard' do
    let(:config_overrides) { {} }
    let(:config) do
      Jekyll.configuration(
        config_overrides.merge(
          'source' => source_dir,
          'destination' => dest_dir,
          'url' => 'http://example.org'
        )
      )
    end
    let(:site) { Jekyll::Site.new(config) }
    let(:contents) { File.read(dest_dir('index.html')) }
    before(:each) do
      site.process
    end

    it 'links the card from a non-specific set when only the name ("Ajani Goldmane") is provided' do
      match = extract_link(contents, 'Ajani Goldmane')
      expect(match).not_to be_nil
      expect(match[1]).to match(generate_regex_for_expected('Ajani Goldmane'))
    end

    it 'links the card from a specific set when the name ("Jace Beleren") and set code ("LRW") are provided' do
      expect(contents).to include("<a href='https://scryfall.com/card/lrw/71/jace-beleren?utm_source=api'>Jace Beleren</a>")
    end

    it 'does not link the card when the name ("Liliana Vess") and set code ("POO") are provided and the set code does not exist' do
      match = extract_link(contents, 'Liliana Vess')
      expect(contents).to include('Liliana Vess')
      expect(match).to be(nil)
    end

    it 'does not link the card when the name ("Chandra Nalaar") and set code ("MOR") are provided and the set code is not one in which the card appeared' do
      match = extract_link(contents, 'Chandra Nalaar')
      expect(contents).to include('Chandra Nalaar')
      expect(match).to be_nil
    end

    it 'links the card when the name ("Garruk Wildspeaker") is misspelled slightly ("Garuk Wildspeeker")' do
      match = extract_link(contents, 'Garuk Wildspeeker')
      expect(match).not_to be_nil
      expect(match[1]).to match(generate_regex_for_expected('Garruk Wildspeaker'))
    end

    it 'does not link the card when the name ("Elspeth, Knight-Errant") is misspelled significantly ("Elspooth, Nite Errand")' do
      match = extract_link(contents, 'Elspooth, Nite Errand')
      expect(match).to be_nil
    end

    it 'does not link the card when the name ("Mickey Mouse") does not match the name of an existing card' do
      match = extract_link(contents, 'Mickey Mouse')
      expect(match).to be_nil
    end

    it 'uses the specified contents in the anchor tag' do
      expect(contents).to include("<a href='https://scryfall.com/card/inv/156/obliterate?utm_source=api'>Obliterate (the one with the good flavor text)</a>")
    end
  end
end
