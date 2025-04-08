class MerchandiseController < ApplicationController
  def index
    @merchandise = Merchandise.all
  end

def show
    @merchandise = Merchandise.find(params[:id])
  end
end
