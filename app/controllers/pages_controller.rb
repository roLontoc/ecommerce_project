class PagesController < ApplicationController
  def home
  end

  def about
    @about_page = AboutPage.first_or_create
  end

  def contact
    @contact_page = ContactPage.first_or_create
  end
end
