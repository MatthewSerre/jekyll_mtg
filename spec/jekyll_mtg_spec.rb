# frozen_string_literal: true

RSpec.describe JekyllMtg do
  Jekyll.logger.log_level = :error

  it 'has a version number' do
    expect(JekyllMtg::VERSION).not_to be nil
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
      expect(contents).to include("<a href='https://scryfall.com/card/m11/1/ajani-goldmane?utm_source=api'>Ajani Goldmane</a>")
    end

    it 'links the card from a specific set when the name ("Jace Beleren") and set code ("LRW") are provided' do
      expect(contents).to include("<a href='https://scryfall.com/card/lrw/71/jace-beleren?utm_source=api'>Jace Beleren</a>")
    end

    it 'does not link the card when the name ("Liliana Vess") and set code ("POO") are provided and the set code does not exist' do
      expect(contents).to include('Liliana Vess')
    end

    it 'does not link the card when the name ("Chandra Nalaar") and set code ("MOR") are provided and the set code is not one in which the card appeared' do
      expect(contents).to include('Chandra Nalaar')
    end

    it 'links the card ("Garruk Wildspeaker") when the name is misspelled slightly ("Garuk Wildspeeker")' do
      expect(contents).to include("<a href='https://scryfall.com/card/lrw/213/garruk-wildspeaker?utm_source=api'>Garuk Wildspeeker</a>")
    end

    it 'does not link the card when the name ("Elspeth, Knight-Errant") is misspelled significantly ("Elspooth, Nite Errand")' do
      expect(contents).to include('Elspooth, Nite Errand')
    end

    it 'does not link the card when the name ("Mickey Mouse") does not exist' do
      expect(contents).to include('Mickey Mouse')
    end
  end
end
