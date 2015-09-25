class CustomersController < AuthenticatedController
  
  layout "true" == Figaro.env.shopify_embedded_app ? 'embedded_app' : 'application'

  def new
    @customer = current_shop.customers.new(customer_params)
  end

  protected

  def customer_params
    params.require(:celebrity).permit(
      :first_name, :last_name, :email)
  end



end
