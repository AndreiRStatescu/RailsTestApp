class AccountImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, except: [:serve]
  
  def index
    # Show all images associated with this account
    @image_keys = @account.image_key.present? ? [@account.image_key] : []
  end
  
  def upload
    # Just render the form
  end

  def create
    if params[:image].blank?
      redirect_to upload_account_images_path(@account), alert: "Please select an image to upload"
      return
    end
    
    result = ImageStorageService.store_image(@account.id, params[:image])
    
    if result[:success]
      # Update the account with the new image key
      @account.update(image_key: result[:key])
      redirect_to account_images_path(@account), notice: "Image uploaded successfully"
    else
      redirect_to upload_account_images_path(@account), alert: result[:error]
    end
  end

  def destroy
    image_key = params[:id]
    
    if @account.image_key == image_key
      ImageStorageService.delete_image(image_key)
      @account.update(image_key: nil)
      redirect_to account_images_path(@account), notice: "Image deleted successfully"
    else
      redirect_to account_images_path(@account), alert: "Image not found or doesn't belong to this account"
    end
  end
  
  def serve
    image_key = params[:key]
    image_data = ImageStorageService.get_image(image_key)
    
    if image_data
      content_type = ImageStorageService.get_content_type(image_key)
      send_data image_data, type: content_type, disposition: 'inline'
    else
      render plain: "Image not found", status: 404
    end
  end
  
  private
  
  def set_account
    @account = Account.find(params[:account_id])
  end
end
