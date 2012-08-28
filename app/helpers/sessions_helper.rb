# encoding: utf-8
module SessionsHelper

  NO_ROLE = 'Не авторизован'


  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user_role
    user = current_user
    if  !user.nil? then
      res = user.role;
    else
      res = NO_ROLE
    end
    return res
  end


  #Права пользователя
  def is_rights_patients_view
     [User::ROLE_EDITOR ,User::ROLE_EDITOR_ANALYTIC,User::ROLE_ANALYTIC,User::ROLE_ADMIN].include?(current_user_role)
  end

  def is_rights_patients_edit
     [User::ROLE_EDITOR ,User::ROLE_EDITOR_ANALYTIC,User::ROLE_ADMIN].include?(current_user_role)
  end

  def is_rights_reports_view
    [User::ROLE_ANALYTIC,User::ROLE_EDITOR_ANALYTIC,User::ROLE_ADMIN].include?(current_user_role)
  end

  def is_rights_admin
    [User::ROLE_ADMIN].include?(current_user_role)
  end

private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
