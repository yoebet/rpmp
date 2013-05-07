# -*- encoding : utf-8 -*-

module ProjectResource

  def self.included(base)
    base.class_eval do
      belongs_to_project
      belongs_to_user :registrar
      [:associations, :comments, :tags].each do |sth|
        has_many sth, :as => :subject, :dependent => :destroy
      end
      has_many :activities, :as => :subject
      default_scope :order => 'id desc'

      validates :abstract, :presence => true if columns_hash.key?('abstract')
      validates :content, :presence => true if columns_hash.key?('content')

      setup_kv('importance', [['不重要', 1], ['普通', 2], ['重要', 3], ['非常重要', 4]], 2) if columns_hash.key?('importance')
      setup_kv('priority', [['低', 1], ['普通', 2], ['高', 3], ['最高', 4]], 2) if columns_hash.key?('priority')
      setup_kv('urgency', [['不紧急', 1], ['普通', 2], ['紧急', 3], ['非常紧急', 4]], 2) if columns_hash.key?('urgency')

      after_create :log_resource_created
      after_update :log_resource_updated
      after_destroy :log_resource_destroyed

      attr_accessor :luu_id

      private

      def status_change_action(from_status, to_status)
        nil
      end

      def log_resource_created
        activity=build_activity :action => 'created', :user_id => self.registrar_id
        activity.save
      end

      def log_resource_updated
        activity=build_activity :action => 'updated', :user_id => self.luu_id

        if self.respond_to?(:status) && self.status_changed?

          status0, status1=self.status_was, self.status

          if status0==Const::STATUS_CANCELED or status0==Const::STATUS_SUSPEND
            activity.action='resumed'
          end

          sa=Activity::STATUS_ACTION_MAP[status1]
          activity.action=sa if sa

          action=status_change_action status0, status1
          activity.action=action if action
        end

        if self.respond_to? :confirmed
          confirmed0=self.changed_attributes['confirmed']
          if confirmed0==false and self.confirmed
            activity.action='confirmed'
          end
        end

        if self.is_a? Task and self.confirmed and self.changed_attributes['work_rank']==0 and self.work_rank!=0
          activity.action='ranked'
        end

        activity.save
      end

      def log_resource_destroyed
        activity=build_activity :action => 'deleted', :user_id => self.luu_id
        activity.abstract=case self
                            when Release
                              self.version
                            when Task
                              "#{self.abstract}（#{self.recipient.name}）"
                            else
                              self.abstract if self.respond_to? :abstract
                          end
        activity.save
      end
    end

    base.extend ClassMethods
    base.extend ::Finder
  end

  module ClassMethods

    private

    def has_attachments
      has_many :attachments, :as => :subject, :select => Attachment::SELECT_FIELDS, :dependent => :destroy
    end

    def has_status(array=[['未完成', 1], ['已完成', 3], ['搁置', 8], ['已撤销', 9]], default=array[0][1])
      setup_kv('status', array, default)
    end

    def setup_associations(associations)
      associations.each do |name, source|
        has_many name, :through => :associations, :source => source||name.to_s.singularize
      end
    end

  end
end