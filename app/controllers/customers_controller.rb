class CustomersController < AuthenticatedController
  
  layout "true" == Figaro.env.shopify_embedded_app ? 'embedded_app' : 'application'

  def index
    @customer = current_shop.customers.new
    @celebrities = current_shop.celebrities.page(params[:page]).per(10)
    @scans_remaining = current_shop.scans_remaining

    if @scans_remaining < 1
      flash[:alert] = "You have no customer scans remaining this month. Upgrade your plan in settings."
    end

  end

  def show
  end

  def destroy
    @celebrity = current_shop.customers.find(params[:id])
    
    if @celebrity.destroy
      redirect_to customers_path
    else
      flash.now[:alert] = "There was an error."
      render :index
    end

  end

  def create
    @customer = current_shop.customers.new(customer_params)
    @customer.scan

    if @customer.celebrity?
      @customer.save
      render 'create.js.erb'
    else
      @customer.save
      flash.now[:notice] = "That ain't no celebrity, kid."
      render 'not_a_celebrity.js'
    end
  end

  def archive
    @customer = current_shop.customers.find(params[:id])
    @customer.archived = true
    if @customer.save
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 404
      flash[:alert] = "There was an error with your archive."
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
    num = bulk_scan_params[:quantity].to_i
    scan_existing = bulk_scan_params[:include_scanned].present?

    Resque.enqueue(BulkScanner, current_shop.id, num, scan_existing)

    flash[:notice] = "Bulk celebrity scan processing. We'll send you an email in approx #{num/2} minutes."
    redirect_to customers_path

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
