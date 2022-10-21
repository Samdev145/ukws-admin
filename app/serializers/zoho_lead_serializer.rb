# frozen_string_literal: true

class ZohoLeadSerializerSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(argument)
    argument.is_a?(Zoho::Lead)
  end

  def serialize(lead)
    record_attributes = Zoho::Lead::ATTRIBUTES.each_with_object({}) do |attr, hash|
      hash[attr] = lead.send(attr.downcase)
    end

    super(record_attributes)
  end

  def deserialize(hash)
    Zoho::Lead.new(hash)
  end
end
