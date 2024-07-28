class PetServices::PetsOutsideZone < PetServices::Base
    def call
        statistics = filter(Pet.all).where(in_zone: false)
                     .group(:type, :tracker_type).count

        [build_custome_response(statistics), 200]
    end

    private
    def build_custome_response(statistics)
        total_outside_pet_count = 0
        data = []

        statistics.keys.each do |group|
          group_info = {}
          pet_type, tracker_type = group
          group_info[:type] = pet_type 
          group_info[:tracker_type] = tracker_type
          group_info[:count] =  statistics[group]

          total_outside_pet_count += group_info[:count]
          data << group_info
        end

        build_response_object(data, total_outside_pet_count)
    end

    def build_response_object(data, total_outside_pet_count)
        {
            data: data,
            total_outside_pet_count: total_outside_pet_count
        }
    end
end