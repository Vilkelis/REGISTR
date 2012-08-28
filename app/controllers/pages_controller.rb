# encoding: utf-8
class PagesController < ApplicationController
  def home
    respond_to do |format|
      format.js # index.html.erb
      format.html
    end
  end

  def contacts
  end

  def about
  end

 #Возвращает возраст человека (полных лет) по указанной дате рождения
 def age_from_date
  respond_to do |format|
    if not (params[:birth_date].nil? or params[:birth_date].empty?) then
        #еще нужно проверить на корректность даты...
         format.json { render json: [:age=>age(try_to_parse_date(params[:birth_date])).to_s] , status: :ok }

    else
      format.json { render json: [:age=>"0"] , status: :ok }
    end
  end
 end

#Возвращает ИМТ и Степень ожирения по весу и росту
 def imt

  respond_to do |format|
    if not (params[:weight].nil? or params[:height].empty?) then
        #еще нужно проверить на корректность даты...
         imt_val =  imt_calc(params[:weight],params[:height])
         imt_cond_val = imt_cond_calc(imt_val,:full)
         format.json { render json: [:imt=>imt_val,:imt_cond=>imt_cond_val] , status: :ok }

    else
      format.json { render json: [:age=>"0"] , status: :ok }
    end
  end
 end
end
