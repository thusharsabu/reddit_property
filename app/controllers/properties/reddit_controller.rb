
require 'reddit/property_manager'

module Properties
  class RedditController < ApplicationController
    before_action :read_data, only: [:index, :show, :upvote, :downvote]

    attr_reader :data

    SORT_OPTIONS = ['price', 'beds', 'baths', 'created_at']

    # GET /index
    def index
      response = []

      sort_by_key = if SORT_OPTIONS.include?params['sort_by']
                      params['sort_by'].to_s
                    else
                      'CREATED_AT'
                    end

      sort_property(key: sort_by_key)

      data.each do |each_data|
        response << each_data.slice('SALE TYPE', 'PRICE', 'BEDS', 'BATHS', 'UPVOTE', 'DOWNVOTE', 'CREATED_AT')
      end

      render json: response
    rescue StandardError => e
      Rails.logger.error message: 'Failed to fetch data', exception: e

      render json: { error: e.message }, status: 500
    end

    # Get /show
    def show
      relevant_data = find_data(id: params['id'].to_i)

      if relevant_data.blank?
        render json: '{"error": "not_found"}', status: :not_found
      else
        render json: { data: relevant_data }
      end
    rescue StandardError => e
      Rails.logger.error message: 'Failed to fetch data', exception: e

      render json: { error: e.message }, status: 500
    end

    # GET /populate
    def populate
      Reddit::PropertyManager.populate_properties

      head :ok
    rescue StandardError => e
      Rails.logger.error message: 'Failed to Populate Property data', exception: e

      render json: { error: e.message }, status: 500
    end

    # POST /upvote
    def upvote
      relevant_data = find_data(id: vote_params['id'].to_i)

      if relevant_data.blank?
        render json: '{"error": "not_found"}', status: :not_found
      else
        relevant_data['UPVOTE'] = relevant_data['UPVOTE'].to_i + vote_params['vote']

        Reddit::PropertyManager.write_data(data: data)
  
        head :ok
      end
    rescue StandardError => e
      Rails.logger.error message: 'Failed to Populate Property data', exception: e

      render json: { error: e.message }, status: 500
    end
  
    # POST /downvote
    def downvote
      relevant_data = find_data(id: vote_params['id'].to_i)

      if relevant_data.blank?
        render json: '{"error": "not_found"}', status: :not_found
      else
        relevant_data['DOWNVOTE'] = relevant_data['DOWNVOTE'].to_i - vote_params['vote']

        Reddit::PropertyManager.write_data(data: data)
  
        head :ok
      end
    rescue StandardError => e
      Rails.logger.error message: 'Failed to Populate Property data', exception: e

      render json: { error: e.message }, status: 500
    end

    private

    # Private: Search Property with id
    # 
    # @param [Integer] id, Properties id
    # 
    # @return [Hash, nil] if found Property else nil
    def find_data(id:)
      data.detect do |each_data| 
        each_data['ID'] == id
      end
    end

    # Private: Reads json file containing all property
    def read_data
      @data = JSON.parse(File.read(File.join(Dir.pwd, 'data', 'data.json')))
    end

    # Private: Sort data based on key
    # 
    # @param [Array<Hash>] data, An array of hashes ie: properties
    # @param [String] key, ie: price, beds, bath
    #
    # @returns [Array<Hash>] Array of sorted hash
    def sort_property(key:)
      if key.upcase == 'CREATED_AT'
        data.sort! { |first, second| Date.parse(second[key]) <=> Date.parse(first[key]) }
      else
        data.sort! { |first, second| second[key.upcase].to_f <=> first[key.upcase].to_f }
      end
    end

    #
    def vote_params
      params.require(:property).permit(:id, :vote)
    end
  end
end
