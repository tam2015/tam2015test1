require 'to_xls/writer.rb'

module Enumerable
  alias old_to_xls to_xls #keep reference to original to_xls method

  def to_xls(options = Hash.new)
    # override only if first element actually has as_xls method
    if self.first.respond_to? :xls_options
      Rails.logger.debug " ===>  #{self.first.inspect} "
      old_to_xls(self.first.xls_options.merge(options))
    else
      old_to_xls(options)
    end
  end
end
