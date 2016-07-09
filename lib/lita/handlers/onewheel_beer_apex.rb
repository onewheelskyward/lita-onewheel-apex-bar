require 'rest-client'
require 'nokogiri'
require 'sanitize'
require 'lita-onewheel-beer-base'

module Lita
  module Handlers
    class OnewheelBeerApex < OnewheelBeerBase
      route /^apex$/i,
            :taps_list,
            command: true,
            help: {'apex' => 'Display the current Apex Bar taps.'}

      route /^apex ([\w ]+)$/i,
            :taps_deets,
            command: true,
            help: {'apex 4' => 'Display the Apex tap 4 deets, including prices.'}

      route /^apex ([<>=\w.\s]+)%$/i,
            :taps_by_abv,
            command: true,
            help: {'apex >4%' => 'Display Apex beers over 4% ABV.'}

      route /^apex ([<>=\$\w.\s]+)$/i,
            :taps_by_price,
            command: true,
            help: {'apex <$5' => 'Display Apex beers under $5.'}

      route /^apex (roulette|random|rand|ran|ra|r)$/i,
            :taps_by_random,
            command: true,
            help: {'apex roulette' => 'Can\'t decide what to drink at Apex?  Let me do it for you!'}

      route /^apexabvlow$/i,
            :taps_low_abv,
            command: true,
            help: {'apexabvlow' => 'Show me the lowest Apex abv keg.'}

      route /^apexabvhigh$/i,
            :taps_high_abv,
            command: true,
            help: {'apexabvhigh' => 'Show me the highest Apex abv keg.'}

      def send_response(tap, datum, response)
        reply = "Apex tap #{tap}) #{get_tap_type_text(datum[:type])}"
        # reply += "#{datum[:brewery]} "
        reply += "#{datum[:name]} "
        # reply += "- #{datum[:desc]}, "
        # reply += "Served in a #{datum[1]['glass']} glass.  "
        # reply += "#{datum[:remaining]}"
        reply += "#{datum[:abv]}%, "
        reply += "$#{datum[:price].to_s.sub '.0', ''}"

        Lita.logger.info "send_response: Replying with #{reply}"

        response.reply reply
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

          brewery = beer_node.css('td')[2].children.to_s
          beer_name = beer_node.css('td')[0].children.text.to_s

          beer_type = beer_name.match(/\s*-\s*\w+$/).to_s
          beer_type.sub! /\s+-\s+/, ''

          abv = beer_node.css('td')[4].children.to_s
          full_text_search = "#{brewery} #{beer_name.to_s.gsub /(\d+|')/, ''}"  # #{beer_desc.to_s.gsub /\d+\.*\d*%*/, ''}

          price_node = beer_node.css('td')[1].children.to_s
          price = (price_node.sub /\$/, '').to_f

          gimme_what_you_got[tap_name] = {
          #     type: tap_type,
          #     remaining: remaining,
              brewery: brewery.to_s,
              name: beer_name.to_s,
              desc: beer_type.to_s,
              abv: abv.to_f,
              price: price,
              search: full_text_search
          }
        end

        gimme_what_you_got
      end

      Lita.register_handler(self)
    end
  end
end
