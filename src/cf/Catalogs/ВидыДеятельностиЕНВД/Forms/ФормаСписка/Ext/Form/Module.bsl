﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ОтборВладелец;
	
	ИспользуетсяНесколькоОрганизаций = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
	Если ИспользуетсяНесколькоОрганизаций Тогда
		
		УстановленОтборПоВладельцу = Параметры.Отбор.Свойство("Владелец", ОтборВладелец);
		
		Если УстановленОтборПоВладельцу Тогда
			ОтборОрганизация = ОтборВладелец;
		Иначе
			ОтборОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
				"Владелец",
				ОтборОрганизация,
				,
				,
				ОтборОрганизацияИспользование);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Владелец.Видимость = Не УстановленОтборПоВладельцу И ИспользуетсяНесколькоОрганизаций;
	Элементы.ГруппаОтборОрганизация.Видимость  = Не УстановленОтборПоВладельцу И ИспользуетсяНесколькоОрганизаций;
	Элементы.ОтборОрганизацияНадпись.Видимость = УстановленОтборПоВладельцу И ИспользуетсяНесколькоОрганизаций;
	
	ВестиУчетЮридическогоЛица = ПолучитьФункциональнуюОпцию("ВестиУчетЮридическогоЛица");
	ВестиУчетИндивидуальногоПредпринимателя = ПолучитьФункциональнуюОпцию("ВестиУчетИндивидуальногоПредпринимателя");
	
	ФормыЗавленияОПостановкеНаУчет = Новый Массив;
	ФормыЗавленияОСнятииСУчета     = Новый Массив;
	
	Если ВестиУчетЮридическогоЛица Тогда
		ФормыЗавленияОПостановкеНаУчет.Добавить("ЕНВД-1");
		ФормыЗавленияОСнятииСУчета.Добавить("ЕНВД-3");
	КонецЕсли;
	
	Если ВестиУчетИндивидуальногоПредпринимателя Тогда
		ФормыЗавленияОПостановкеНаУчет.Добавить("ЕНВД-2");
		ФормыЗавленияОСнятииСУчета.Добавить("ЕНВД-4");
	КонецЕсли;
	
	Элементы.ФормаПостановкаНаУчет.Заголовок =
		СтрШаблон("%1 (%2)",
		НСтр("ru = 'Постановка на учет'"),
		СтрСоединить(ФормыЗавленияОПостановкеНаУчет, ", "));
	
	Элементы.ФормаСнятиеСУчета.Заголовок =
		СтрШаблон("%1 (%2)",
		НСтр("ru = 'Снятие с учета'"),
		СтрСоединить(ФормыЗавленияОСнятииСУчета, ", "));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" И Не УстановленОтборПоВладельцу Тогда
		
		ОтборОрганизация = Параметр;
		ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
			"Владелец",
			ОтборОрганизация,
			,
			,
			ОтборОрганизацияИспользование);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		"Владелец",
		ОтборОрганизация,
		,
		,
		ОтборОрганизацияИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ОтборОрганизацияИспользование = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		"Владелец",
		ОтборОрганизация,
		,
		,
		ОтборОрганизацияИспользование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПостановкаНаУчет(Команда)
	
	ВидыЗаявлений = Новый Соответствие;
	Если ВестиУчетЮридическогоЛица Тогда
		ЭтоЮрЛицо = Истина;
		ВидыЗаявлений.Вставить(ЭтоЮрЛицо, ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1"));
	КонецЕсли;
	Если ВестиУчетИндивидуальногоПредпринимателя Тогда
		ЭтоЮрЛицо = Ложь;
		ВидыЗаявлений.Вставить(ЭтоЮрЛицо, ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2"));
	КонецЕсли;
	
	СоздатьЗаявления(ВидыЗаявлений);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятиеСУчета(Команда)
	
	ВидыЗаявлений = Новый Соответствие;
	Если ВестиУчетЮридическогоЛица Тогда
		ЭтоЮрЛицо = Истина;
		ВидыЗаявлений.Вставить(ЭтоЮрЛицо, ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3"));
	КонецЕсли;
	Если ВестиУчетИндивидуальногоПредпринимателя Тогда
		ЭтоЮрЛицо = Ложь;
		ВидыЗаявлений.Вставить(ЭтоЮрЛицо, ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4"));
	КонецЕсли;
	
	СоздатьЗаявления(ВидыЗаявлений);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьЗаявления(ВидыЗаявлений)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	МассивРегистраций = Новый Массив;
	УникальныеЗначенияРегистраций = Новый Соответствие;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ТекущиеДанные = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		
		РегистрацияВНалоговомОргане = ТекущиеДанные.РегистрацияВНалоговомОргане;
		Если УникальныеЗначенияРегистраций[РегистрацияВНалоговомОргане] <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МассивРегистраций.Добавить(РегистрацияВНалоговомОргане);
		УникальныеЗначенияРегистраций.Вставить(РегистрацияВНалоговомОргане, Истина);
		
	КонецЦикла;
	
	Для Каждого РегистрацияВНалоговомОргане Из МассивРегистраций Цикл
		
		МассивВидовДеятельности = Новый Массив;
		Организация = Неопределено;
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			
			ТекущиеДанные = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
			Если ТекущиеДанные.РегистрацияВНалоговомОргане = РегистрацияВНалоговомОргане Тогда
				Если Организация = Неопределено Или Организация = ТекущиеДанные.Владелец Тогда
					МассивВидовДеятельности.Добавить(ТекущиеДанные.Ссылка);
					Организация = ТекущиеДанные.Владелец;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Если МассивВидовДеятельности.Количество() <> 0 Тогда
			
			ВидЗаявления = ВидыЗаявлений.Получить(ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация));
			Если ВидЗаявления = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ОткрытьФормуЗаявления(ВидЗаявления, Организация, РегистрацияВНалоговомОргане, МассивВидовДеятельности);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗаявления(ВидЗаявления, Организация, РегистрацияВНалоговомОргане, ВидыДеятельности)
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ВидыДеятельности", ВидыДеятельности);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("НалоговыйОрган", РегистрацияВНалоговомОргане);
	ПараметрыФормы.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
	ПараметрыФормы.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
	
	УчетЕНВДКлиент.ОткрытьФормуЗаявления(ВидЗаявления, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти