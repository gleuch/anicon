class PhotosController < ApplicationController

  before_filter :check_twitter_oauth, :only => [:upload]
  before_filter :get_photo, :only => [:show, :destroy, :download, :upload]

  def index
    @title = 'Resize Your Animated GIF'
    @photos = Photo.active.all(:limit => 14, :order => 'created_at desc') rescue nil unless embed?
    render :index, :layout => which_layout
  end

  def gallery
    @title = 'All Animated GIFs'
    @photos = Photo.active.all(:limit => 500, :order => 'created_at desc') rescue nil
    render :gallery, :layout => which_layout
  end

  def show
    @title = 'Your Photo'
    render :show, :layout => which_layout
  end

  def download
    #render :text => @photo.photo.path(@use_photo_size)
    send_file @photo.photo.path(@use_photo_size) and return
  end

  def upload
    if signed_in?
      client.update_profile_image(File.new(@photo.photo.path(@use_photo_size)))

      @photo.update_attributes(:uploaded => true, :user_id => current_user.id)

      flash[:notice] = {:title => 'Upload success!', :body => "Your avatar was upload. <a href='http://twitter.com/#{session[:screen_name]}' target='_blank'>Check your account &raquo;</a>".html_safe}
      redirect_to "#{photo_path(@photo)}#{embed_params}"
    else
      store_location("#{upload_photo_path(@photo)}#{embed_params}")
      initiate_oauth_connect
    end
  end

  def new
    @title = 'Upload an Animated GIF'
    @photo = Photo.new
    render :new, :layout => which_layout
  end

  def create
    @title = 'Upload an Animated GIF'
    @photo = Photo.new(params[:photo])
    @photo.active = true
    @photo.ip_address = request.remote_addr rescue nil

    if @photo.save
      flash[:notice] = {:title => 'Nice animated avatar! :D', :body => 'Now upload to Twitter or download it for your own purposes.'}
      redirect_to "#{photo_path(@photo)}#{embed_params}" and return
    else
      flash[:error] = 'Photo could not be saved.' unless embed?
      render :new, :layout => which_layout
    end
  end

  def destroy
    # if (params[:d] == 'delete' ? @photo.destroy : @photo.delete)
    #   flash[:notice] = 'Photo deleted!'
    # else
      flash[:error] = 'Could not delete photo.'
    # end

    redirect_to "#{root_path}#{embed_params}" and return
  end


protected

  def check_twitter_oauth
    redirect_back_or(root_path) unless allow_twitter_oauth?
  end

  def get_photo
    @photo = Photo.active.find(params[:id])
    raise ActiveRecord::RecordNotFound if @photo.blank?
  end

end
