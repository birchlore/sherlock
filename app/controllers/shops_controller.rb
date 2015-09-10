class ShopsController < AuthenticatedController

	def edit
		@shop = current_shop
	end

	def update
		@shop = current_shop
		if @shop.update_attributes(shop_params)
			flash[:notice] = "Settings Successfully Saved"
			redirect_to celebrities_url
		else
			render :edit
		end
	end


  protected

  def shop_params
    params.require(:shop).permit(
      :email_notifications, :wikipedia_notification, :imdb_notification, :twitter_follower_threshold)
  end

end
