class Pet < ApplicationRecord
    # For STI
    self.inheritance_column = :type 
    
    # Relations
    belongs_to :owner, class_name: :User, foreign_key: 'owner_id', primary_key: 'id'

    # Scopes for each type
    scope :dogs, -> { where(type: 'Dog') }
    scope :cats, -> { where(type: 'Cat') }

    # Define the allowed types for STI
    ALLOWED_TYPES = %w[Dog Cat].freeze

    # Tracker Types 
    enum tracker_type: { small: 0, medium: 1, big: 2 }

    #Validations
    validates :owner_id, :tracker_type, :type, presence: true
    validates :tracker_type, inclusion: { in: tracker_types.keys, message: "is not a valid pet tracker type" }
    validates :type, inclusion: { in: ALLOWED_TYPES, message: "is not a valid pet type" }
    validate :validate_tracker_type, if: -> { type.present? && ALLOWED_TYPES.include?(type) }

    #callbacks
    after_save :clear_outside_zone_cache

    private
    def validate_tracker_type
        allowed_trackers =  type.constantize.allowed_tracker_types
        
        unless allowed_trackers.include?(tracker_type)
            errors.add(:tracker_type, "#{type} can only have #{allowed_trackers.join(', ')} trackers.")
        end
    end

    def clear_outside_zone_cache
        Rails.cache.delete('outside_zone_count')
    end
end
  