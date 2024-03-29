class CustomersController < AuthenticatedController
  skip_before_action :verify_authenticity_token, :only => :bulk_scan
  layout 'true' == Figaro.env.shopify_embedded_app ? 'embedded_app' : 'application'

  def index
    @shop = current_shop
    @customer = current_shop.customers.new
    @celebrities = current_shop.celebrities.page(params[:page]).per(10)
    @plan = current_shop.plan
    @basic_scans_remaining = current_shop.basic_scans_remaining
    @social_scans_remaining = current_shop.social_scans_remaining
    @free_influencer_scans_remaining = current_shop.free_influencer_scans_remaining
    @bulk_scans_allowed = Plan.bulk_scans_allowed?(@plan)

    if @basic_scans_remaining < 1
      flash[:alert] = 'You have no more customer scans remaining. Upgrade your plan in settings.'
    end
  end

  def show
  end

  def destroy
    @celebrity = current_shop.customers.find(params[:id])

    if @celebrity.destroy
      redirect_to customers_path
    else
      flash.now[:alert] = 'There was an error.'
      render :index
    end
  end

  def create
    if current_shop.basic_scans_remaining > 0
      @customer = current_shop.customers.new(customer_params)
      @customer.scan
      @customer.save

      if @customer.celebrity?
        render 'create.js.erb'
      elsif current_shop.social_scans_remaining < 1
        flash.now[:notice] = 'No Wikipedia or IMDB Match.'
        render 'not_a_celebrity.js'
      else
        flash.now[:notice] = "That ain't no celebrity, kid."
        render 'not_a_celebrity.js'
      end

    else
      flash.now[:notice] = 'You have no scans remaining :('
      render 'not_a_celebrity.js'
    end
  end

  def archive
    @customer = current_shop.customers.find(params[:id])
    @customer.archived = true
    if @customer.save
      render nothing: true, status: 200
    else
      render nothing: true, status: 404
      flash[:alert] = 'There was an error with your archive.'
    end
  end

  def unarchive
    @customer = current_shop.customers.find(params[:id])
    @customer.archived = false
    if @customer.save
      redirect_to customers_url
    else
      render :index
    end
  end

  def bulk_scan
    return unless current_shop.basic_scans_remaining > 0 && Plan.bulk_scans_allowed?(current_shop.plan)

    num = bulk_scan_params[:quantity].to_f
    # scan_existing = bulk_scan_params[:include_scanned].present?
    scan_existing = true
    Resque.enqueue(BulkScanner, current_shop.id, num, scan_existing)

    @time = (num / 6).ceil
    @celebrities = current_shop.customers.where(status: "celebrity")

    respond_to do |format|
      format.js do
        ## polling would go here
        flash.now[:success] = "Bulk influencer scan processing."
        render :bulk_scan
      end
      format.html do
        flash[:notice] = "Bulk influencer scan processing. Refresh to see results."
        redirect_to customers_path
      end
    end
  end

  def celebrity_poll
    respond_to do |format|
      format.js do
        render :celebrity_poll
      end
    end
  end

  protected

  def customer_params
    params.require(:customer).permit(
      :first_name, :last_name, :email)
  end

  def bulk_scan_params
    params.permit(
      :include_scanned, :quantity)
  end
end
