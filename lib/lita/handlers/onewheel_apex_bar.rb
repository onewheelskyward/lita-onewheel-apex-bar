require 'rest-client'
require 'nokogiri'
require 'sanitize'
require 'lita-onewheel-beer-base'

module Lita
  module Handlers
    class OnewheelApexBar < OnewheelBeerBase
      route /^apex$/i,
            :taps_list,
            command: true,
            help: {'taps' => 'Display the current Apex Bar taps.'}

      route /^apex ([\w ]+)$/i,
            :taps_deets,
            command: true,
            help: {'taps 4' => 'Display the tap 4 deets, including prices.'}

      route /^apex ([<>=\w.\s]+)%$/i,
            :taps_by_abv,
            command: true,
            help: {'taps >4%' => 'Display beers over 4% ABV.'}

      route /^apex ([<>=\$\w.\s]+)$/i,
            :taps_by_price,
            command: true,
            help: {'taps <$5' => 'Display beers under $5.'}

      route /^apex (roulette|random|rand|ran|ra|r)$/i,
            :taps_by_random,
            command: true,
            help: {'taps roulette' => 'Can\'t decide?  Let me do it for you!'}

      route /^apexabvlow$/i,
            :taps_low_abv,
            command: true,
            help: {'tapslow' => 'Show me the lowest abv keg.'}

      route /^apexabvhigh$/i,
            :taps_high_abv,
            command: true,
            help: {'tapslow' => 'Show me the highest abv keg.'}

      def send_response(tap, datum, response)
        reply = "Apex tap #{tap}) #{get_tap_type_text(datum[:type])}"
        # reply += "#{datum[:brewery]} "
        reply += "#{datum[:name]} "
        # reply += "- #{datum[:desc]}, "
        # reply += "Served in a #{datum[1]['glass']} glass.  "
        # reply += "#{get_display_prices datum[:prices]}, "
        # reply += "#{datum[:remaining]}"

        Lita.logger.info "send_response: Replying with #{reply}"

        response.reply reply
      end

      def get_display_prices(prices)
        price_array = []
        prices.each do |p|
          price_array.push "#{p[:size]} - $#{p[:cost]}"
        end
        price_array.join ' | '
      end

      def get_source
        Lita.logger.debug 'get_source started'
        unless (response = redis.get('page_response'))
          Lita.logger.info 'No cached result found, fetching.'
          response = RestClient.get('http://apexbar.com/menu')
          redis.setex('page_response', 1800, response)
        end
        parse_response response
      end

      # This is the worker bee- decoding the html into our "standard" document.
      # Future implementations could simply override this implementation-specific
      # code to help this grow more widely.
      def parse_response(response)
        Lita.logger.debug 'parse_response started.'
        gimme_what_you_got = {}
        noko = Nokogiri.HTML response
        noko.css('table.table tbody tr').each_with_index do |beer_node, index|
          # gimme_what_you_got
          tap_name = (index + 1).to_s

          # brewery = beer_node.css('td')[0].children.to_s
          beer_name = beer_node.css('td')[0].children.to_s
          # beer_desc = get_beer_desc(beer_node)
          abv = beer_node.css('td')[4].children.to_s
          # full_text_search = "#{tap.sub /\d+/, ''} #{brewery} #{beer_name} #{beer_desc.to_s.gsub /\d+\.*\d*%*/, ''}"
          # prices = get_prices(beer_node)

          gimme_what_you_got[tap_name] = {
          #     type: tap_type,
          #     remaining: remaining,
          #     brewery: brewery.to_s,
              name: beer_name.to_s,
          #     desc: beer_desc.to_s,
              abv: abv.to_f,
          #     prices: prices,
          #     search: full_text_search
          }
        end
        puts gimme_what_you_got.inspect
        gimme_what_you_got
      end

      def get_abv(beer_desc)
        if (abv_matches = beer_desc.match(/\d+\.\d+%/))
          abv_matches.to_s.sub '%', ''
        end
      end

      # Return the desc of the beer, "Amber ale 6.9%"
      def get_beer_desc(noko)
        beer_desc = ''
        if (beer_desc_matchdata = noko.to_s.gsub(/\n/, '').match(/(<br\s*\/*>)(.+%) /))
          beer_desc = beer_desc_matchdata[2].gsub(/\s+/, ' ').strip
        end
        beer_desc
      end

      # Get the brewery from the node, return it or blank.
      def get_brewery(noko)
        brewery = ''
        if (node = noko.css('span a').first)
          brewery = node.children.to_s.gsub(/\n/, '')
          brewery.gsub! /RBBA/, ''
          brewery.strip!
        end
        brewery
      end

      # Returns ...
      # There are a bunch of hidden html fields that get stripped after sanitize.
      def get_prices(noko)
        prices_str = noko.css('div#prices').children.to_s.strip
        prices = Sanitize.clean(prices_str)
            .gsub(/We're Sorry/, '')
            .gsub(/Inventory Restriction/, '')
            .gsub(/Inventory Failure/, '')
            .gsub('Success!', '')
            .gsub(/\s+/, ' ')
            .strip
        price_points = prices.split(/\s\|\s/)
        prices_array = []
        price_points.each do |price|
          size = price.match /\d+(oz|cl)/
          dollars = price.match(/\$\d+\.*\d*/).to_s.sub('$', '')
          crowler = price.match ' Crowler'
          size = size.to_s + crowler.to_s
          p = {size: size, cost: dollars}
          prices_array.push p
        end
        prices_array
      end

      # Returns 1, 2, Cask 3, Nitro 4...
      def get_tap_name(noko)
        noko.css('span')
            .first
            .children
            .first
            .to_s
            .match(/[\w ]+\:/)
            .to_s
            .sub(/\:$/, '')
      end

      Lita.register_handler(self)
    end
  end
end
