﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"КлючСтроки,АдресТаблицыПодтверждающиеДокументы");
		
	ТаблицаПодтверждающиеДокументы = ПолучитьИзВременногоХранилища(АдресТаблицыПодтверждающиеДокументы);
	
	Объект.ПодтверждающиеДокументы.Очистить();
	Объект.ПодтверждающиеДокументы.Загрузить(ТаблицаПодтверждающиеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗавершениеРаботы И (Модифицированность ИЛИ ПеренестиВДокумент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
	Если ПеренестиВДокумент И НЕ Отказ Тогда
		Отказ = НЕ ПроверитьЗаполнениеНаКлиенте();
	КонецЕсли;
	
	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ПеренестиВДокумент Тогда
		
		СтруктураРезультат = ПриЗакрытииНаСервере();
		
		Оповестить("РедактированиеСпискаПодтверждающихДокументов", СтруктураРезультат, ЭтаФорма.ВладелецФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицы

&НаКлиенте
Процедура ПодтверждающиеДокументыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ДанныеСтроки = Элементы.ПодтверждающиеДокументы.ТекущиеДанные;
	
	Если НоваяСтрока Тогда
		ДанныеСтроки.КлючСтроки = КлючСтроки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	Отказ = Ложь;
	ИмяСписка = НСтр("ru = 'Подтверждающие документы'");
	
	Для Индекс = 0 По Объект.ПодтверждающиеДокументы.Количество() - 1 Цикл
		
		СтрокаПодтверждающиеДокументы = Объект.ПодтверждающиеДокументы[Индекс];
		Префикс = "Объект.ПодтверждающиеДокументы[%1]";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Префикс, Формат(Индекс, "ЧН=0; ЧГ="));
		
		Если Не ЗначениеЗаполнено(СтрокаПодтверждающиеДокументы.ТипДокумента) Тогда
			Поле = Префикс + ".ТипДокумента";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Тип документа'"),
				Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаПодтверждающиеДокументы.НомерДокумента) Тогда
			Поле = Префикс + ".НомерДокумента";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Номер документа'"),
				Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаПодтверждающиеДокументы.ДатаДокумента) Тогда
			Поле = Префикс + ".ДатаДокумента";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Дата документа'"),
				Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции

&НаСервере
Функция ПриЗакрытииНаСервере()
	
	ТаблицаПодтверждающиеДокументы = Объект.ПодтверждающиеДокументы.Выгрузить();
	АдресТаблицыПодтверждающиеДокументы = ПоместитьВоВременноеХранилище(ТаблицаПодтверждающиеДокументы, УникальныйИдентификатор);
	
	СтруктураРезультат = Новый Структура();
	СтруктураРезультат.Вставить("КлючСтроки", КлючСтроки);
	СтруктураРезультат.Вставить("АдресТаблицыПодтверждающиеДокументы", АдресТаблицыПодтверждающиеДокументы);
	
	Возврат СтруктураРезультат;
	
КонецФункции

#КонецОбласти
