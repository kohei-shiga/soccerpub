class ImageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank?

    file_type = value.content_type
    file_types = %w[image/jpg image/jpeg image/png image/gif]
    record.errors.add(attribute, :type_error) unless file_types.include?(file_type)
    record.errors.add(attribute, :size_error) unless value.attachment.byte_size < 5.megabytes
  end
end