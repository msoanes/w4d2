class CatRentalRequestsController < ApplicationController
  def new
    @cats = Cat.all
    @passed_cat_id = params[:catid].to_i
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental_request.save
      flash[:success] = "Rental request submitted"
      redirect_to cat_url(cat_rental_request_params[:cat_id])
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    begin
      transaction_success = @cat_rental_request.approve!
      flash[:success] = "Request approved!" if transaction_success
    rescue StandardError => e
      puts e.message
      flash[:warning] = @cat_rental_request.errors.full_messages
    end

    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    flash[:notice] = "Request denied."
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  private

    def cat_rental_request_params
      params.require(:cat_rental_request)
            .permit(:cat_id, :start_date, :end_date)
    end
end
