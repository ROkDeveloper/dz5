﻿
&НаКлиенте 
Перем ТекущийТекстНомераСчета; // Текст, набранный в поле ввода номера счета

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указан владелец банковского счета!'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		
	Если Параметры.Ключ.Пустая() Тогда
		БанковскийСчетСсылка = Справочники.БанковскиеСчета.ПолучитьСсылку();
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			
			Объект.ЦифровойСчет = Параметры.ЗначениеКопирования.ЦифровойСчет;
			Объект.Наименование = "";
			УстановитьНаименованиеСчета(ЭтотОбъект);
			
		Иначе
			
			Объект.ЦифровойСчет = Параметры.ЦифровойСчет;
			Если НЕ Объект.Валютный Тогда
				Объект.ВалютаДенежныхСредств = ВалютаРегламентированногоУчета;
			КонецЕсли;
			
		КонецЕсли;
		
		ПодготовитьФормуНаСервере();
	КонецЕсли;
			
	УстановитьЗаголовокФормы(Параметры.Ключ.Пустая());

	Если СвойстваБанковскогоСчета.СчетОрганизации Тогда
		
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Владелец));
		
	Иначе
		
		Если Не СвойстваБанковскогоСчета.СчетКонтрагента И Не СвойстваБанковскогоСчета.СчетФизлица Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Неверно указан владелец банковского счета!'"),,,, Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ПодразделениеОрганизацииРасширеннаяПодсказка.Заголовок =
		НСтр("ru = 'Подразделение, которое подставляется по умолчанию в Поступление и Списание с этого банковского счета'");
		
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если Не ЗначениеЗаполнено(БанковскийСчетСсылка) Тогда
		БанковскийСчетСсылка = Объект.Ссылка;
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	УстановитьЗаголовокФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекстОшибки = "";
	
	Если Не ЗначениеЗаполнено(Объект.НомерСчета) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Заполнение", НСтр("ru = 'ID кошелька'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.НомерСчета", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
		
	Если Параметры.Ключ.Пустая() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(БанковскийСчетСсылка);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьЗаголовокФормы();
	ЗаполнитьСвойстваБанковскогоСчета(ТекущийОбъект, ЭтотОбъект);
	КлючСохраненияПоложенияОкна = СвойстваПоложенияОкна();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПараметрОповещения = Новый Структура("Ссылка, Владелец", Объект.Ссылка, Объект.Владелец);
	Оповестить("ИзмененБанковскийСчет", ПараметрОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерСчетаПриИзменении(Элемент)
	
	Объект.НомерСчета = СтрЗаменить(Объект.НомерСчета, " ", "");

	СчетУчетаПоУмолчанию(ЭтотОбъект);
	
	УстановитьНаименованиеСчета(ЭтотОбъект, Истина);
	УстановитьПараметрыВыбораСчетаБанк(ЭтотОбъект);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
		
	СвойстваБанковскогоСчета = НовыйСвойстваБанковскогоСчета();
	ЗаполнитьСвойстваБанковскогоСчета(Объект, ЭтотОбъект);
					
	Элементы.СчетБанк.Видимость = СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета();
			
	Если СвойстваБанковскогоСчета.СчетКонтрагента Тогда
		
		Элементы.Владелец.Заголовок = НСтр("ru = 'Контрагент'");
		
		Элементы.СчетБанк.Видимость                 = Ложь;
		Элементы.ПодразделениеОрганизации.Видимость = Ложь;
		Элементы.ДатаОткрытия.Видимость             = Ложь;
		
	ИначеЕсли СвойстваБанковскогоСчета.СчетОрганизации Тогда
		
		Элементы.Владелец.Видимость = СвойстваБанковскогоСчета.НесколькоОрганизаций;
		Элементы.Владелец.Заголовок = НСтр("ru = 'Организация'");
				
		Элементы.ПодразделениеОрганизации.Видимость = Истина;
				
	ИначеЕсли СвойстваБанковскогоСчета.СчетФизлица Тогда
		
		Элементы.Владелец.Заголовок = НСтр("ru = 'Физическое лицо'");
		
		Элементы.СчетБанк.Видимость                           = Ложь;
		Элементы.ПодразделениеОрганизации.Видимость           = Ложь;
		Элементы.ДатаОткрытия.Видимость                       = Ложь;
				
	КонецЕсли;
		
	КлючСохраненияПоложенияОкна = СвойстваПоложенияОкна();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораСчетаБанк(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	СчетаБанка = СчетаБанка();
	
	НовыйМассивПараметров = Новый Массив;
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СчетаБанка));
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ЗапретитьИспользоватьВПроводках", Ложь));
	Элементы.СчетБанк.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	
КонецПроцедуры

Функция НовыйСвойстваБанковскогоСчета()
	
	Возврат Новый Структура("СчетОрганизации,
		|НесколькоОрганизаций,
		|СчетКонтрагента,
		|СчетФизлица,
		|ВозможныДопРеквизиты");
	
КонецФункции

&НаСервере
Функция СвойстваПоложенияОкна()
	
	ВключенныеСвойстваБанковскогоСчета = Новый Массив;
	Для Каждого КлючИЗначение Из СвойстваБанковскогоСчета Цикл
		Если КлючИЗначение.Значение Тогда
			ВключенныеСвойстваБанковскогоСчета.Добавить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрСоединить(ВключенныеСвойстваБанковскогоСчета, "/");
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьСвойстваБанковскогоСчета(ТекОбъект, Форма)
	
	Форма.СвойстваБанковскогоСчета.СчетКонтрагента = ТипЗнч(ТекОбъект.Владелец) = Тип("СправочникСсылка.Контрагенты");
	Форма.СвойстваБанковскогоСчета.СчетФизлица     = ТипЗнч(ТекОбъект.Владелец) = Тип("СправочникСсылка.ФизическиеЛица");
	Форма.СвойстваБанковскогоСчета.СчетОрганизации = ТипЗнч(ТекОбъект.Владелец) = Тип("СправочникСсылка.Организации");
	Форма.СвойстваБанковскогоСчета.НесколькоОрганизаций = Форма.СвойстваБанковскогоСчета.СчетОрганизации
		И Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	Форма.СвойстваБанковскогоСчета.ВозможныДопРеквизиты = Форма.СвойстваБанковскогоСчета.СчетОрганизации;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция СчетаБанка()
	
	СчетаОтбора = Новый Массив;
	ОтбиратьПоВалюте = Ложь;
	ОбразецСчета     = Неопределено;
	ОбразецСчета     = ПланыСчетов.Хозрасчетный.ОсновнойСчет("БезналичныеДеньгиЦифровые");
	СчетаОтбора.Добавить(ПланыСчетов.Хозрасчетный.ОсновнойСчет("БезналичныеДеньги")); 
	СчетаОтбора.Добавить(ПланыСчетов.Хозрасчетный.ОсновнойСчет("БезналичныеДеньгиЦифровые"));
	СчетаОтбора.Добавить(ПланыСчетов.Хозрасчетный.ОсновнойСчет("СчетКорпоративныхРасчетов"));
		
	СчетаБанка = БухгалтерскийУчет.ПолучитьМассивСчетовДенежныхСредств(СчетаОтбора, ОтбиратьПоВалюте, ОбразецСчета);
	
	Возврат Новый ФиксированныйМассив(СчетаБанка);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СчетУчетаПоУмолчанию(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если  ЗначениеЗаполнено(Объект.СчетБанк) Тогда
		ЗначениеОтбора = Неопределено;
		Для Каждого ПараметрВыбора Из Элементы.СчетБанк.ПараметрыВыбора Цикл
			Если ПараметрВыбора.Имя = "Отбор.Ссылка" Тогда
				ЗначениеОтбора = ПараметрВыбора.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеОтбора = Неопределено Или ЗначениеОтбора.Найти(Объект.СчетБанк) <> Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Объект.СчетБанк = БанковскиеСчетаКлиентСервер.СчетУчетаПоНомеру(Объект.НомерСчета, Объект.Валютный, Объект.ЦифровойСчет);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы(ЭтоНовыйСчет = Ложь)
	
	Если ЭтоНовыйСчет Тогда
		Заголовок = НСтр("ru = 'Цифровой рубль (создание)'");
	Иначе
		Заголовок = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	УстановитьНаименованиеСчета(Форма);
			
	УстановитьПараметрыВыбораСчетаБанк(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНаименованиеСчета(Форма, ИзменениеНомераСчета = Ложь)
	
	Объект = Форма.Объект;
	
	СокращенноеНаименование = Прав(СокрЛП(Объект.НомерСчета), 4);
	Если ПустаяСтрока(Объект.Наименование) И Не ПустаяСтрока(СокращенноеНаименование) Тогда 
		
		ШаблонНаименования = НСтр("ru = 'Цифровой рубль %1%2'");
		Объект.Наименование = СтрШаблон(ШаблонНаименования, "*", СокращенноеНаименование); 
		
	Иначе     
		
		Если ИзменениеНомераСчета И НЕ ПустаяСтрока(Форма.НомерСчетаТекущий) Тогда
			Объект.Наименование = СтрЗаменить(Объект.Наименование, Форма.НомерСчетаТекущий, СокращенноеНаименование);
		КонецЕсли;
		
	КонецЕсли;
	
	Форма.НомерСчетаТекущий = СокращенноеНаименование;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
