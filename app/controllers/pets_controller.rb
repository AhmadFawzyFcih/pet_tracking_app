class PetsController < ApplicationController
    before_action :set_pet, only: [:update]
    before_action :authenticate_user!

    def create
        result, status = PetServices::Create.new(pet_params).call
        render json: result, status: status
    end
  
    def update
      result, status = PetServices::Update.new(pet_params, @pet).call
      render json: result, status: status
    end
    
    def index
      result, status = PetServices::Index.new(params).call
      render json: result, status: status
    end
  
    def outside_zone_statistics
      result, status = Rails.cache.fetch('outside_zone_count', expires_in: 5.minutes) do
                          PetServices::PetsOutsideZone.new(params).call
                       end
      render json: result, status: status
    end
  
    private
  
    def pet_params
      params.require(:pet).permit(
        :type, :tracker_type, :owner_id, :in_zone, :lost_tracker
       ).merge(owner_id: current_user&.id)
    end

    def set_pet
      @pet = Pet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Pet not found' }, status: :not_found
    end
  end
  
