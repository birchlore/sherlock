class ShopsController < AuthenticatedController

	require './lib/modules/plan'
	include Plan

	def edit
		@shop = current_shop
	end

	def update
		@shop = current_shop

		if @shop.update_attributes(shop_params)
			flash[:info] = "Settings Successfully Saved"
			redirect_to celebrities_url
		else
			render :edit
		end
	end

	def confirm_update
		@plan = shop_params[:plan]

		if @plan != current_shop.plan

			if @plan == "free"
				if charge = current_shop.charge_id
					recurring = ShopifyAPI::RecurringApplicationCharge.find(charge)
					recurring.destroy
					current_shop.charge_id = nil
				end

				current_shop.plan = "free"
				current_shop.save
				flash[:info] = "Successfully downgraded to Free Groupie Plan"
				redirect_to celebrities_url
			else
				price = Plan.cost(@plan)
				name = @plan + " Groupie Plan"
				response = ShopifyAPI::RecurringApplicationCharge.create({
															:name => name, 
															:price => price, 
															:return_url => update_plan_url, 
															:test=> !Rails.env.production? 
															})
				redirect_to response.confirmation_url
			end

		else
			redirect_to celebrities_url
		end

	end

	def update_plan
		charge = charge = ShopifyAPI::RecurringApplicationCharge.first
		plan = charge.name.split.first

		if charge.status == "accepted"
			charge.activate
			current_shop.plan = plan
			current_shop.charge_id = charge.id
			current_shop.save
			flash[:success] = "Update complete! You are now on the #{plan.capitalize} Groupie Plan. Yay!"
		else
			flash[:danger] = "Charge not processed properly, please try again"
		end
		
		redirect_to celebrities_url

	end


  protected

  def shop_params
    params.require(:shop).permit(
      :email_notifications, :wikipedia_notification, :imdb_notification, :twitter_follower_threshold, :instagram_follower_threshold, :klout_score_threshold, :youtube_subscriber_threshold, :plan)
  end

end
