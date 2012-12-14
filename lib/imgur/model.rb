class Imgur::Model < Cistern::Model
  def self.assoc_reader(name)
    define_method(name) do
      send("#{name}_id".to_sym) && self.connection.send("#{name}s").get(self.send("#{name}_id"))
    end
  end

  def self.assoc_writer(name)
    define_method("#{name}=") do |value|
      self.send("#{name}_id=", value.id) if value
    end
  end

  def self.assoc_accessor(name)
    assoc_reader(name)
    assoc_writer(name)
  end
end
