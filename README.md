# JekyllMTG

`jekyll_mtg` is a [Jekyll](https://jekyllrb.com/) [plugin](https://jekyllrb.com/docs/plugins/) that helps you reference *Magic: The Gathering* cards in your site content. You can generate links to cards on [Scryfall](https://scryfall.com/) by using a simple [Liquid](https://shopify.github.io/liquid/) tag.

## Installation

Follow [the Plugins doc](https://jekyllrb.com/docs/plugins/installation/) from Jekyll.

## Usage

### Link a Card

```
# Link to any version of the named card.
{% link_card name="Obliterate" %}

# Or link to a specific version by including the set code.
{% link_card name="Obliterate" set="INV" %}

# Override the card name as the default contents of the anchor tag.
{% link_card name="Obliterate" set="INV" contents="Obliterate (the one with the good flavor text) %}
```

If no card is found from the query to Scryfall, whether because the card name is misspelled significantly or the wrong set code is specified or no card with the specified name exists, then the output of the conversion process is the value of `contents` (if specified) or `name`.

### Coming Soon

- Embed a card image
- Render a full deck list

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatthewSerre/jekyll_mtg.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
