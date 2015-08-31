class CelebritiesController < AuthenticatedController

  def new
    @celebrity = Celebrity.new
  end
  
  def index
    @celebrity = Celebrity.new
    @celebrities = Celebrity.where(status: "active").select { |c| c.celebrity? }.reverse
    @archived_celebrities = Celebrity.where(status: "archived").reverse
  end

  def show
  end

  def destroy
    @celebrity = Celebrity.find(params[:id])
    
    if @celebrity.destroy
      redirect_to celebrities_path
    else
      flash[:now] = "There was an error."
      render :index
    end

  end

  def create
    @celebrity = Celebrity.create(celebrity_params.merge(:shop => current_shop))
    if @celebrity.save
      redirect_to celebrities_path
    else
      flash[:notice] = "Hmmmm... That didn't seem to work: #{@celebrity.errors.full_messages}. Try again?"
      render :new
    end
  end


  def archive
    @celebrity = Celebrity.find(params[:id])
    @celebrity.status = "archived"
    if @celebrity.save
      redirect_to celebrities_url
    else
      render :index
    end
  end

  def unarchive
    @celebrity = Celebrity.find(params[:id])
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
