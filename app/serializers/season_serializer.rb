class SeasonSerializer
  include JSONAPI::Serializer
  attributes :start_month, :end_month, :note

  belongs_to :vegetable
end
