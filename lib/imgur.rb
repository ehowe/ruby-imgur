require 'imgur/version'
require 'cistern'
require 'logger'
require 'launchy'
require 'yaml'
require 'rest-client'

module Imgur
  DEFAULT_TIMEOUT = 60
  RequestFailure = Class.new(Exception)

  autoload :Client,          'imgur/client'
  autoload :Collection,      'imgur/collection'
  autoload :Json,            'imgur/json'
  autoload :Logger,          'imgur/logger'
  autoload :Model,           'imgur/model'
  autoload :Response,        'imgur/response'
  autoload :PagedCollection, 'imgur/paged_collection'

  def self.paging_parameters(params)
    if url = params["url"]
      Addressable::URI.parse(url).query_values
    else
      params
    end
  end
end

Cistern.timeout = Imgur::DEFAULT_TIMEOUT
