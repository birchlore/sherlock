class OnboardsController < AuthenticatedController

	def index
		redirect_to customers_path if current_shop.onboarded
	end

	def scan
		if !current_shop.onboarded
			@celebrity = current_shop.onboard_scan
			current_shop.onboarded = true
			current_shop.save
			redirect_to onboard_result_path
		else
			flash[:info] = "You've already used your free scan :("
			redirect_to customers_path
		end
		
	end


	def result
		@celebrity = current_shop.celebrities.last
	end

end
