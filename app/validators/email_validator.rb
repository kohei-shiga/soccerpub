class EmailValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    max = 255
    record.errors.add(attribute, :too_long, count: max) if value.length > max

    format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
    record.errors.add(attribute, :invalid) unless format =~ value || value.blank?
    email = value.downcase
    record.errors.add(attribute, :taken) if User.find_by(email: email)
                    
  end
end