class PhotosController < ApplicationController

  before_filter :get_photo, :only => [:show, :destroy, :download]

  def index
    @title = 'Resize Your Animated GIF'
    @photos = Photo.active.all(:limit => 15, :order => 'created_at desc') rescue nil unless embed?
    render :index, :layout => which_layout
  end

  def show
    @title = 'Your Photo'
    render :show, :layout => which_layout
  end

  def download
    send_file @photo.photo.path(:icon) and return
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
      flash[:notice] = 'Photo saved!'
      redirect_to "#{photo_path(@photo)}#{embed_params}" and return
    else
      flash[:error] = 'Photo could not be saved.'
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

  def get_photo
    @photo = Photo.active.find(params[:id])
    raise ActiveRecord::RecordNotFound if @photo.blank?
  end

end
