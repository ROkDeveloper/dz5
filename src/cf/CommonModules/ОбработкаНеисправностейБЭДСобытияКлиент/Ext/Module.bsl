﻿
#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при инициализации контекста диагностики.
// 
// Параметры:
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
Процедура ПриИнициализацииКонтекстаДиагностики(КонтекстДиагностики) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия.ПриИнициализацииКонтекстаДиагностики(КонтекстДиагностики);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при инициализации ошибки, свойства ошибки можно расширить дополнительными свойствами.
// 
// Параметры:
// 	Ошибка - см. ОбработкаНеисправностейБЭДКлиент.НоваяОшибка
Процедура ПриИнициализацииОшибки(Ошибка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия.ПриИнициализацииОшибки(Ошибка);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при добавлении ошибки в контекст диагностики.
// 
// Параметры:
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
// 	Ошибка - см. ОбработкаНеисправностейБЭДКлиент.НоваяОшибка
Процедура ПриДобавленииОшибки(КонтекстДиагностики, Ошибка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия.ПриДобавленииОшибки(КонтекстДиагностики, Ошибка);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед формированием файла для техподдержки.
// Предназначена для подготовки клиентских данных. В переопределяемой части после заполнения данных
// необходимо выполнить обработку оповещения, указанного в параметре ОповещениеОЗавершении.
//
// Параметры:
//  ТехническаяИнформация    - Структура - см. параметр ТехническаяИнформация общего модуля 
//                ОбработкаНеисправностейБЭДСобытия.ПриФормированииФайлаСИнформациейДляТехподдержки.
//  ОповещениеОЗавершении    - ОписаниеОповещения - необходимо выполнить после заполнения данных, передав
//                             в качестве результата значение параметра ТехническаяИнформация.
// Пример:
// ТехническаяИнформация.Вставить("КлиентскийПараметр", "Значение клиентского параметра");
// ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, ТехническаяИнформация).
Процедура ПередФормированиемФайлаДляТехподдержки(ТехническаяИнформация, ОповещениеОЗавершении) Экспорт
	
	// ОбменСКонтрагентами начало
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия.ПередФормированиемФайлаДляТехподдержки(ТехническаяИнформация,
			ОповещениеОЗавершении);
	КонецЕсли;
	// ОбменСКонтрагентами конец
	
КонецПроцедуры

// Вызывается при формировании параметров обращения в техподдержку, параметры подставляются
// в форму обращения в техподдержку.
//
// Параметры:
//  ПараметрыОбращения - Структура - с ключами:
//    * ТекстОбращения - Строка - текст обращения в техподдержку.
//    * ТелефонСлужбыПоддержки - Строка - телефон службы техподдержки.
//    * АдресЭлектроннойПочтыСлужбыПоддержки - Строка - адрес электронной почты службы техподдержки.
//  КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
//
// Пример:
// ТекстОбращения = НСтр("ru = 'Требуется повторное получение контейнеров с идентификаторами:'");
// ТелефонСлужбыПоддержки = НСтр("ru = '123-45-67'").
//
Процедура ПриОпределенииПараметровОбращенияВТехподдержку(ПараметрыОбращения, КонтекстДиагностики) Экспорт
	
	// ОбменСКонтрагентами начало
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиИнтеграцияКлиентСобытия.ПриОпределенииПараметровОбращенияВТехподдержку(
			ПараметрыОбращения, КонтекстДиагностики);
	КонецЕсли;
	// ОбменСКонтрагентами конец
	
КонецПроцедуры

#КонецОбласти