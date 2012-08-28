# encoding: utf-8
class ReportsController < InController
 before_filter :check_rights_view

 def index

      respond_to do |format|
        format.js # index.html.erb
      end

 end

 private

   def check_rights_view
      if is_rights_reports_view
       true
     else
       respond_to do |format|
        format.json  { render json: {:base=>["У Вас нет прав для выполнения указанного действия. <br>Обратитесь к администратору."]}, status: :unprocessable_entity }
       end
       false
      end
   end

end