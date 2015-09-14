class CelebritiesController < AuthenticatedController
  
  layout "true" == Figaro.env.shopify_embedded_app ? 'embedded_app' : 'application'

  def new
    @celebrity = current_shop.celebrities.new
  end
  
  def index
    # trigger_login
    @celebrity = current_shop.celebrities.new
    @celebrities = current_shop.celebrities.where(status: "active")
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
      flash.now[:notice] = "That ain't no celebrity, kid."
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
      flash[:notice] = "There was an error with your archive."
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



  # helper_method :description
  # helper_method :has_wikipedia?
  # helper_method :has_imdb?
  # helper_method :twitter_followers



  protected

  def celebrity_params
    params.require(:celebrity).permit(
      :first_name, :last_name, :email)
  end



end
