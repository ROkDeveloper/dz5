﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ОтборОрганизация = Параметры.Отбор.Владелец;
		Параметры.Отбор.Удалить("Владелец");
	ИначеЕсли НЕ Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		ОтборОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	Элементы.ОтборОрганизация.Видимость = ОтборОрганизацияИспользование;
	
	Если ОтборОрганизацияИспользование Тогда
		ОсновнойБанковскийСчет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтборОрганизация, "ОсновнойБанковскийСчет");
	КонецЕсли;
	
	ТипВладельца = ТипЗнч(ОтборОрганизация);
	Элементы.СтатусСчета.Видимость = Ложь;
	Если ОтборОрганизацияИспользование Тогда
		Если ТипВладельца = Тип("СправочникСсылка.Контрагенты") Тогда
			Элементы.ОтборОрганизация.Заголовок = НСтр("ru = 'Контрагент'");
		ИначеЕсли ТипВладельца = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			Элементы.ОтборОрганизация.Заголовок = НСтр("ru = 'Физическое лицо'");
		ИначеЕсли ТипВладельца = Тип("СправочникСсылка.Организации") Тогда
			Элементы.ОтборОрганизация.Видимость = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
			Элементы.ОтборОрганизация.Заголовок = НСтр("ru = 'Организация'");
			
			ЭтоИнтерфейсИнтеграцииСБанком  = ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком();
			Элементы.Основной.Видимость    = Не ЭтоИнтерфейсИнтеграцииСБанком;
			Элементы.СтатусСчета.Видимость = Справочники.НастройкиИнтеграцииСБанками.ИнтеграцияВИнформационнойБазеВключена();
			Элементы.СчетБанк.Видимость    = СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета();
			
			// Переключение на подменю создать
			ДоступноСоздание = ПравоДоступа("Редактирование", Метаданные.Справочники.БанковскиеСчета);

			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Создать", "Видимость", Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСоздать", "Видимость", ДоступноСоздание);
			
			БИКБанковСИнформациейОНастройкеПрямогоОбмена = 
				Справочники.БанковскиеСчета.БИКБанковСИнформациейОНастройкеПрямогоОбмена(ОтборОрганизация);
				
			Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("БИКБанковСИнформациейОНастройкеПрямогоОбмена",
				БИКБанковСИнформациейОНастройкеПрямогоОбмена);
			Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ДоступнаНастройкаПрямогоОбмена",
				ПравоДоступа("Редактирование", Метаданные.Справочники.НастройкиОбменСБанками));
				
			Элементы.ГруппаДиректБанк.Видимость = БИКБанковСИнформациейОНастройкеПрямогоОбмена.Количество() > 0;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПараметрыСписка(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборПоОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УстановкаОсновногоБанковскогоСчета" Тогда
		Если ЗначениеЗаполнено(ОтборОрганизация) И ОтборОрганизация = Параметр.КонтрагентОрганизация Тогда
			ОсновнойБанковскийСчет = Параметр.ОсновнойБанковскийСчет;
			УстановитьПараметрыСписка(ЭтотОбъект);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ИзмененБанковскийСчет" Тогда
		Если Параметр.Свойство("ОсновнойБанковскийСчет")
			И ЗначениеЗаполнено(ОтборОрганизация) И ОтборОрганизация = Параметр.Владелец Тогда
			ОсновнойБанковскийСчет = Параметр.ОсновнойБанковскийСчет;
		КонецЕсли;
		
		// Проверка состояния настройки прямого обмена для банка счета
		Если Параметр.Свойство("Владелец") И Параметр.Свойство("Банк") Тогда
			БанкСНастройкойПрямогоОбменаНаСервере(Параметр.Владелец, Параметр.Банк);	
		КонецЕсли;
		
		Элементы.Список.ТекущаяСтрока = Параметр.Ссылка;
		УстановитьПараметрыСписка(ЭтотОбъект);
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЦифровойСчет(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Владелец", ОтборОрганизация);

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЦифровойСчет", Истина);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);

	ОткрытьФорму("Справочник.БанковскиеСчета.Форма.ФормаЭлементаЦифровойСчет", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБанковскийСчет(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Владелец", ОтборОрганизация);

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);

	ОткрытьФорму("Справочник.БанковскиеСчета.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборПоОрганизации()
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ЭтотОбъект.Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
			"Владелец",
			ОтборОрганизация,
			Неопределено,
			,
			ОтборОрганизацияИспользование);
	ИначеЕсли ЗначениеЗаполнено(ТипВладельца) И ТипВладельца <> Тип("Неопределено") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ЭтотОбъект.Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, "ТипВладельца", ТипВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураОтборовСписка()

	СтруктураОтборов = Новый Структура;
	Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		Если НЕ ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда 
			СтруктураОтборов.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
		ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			СтруктураОтборов.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение.ВыгрузитьЗначения());
		КонецЕсли;
	КонецЦикла;
	Возврат СтруктураОтборов;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтатусыСчетов()
	
	СтатусыСчетов = Новый Структура;
	СтатусыСчетов.Вставить("СчетВРежимеИнтеграции", 0);
	СтатусыСчетов.Вставить("СчетБезИнтеграции", 1);
	
	Возврат СтатусыСчетов;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыСписка(Форма)
	
	Список = Форма.Список;
	
	СтатусыСчетов = СтатусыСчетов();
	Список.Параметры.УстановитьЗначениеПараметра("СтатусСчетВРежимеИнтеграции", СтатусыСчетов.СчетВРежимеИнтеграции);
	Список.Параметры.УстановитьЗначениеПараметра("СтатусСчетБезИнтеграции", СтатусыСчетов.СчетБезИнтеграции);
	
	Если ЗначениеЗаполнено(Форма.ОсновнойБанковскийСчет) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОсновнойБанковскийСчет", Форма.ОсновнойБанковскийСчет);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("ОсновнойБанковскийСчет", Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаЗакрытия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	// Владелец
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Владелец");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборОрганизацияИспользование", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборОрганизация", ВидСравненияКомпоновкиДанных.Заполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура БанкСНастройкойПрямогоОбменаНаСервере(ВладелецСчета, Банк)
	СвойстваНастроек = Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
	Если НЕ ЗначениеЗаполнено(Банк) ИЛИ НЕ ЗначениеЗаполнено(ВладелецСчета) 
		ИЛИ ТипЗнч(ОтборОрганизация) <> Тип("СправочникСсылка.Организации") ИЛИ ВладелецСчета <> ОтборОрганизация
		ИЛИ НЕ СвойстваНастроек.Свойство("БИКБанковСИнформациейОНастройкеПрямогоОбмена") Тогда
		Возврат;
	КонецЕсли;
	
	БИКБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Банк, "Код");
	БИКБанковСИнформациейОНастройкеПрямогоОбмена = СвойстваНастроек.БИКБанковСИнформациейОНастройкеПрямогоОбмена;
	
	Если БИКБанковСИнформациейОНастройкеПрямогоОбмена.Получить(БИКБанка) = Неопределено Тогда	
					
		ИнформацияОНастройкеПрямогоОбмена
			= Справочники.БанковскиеСчета.ИнформацияОНастройкеПрямогоОбменаСБанком(ВладелецСчета, Банк);
		
		Если ИнформацияОНастройкеПрямогоОбмена.Рублевый ИЛИ ИнформацияОНастройкеПрямогоОбмена.Валютный Тогда
			
			БИКБанковСИнформациейОНастройкеПрямогоОбмена.Вставить(БИКБанка, ИнформацияОНастройкеПрямогоОбмена);
			Элементы.ГруппаДиректБанк.Видимость = Истина;
			
		КонецЕсли;		
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ЦифровойСчет = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураОтборовСписка());
	ПараметрыФормы.ЗначенияЗаполнения.Вставить("Владелец", ОтборОрганизация);

	Если Копирование Тогда
		
		Если Не Элементы.Список.ТекущиеДанные.Свойство("Ссылка") Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
		ЦифровойСчет = Элементы.Список.ТекущиеДанные.ЦифровойСчет;
		
	КонецЕсли;


	
	Если ЦифровойСчет Тогда
		
		ОткрытьФорму("Справочник.БанковскиеСчета.Форма.ФормаЭлементаЦифровойСчет",
			ПараметрыФормы, ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

	ИначеЕсли Копирование Или ТипЗнч(ОтборОрганизация) <> Тип("СправочникСсылка.Организации") Тогда
		
		ОткрытьФорму("Справочник.БанковскиеСчета.ФормаОбъекта",
			ПараметрыФормы, ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
			
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыполнитьОткрытиеФормыВыбораЗавершение", ЭтотОбъект, ПараметрыФормы);

		ОткрытьФорму("Справочник.БанковскиеСчета.Форма.ФормаВыбораВидаСчета",
			ПараметрыФормы,
			,
			,
			,
			,
			ОписаниеОповещения);

	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОткрытиеФормыВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;

	Если РезультатЗакрытия.ЦифровойСчет Тогда
		
		ДополнительныеПараметры.Вставить("ЦифровойСчет", Истина);
		ОткрытьФорму("Справочник.БанковскиеСчета.Форма.ФормаЭлементаЦифровойСчет",
			ДополнительныеПараметры, ЭтотОбъект,,,,, 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Иначе
		
		ОткрытьФорму("Справочник.БанковскиеСчета.ФормаОбъекта",
			ДополнительныеПараметры, ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	СписокПуст = Элементы.Список.ТекущиеДанные = Неопределено;
	
	Если СписокПуст Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущаяСтрока);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураОтборовСписка());
	
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.Свойство("Ссылка") И ЗначениеЗаполнено(ТекущиеДанные.Ссылка)
			И ТекущиеДанные.Свойство("Основной") И ТекущиеДанные.Основной
			И (ТекущиеДанные.Свойство("ПометкаУдаления") И ТекущиеДанные.ПометкаУдаления
				Или ТекущиеДанные.Свойство("ДатаЗакрытия") И ЗначениеЗаполнено(ТекущиеДанные.ДатаЗакрытия)) Тогда
			ПараметрОповещения = Новый Структура("Ссылка, Владелец, ОсновнойБанковскийСчет",
				ТекущиеДанные.Ссылка,
				ТекущиеДанные.Владелец,
				ПредопределенноеЗначение("Справочник.БанковскиеСчета.ПустаяСсылка"));
			Оповестить("ИзмененБанковскийСчет", ПараметрОповещения);
		КонецЕсли;
	КонецЕсли;
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
	
	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ДиректБанкСтатус = Неопределено;

	Если Элементы["ДиректБанкСтатус"] = Поле И Элементы.Список.ТекущиеДанные <> Неопределено
		И Элементы.Список.ТекущиеДанные.Свойство("ДиректБанкСтатус", ДиректБанкСтатус)
		И ДиректБанкСтатус = НСтр("ru = 'Подключить'") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ДоступнаНастройкаПрямогоОбмена")
			И Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ДоступнаНастройкаПрямогоОбмена Тогда
			
			ТекущиеДанные = Элементы.Список.ТекущиеДанные;
			ОбменСБанкамиКлиент.ОткрытьСоздатьНастройкуОбмена(ТекущиеДанные.Владелец, 
				ТекущиеДанные.Банк, ТекущиеДанные.НомерСчета);	
		Иначе
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://portal.1c.ru/applications/1C-Direct-bank");		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	БИКБанковСИнформациейОНастройкеПрямогоОбмена = Неопределено;
	
	Если НЕ Настройки.ДополнительныеСвойства.Свойство("БИКБанковСИнформациейОНастройкеПрямогоОбмена", 
		БИКБанковСИнформациейОНастройкеПрямогоОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	МассивКлючей = Строки.ПолучитьКлючи();
	
	Если МассивКлючей.Количество() = 0 Тогда
		Возврат;		
	КонецЕсли;
	
	СтрокаСписка = Строки[МассивКлючей[0]];
	Если НЕ СтрокаСписка.Данные.Свойство("ДиректБанкСтатус") ИЛИ
		НЕ СтрокаСписка.Данные.Свойство("ДиректБанкКартинка") Тогда
		Возврат;			
	КонецЕсли;		
	
	ПроверятьИнтеграциюСБанком = СтрокаСписка.Данные.Свойство("СтатусСчета");
	
	Для каждого ЭлементСписка Из Строки Цикл
		ТекущиеДанные = ЭлементСписка.Значение.Данные;
		СтатусСчетБезИнтеграции = Истина;
		
		Если ПроверятьИнтеграциюСБанком Тогда
			СтатусСчетБезИнтеграции = ЗначениеЗаполнено(ТекущиеДанные.СтатусСчета);	
		КонецЕсли;
		
		ЭлементСписка.Значение.Оформление["ДиректБанкКартинка"].УстановитьЗначениеПараметра("Видимость", Истина);
		ЭлементСписка.Значение.Оформление["ДиректБанкСтатус"].УстановитьЗначениеПараметра("Видимость", Ложь);
		
		Если СтатусСчетБезИнтеграции И НЕ ЗначениеЗаполнено(ТекущиеДанные.ДатаЗакрытия) 
			И НЕ ТекущиеДанные.ПометкаУдаления Тогда
			
			ИнформацияОНастройкахПрямогоОбмена = БИКБанковСИнформациейОНастройкеПрямогоОбмена.Получить(ТекущиеДанные.БИК);
			ЕстьНастройка = Ложь;
			
			Если ИнформацияОНастройкахПрямогоОбмена <> Неопределено
				И (ТекущиеДанные.Валютный И ИнформацияОНастройкахПрямогоОбмена.Валютный
					ИЛИ НЕ ТекущиеДанные.Валютный И ИнформацияОНастройкахПрямогоОбмена.Рублевый) Тогда
				
				ЕстьНастройка = ИнформацияОНастройкахПрямогоОбмена.Настройка;
				
				Если НЕ ЕстьНастройка Тогда
					ТекущиеДанные.ДиректБанкСтатус = НСтр("ru = 'Подключить'");
				КонецЕсли;					
				
			КонецЕсли;
			
			ТекущиеДанные.ДиректБанкКартинка = ЕстьНастройка;	
			ЭлементСписка.Значение.Оформление["ДиректБанкКартинка"].УстановитьЗначениеПараметра("Видимость",
				ЕстьНастройка);
			ЭлементСписка.Значение.Оформление["ДиректБанкСтатус"].УстановитьЗначениеПараметра("Видимость",
				НЕ ЕстьНастройка);
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
