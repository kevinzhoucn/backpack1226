class User
  include Mongoid::Document
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :encryptable, :encryptor => :md5

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :devices_key, type: String
  field :app_token, type: String

  after_create :assign_user_key

  has_many :devices

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  
  def get_device_key
    if devices_key.nil? or devices_key.length != 16
      assign_user_key
    else
      devices_key
    end
  end

  def valid_password?(password)
    return false if encrypted_password.blank?
    # Devise.secure_compare(Devise::Encryptable::Encryptors::Md5.digest(password, nil, nil, nil), self.encrypted_password)
    Devise.secure_compare(Devise::Encryptable::Encryptors::Md5.digest(password, nil, PASSWORD_SALT, nil), self.encrypted_password)
    # return Devise::Encryptable::Encryptors::Md5.digest(password, nil, nil, nil)
  end

  def password_salt
    PASSWORD_SALT
  end

  def password_salt=(new_salt)
  end

  protected
    def assign_user_key
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(16) { |i| newpass << chars[rand(chars.size-1)] }
      self.update_attributes(devices_key: newpass)
      newpass
    end
end
