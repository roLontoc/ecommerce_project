class CreateProvinces < ActiveRecord::Migration[8.0]
  def change
    create_table :provinces do |t|
      t.string :name
      t.decimal :pst_rate
      t.decimal :gst_rate
      t.decimal :hst_rate

      t.timestamps
    end
    Province.create(code: "AB", name: "Alberta", pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0)
    Province.create(code: "BC", name: "British Columbia", pst_rate: 0.07, gst_rate: 0.05, hst_rate: 0.0)
    Province.create(code: "MB", name: "Manitoba", pst_rate: 0.07, gst_rate: 0.05, hst_rate: 0.0)
    Province.create(code: "NB", name: "New Brunswick", hst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15)
    Province.create(code: "NL", name: "Newfoundland and Labrador", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15)
    Province.create(code: "NS", name: "Nova Scotia", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15)
    Province.create(code: "ON", name: "Ontario", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.13)
    Province.create(code: "PE", name: "Prince Edward Island", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15)
    Province.create(code: "QC", name: "Quebec", pst_rate: 0.09975, gst_rate: 0.05, hst_rate: 0.0)
    Province.create(code: "SK", name: "Saskatchewan", pst_rate: 0.06, gst_rate: 0.05, hst_rate: 0.0)
    Province.create(code: "NT", name: "Northwest Territories", pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0)
    Province.create(code: "NU", name: "Nunavut", pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0)
    Province.create(code: "YT", name: "Yukon", pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0)
  end
end
