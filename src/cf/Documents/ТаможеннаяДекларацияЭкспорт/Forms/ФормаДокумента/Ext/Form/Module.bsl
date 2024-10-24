﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ПодготовитьФормуНаСервере();
		
		Если УчетНДСВызовСервера.КлассифицироватьНоменклатуруПоОперациям0(,Объект.Организация) Тогда
			Объект.КодОперации = "";
			Элементы.КодОперации.Видимость = Ложь;
		Иначе
			Объект.КодОперации = УчетНДСВызовСервера.КодОперацииПоСтавке0ПоУмолчанию(,Объект.Организация);
			Отбор = Новый Структура("Код", Объект.КодОперации);
			НайденныеСтроки = КодыОперации.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() = 0 Тогда
				Объект.КодОперации = "1011410";
			КонецЕсли;
		КонецЕсли;

	Иначе
		
		Элементы.КодОперации.Видимость = (НЕ УчетНДСВызовСервера.КлассифицироватьНоменклатуруПоОперациям0(Объект.Дата, Объект.Организация)) ИЛИ ЗначениеЗаполнено(Объект.КодОперации);
		
	КонецЕсли;
	
	НадписьВыбор = НСтр("ru='Выбор'");
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.Документ.ТаможеннаяДекларацияЭкспорт",
		"ФормаДокумента",
		НСтр("ru='Новости: Таможенная декларация (экспорт)'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаДокументыОснования" Тогда
		
		Если ТолькоПросмотр Тогда
			Возврат;
		КонецЕсли;
		
		Модифицированность = Истина;
		ОбработкаВыбораОснований(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьЗаголовокФормы();
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.НомерВходящегоДокумента = НомерДекларацииНаТовары;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияИнтеграцияСЛКФТСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СсылкаНаФормуПодбораДеклараций" Тогда
		ОткрытьФормуПодбораДеклараций(НомерДекларацииНаТовары);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБаннерНажатие(Элемент)
	
	ОбработатьЗакрытиеБаннераНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерВходящегоДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуПодбораДеклараций(Элемент.ТекстРедактирования);

КонецПроцедуры

&НаКлиенте
Процедура НомерВходящегоДокументаПриИзменении(Элемент)
	
	КодОшибки = УчетНДСКлиентСервер.НаличиеОшибокВНомереДекларации(
		НомерДекларацииНаТовары, НачалоКорректногоПериода, КонецКорректногоПериода);
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура НомерВходящегоДокументаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ТекущийТекстРедактированияНомерДекларацииНаТовары = Текст;
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиИнформациюОбОшибкахВНомере", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
	Элементы.КодОперации.Видимость = НЕ УчетНДСВызовСервера.КлассифицироватьНоменклатуруПоОперациям0(Объект.Дата, Объект.Организация);
	
	Если Элементы.КодОперации.Видимость = Ложь Тогда
		Объект.КодОперации = "";
	Иначе
		Объект.КодОперации = УчетНДСВызовСервера.КодОперацииПоСтавке0ПоУмолчанию(Объект.Дата,Объект.Организация);
		Отбор = Новый Структура("Код", Объект.КодОперации);
		НайденныеСтроки = КодыОперации.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Объект.КодОперации = "1011410";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(ВыбранноеЗначение) И НЕ Объект.Организация = ВыбранноеЗначение Тогда
		Объект.ДокументОснование = Неопределено;
		Объект.ДокументыОснования.Очистить();
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НСтр("ru='Выбор кода операции'"));
	ПараметрыФормы.Вставить("ТаблицаЗначений",    КодыОперации);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", Объект.КодОперации));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборКодаОперацииЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор, , ,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыборНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДокументыОснованияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьИзменитьНажатие(Элемент)
	
	ВыбратьОснование();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьСостояниеДокумента();
	УстановитьЗаголовокФормы();
	ЗаполнитьКоллекциюСписковВыбора();
	
	НалоговаяБаза = НалоговаяБазаПоОснованиям();
	Контрагент = КонтрагентПоОснованиям();
	НомерДекларацииНаТовары = Объект.НомерВходящегоДокумента;

	КорректныйПериод = ОбщегоНазначенияБПСобытия.КорректныйПериодВводаДокументов();
	
	НачалоКорректногоПериода = КорректныйПериод.НачалоКорректногоПериода;
	КонецКорректногоПериода  = КорректныйПериод.КонецКорректногоПериода;
	
	ОпределитьНеобходимостьПоказаБаннераЛКФТС();
	
	КодОшибки = УчетНДСКлиентСервер.НаличиеОшибокВНомереДекларации(
		НомерДекларацииНаТовары, НачалоКорректногоПериода, КонецКорректногоПериода);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(ЭтотОбъект)
	
	Элементы = ЭтотОбъект.Элементы;
	Объект   = ЭтотОбъект.Объект;
	
	// Представление ссылки "Документы-основания"
	КоличествоОснований = Объект.ДокументыОснования.Количество();
	
	Элементы.НадписьВыбор.Видимость              = КоличествоОснований = 0;
	Элементы.ГруппаОдноОснование.Видимость       = КоличествоОснований = 1;
	Элементы.НадписьДокументыОснования.Видимость = КоличествоОснований > 1;
	
	Если КоличествоОснований > 1 Тогда
		
		ФормСтрока     = "Л = ru_RU; ЧДЦ=0";
		ПарПредмета    = "документ,документа,документов,м,,,,0";
		ПрописьЧисла   = ЧислоПрописью(КоличествоОснований, ФормСтрока, ПарПредмета);
		ИндексПредмета = СтрНайти(ПрописьЧисла, "док");
		ТекстДокументы = Строка(КоличествоОснований) + " " + Сред(ПрописьЧисла, ИндексПредмета, СтрДлина(ПрописьЧисла)- ИндексПредмета - 3);
		ТекстНадписи   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (%2 и еще %3)'"), 
			ТекстДокументы, 
			Строка(Объект.ДокументыОснования[0].ДокументОснование),
			КоличествоОснований - 1);
		
		ЭтотОбъект.НадписьДокументыОснования = ТекстНадписи;
		
	КонецЕсли;
	
	Элементы.ГруппаБаннерИнтеграцияСЛКФТС.Видимость = ЭтотОбъект.ПоказыватьБаннерЛКФТС;
	
	Если ЭтотОбъект.КодОшибки <> 0 Тогда
		Элементы.ОшибочныйНомерДекларации.Видимость = Истина;
		Элементы.ОшибочныйНомерДекларации.Заголовок = УчетНДСКлиентСервер.ПояснениеКОшибкеВНомереДекларации(
			ЭтотОбъект.КодОшибки, Истина);
	Иначе
		Элементы.ОшибочныйНомерДекларации.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбораДеклараций(ТекстРедактирования)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Период",                          Объект.Дата);
	ПараметрыФормы.Вставить("Организация",                     Объект.Организация);
	ПараметрыФормы.Вставить("РегистрационныйНомерИзФормы",     ТекстРедактирования);
	ПараметрыФормы.Вставить("РегистрационныйНомерИзОбъекта",   Объект.НомерВходящегоДокумента);
	ПараметрыФормы.Вставить("ОбщаяСтоимостьИзДокумента",       НалоговаяБаза);

	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборНомераВходящегоДокументаЗавершение", ЭтотОбъект);
	ОткрытьФорму("РегистрСведений.СведенияДекларацийНаТовары.Форма.ФормаПодбораДеклараций",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор, , ,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснование()
	
	ЕстьОшибкиЗаполнения = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Заполнение", НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Организация", "Объект" , ЕстьОшибкиЗаполнения);
	КонецЕсли;
	
	Если ЕстьОшибкиЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыФормыПодбораОснования();
	
	ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаДокументыОснования",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыФормыПодбораОснования()
	
	СтруктураПараметров = Новый Структура;
	ДанныеЗаполнения = Новый Структура;
	
	Если Объект.ДокументыОснования.Количество() > 0 Тогда
		ДанныеЗаполнения.Вставить("СписокДокументовОснований", Новый СписокЗначений);
		Для Каждого СтрокаТаблицы Из Объект.ДокументыОснования Цикл
			ДанныеЗаполнения.СписокДокументовОснований.Добавить(СтрокаТаблицы.ДокументОснование)
		КонецЦикла;
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	СтруктураПараметров.Вставить("Организация",Объект.Организация);
	СтруктураПараметров.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораОснований(ВыбранноеЗначение)
	
	Объект.ДокументыОснования.Очистить();
	Для Каждого СтрокаСписка Из ВыбранноеЗначение Цикл
		Если СтрокаСписка.Значение.Пустая() Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаТаблицы = Объект.ДокументыОснования.Добавить();
		СтрокаТаблицы.ДокументОснование = СтрокаСписка.Значение;
	КонецЦикла;
	
	НалоговаяБаза = НалоговаяБазаПоОснованиям();
	Контрагент = КонтрагентПоОснованиям();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция НалоговаяБазаПоОснованиям()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументыОснования", Объект.ДокументыОснования.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументыОснования.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ ВТ_ДокументыОснования
	|ИЗ
	|	&ДокументыОснования КАК ДокументыОснования
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ЕСТЬNULL(РеализацияТоваровУслуг.СуммаДокумента, 0)) КАК СуммаДокумента
	|ИЗ
	|	ВТ_ДокументыОснования КАК ВТ_ДокументыОснования
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|		ПО ВТ_ДокументыОснования.ДокументОснование = РеализацияТоваровУслуг.Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СуммаДокумента;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция КонтрагентПоОснованиям()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументыОснования", Объект.ДокументыОснования.Выгрузить());
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументыОснования.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ ВТ_ДокументыОснования
	|ИЗ
	|	&ДокументыОснования КАК ДокументыОснования
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РеализацияТоваровУслуг.Контрагент КАК Контрагент
	|ИЗ
	|	ВТ_ДокументыОснования КАК ВТ_ДокументыОснования
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|		ПО ВТ_ДокументыОснования.ДокументОснование = РеализацияТоваровУслуг.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Контрагент;
	Иначе
		Возврат Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Заголовок = Документы.ТаможеннаяДекларацияЭкспорт.ПредставлениеДокумента(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоллекциюСписковВыбора()
	
	МакетСоставаПоказателей = Отчеты.РегламентированныйОтчетРеестрНДСПриложение5.ПолучитьМакет("СпискиВыбора2015Кв4");
	
	КоллекцияСписковВыбора = Новый Структура;
	Для Каждого Область Из МакетСоставаПоказателей.Области Цикл
		Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
			ВерхОбласти = Область.Верх;
			НизОбласти  = Область.Низ;
			Коды = Новый ТаблицаЗначений;
			Коды.Колонки.Добавить("Код");
			Коды.Колонки.Добавить("Название");
			Коды.Колонки.Добавить("РезультатПроверки");
			Для НомерСтроки = ВерхОбласти По НизОбласти Цикл
				КодПоказателя = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 1).Текст);
				Если КодПоказателя <> "###" Тогда
					НовСтрока = Коды.Добавить();
					НовСтрока.Код               = КодПоказателя;
					НовСтрока.Название          = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 2).Текст);
					НовСтрока.РезультатПроверки = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 3).Текст);
				КонецЕсли;
			КонецЦикла;
			КоллекцияСписковВыбора.Вставить(Область.Имя, Коды);
		КонецЕсли;
	КонецЦикла;
	
	Если КоллекцияСписковВыбора.Свойство("ВидыДокумента") Тогда
		СписокВыбора = Элементы.СопроводительныеДокументыВидДокумента.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого ВидДокумента Из КоллекцияСписковВыбора.ВидыДокумента Цикл
			Если НЕ ЗначениеЗаполнено(ВидДокумента.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(ВидДокумента.Код, ВидДокумента.Код + " - " + ВидДокумента.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("КодыВидаТС") Тогда
		СписокВыбора = Элементы.СопроводительныеДокументыКодТС.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого КодВидаТС Из КоллекцияСписковВыбора.КодыВидаТС Цикл
			Если НЕ ЗначениеЗаполнено(КодВидаТС.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(КодВидаТС.Код, КодВидаТС.Код + " - " + КодВидаТС.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("КодыОпераций") Тогда
		Для Каждого КодОперации Из КоллекцияСписковВыбора.КодыОпераций Цикл
			Если НЕ ЗначениеЗаполнено(КодОперации.Код) Тогда
				Продолжить;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(КодыОперации.Добавить(), КодОперации);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодаОперацииЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.КодОперации = РезультатВыбора.Код;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборНомераВходящегоДокументаЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	НомерДекларацииНаТовары = РезультатВыбора.РегистрационныйНомер;
	
	КодОшибки = УчетНДСКлиентСервер.НаличиеОшибокВНомереДекларации(
		НомерДекларацииНаТовары, НачалоКорректногоПериода, КонецКорректногоПериода);
		
	ПоказыватьБаннерЛКФТС = Ложь;
	ОбновитьОтображениеДанных();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьЗакрытиеБаннераНаСервере()
	
	ПоказыватьБаннерЛКФТС = Ложь;
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОбщегоНазначенияБП.ЗаписатьДанныеВХранилище(Объект.Организация, Истина, "НеПоказыватьБаннерЛКФТС");
	КонецЕсли;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНеобходимостьПоказаБаннераЛКФТС()

	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	ЭтоБухгалтер = РольДоступна("ДобавлениеИзменениеДанныхБухгалтерии");
	НетПравНаЗагрузкуСведений = Не ЭтоБухгалтер И Не ЭтоПолноправныйПользователь;
	
	Если НетПравНаЗагрузкуСведений Или Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ПоказыватьБаннерЛКФТС = Ложь;
		Возврат;
	КонецЕсли;
	
	// Показываем баннер если сведения не загружались и баннер не был ранее закрыт пользователем.
	ПоказыватьБаннерЛКФТС = Не РегистрыСведений.СведенияДекларацийНаТовары.СведенияЗагружены(Объект.Организация)
		И Не ЗначениеЗаполнено(ОбщегоНазначенияБП.ПрочитатьДанныеИзХранилища(Объект.Организация, "НеПоказыватьБаннерЛКФТС"));

КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);
	
КонецПроцедуры

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

&НаКлиенте
Процедура Подключаемый_ВывестиИнформациюОбОшибкахВНомере() Экспорт

	КодОшибки = УчетНДСКлиентСервер.НаличиеОшибокВНомереДекларации(
		ТекущийТекстРедактированияНомерДекларацииНаТовары, НачалоКорректногоПериода, КонецКорректногоПериода);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
		
	ОпределитьНеобходимостьПоказаБаннераЛКФТС();
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Элементы.КодОперации.Видимость = НЕ УчетНДСВызовСервера.КлассифицироватьНоменклатуруПоОперациям0(Объект.Дата, Объект.Организация);
	
	Если Элементы.КодОперации.Видимость = Ложь Тогда
		Объект.КодОперации = "";
	Иначе
		Объект.КодОперации = УчетНДСВызовСервера.КодОперацииПоСтавке0ПоУмолчанию(Объект.Дата,Объект.Организация);
		Отбор = Новый Структура("Код", Объект.КодОперации);
		НайденныеСтроки = КодыОперации.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Объект.КодОперации = "1011410";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти