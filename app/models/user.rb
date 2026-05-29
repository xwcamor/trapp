class User < ActiveRecord::Base
  serialize :customer_id, Array
  # Model relationships
  belongs_to :profile
  belongs_to :country
   
  has_many :meetings
  has_many :user_customers
  mount_uploader :avatar, AvatarUploader

  #audited
  audited except: [:last_signed_in_on, :real_password,:hashed_password,:salt,:authentication_token,:password_reset_token,:password_expires_after,:customer_id]
  has_associated_audits

  attr_accessor :password_confirmation
  attr_accessor :password, :new_password, :new_password_confirmation, :previous_email, :previous_username, :remember_me

  # Method string on action show
  def str_state
    return "Activo" if state == 0
    return "Inactivo" if state == 1
  end

  # Method string on action show
  def str_sex
    return "Masculino" if sex == 0
    return "Femenino" if sex == 1
  end

  def str_complete_name
    self.name.to_s + " " + self.lastname1.to_s + " " + self.lastname2.to_s
  end 

  # Method to load profile
  def self.authentication(user_id,access_id)
    user = self.find_by id: user_id
    begin
      profile = Profile.select("profiles.id").joins(:profile_accesses).where("profiles.id= ? and profile_accesses.access_id = ?", user.profile_id, access_id )
    rescue
    end
    return !profile.blank?
  end

  # Method for login and create authentication
  def self.authenticate(email, password)
    user = User.where('state=0 AND deleted= 0 AND (email = ? or username= ?)',email,email).first
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
         user = nil
      end
    end
    user
  end
  
  # String used on Method for login
  def password
    @password
  end

  # Method to encrypt password
  def password=(pwd)
    @password = pwd
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  private
    # Encrypting password
    def self.encrypted_password(password, salt)
      string_to_hash = password + "tektonlabs" + salt
      Digest::SHA1.hexdigest(string_to_hash)
    end
    # Encrypting password code
    def create_new_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end
