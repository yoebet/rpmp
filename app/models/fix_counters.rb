# -*- encoding : utf-8 -*-

module FixCounters

  def self.included(base)

    base.class_eval do
      after_update :fix_updated_counters
    end

    private

    def fix_updated_counters
      self.changes.each do |key, (old_value, new_value)|
        if key =~ /_id$/ #FIXME
          changed_class = key.sub /_id$/, ''
          association = self.association changed_class.to_sym

          option = association.options[:counter_cache]
          case option
            when TrueClass
              counter_name = "#{self.class.name.tableize}_count"
            when Symbol
              counter_name = option.to_s
            else
              next
          end

          klass=association.klass
          klass.decrement_counter(counter_name, old_value) if old_value
          klass.increment_counter(counter_name, new_value) if new_value
        end
      end
    end
  end
end
