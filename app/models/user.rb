class User < ActiveRecord::Base

  # Constants --------------------------------------------------------------------------------
  # ...


  # Extra additions --------------------------------------------------------------------------
  # ...


  # Associations -----------------------------------------------------------------------------
  has_many :photos


  # Validations ------------------------------------------------------------------------------


  # Scopes -----------------------------------------------------------------------------------
  scope :active,      :conditions => "#{User::table_name}.active=1"


  # Methods ----------------------------------------------------------------------------------

  # Status
  def active?; self.active; end

  # Actions
  def activate!; self.update_attribute(:active, true); end
  def deactivate!; self.update_attribute(:active, false); end


protected


end