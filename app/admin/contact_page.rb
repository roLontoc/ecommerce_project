ActiveAdmin.register ContactPage do
  permit_params :content

  form do |f|
    f.inputs "Contact Page Content" do
      f.input :content, as: :text, input_html: { rows: 10 }
    end
    f.actions
  end

  actions :index, :edit, :update, :show
  controller do
    def update
      update! do |success, failure|
        success.html { redirect_to admin_contact_page_path(resource) }
        failure.html { render :edit }
      end
    end
  end
end
