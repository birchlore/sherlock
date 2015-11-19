class OnboardingController < AuthenticatedController
  respond_to :html, :json

  def index
    redirect_to customers_path if current_shop.onboarded
  end

  def scan
    if !current_shop.onboarded
      Resque.enqueue(Onboard, current_shop.id)
      current_shop.update_attributes onboard_status: 'queued'
    else
      flash[:info] = "You've already used your free scan :("
      render js: "window.location = '#{customers_path}'"
    end
  end

  def status
    @shop = current_shop
    render json: @shop
  end

  def result
    @celebrity = current_shop.celebrities.last
  end
end
