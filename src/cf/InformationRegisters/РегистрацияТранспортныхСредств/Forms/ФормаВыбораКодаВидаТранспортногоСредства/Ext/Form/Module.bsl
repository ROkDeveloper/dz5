﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Дата") Тогда 
		
		Если Год(Параметры.Дата) < 2012 Тогда
			Макет = Отчеты.РегламентированныйОтчетТранспортныйНалог.ПолучитьМакет("Списки2007Кв1");
			ИмяОбласти = "ВидыТранспортныхСредств";
		ИначеЕсли Год(Параметры.Дата) = 2012 Тогда 
			Макет = Отчеты.РегламентированныйОтчетТранспортныйНалог.ПолучитьМакет("Списки2012Кв1");
			ИмяОбласти = "ВидыТранспортныхСредств";
		ИначеЕсли Год(Параметры.Дата) < 2014 Тогда 
			Макет = Отчеты.РегламентированныйОтчетТранспортныйНалог.ПолучитьМакет("Списки2012Кв1");
			ИмяОбласти = "ВидыТранспортныхСредств2013";
		Иначе
			Макет = АктуальныйМакетСписковВыбора(Параметры.Дата);
			Если Макет = Неопределено Тогда
				Макет = Отчеты.РегламентированныйОтчетТранспортныйНалог.ПолучитьМакет("СпискиВыбора2019Кв1");
			КонецЕсли;	
			ИмяОбласти = "ВидыТранспортныхСредств";
		КонецЕсли;
		
	Иначе
		
		Макет = АктуальныйМакетСписковВыбора();
		Если Макет = Неопределено Тогда
			Макет = Отчеты.РегламентированныйОтчетТранспортныйНалог.ПолучитьМакет("СпискиВыбора2019Кв1");
		КонецЕсли;	
		ИмяОбласти = "ВидыТранспортныхСредств";
		
	КонецЕсли;
	
	ТекущаяОбласть = Макет.Области.Найти(ИмяОбласти);

	Если НЕ (ТекущаяОбласть = Неопределено) Тогда	
	
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			// Перебираем строки макета.
			КодПоказателя = СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название      = СокрП(Макет.Область(НомерСтр, 2).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				НоваяСтрока = СписокКодов.Добавить();
				НоваяСтрока.Код          = КодПоказателя;
				НоваяСтрока.Наименование = Название;
			КонецЕсли;

		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекущийКод) Тогда
		СтрокиКодов = СписокКодов.НайтиСтроки(Новый Структура("Код", Параметры.ТекущийКод));
		Если СтрокиКодов.Количество() > 0 Тогда
			Элементы.СписокКодов.ТекущаяСтрока = СтрокиКодов[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКодов

&НаКлиенте
Процедура СписокКодовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ВыборЭлемента();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыборЭлемента()
	
	СтрокаТаблицы = Элементы.СписокКодов.ТекущиеДанные;
	
	ВозвращаемыеПараметры = Новый Структура("КодВидаТС, Наименование",СтрокаТаблицы.Код,СтрокаТаблицы.Наименование);
	Закрыть(ВозвращаемыеПараметры);

КонецПроцедуры

&НаСервереБезКонтекста
Функция АктуальныйМакетСписковВыбора(Период = Неопределено)
	
	СпискиВыбора = Новый ТаблицаЗначений;
	СпискиВыбора.Колонки.Добавить("ИмяМакета", ОбщегоНазначения.ОписаниеТипаСтрока(20));
	СпискиВыбора.Колонки.Добавить("Год", ОбщегоНазначения.ОписаниеТипаЧисло(4,0,ДопустимыйЗнак.Неотрицательный));
	СпискиВыбора.Колонки.Добавить("Квартал", ОбщегоНазначения.ОписаниеТипаЧисло(1,0,ДопустимыйЗнак.Неотрицательный));
	
	Для каждого Макет Из Метаданные.Отчеты.РегламентированныйОтчетТранспортныйНалог.Макеты Цикл
		
		Если СтрНайти(Макет.Имя, "СпискиВыбора") = 0 Тогда
			Продолжить;
		КонецЕсли;
						
		ГодМакета = Число(Лев(СтрЗаменить(Макет.Имя, "СпискиВыбора", ""), 4));
		Если ЗначениеЗаполнено(Период) И ГодМакета > Год(Период) Тогда
			Продолжить;
		КонецЕсли;	
		
		КварталМакета = 0;
		
		ПозицияКв = СтрНайти(Макет.Имя, "Кв");
		Если ПозицияКв <> 0 Тогда
			КварталМакета = Число(Сред(Макет.Имя, ПозицияКв + 2));
		КонецЕсли;	
		
		СписокВыбора = СпискиВыбора.Добавить();
		СписокВыбора.ИмяМакета = Макет.Имя;
		СписокВыбора.Год = ГодМакета;
		СписокВыбора.Квартал = КварталМакета;
		
	КонецЦикла; 
			
	СпискиВыбора.Сортировать("Год Убыв, Квартал Убыв");
	
	Если СпискиВыбора.Количество() > 0 Тогда
		Возврат Отчеты.РегламентированныйОтчетТранспортныйНалог.ПолучитьМакет(СпискиВыбора[0].ИмяМакета);
	Иначе
		Возврат Неопределено;
	КонецЕсли;	
		
КонецФункции	

#КонецОбласти
