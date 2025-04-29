ActiveAdmin.register Order do
  permit_params :status, :order_total, :order_tax
end
