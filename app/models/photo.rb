class Photo < ActiveRecord::Base

  # Constants --------------------------------------------------------------------------------
  ALLOWED_IMAGE_CONTENT_TYPES = ['image/gif']


  # Extra additions --------------------------------------------------------------------------
  has_attached_file :photo, :styles => { :icon => '48x48#' }


  # Associations -----------------------------------------------------------------------------
  # ...


  # Validations ------------------------------------------------------------------------------
  validates_attachment_presence :photo, :message => ': You must upload a photo.'
  validates_attachment_content_type :photo, :content_type => ALLOWED_IMAGE_CONTENT_TYPES, :message => ': It must be an animated GIF!', :if => lambda { |e| !e.photo_file_name.blank? }
  validates_attachment_size :photo, :less_than => 1.megabytes, :message => ': Your photo must be less than 1 megabyte (MB).', :if => lambda { |e| !e.photo_file_name.blank? }


  # Scopes -----------------------------------------------------------------------------------
  scope :active,      :conditions => "#{Photo::table_name}.active=1"


  # Methods ----------------------------------------------------------------------------------

  # Status
  def active?; self.active; end

  # Actions
  def activate!; self.update_attribute(:active, true); end
  def deactivate!; self.update_attribute(:active, false); end


protected


end