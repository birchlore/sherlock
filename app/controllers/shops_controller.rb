class ShopsController < AuthenticatedController

	require './lib/modules/plan'
	include Plan

	def edit
		@shop = current_shop
	end

	def update
		@shop = current_shop

		if @shop.update_attributes(shop_params)
			flash[:success] = "Settings Successfully Saved"
			redirect_to customers_url
		else
			render :edit
		end
	end

	def confirm_update
		@plan = shop_params[:plan]
		redirect_url = current_shop.confirm_plan(@plan)

		if redirect_url == customers_url
			flash[:success] = "Groupie Plan Updated! You are now on the #{@plan} plan."
			redirect_to customers_url
		else
			gon.authorization_url = redirect_url
			render :authorize_payment
		end
		

	end

	def update_plan
		charge = charge = ShopifyAPI::RecurringApplicationCharge.first
		plan = current_shop.update_plan(charge)

		if plan
			NotificationMailer.plan_change(current_shop).deliver_now
			flash[:notice] = "You are now on the #{plan.capitalize} Groupie Plan. Yay!"
	    else
	      	flash[:alert] = "Charge not processed properly, please try again"
	    end

		redirect_to customers_url
	end


  protected

  def shop_params
    params.require(:shop).permit(
      :email_notifications, :wikipedia_notification, :imdb_notification, :twitter_follower_threshold, :instagram_follower_threshold, :klout_score_threshold, :youtube_subscriber_threshold, :plan)
  end

end
