class Dog < Pet

    def self.allowed_tracker_types
        tracker_types.keys
    end
end
