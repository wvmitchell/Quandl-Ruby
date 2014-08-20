module Quandl
  class Favorites
    attr_reader :auth_token, :options, :data

    def self.get(options = {})
      instance = new(options)
      instance.get
      if block_given?
        yield(instance.data)
      else
        instance.data
      end
    end

    def initialize(options = {})
      @auth_token = options.delete(:auth_token) || Quandl.configuration.auth_token
      @options = options
    end

    def get(reload = false)
      if !data || reload
        raw_data = Quandl::Request.new('current_user/collections/datasets/favourites', {
          options: options,
          auth_token: auth_token
        }).get
        self.data = Quandl.parse(raw_data, (options[:format] || :json).to_sym)
      end
      if block_given?
        yield(data)
      else
        data
      end
    end
  end

  Favourites = Favorites
end
