class PetServices::Update < PetServices::Base
    def call
        success = @pet_object.save
        success ? [response(@pet_object.reload), 200] : [@pet_object.errors, 422]
    end
end