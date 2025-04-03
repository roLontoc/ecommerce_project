class MerchandiseController < ApplicationController
  def show
    @merchandise = Merchandise.find(params[:id])
  end
end
