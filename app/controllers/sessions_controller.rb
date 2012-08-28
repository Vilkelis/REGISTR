# encoding: utf-8
class SessionsController < ApplicationController
  def new
     respond_to do |format|
       format.js # new.js.erb
     end
  end

  def create
    user = User.authenticate(params[:name],params[:password])

    respond_to do |format|
      if user.nil?
         # Create an error message and re-render the signin form.
         format.json { render json: {:base=>["Неверное имя пользователя или пароль."]}, status: :unprocessable_entity }
      elsif user.blocked?
         format.json { render json: {:base=>["Администратор заблокировал Вам доступ в систему."]}, status: :unprocessable_entity }
      else
          # Sign the user in and redirect to the user's show page.
         sign_in user
         format.json { render json: [:id=>user.id,:name=>user.name,:namefull=>user.namefull,:show_reports=>is_rights_reports_view,:show_admin=>is_rights_admin] , status: :ok, location: user }
      end
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def change_my_password
    respond_to do |format|
      if signed_in?
         format.js
      else
       format.json { render json: {:base=>["Не выполнен вход в систему. Чтобы сменить пароль необходимо выполнить вход."]}, status: :unprocessable_entity }
      end
    end
  end

  def do_change_my_password
     respond_to do |format|
      if signed_in?
         user = current_user
         if user.has_password?(params[:old_password]) then
            if user.update_attributes(:password=>params[:password],
                                      :password_confirmation=>params[:password_confirmation],
                                      :no_change_password=>false)
           #  format.html { redirect_to @user, notice: 'user was successfully created.' }
             format.json { render json: [:id=>user.id] , status: :ok, location: user }
           else
            # format.html { render action: "new" }
             format.json { render json: user.errors, status: :unprocessable_entity }
           end
         else
           format.json{render json: {:base=>["Старый пароль введен не верно."]}, status: :unprocessable_entity }
         end
      else
       format.json { render json: {:base=>["Не выполнен вход в систему. Чтобы сменить пароль необходимо выполнить вход."]}, status: :unprocessable_entity }
      end
    end
  end




end
