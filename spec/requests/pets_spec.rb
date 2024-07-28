require 'rails_helper'

RSpec.describe "Pets API", type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_jwt_token(user) }
  let(:headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
  end

  let!(:pet) { create(:pet, :cat, owner: user) }
  let(:dog) { create(:dog, owner: user) }
  let(:cat) { create(:cat, owner: user) }

  describe '[Index]' do
    it 'returns unauthorized without valid token' do
        get '/pets'
        expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a list of pets' do
      get '/pets', headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response["meta"]["count"]).to eql(Pet.count)
    end

    context "with filter_by_type" do
        it "returns only dogs" do
          get '/pets', params: { filter_by_type: 'Dog' }, headers: headers
          expect(response).to have_http_status(:ok)
          expect(json_response["meta"]["count"]).to eql(Pet.dogs.count)
        end
  
        it "returns only cats" do
          get '/pets', params: { filter_by_type: 'Cat' }, headers: headers
          expect(response).to be_successful
          expect(json_response["meta"]["count"]).to eql(Pet.cats.count)
        end
    end
  end

  describe '[Create]' do
    let(:valid_attributes) do
      {
        pet: {
          type: 'Cat',
          tracker_type: 'small',
          owner_id: user.id,
          in_zone: true,
          lost_tracker: false
        }
      }
    end

    it 'creates a new pet' do
      expect {
        post '/pets', params: valid_attributes, headers: headers, as: :json
      }.to change(Pet, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns unprocessable entity with invalid type' do
      invalid_attributes = { pet: { type: nil } }

      post '/pets', params: invalid_attributes, headers: headers, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response.values.first.first).to include("can't be blank")
    end

    it 'returns unprocessable entity with medium tracker with cats' do
        valid_attributes[:pet][:tracker_type] = 'medium'
        post '/pets', params: valid_attributes, headers: headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response.values.first.first).to include("only have small, big")
    end
  end

  describe '[Update]' do
    let(:new_attributes) do
      {
        pet: {
          in_zone: false
        }
      }
    end

    it 'updates the pet' do
      put "/pets/#{pet.id}", params: new_attributes, headers: headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(pet.reload.in_zone).to eq(false)
    end

    it 'returns not found for invalid pet id' do
      put "/pets/999", params: new_attributes, headers: headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "[outside_zone_statistics]" do
    let!(:dog_outside_zone) { create(:pet, :dog, owner: user, in_zone: false, tracker_type: 'small') }
    let!(:dog2_outside_zone) { create(:pet, :dog, owner: user, in_zone: false, tracker_type: 'small') }
    let!(:cat_outside_zone) { create(:pet, :cat, owner: user, in_zone: false, tracker_type: 'small') }
    let!(:cat2_outside_zone) { create(:pet, :cat, owner: user, in_zone: false, tracker_type: 'big') }

    it "returns the total count of pets outside the power saving zone" do
      get "/pets/outside_zone_statistics", headers: headers
      expect(response).to be_successful
      expect(json_response["total_outside_pet_count"]).to eq(Pet.where(in_zone: false).count)
    end

    it "returns pets outside zone groups" do
        get "/pets/outside_zone_statistics", headers: headers

        expect(json_response["data"]).to include(
            "type" => "Dog", "tracker_type" => "small", "count" => 2
        )
    end  
  end


  private
  def json_response
    JSON.parse(response.body)
  end
end
