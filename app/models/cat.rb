class Cat < Pet
    def self.allowed_tracker_types
        tracker_types.keys - ["medium"]
    end
end
  