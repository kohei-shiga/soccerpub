class FriendlyIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    
    count = value.length
    record.errors.add(attribute, :too_long_or_too_short) if count > 20 || count < 3

    format = /\A[\w@-]*[A-Za-z][\w@]*\z/.freeze
    record.errors.add(attribute, :friendly_id_invalid) unless format =~ value 

    users = User.where.not(id: record.id)
    record.errors.add(attribute, :taken) if users.find_by(friendly_id: value)                       
  end 
end
