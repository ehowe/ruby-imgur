module Imgur::PagedCollection
  def self.included(klass)
    klass.attribute :next_link
    klass.attribute :prev_link
    klass.attribute :last_link
    klass.send(:extend, Imgur::PagedCollection::Attributes)
  end

  module Imgur::PagedCollection::Attributes
    def collection_root(collection_root)
      @collection_root = collection_root
    end

    def collection_request(collection_request)
      @collection_request = collection_request
    end
  end

  def collection_root
    self.class.instance_variable_get(:@collection_root)
  end

  def collection_request
    self.class.instance_variable_get(:@collection_request)
  end

  def next_page
    all("url" => self.next_link) if self.next_link
  end

  def previous_page
    all("url" => self.prev_link) if self.prev_link
  end

  def last_page
    all("url" => self.last_link)
  end

  def ==(comparison_object)
    comparison_object.equal?(self) ||
      (comparison_object.is_a?(self.class) &&
       comparison_object.map(&:identity) == self.map(&:identity))
  end

  def all(params={})
    response = connection.send(self.collection_request, params)

    collection = self.clone.load(response.body[self.collection_root])

    collection.attributes.clear

    links = response.headers['Link'].split(", ").inject({}) do |r, link|
      value, key = link.match(/<(.*)>; rel="(\w+)"/).captures
      r.merge("#{key}_link" => value)
    end

    collection.merge_attributes(links)
  end
end
