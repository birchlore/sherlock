class CelebritiesController < AuthenticatedController
  
  layout "true" == Figaro.env.shopify_embedded_app ? 'embedded_app' : 'application'

  def index
    @celebrity = current_shop.celebrities.new
    @celebrities = current_shop.active_celebrities.page(params[:page]).per(10)
    @scans_remaining = current_shop.scans_remaining

    if @scans_remaining < 1
      flash[:danger] = "You have no celebrity scans remaining this month. Upgrade your plan in settings."
    end

  end

  def show
  end

  def destroy
    @celebrity = current_shop.celebrities.find(params[:id])
    
    if @celebrity.destroy
      redirect_to celebrities_path
    else
      flash[:now] = "There was an error."
      render :index
    end

  end

  def create
    @celebrity = current_shop.celebrities.create(celebrity_params)
    if @celebrity.persisted?
      render 'create.js.erb'
    else
      flash.now[:info] = "That ain't no celebrity, kid."
      render 'not_a_celebrity.js'
    end
  end

  def archive
    @celebrity = current_shop.celebrities.find(params[:id])
    @celebrity.status = "archived"
    if @celebrity.save
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 404
      flash[:danger] = "There was an error with your archive."
    end
  end

  def unarchive
    @celebrity = current_shop.celebrities.find(params[:id])
    @celebrity.status = "active"
    if @celebrity.save
      redirect_to celebrities_url
    else
      render :index
    end
  end

  def bulk_scan
    num = bulk_scan_params[:quantity]
    scan_existing = bulk_scan_params[:include_scanned].present?

    result = current_shop.bulk_scan(num, scan_existing)
    total_scanned = result[0]
    total_found = result[1]

    flash[:success] = "#{total_scanned} customers scanned and #{total_found} new celebrities found"
  

    redirect_to celebrities_path
  end

  protected

  def celebrity_params
    params.require(:celebrity).permit(
      :first_name, :last_name, :email)
  end

  def bulk_scan_params
    params.permit(
      :include_scanned, :quantity)
  end



end
