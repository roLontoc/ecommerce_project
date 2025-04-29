class ProvincesController < ApplicationController
  def tax_rates
    province = Province.find(params[:id])

    if province
      render json: {
        success: true,
        gst_rate: province.gst_rate,
        pst_rate: province.pst_rate,
        hst_rate: province.hst_rate
      }
    else
      render json: { success: false }, status: 404
    end
  end
end
