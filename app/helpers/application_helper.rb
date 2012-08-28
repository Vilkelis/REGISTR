# encoding: utf-8
module ApplicationHelper

  #возвращает возраст по дате рождения
  def age(date)
    d = Date.today
    if date.nil? or !date.is_a?(Date)  or  date > d then
       0
    else
      full_years_between date, d
    end
  end

  def imt_calc(weight, height)
    begin
      round2 (try_to_parse_number(weight)/(try_to_parse_number(height) * try_to_parse_number(height)) )
    rescue
      0
    end
  end


  def imt_cond_calc(imt_val,restype)
#16 и менее	Выраженный дефицит массы
#16—18.5	Недостаточная (дефицит) масса тела
#18.5—25	Норма.
#25—30	Избыточная масса тела (предожирение)
#30—35	Ожирение первой степени
#35—40	Ожирение второй степени
#40 и более	Ожирение третьей степени (морбидное)

    if imt_val.nil? or imt_val <= 0 then
      if restype == :short or restype == :full then
       '-'
      else
       -3
      end
    elsif imt_val <= 16 then
      if restype == :short
         'Выр. деф.'
      elsif restype == :full
         'Выраженный дефицит массы тела'
      else
        -2
      end
    elsif  imt_val <=18.5 then
      if restype == :short
       'Деф.'
      elsif restype == :full
       'Недостаточная (дефицит) масса тела'
      else
        -1
      end
    elsif imt_val <= 25 then
      if restype == :short or restype == :full then
       'Норма'
      else
        0
      end
    elsif imt_val <= 30 then
      if restype == :short
       'Избыт.'
      elsif restype == :full
       'Избыточная масса тела (предожирение)'
      else
        1
      end
    elsif imt_val <= 35 then
      if restype == :short
       'I ст.'
      elsif restype == :full
      'Ожирение первой степени'
      else
        2
      end
    elsif  imt_val <=40 then
      if restype == :short
       'II ст.'
      elsif restype == :full
      'Ожирение второй степени'
      else
        3
      end
    else
      if restype == :short
       'III ст.'
      elsif restype == :full
      'Ожирение третьей степени (морбидное)'
      else
        4
      end
    end
  end


  def round2(num)
    n = num.to_f*100
    n =  n.round
    n/100
  end
  #возвращает количество полных лет между датами
  def full_years_between (date_b, date_e)
     y = date_e.year - date_b.year
     d = Date.new(date_e.year, date_b.month, date_b.day)
     if d > date_e then
       y - 1
     else
       y
     end
  end

TRY_DATE_FORMATS = ['%d.%m.%Y']
#Преобразует строку в дату (если это возможно)
def try_to_parse_date(s)
  parsed = nil
  TRY_DATE_FORMATS.each do |format|
    begin
      parsed = Date.strptime(s, format)
      break
    rescue ArgumentError
    end
  end
  return parsed
end

def try_to_parse_number(s)
  s = s.to_s.tr(',:/', '...')
  s.to_f
end

end
