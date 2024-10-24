﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПредопределенныйСчет = Предопределенный Или ЗначениеЗаполнено(ВидНалога);
	ПользовательУправляетСчетамиУчета = СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета();
	Если Не ПользовательУправляетСчетамиУчета И Не ПредопределенныйСчет И Не ЗначениеЗаполнено(СчетУчета) Тогда
		СчетУчета = ПланыСчетов.Хозрасчетный.ОсновнойСчет("Налоги");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетУчета) Тогда
		СвойстваСчетаУчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетУчета);
		СчетУчетаКод               = СвойстваСчетаУчета.Код;
		СчетУчетаКодБыстрогоВыбора = СвойстваСчетаУчета.КодБыстрогоВыбора;
	Иначе
		СчетУчетаКод               = "";
		СчетУчетаКодБыстрогоВыбора = "";
	КонецЕсли;
	
	Справочники.ВидыНалоговИПлатежейВБюджет.ПодменитьРеквизитыПриСовпаденииКБК(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВидНалога = Перечисления.ВидыНалогов.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
