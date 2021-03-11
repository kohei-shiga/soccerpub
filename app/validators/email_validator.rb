class EmailValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    
    return if value.nil?
       
    max = 255
    record.errors.add(attribute, :too_long, count: max) if value.length > max

    format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
    record.errors.add(attribute, :invalid) unless format =~ value || value.blank?

    users = User.where.not(id: record.id)
    record.errors.add(attribute, :taken) if users.find_by(email: value)
  end
end