# encoding: utf-8
class UsersController < InController

   before_filter :check_rights

  # GET /users
  # GET /users.json
    def index
   #  if users_check_rights then
      filter = ""
      #Параметры быстрой фильтрации грида
      filter = get_qsearch_condition(filter,params[:search])
      #Параметры фильтрации грида
      if not (params[:filter].nil? or params[:filter].empty?) then
        filter = get_string_condition(filter,'name',params[:filter])
        filter = get_string_condition(filter,'namefull',params[:filter])
        filter = get_string_condition(filter,'role',params[:filter])
        filter = get_string_condition(filter,'description',params[:filter])
        filter = get_string_condition(filter,'email',params[:filter])
        filter = get_id_condition(filter,'hospital',params[:filter])
      end

      #Максимальное кол-во строк в гриде
      @maxrows = 100
      if not (params[:maxrows].nil? or params[:maxrows].empty?) then
        @maxrows = params[:maxrows].to_i
      end
      if @maxrows > 100 or @maxrows <= 0 then
        @maxrows = 100
      end

      if  not (params[:sorting].nil? or params[:sorting].empty?) then
        #order
        order = " "
        for i in 0..params[:sorting].count-1 do
          sortval = params[:sorting][i.to_s]
          order += " " + sortval[:dataKey]
          if sortval[:sortDirection] == 'descending'  then
            order += " desc"
          end

          if i != params[:sorting].count-1 then
            order += ","
          end
        end
      else
        order = "name"
      end

      if filter.nil? or filter.empty? then
        @users = User.find(:all, :order=> order, :limit => @maxrows + 1, :offset =>0 )
      else
        @users = User.find(:all,:conditions => filter.to_s, :order=> order, :limit => @maxrows + 1, :offset =>0 )
      end

      if @users.count > @maxrows then
       @pages = 2
      else
       @pages = 1
      end
      @page = 1

      respond_to do |format|
        format.js # index.html.erb
        format.json #{ render json: @users }
        format.xml { render xml: @users }
      end


   # end
  end

  def new
     @user = User.new

     respond_to do |format|
       format.js # new.js.erb
     #  format.json { render json: @user }
     end
   end

   # GET /users/1/edit
   def edit
     @user = User.find(params[:id])
     respond_to do |format|
       format.js # edit.js.erb
     end

   end

   # POST /users
   # POST /users.json
   def create
      @user = User.new(:name=>params[:name],
                       :namefull=>params[:namefull],
                       :description=>params[:description],
                       :email=>params[:email],
                       :password=>params[:password],
                       :password_confirmation=>params[:password_confirmation],
                       :no_change_password=>false ,
                       :role=>params[:role],
                       :hospital_id=>params[:hospital]
                      )

      respond_to do |format|
       if @user.save
       #  format.html { redirect_to @user, notice: 'User was successfully created.' }
         format.json { render json: [:id=>@user.id] , status: :ok, location: @user }
       else
        # format.html { render action: "new" }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end

   end

   # PUT /users/1/change_password
   # PUT /users/1/change_password.json
  def change_password
     @user = User.find(params[:id])
     respond_to do |format|
       if @user.update_attributes(:password=>params[:password],
                                  :password_confirmation=>params[:password_confirmation],
                                  :no_change_password=>false)
       #  format.html { redirect_to @user, notice: 'user was successfully created.' }
         format.json { render json: [:id=>@user.id] , status: :ok, location: @user }
       else
        # format.html { render action: "new" }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
  end


   end

   # PUT /users/1
   # PUT /users/1.json
   def update
     @user = User.find(params[:id])


     respond_to do |format|
       if @user.update_attributes(:name=> params[:name],
                         :namefull=>params[:namefull],
                         :description=>params[:description],
                         :email=>params[:email],
                         :no_change_password=>true,
                         :role=>params[:role],
                         :hospital_id=>params[:hospital]
                         )
      then
       #  format.html { redirect_to @user, notice: 'user was successfully created.' }
         format.json { render json: [:id=>@user.id] , status: :ok, location: @user }
       else
        # format.html { render action: "new" }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end


   end

   # DELETE /users/1
   # DELETE /users/1.json
   def destroy
     @user = User.find(params[:id])
     @user.destroy
     #  @user.errors[:base] << "This person is invalid because ..."
     # @user.errors[:base] << "This person is invalid because 1..."
     # @user.errors[:base] << "This person is invalid because 2..."
     # @user.errors[:base] << "This person is invalid because 3..."

     if @user.errors.size > 0 then
       respond_to do |format|
       #  format.html { redirect_to users_url }
         # format.json { head :no_content }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     else
       respond_to do |format|
         #  format.html { redirect_to users_url }
         # format.json { head :no_content }
         format.json { head :no_content }
       end
     end
   end

    private

    def get_id_condition(filterstr, fieldname, filterparams)
      res = filterstr
      if(!filterparams.nil? && !filterparams[fieldname].nil?)
        value = filterparams[fieldname][:value]
        condition = filterparams[fieldname][:condition]
        if not (value.nil? or value.empty?) then
          value = sanitize_sql_local(value.to_s.mb_chars.upcase.strip)
        end
        if not (fieldname.nil? or fieldname.empty?) and not (condition.nil? or condition.empty?) then
            if condition.to_i == 1 then
               #равно
               if not (value.nil? or value.empty?) then
                 res = append_with_and(filterstr, " "+fieldname+"_id = "+value)
               end
            else
               #не равно
              if not (value.nil? or value.empty?) then
                res = append_with_and(filterstr, " "+fieldname+"_id <> "+value)
              end
            end
        end
      end
      return res
    end

    #строит выражение SQL фильтра для строкового поля
    def get_string_condition(filterstr, fieldname, filterparams)
      res = filterstr
      if(!filterparams.nil? && !filterparams[fieldname].nil?)

        value = filterparams[fieldname][:value]
        condition = filterparams[fieldname][:condition]

        if not (value.nil? or value.empty?) then
          value = sanitize_sql_local(value.to_s.mb_chars.upcase.strip)
        end


        if not (fieldname.nil? or fieldname.empty?) and not (condition.nil? or condition.empty?) then
            if condition.to_i == 1 then
               #содержит
               if not (value.nil? or value.empty?) then
                 res = append_with_and(filterstr, "upper("+fieldname+") like '%"+value+"%'")
               end
            elsif condition.to_i == 2 then
               #не содержит
              if not (value.nil? or value.empty?) then
                res = append_with_and(filterstr, "upper("+fieldname+") not like '%"+value+"%'")
              end
            elsif condition.to_i == 3 then
               #=
              if not (value.nil? or value.empty?) then
                res = append_with_and(filterstr, "upper("+fieldname+") = '%"+value+"%'")
              end
            elsif condition.to_i == 4 then
               #<>
              if not (value.nil? or value.empty?) then
                res = append_with_and(filterstr, "upper("+fieldname+") <> '%"+value+"%'")
              end
            end
        end
      end
      return res
    end

    #возвращает sql условие для быстрого поиска
    def get_qsearch_condition(filterstr, qsearchtext)
      if not (qsearchtext.nil? or qsearchtext.empty?) then
        qsearchtext =  sanitize_sql_local(qsearchtext.to_s.mb_chars.upcase.strip)
      end
      if not (qsearchtext.nil? or qsearchtext.empty?) then
        return append_with_and(filterstr," (upper(name) like '%"+qsearchtext+"%' or upper(namefull) like '%"+qsearchtext+"%' ) ")
      else
        return filterstr
      end
    end

    # склеивает строки с разделителем and
    def append_with_and(str1, str2)
       if not str1.empty? then
         return str1 + ' and '+ str2
       else
         return str2
       end
    end

    def sanitize_sql_local(sql)
      return sql.to_s.gsub('\'','\'\'')
    end

   def check_rights
     if is_rights_admin
       true
     else
       respond_to do |format|
        format.json  { render json: {:base=>["У Вас нет прав для выполнения указанного действия. <br>Обратитесь к администратору."]}, status: :unprocessable_entity }
       end
       false
     end
   end
end
