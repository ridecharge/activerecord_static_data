module ActiveRecord
  module RequiredData
    def static_data(key, values)
      return if ENV['SKIP_REQUIRED_DATA'] == 'true'
      actual_values = self.name.classify.constantize.all.map{|record| record.send(key)}
      missing_values = values - actual_values
      raise "Missing required #{key.to_s.pluralize} for #{self.name.classify}: #{missing_values}" if missing_values.any?
      extra_values = actual_values - values
      raise "Unknown extra #{key.to_s.pluralize} in database for #{self.name.classify}: #{extra_values}" if extra_values.any?
    end
  end
end
