# -*- encoding : utf-8 -*-

module ModelSupport

  def self.included(base)

    base.class_eval do
      include ::Const

      private

      def self.setup_kv(name, array, default)
        const_name=name.upcase
        const_set const_name.to_sym, array
        const_set :"DEFAULT_#{const_name}", default
        self.class_eval <<-MD, __FILE__, __LINE__ + 1
          def set_defaults
          end unless self.method_defined? :set_defaults
          after_initialize :set_defaults
          def set_defaults_with_#{name}
            set_defaults_without_#{name}
            self.#{name}=DEFAULT_#{const_name} unless self.#{name} rescue nil
          end
          alias_method_chain :set_defaults, :#{name}
          def #{name}_name
            s=#{const_name}.find {|n,v|v==self.#{name}}
            s[0] unless s.nil?
          end
        MD
      end

      def self.belongs_to_user(name=:user)
        belongs_to name, :class_name => 'Sys::User'
        self.class_eval <<-MD, __FILE__, __LINE__ + 1
          def #{name}
            Sys::User.unscoped {super}
          end
        MD
      end

      def self.belongs_to_project
        belongs_to :project, :class_name => 'Sys::Project'
      end

      def self.date_range_and_project_id(params)
        date_from=params[:date_from]
        date_to=params[:date_to]
        date_from=date_from.gsub(/\s/, '').gsub(/'/, '') unless date_from.blank?
        date_to=date_to.gsub(/\s/, '').gsub(/'/, '') unless date_to.blank?
        project_id=params[:project_id]
        project_id=project_id.to_i if project_id
        return date_from, date_to, project_id
      end

      def build_activity(atts={})
        m = {:project_id => self.project_id, :subject_type => self.class.name, :subject_id => self.id}
        m[:user_id] = self.luu_id if self.respond_to?(:luu_id)
        Activity.new(m.merge(atts))
      end

      def save_activity(atts={})
        build_activity(atts).save
      end

      def build_sys_log(atts={})
        m = {:subject_type => self.class.name, :subject_id => self.id}
        m[:user_id] = self.luu_id if self.respond_to?(:luu_id)
        m[:user_ip] = self.luu_ip if self.respond_to?(:luu_ip)
        Sys::Log.new(m.merge(atts))
      end

      def save_sys_log(atts={})
        build_sys_log(atts).save
      end
    end
  end

end
