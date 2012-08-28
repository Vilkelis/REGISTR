# encoding: utf-8
class PatientsController < InController


  before_filter :check_rights_view, :only => [:index]
  before_filter :check_rights_edit , :only => [:new,:edit,:update,:create,:destroy]

  #skip_before_filter :check_rights_edit, :only => [:index]

  # GET /Patients
  # GET /Patients.json
  def index

    filter = ""
    #Параметры быстрой фильтрации грида
    filter = get_qsearch_condition(filter,params[:search])
    #Параметры фильтрации грида
    if not (params[:filter].nil? or params[:filter].empty?) then
      filter = get_string_condition(filter,'name_f',params[:filter])
      filter = get_string_condition(filter,'name_i',params[:filter])
      filter = get_string_condition(filter,'name_o',params[:filter])
      filter = get_string_condition(filter,'address',params[:filter])
      filter = get_string_condition(filter,'work_place',params[:filter])
      filter = get_string_condition(filter,'work_position',params[:filter])
      filter = get_string_condition(filter,'description',params[:filter])
      filter = get_integer_condition(filter,'sex',params[:filter])
      filter = get_date_condition(filter,'birth_date',params[:filter])
      filter = get_age_condition(filter,'age','birth_date',params[:filter])
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
        if sortval[:dataKey] == "age" then
          order += " birth_date"
        else
          order += " " + sortval[:dataKey]
        end
        if sortval[:sortDirection] == 'descending'  then
          order += " desc"
        end

        if i != params[:sorting].count-1 then
          order += ","
        end
      end
    else
      order = "name_f"
    end
    order = sanitize_sql_local(order)

    if filter.nil? or filter.empty? then
      @patients = Patient.find(:all, :order=> order, :limit => @maxrows + 1, :offset =>0 )
    else
      @patients = Patient.find(:all,:conditions => filter.to_s, :order=> order, :limit => @maxrows + 1, :offset =>0 )
    end

    if @patients.count > @maxrows then
     @pages = 2
    else
     @pages = 1
    end
    @page = 1

    @can_edit = is_rights_patients_edit

    respond_to do |format|
      format.js # index.html.erb
      format.json #{ render json: @patients }
      format.xml { render xml: @patients }
    end
  end

  def new
     @patient = Patient.new

     respond_to do |format|
       format.js # new.js.erb
     #  format.json { render json: @patient }
     end
   end

   # GET /Patients/1/edit
   def edit
     @patient = Patient.find(params[:id])
     respond_to do |format|
       format.js # edit.js.erb
     end

   end

   # POST /Patients
   # POST /Patients.json
   def create
      imt = imt_calc(params[:weight],params[:height])
      imt_cond = imt_cond_calc(imt,:num)
      @patient = Patient.new(:name_f=>params[:name_f],
                             :name_i=>params[:name_i],
                             :name_o=>params[:name_o],
                             :sex=>params[:sex],
                             :birth_date=>params[:birth_date],
                             :address=>params[:address],
                             :work_place=>params[:work_place],
                             :work_position=>params[:work_position],
                             :description=>params[:description],

                             :before_invalid=>params[:before_invalid], #Инвалидность до операции - степень
                             :before_invalid_descr=>params[:before_invalid_descr], #Инвалидность до операции - причина

                             :weight=>params[:weight], #Вес
                             :height=>params[:height], #Рост
                             :imt=>imt, #ИМТ
                             :imt_cond=>imt_cond, #Степень ожирения
                             :is_nasled=>params[:is_nasled], # 'Наследственность'
                             :is_smoke=>params[:is_smoke], # 'Курение'
                             :is_art_giper=>params[:is_art_giper], #    'Артериальная гипертония'
                             :is_sahar_diabet=>params[:is_sahar_diabet], # 'Сахарный диабет'
                             :glukoza=>params[:glukoza], # 'Глюкоза крови, ммоль/л'
                             :oh_before=>params[:oh_before], #   'ОХ до операции,ммоль/л'
                             :oh_in_hospital=>params[:oh_in_hospital], #  'ОХ в отделении, ммоль/л', data
                             # 'Клиническая характеристика',

                             :stenokard=>params[:stenokard],   #'Стенокардия, функц.класс' :decimal
                             :is_anevrizm=>params[:is_anevrizm], # 'Аневризм ЛЖ' :integer
                             :onmk_year=>params[:onmk_year], 		#  'ОНМК, год' :integer
                             :pik_year=>params[:pik_year], 			# 'ПИК, год' :integer
                             :xch=>params[:xch], 			  # 'ХСН по NYHA' :string
                             :xch_class=>params[:xch_class], 		# 'ХСН функц.класс' :integer

                             # 'Ангиографическая характеристика',
                             #       'Поражение кор.русла',
                             :sosud_qty=>params[:sosud_qty],     # 'Кол-во пораж. сосудов' :integer
                             :is_sosud_75=>params[:is_sosud_75], 		# '75 и окклюзия' :integer

                             #        'Фракция выброса ЛЖ',
                             :fb_before=>params[:fb_before], #  'ФВ до операции' :integer
                             :fb_after=>params[:fb_after], #  'ФВ п/операции':integer

                             #        'Левое предсердие',
                             :lp_before=>params[:lp_before], # 'ЛП до операции' :integer
                             :lp_after=>params[:lp_after], # 'ЛП п/операции' :integer

                             #    'Сведения об операции'
                             :oper_date=>params[:oper_date],			#  'Дата операции' :date
                             :oper_type=>params[:oper_type],		#  'Тип операции' ,:string
                             :oper_result=>params[:oper_result],	#  'Исход операции',:string

                             # 'РЕАБИЛИТАЦИЯ',
                             :is_napravlen=>params[:is_napravlen],     #  'Направлен ',:integer
                             :hospital_id=>params[:hospital_id],      #  'ЛПУ' ,:integer

                             #           'АМБУЛАТОРНЫЙ ЭТАП',
                             :fate=>params[:fate],         # 'Судьба в отдаленном периоде',:string
                             :death_year=>params[:death_year], # 'Год смерти',:integer

                            :after_invalid=>params[:after_invalid], #Инвалидность после операции - степень
                            :after_invalid_descr=>params[:after_invalid_descr] #Инвалидность после операции - причина

                             )

      respond_to do |format|
       if @patient.save
       #  format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
         format.json { render json: [:id=>@patient.id] , status: :ok, location: @patient }
       else
        # format.html { render action: "new" }
         format.json { render json: @patient.errors, status: :unprocessable_entity }
       end
     end

   end



   # PUT /Patients/1
   # PUT /Patients/1.json
   def update
     @patient = Patient.find(params[:id])

     imt = imt_calc(params[:weight],params[:height])
     imt_cond = imt_cond_calc(imt,:num)

     respond_to do |format|
       if @patient.update_attributes(
                             :name_f=>params[:name_f],
                             :name_i=>params[:name_i],
                             :name_o=>params[:name_o],
                             :sex=>params[:sex],
                             :birth_date=>params[:birth_date],
                             :address=>params[:address],
                             :work_place=>params[:work_place],
                             :work_position=>params[:work_position],
                             :description=>params[:description],

                             :address=>params[:address],
                             :work_place=>params[:work_place],
                             :work_position=>params[:work_position],
                             :description=>params[:description],

                             :before_invalid=>params[:before_invalid], #Инвалидность до операции - степень
                             :before_invalid_descr=>params[:before_invalid_descr], #Инвалидность до операции - причина

                             :weight=>params[:weight], #Вес
                             :height=>params[:height], #Рост
                             :imt=>imt, #ИМТ
                             :imt_cond=>imt_cond, #Степень ожирения
                             :is_nasled=>params[:is_nasled], # 'Наследственность'
                             :is_smoke=>params[:is_smoke], # 'Курение'
                             :is_art_giper=>params[:is_art_giper], #    'Артериальная гипертония'
                             :is_sahar_diabet=>params[:is_sahar_diabet], # 'Сахарный диабет'
                             :glukoza=>params[:glukoza], # 'Глюкоза крови, ммоль/л'
                             :oh_before=>params[:oh_before], #   'ОХ до операции,ммоль/л'
                             :oh_in_hospital=>params[:oh_in_hospital], #  'ОХ в отделении, ммоль/л', data
                             # 'Клиническая характеристика',

                             :stenokard=>params[:stenokard],   #'Стенокардия, функц.класс' :decimal
                             :is_anevrizm=>params[:is_anevrizm], # 'Аневризм ЛЖ' :integer
                             :onmk_year=>params[:onmk_year], 		#  'ОНМК, год' :integer
                             :pik_year=>params[:pik_year], 			# 'ПИК, год' :integer
                             :xch=>params[:xch], 			  # 'ХСН по NYHA' :string
                             :xch_class=>params[:xch_class], 		# 'ХСН функц.класс' :integer

                             # 'Ангиографическая характеристика',
                             #       'Поражение кор.русла',
                             :sosud_qty=>params[:sosud_qty],     # 'Кол-во пораж. сосудов' :integer
                             :is_sosud_75=>params[:is_sosud_75], 		# '75 и окклюзия' :integer

                             #        'Фракция выброса ЛЖ',
                             :fb_before=>params[:fb_before], #  'ФВ до операции' :integer
                             :fb_after=>params[:fb_after], #  'ФВ п/операции':integer

                             #        'Левое предсердие',
                             :lp_before=>params[:lp_before], # 'ЛП до операции' :integer
                             :lp_after=>params[:lp_after], # 'ЛП п/операции' :integer

                             #    'Сведения об операции'
                             :oper_date=>params[:oper_date],			#  'Дата операции' :date
                             :oper_type=>params[:oper_type],		#  'Тип операции' ,:string
                             :oper_result=>params[:oper_result],	#  'Исход операции',:string

                             # 'РЕАБИЛИТАЦИЯ',
                             :is_napravlen=>params[:is_napravlen],     #  'Направлен ',:integer
                             :hospital_id=>params[:hospital_id],      #  'ЛПУ' ,:integer

                             #           'АМБУЛАТОРНЫЙ ЭТАП',
                             :fate=>params[:fate],         # 'Судьба в отдаленном периоде',:string
                             :death_year=>params[:death_year], # 'Год смерти',:integer

                             :after_invalid=>params[:after_invalid], #Инвалидность после операции - степень
                             :after_invalid_descr=>params[:after_invalid_descr] #Инвалидность после операции - причина

                              )
       #  format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
         format.json { render json: [:id=>@patient.id] , status: :ok, location: @patient }
       else
        # format.html { render action: "new" }
         format.json { render json: @patient.errors, status: :unprocessable_entity }
       end
     end


   end

   # DELETE /Patients/1
   # DELETE /Patients/1.json
   def destroy
     @patient = Patient.find(params[:id])
     @patient.destroy

     if @patient.errors.size > 0 then
       respond_to do |format|
       #  format.html { redirect_to Patients_url }
         # format.json { head :no_content }
         format.json { render json: @patient.errors, status: :unprocessable_entity }
       end
     else
       respond_to do |format|
         #  format.html { redirect_to Patients_url }
         # format.json { head :no_content }
         format.json { head :no_content }
       end
     end
   end



    private

    def get_date_condition(filterstr, fieldname, filterparams)

      value = filterparams[fieldname][:value]
      value_end = filterparams[fieldname][:value_end]
      condition = filterparams[fieldname][:condition]

      if not (value.nil? or value.empty?) then
        value = sanitize_sql_local(value.to_s.mb_chars.upcase.strip)
      end

      if not (value_end.nil? or value_end.empty?) then
        value_end = sanitize_sql_local(value_end.to_s.mb_chars.upcase.strip)
      end

      res = filterstr
      if not (fieldname.nil? or fieldname.empty?) and not (condition.nil? or condition.empty?) then
          if condition.to_i == 1 then
             # в интервале
             if not (value.nil? or value.empty?) then
              filterstr = append_with_and(filterstr, " "+fieldname+" >= to_date('"+value+"','dd.mm.yyyy') ")
             end

             if not (value_end.nil? or value_end.empty?) then
               filterstr = append_with_and(filterstr, " "+fieldname+" <= to_date('"+value_end+"','dd.mm.yyyy') ")
             end
          end
      end
      res = filterstr
      return res
    end


  def get_age_condition(filterstr,paramname, field_of_date, filterparams)
      value = filterparams[paramname][:value]
      value_end = filterparams[paramname][:value_end]
      condition = filterparams[paramname][:condition]

      if not (value.nil? or value.empty?) then
        value = sanitize_sql_local(value.to_s.mb_chars.upcase.strip)
      end

      if not (value_end.nil? or value_end.empty?) then
        value_end = sanitize_sql_local(value_end.to_s.mb_chars.upcase.strip)
      end

      res = filterstr
      if not (field_of_date.nil? or field_of_date.empty?) and not (condition.nil? or condition.empty?) then
          if condition.to_i == 1 then
             # в интервале
             if not (value.nil? or value.empty?) then
               filterstr = append_with_and(filterstr, " "+field_of_date+" <= date_trunc('day',now()-interval '"+value+" year') ") #конца года
             end

             if not (value_end.nil? or value_end.empty?) then
               filterstr = append_with_and(filterstr, " "+field_of_date+" >= date_trunc('year',now()-interval '"+value_end+" year') ") #начала года
             end
          end
      end
      res = filterstr
      return res
  end


    def get_integer_condition(filterstr,fieldname, filterparams)
      value = filterparams[fieldname][:value]
      condition = filterparams[fieldname][:condition]

      if not (value.nil? or value.empty?) then
        value = sanitize_sql_local(value.to_s.mb_chars.upcase.strip)
      end

      res = filterstr
      if not (fieldname.nil? or fieldname.empty?) and not (condition.nil? or condition.empty?) then
          if condition.to_i == 1 then
             # =
             if not (value.nil? or value.empty?) then
               res = append_with_and(filterstr, " "+fieldname+" = "+value)
             end
          elsif condition.to_i == 2 then
            if not (value.nil? or value.empty?) then
              res = append_with_and(filterstr, " "+fieldname+" <> "+value)
            end
          elsif condition.to_i == 3 then
            if not (value.nil? or value.empty?) then
              res = append_with_and(filterstr, " "+fieldname+" > "+value)
            end
          elsif condition.to_i == 4 then
            if not (value.nil? or value.empty?) then
              res = append_with_and(filterstr, " "+fieldname+" >= "+value)
            end
          elsif condition.to_i == 5 then
            if not (value.nil? or value.empty?) then
              res = append_with_and(filterstr, " "+fieldname+" < "+value)
            end
          elsif condition.to_i == 6 then
            if not (value.nil? or value.empty?) then
              res = append_with_and(filterstr, " "+fieldname+" <= "+value)
            end
          end
      end
      return res
    end

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
        return append_with_and(filterstr," (upper(name_F) like '%"+qsearchtext+"%' or upper(name_I) like '%"+qsearchtext+"%'  or upper(name_O) like '%"+qsearchtext+"%' ) ")
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



   def check_rights_view
      if is_rights_patients_view
       true
     else
       respond_to do |format|
        format.json  { render json: {:base=>["У Вас нет прав для выполнения указанного действия. <br>Обратитесь к администратору."]}, status: :unprocessable_entity }
       end
       false
      end
   end

  def check_rights_edit
    if is_rights_patients_edit
     true
   else
     respond_to do |format|
      format.json  { render json: {:base=>["У Вас нет прав для выполнения указанного действия. <br>Обратитесь к администратору."]}, status: :unprocessable_entity }
     end
     false
    end
  end

end
