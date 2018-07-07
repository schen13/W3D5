class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |attr|

      attr_str = attr.to_s

      define_method(attr_str) do
        instance_variable_get("@"+attr_str)
      end

      define_method(attr_str+'=') do |value|
        instance_variable_set("@"+attr_str, value)
      end
    end
  end
end
