class PetSerializer
  include JSONAPI::Serializer
  attributes :id, :type, :owner_id, :in_zone, :tracker_type, :created_at, :updated_at

  attribute :lost_tracker, if: Proc.new { |object| object.type == "Cat" } do |object|
    object.lost_tracker
  end
end
