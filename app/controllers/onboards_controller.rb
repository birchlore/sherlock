class OnboardsController < AuthenticatedController
	respond_to :html, :json

	def index
		redirect_to customers_path if current_shop.onboarded
	end

	def scan
		if !current_shop.onboarded
			Resque.enqueue(Onboard, current_shop.id)
			shop.update_attributes :onboard_status => "queued"
			head :ok
		else
			flash[:info] = "You've already used your free scan :("
			redirect_to customers_path
		end
		
	end

	def scan_status
	end


	def result
		# @celebrity = current_shop.celebrities.last
	end

end