// Инициализация  всплывающих подсказок
function initToolTips()
{
    var obj = $('.pagedata');
    if(obj != undefined)
    {
        $('.pagedata').tooltip({
          selector: "a[rel=tooltip]"
        });
    }
}


//Разбор сообщений об ошибках при AJAX запросах (сообщения возвращаются в виде JSON
function parseErrAndShow(jqXHR, textStatus, errorThrown, doOnClose)
{  //textStatus может быть: ("success", "notmodified", "error", "timeout", "abort", or "parsererror")
  if(textStatus == "timeout")
  {
     AlertErr('Сервер слишком долго не отвечает.',undefined, doOnClose);
  }
  else {
  if(textStatus == "parsererror")
  {
     mes = 'Внутренняя ошибка сервера';
  }
  else
  {

     // alert(jqXHR.responseText+ '    ' + textStatus + '   ' + jqXHR);
    //Разбор сообщения об ошибке
      var mes = "";
      if(jqXHR.statusText == 'OK')
      {
        var resp = jQuery.parseJSON(jqXHR.responseText); //jqXHR.responseText - должен быть JSON
        var ar;
        var i;
        var j = 0;
        for (var key in resp) {
          ar = resp[key];
          for(i=0; i<ar.length; i++) {
            if(j != 0 ) { mes = mes + "<br>"}
            j++;
            mes = mes + ar[i];
          }
        }
      }
      else
      {
        mes = 'Внутренняя ошибка сервера: ' + jqXHR.statusText + ' ( ' + jqXHR.status +' ).';
      }
  }
  //  if(i>1)
//    {
  //    AlertErr(mes,'При выполнении операции произошли ошибки:');
  //  }
   // else {
      AlertErr(mes,undefined, doOnClose);
   // }
  }
}

//==========================   ГРИД   ===========================================================================
//Получение значений всех полей текущей строки грида Wijmo Grid
function getGridSelectedRowValues(gridId)
{
  var grid=$('#'+gridId);
  var selectedCells = grid.wijgrid('selection').selectedCells();
  if(selectedCells != undefined && selectedCells.item(0) != undefined)
  {
    var selectedRowIndex = selectedCells.item(0).rowIndex(); //length()
    var data = grid.wijgrid("data");
    return data[selectedRowIndex];
  }
  else
  {
    return undefined;
  }
}

//Возвращает номер текущей подсвеченной строки грида
function getGridSelectedRowNum(gridId)
{
  var res = getGridSelection(gridId);
  return res.rownum;
}

function getGridSelectedColNum(gridId)
{
  var res = getGridSelection(gridId);
  return res.colnum;
}

//Возвращает объект в формате {rownum:10, colnum:5} со значениями текущей строки и колонки
function getGridSelection(gridId)
{

    var res;
    try
    {


    var grid=$('#'+gridId);
    if(grid != undefined)
    {
    var selectedCells = grid.wijgrid('selection').selectedCells();
    var curCell = grid.wijgrid("currentCell");
    var selRow;
    var selRowA;
    var selCol;
    if(selectedCells != undefined && selectedCells.item(0) != undefined)
    {
      selRow = selectedCells.item(0).rowIndex(); //length()
    }
    else
    {
      selRow = undefined;
    }
    if(curCell != undefined)
    {
      selCol = curCell.cellIndex(); //length()
      selRowA = curCell.rowIndex();
    }
    else
    {
       selCol = undefined;
       selRowA = undefined;
    }

    res = {rownum:selRow, colnum: selCol};
    if(res.rownum == undefined) {res.rownum = selRowA}
    }
    else
    {
      res = {rownum:0, colnum: 0};

    }
}
catch (e)
{
    res = {rownum:0, colnum: 0};
}


    return res;
}

//Переходит в гриде на указанную запись
//selVal = {idvalue=null,rownum:10, colnum:5} -- указанная запись (и колонка)
//вначале пытаемся позиционироваться по idvalue
function setGridSelection(gridId,selVal)
{
  var grid=$("#"+gridId);
  var rowNum = selVal.rownum;
  var colNum = selVal.colnum;

  if((selVal.idvalue != undefined) && (selVal.idvalue != null))
  {
     //Вначале ищем по ID и только при неудаче - по номеру строки
     //Ищем номер строки в данных

     var data = grid.wijgrid("data");
     var rowfound=-1;
     for(i=0; i<data.length; i++) {
       if(data[i].id == selVal.idvalue)
       {
        rowfound = i;
        break;
       }
     }
     if(rowfound > -1)
     {
       rowNum = i;
     }
  }

   var sel = grid.wijgrid('selection');
   if (rowNum >= 0) {
      sel.beginUpdate();
      sel.clear();
      sel.addRows(rowNum,rowNum);
      if((colNum == undefined) || (colNum < 0))
      { colNum = 0;}
      grid.wijgrid("currentCell", colNum,rowNum);
      sel.endUpdate();
   }

}


//Пытается перейти в гриде на строку, указанную в grid.currentRow
function tryToSelectRow(grid)
{
 if(grid.currentRow != undefined)
 {
   setGridSelection(grid.id,grid.currentRow);
   grid.currentRow = undefined;
 }
}


//Сохраняет в sessionStorage Id текущей записи (для последующего восстановления)
function saveGridCurrentRecordId(viewId,gridId,curId)
{
  var lselection;
  try {lselection =  JSON.parse(sessionStorage.getItem(viewId+'.'+gridId+'.selection'));} catch (e) {lselection = undefined;}
  if(lselection == undefined)
  {
    lselection = {rownum:0, idvalue:curId, colnum : 0 };
  }

  lselection.idvalue = curId;
  sessionStorage.setItem(viewId+'.'+gridId+'.selection',JSON.stringify(lselection));

}

//Сохраняет вид грида в sessionStorage viewId - string , grid - object
function saveGidView(viewId,grid)
{
  var selInfo = getGridSelection(grid.id); //Всегда без ID записи
  sessionStorage.setItem(viewId+'.'+grid.id+'.selection',JSON.stringify(selInfo)); //Номер текущей строки грида
  sessionStorage.setItem(viewId+'.'+grid.id+'.filter',JSON.stringify(grid.filter));
  sessionStorage.setItem(viewId+'.'+grid.id+'.search',JSON.stringify(grid.search));
  sessionStorage.setItem(viewId+'.'+grid.id+'.sorting',JSON.stringify(grid.sorting));
}

//Восстанавливает вид грида из sessionStorage
function restoreGridView(viewId,grid)
{
   var lselection;
   var lfilter;
   var lqsearch;
   var lsorting;

   //Так как переменные заполнены значениями по умолчанию, то устанавливаем их значения если только что-то сохранено
   try {lselection =  JSON.parse(sessionStorage.getItem(viewId+'.'+grid.id+'.selection'));} catch (e) {lselection = undefined;}
   try {lfilter = JSON.parse(sessionStorage.getItem(viewId+'.'+grid.id+'.filter'));} catch (e) {lfilter = undefined;}
   try {lqsearch = JSON.parse(sessionStorage.getItem(viewId+'.'+grid.id+'.search'));} catch (e) {lqsearch = undefined;}
   try {lsorting = JSON.parse(sessionStorage.getItem(viewId+'.'+grid.id+'.sorting'));} catch (e) {lsorting= undefined;}

   if( lfilter != undefined)
   {
     grid.filter  = lfilter;
   }

   if(lqsearch != undefined)
   {
     grid.search  = lqsearch;
   }

   if(lsorting != undefined)
   {

      if(lsorting.length > 0)
      {
        //Очищаем сортировку колонок по умолчанию
        for(var i = 0; i < grid.columns.length; i++)
        {
             grid.columns[i].sortDirection =  "none";
             grid.columns[i].sortOrder = 0;
        }
      }
      //Разбираемся с колонками грида
      for(var j = 0; j < lsorting.length; j++)
      {
        for(var i = 0; i < grid.columns.length; i++)
        {
          if(grid.columns[i].dataKey == lsorting[j].dataKey)
          {
             grid.columns[i].sortDirection =  lsorting[j].sortDirection;
             grid.columns[i].sortOrder = j;
             break;
          }
        }
      }
   }

   if(lselection != undefined)
   {
      grid.currentRow = lselection;
   }

}


//Обновить грид
function refreshGrid(gridId)
{
 $('#'+gridId).wijgrid('ensureControl', true);
}


//Перевод дата-пикера
/* DPGlobal.dates  = {
			days: ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"],
			daysShort:  ["Вс", "Пн", "Вт", "Срe", "Чт", "Пт", "Сб", "Вс"],
			daysMin: ["Вс", "Пн", "Вт", "Срe", "Чт", "Пт", "Сб", "Вс"],
			months: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
			monthsShort: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
		}

  */

function fateChanged(val)
{
  if(val != 'умер')
  {
    $("#death_year_val").val(0);
    $("#death_year_val").attr("disabled","true")
  }
  else{
    $("#death_year_val").removeAttr("disabled");
  }
}