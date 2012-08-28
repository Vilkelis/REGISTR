# encoding: utf-8
class InController < ApplicationController

  before_filter :require_login

   private

  def require_login
    unless signed_in?
    #  flash[:error] = "Вы не авторизованы. Для работы с регистром сведений необходима авторизация."
   #   redirect_to root_path # прерывает цикл запроса
       respond_to do |format|
        format.json  { render json: {:base=>["Вы не авторизованы.<br>Для работы с регистром сведений необходима авторизация."]}, status: :unprocessable_entity }
       end

    end
  end
end