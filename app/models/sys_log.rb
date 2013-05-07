# -*- encoding : utf-8 -*-

module SysLog

  def self.included(base)
    base.class_eval do

      has_many :logs, :as => :subject

      after_create { do_log 'created' }
      after_update { do_log 'updated' }
      after_destroy { do_log 'deleted' }

      attr_accessor :luu_id, :luu_ip, :skip_log

      private

      def do_log(action)
        return if self.skip_log
        save_sys_log :action => action, :abstract => log_abstract(action)
      end

      def log_abstract(action)
        return self.name if respond_to? :name
      end
    end
  end
end

