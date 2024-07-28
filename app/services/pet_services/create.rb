class PetServices::Create < PetServices::Base
    def call
        success = @pet_object.save
        success ? [response(@pet_object.reload), 201] : [@pet_object.errors, 422]
    end
end