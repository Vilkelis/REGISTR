# encoding: utf-8
class HospitalsController < InController
  # GET /hospitals
  # GET /hospitals.json
  before_filter :check_rights

  def index

    filter = ""
    #Параметры быстрой фильтрации грида
    filter = get_qsearch_condition(filter,params[:search])
    #Параметры фильтрации грида
    if not (params[:filter].nil? or params[:filter].empty?) then
      filter = get_string_condition(filter,'name',params[:filter])
      filter = get_string_condition(filter,'namefull',params[:filter])
      filter = get_string_condition(filter,'description',params[:filter])
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


    #Страницы
  #  if not (params[:paging].nil? or params[:paging].empty?)
  #    @rows = params[:paging][:pageSize]
  #    @page = params[:paging][:pageIndex]
  #  else
  #    @rows = 10
  #    @page = 1
  #  end
    #Мы предполагаем, что Padding показывает кнопки для 5 страниц.
    #поэтому нам нужно подсчитать кол-во строк исходя из полученных данных + 5 страниц.
    #можно действовать следующим образом: выбрать данные на 5 страниц а вернуть только первую
    #либо вторым запросом выбрать кол-во строк в 5ти следующих страницах
    #второй способ будет экономичнее, так как объекты не будут выбираться на каждую запись...

  #  offset = @rows.to_f*(@page.to_f)
    if filter.nil? or filter.empty? then
      if !params[:limit].nil? && params[:limit] == "no" then
        @hospitals = Hospital.find(:all, :order=> order, :offset =>0 )
      else
        @hospitals = Hospital.find(:all, :order=> order, :limit => @maxrows + 1, :offset =>0 )
      end
    else
      @hospitals = Hospital.find(:all,:conditions => filter.to_s, :order=> order, :limit => @maxrows + 1, :offset =>0 )
    end

    if @hospitals.count > @maxrows then
     @pages = 2
    else
     @pages = 1
    end
    @page = 1
  #  @rowcount = Hospital.count
  #  @pages =  (@rowcount/@rows.to_f).ceil


    respond_to do |format|
      format.js # index.html.erb
      format.json #{ render json: @hospitals }
      format.xml { render xml: @hospitals }
    end
  end

  # GET /hospitals/1
  # GET /hospitals/1.json
  def show
    @hospital = Hospital.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hospital }
    end
  end

  # GET /hospitals/new
  # GET /hospitals/new.json
  def new
    @hospital = Hospital.new

    respond_to do |format|
      format.js # new.js.erb
    #  format.json { render json: @hospital }
    end
  end

  # GET /hospitals/1/edit
  def edit
    @hospital = Hospital.find(params[:id])
    respond_to do |format|
      format.js # edit.js.erb
    end

  end

  # POST /hospitals
  # POST /hospitals.json
  def create
   # if params[:oper]=="del"
   #     @hospital = Hospital.find(params[:id])
   #     @hospital.destroy
   # elsif params[:oper]=="edit"
   #   @hospital = Hospital.find(params[:id])
   #   @hospital.name = params[:name]
   #   @hospital.namefull = params[:namefull]
   #   @hospital.description = params[:description]
   #   @hospital.save
   # else
      @hospital = Hospital.new(:name=>params[:name],:namefull=>params[:namefull],:description=>params[:description])
   # end

     respond_to do |format|
      if @hospital.save
      #  format.html { redirect_to @hospital, notice: 'Hospital was successfully created.' }
        format.json { render json: [:id=>@hospital.id] , status: :ok, location: @hospital }
      else
       # format.html { render action: "new" }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end

  end



  # PUT /hospitals/1
  # PUT /hospitals/1.json
  def update
    @hospital = Hospital.find(params[:id])


    respond_to do |format|
      if @hospital.update_attributes(:name=>params[:name],:namefull=>params[:namefull],:description=>params[:description])
      #  format.html { redirect_to @hospital, notice: 'Hospital was successfully created.' }
        format.json { render json: [:id=>@hospital.id] , status: :ok, location: @hospital }
      else
       # format.html { render action: "new" }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end

  #  respond_to do |format|
  #    if @hospital.update_attributes(params[:hospital])
  #      format.html { redirect_to @hospital, notice: 'Hospital was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @hospital.errors, status: :unprocessable_entity }
  #    end
  #   end

  end

  # DELETE /hospitals/1
  # DELETE /hospitals/1.json
  def destroy
    @hospital = Hospital.find(params[:id])
    @hospital.destroy
    #  @hospital.errors[:base] << "This person is invalid because ..."
    # @hospital.errors[:base] << "This person is invalid because 1..."
    # @hospital.errors[:base] << "This person is invalid because 2..."
    # @hospital.errors[:base] << "This person is invalid because 3..."

    if @hospital.errors.size > 0 then
      respond_to do |format|
      #  format.html { redirect_to hospitals_url }
        # format.json { head :no_content }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        #  format.html { redirect_to hospitals_url }
        # format.json { head :no_content }
        format.json { head :no_content }
      end
    end
  end

  private

  #строит выражение SQL фильтра для строкового поля
  def get_string_condition(filterstr, fieldname, filterparams)

    value = filterparams[fieldname][:value]
    condition = filterparams[fieldname][:condition]

    if not (value.nil? or value.empty?) then
      value = sanitize_sql_local(value.to_s.mb_chars.upcase.strip)
    end

    res = filterstr
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
     if current_user_role == User::ROLE_ADMIN
       true
     else
       respond_to do |format|
        format.json  { render json: {:base=>["У Вас нет прав для выполнения указанного действия. <br>Обратитесь к администратору."]}, status: :unprocessable_entity }
       end
       false
     end
  end
end
