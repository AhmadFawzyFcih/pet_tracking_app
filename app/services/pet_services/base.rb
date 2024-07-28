class PetServices::Base
    def initialize(pet_params, pet=nil)
      @pet_params = {}
      @pet_params = pet_params if pet_params.permitted? 

      @pet = pet
      @pet_object = prepare_object
      

      @page = pet_params["page"] || 1
      @pagesize = pet_params["pagesize"] || 50
      @filter_by_type = pet_params["filter_by_type"]
    end

    def prepare_object
      pet = @pet || Pet.new
      pet.type = @pet_params["type"] if @pet_params.has_key?("type")
      pet.owner_id = @pet_params["owner_id"] 
      pet.in_zone = @pet_params["in_zone"]  if @pet_params.has_key?("in_zone")
      pet.tracker_type = @pet_params["tracker_type"]  if @pet_params.has_key?("tracker_type")
      pet.lost_tracker = @pet_params["lost_tracker"] if pet.type == "Cat"
      pet
    end

    def response(payload, extra_info={}, includes=[])
      options = {}
      options[:meta] = meta.merge(extra_info)
      options[:include] = includes unless includes.empty?
      PetSerializer.new(payload, options).serializable_hash
    end

    def meta
      {
          page: @page,
          pagesize: @pagesize
      }
    end

    def filter(pets)
      case @filter_by_type
      when "Cat"
          pets.cats
      when "Dog"
          pets.dogs
      else
          pets
      end
    end
end