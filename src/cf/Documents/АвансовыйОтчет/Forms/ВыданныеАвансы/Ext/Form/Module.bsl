﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ДействиеВыбрано;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Организация 			= Параметры.Организация;
	ФизЛицо 				= Параметры.ФизЛицо;
	ВалютаДокумента 		= Параметры.ВалютаДокумента;
	ДатаАвансовогоОтчета 	= Параметры.ДатаАвансовогоОтчета;
	ТекущийДокумент			= Параметры.ТекущийДокумент;
	
	ВыданныеАвансы.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыВыданныеАвансы));
	ЗаполнитьСуммыАвансов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	НовыйАванс = ВыданныеАвансы.Добавить();
	НовыйАванс.ДокументАванса = ВыбранноеЗначение;
	ЗаполнитьСуммуАвансаВСтроке(НовыйАванс.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Если ДействиеВыбрано <> Истина Тогда
		ОповеститьОВыборе(Неопределено);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАвансы

&НаКлиенте
Процедура ВыданныеАвансыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина; // Событие обрабатывается нестандартным образом
	ОткрытьФормуВыбораДокументаАванса();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыданныеАвансыПослеУдаления(Элемент)
	ВыданныеАвансыВсего = ВыданныеАвансы.Итог("СуммаАванса");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьАванс(Команда)
		
	ОткрытьФормуВыбораДокументаАванса();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
		
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(ПоместитьТаблицуАвансовВоВременноеХранилище());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораДокументаАванса()
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", 			Организация);
	ПараметрыФормы.Вставить("ФизЛицо", 				ФизЛицо);
	ПараметрыФормы.Вставить("ВалютаДокумента", 		ВалютаДокумента);
	ПараметрыФормы.Вставить("ДатаАвансовогоОтчета", ДатаАвансовогоОтчета);
	ПараметрыФормы.Вставить("ТекущийДокумент", 		ТекущийДокумент);
	
	ВыбранныеДокументы = Новый СписокЗначений;
	Для каждого СтрокаАванса Из ВыданныеАвансы Цикл
		ВыбранныеДокументы.Добавить(СтрокаАванса.ДокументАванса);
	КонецЦикла; 
	
	ПараметрыФормы.Вставить("ВыбранныеДокументы", 	ВыбранныеДокументы);
		
	ОткрытьФорму("Документ.АвансовыйОтчет.Форма.ВыборДокументаАванса", 
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуммыАвансов()
		
	Для каждого СтрокаАванса Из ВыданныеАвансы Цикл
		// ОбщегоНазначения.ЗначениеРеквизитаОбъектов() не умеет выбирать реквизиты объектов разных типов.
		// Поэтому получаем сумму по каждому документу отдельно.
		СтрокаАванса.СуммаАванса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаАванса.ДокументАванса, "СуммаДокумента");
	КонецЦикла; 
	
	ВыданныеАвансыВсего = ВыданныеАвансы.Итог("СуммаАванса");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуммуАвансаВСтроке(ИдентификаторСтроки)
	
	ТекущиеДанные = ВыданныеАвансы.НайтиПоИдентификатору(ИдентификаторСтроки);
	ТекущиеДанные.СуммаАванса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ДокументАванса, "СуммаДокумента");
	
	ВыданныеАвансыВсего = ВыданныеАвансы.Итог("СуммаАванса");
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТаблицуАвансовВоВременноеХранилище()

	Возврат ПоместитьВоВременноеХранилище(ВыданныеАвансы.Выгрузить(), УникальныйИдентификатор);

КонецФункции

#КонецОбласти