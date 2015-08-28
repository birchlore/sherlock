require 'pry'

class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token, :only=> :celebrity_created_callback

  def celebrity_created_callback
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email = params[:email]

    @celebrity = Celebrity.new(first_name: @first_name, last_name: @last_name, email: @email)

    if @celebrity.save
      redirect_to celebrities_url
    else
      puts "error"
    end

  end

end
