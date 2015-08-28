class HomeController < AuthenticatedController
  layout 'embedded_app'
  
  def index
    @celebrities = Celebrity.all

    if @celebrities.count < 1
      redirect_to new_celebrity_path
    else
      redirect_to celebrities_path
    end
  end

end
