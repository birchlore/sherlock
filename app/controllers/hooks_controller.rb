require 'pry'

class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token, :only=> :customer_created_callback

  def customer_created_callback
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email = params[:email]

    @customer = Customer.new(first_name: @first_name, last_name: @last_name, email: @email)

    if @customer.save
      redirect_to customers_url
    else
      puts "error"
    end

  end

end
