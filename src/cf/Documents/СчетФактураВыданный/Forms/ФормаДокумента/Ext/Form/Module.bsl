﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("ЗначениеКопирования") Тогда
		ЗначениеКопирования = Параметры.ЗначениеКопирования;
	КонецЕсли;
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	Если Параметры.Свойство("Основание") Тогда
		Основание           = Параметры.Основание;
	КонецЕсли;
	Если Параметры.Свойство("Ключ") Тогда
		Ключ				= Параметры.Ключ;
	КонецЕсли;
	
	ФормыСчетовФактур   = Новый ФиксированноеСоответствие(
		Документы.СчетФактураВыданный.ПолучитьСоответствиеВидовСчетаФактурыФормам(Истина));
		
	ВидыОпераций = ПолучитьСписокВидовОпераций(ОбщегоНазначения.ТекущаяДатаПользователя());
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если Параметры.Свойство("ВидСчетаФактуры") Тогда
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(Параметры.ВидСчетаФактуры);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОпераций(Дата)

	ИспользуетсяПостановлениеНДС1137 = УчетНДСПереопределяемый.ИспользуетсяПостановлениеНДС1137(Дата);
	КомиссияПродажа = ПолучитьФункциональнуюОпцию("ОсуществляетсяРеализацияТоваровУслугКомитентов");
	КомиссияЗакупка = ПолучитьФункциональнуюОпцию("ОсуществляетсяЗакупкаТоваровУслугДляКомитентов");
	ИспользоватьВалютныйУчет = ПолучитьФункциональнуюОпцию("ИспользоватьВалютныйУчет");
	
	СписокВидовОпераций = Новый СписокЗначений;
	
	СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.НаРеализацию, НСтр("ru = 'Счет-фактура на реализацию'"));
	СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.НаАванс, НСтр("ru = 'Счет-фактура на аванс'"));
	
	Если ИспользуетсяПостановлениеНДС1137 И КомиссияПродажа Тогда
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.НаАвансКомитента, НСтр("ru = 'Счет-фактура на аванс комитента'"));
	КонецЕсли;	
	Если ИспользуетсяПостановлениеНДС1137 И КомиссияЗакупка Тогда
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.НаАвансКомитентаНаЗакупку, НСтр("ru = 'Счет-фактура на аванс комитента на закупку'"));
	КонецЕсли;
	
	СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.НалоговыйАгент, НСтр("ru = 'Счет-фактура налогового агента'"));
	
	Если ИспользоватьВалютныйУчет Тогда 
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.НаСуммовуюРазницу, НСтр("ru = 'Счет-фактура на суммовую разницу'"));
	КонецЕсли;
	
	Если Дата >= '20111001' Тогда
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.Корректировочный, НСтр("ru = 'Корректировочный счет-фактура...'"));
	КонецЕсли;
	
	СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.ПустаяСсылка(), НСтр("ru = 'Исправление счета-фактуры...'"));
	
	Если УчетНДСПереопределяемый.ВерсияПостановленияНДС1137(Дата) > 3
		И ПолучитьФункциональнуюОпцию("ВедетсяРозничнаяТорговля") Тогда
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.СводнаяСправка, НСтр("ru = 'Сводная справка по розничным продажам'"));
		СписокВидовОпераций.Добавить(Перечисления.ВидСчетаФактурыВыставленного.КорректировочнаяСправка, НСтр("ru = 'Корректировочная справка по розничным продажам'"));
	КонецЕсли;
	
	Возврат СписокВидовОпераций;

КонецФункции

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидСчетаФактуры)
	
	Если ТипЗнч(ЗначенияЗаполнения) <> Тип("Структура") Тогда
		ЗначенияЗаполнения = Новый Структура();
	КонецЕсли;

	ЗначенияЗаполнения.Вставить("ВидСчетаФактуры",		ВыбранныйВидСчетаФактуры);
	Если ЗначениеЗаполнено(Основание) Тогда
		ЗначенияЗаполнения.Вставить("Основание",        Основание);
	КонецЕсли;
	
	ЗначениеОтбора = Новый Структура();
	
	Если ЗначенияЗаполнения.Свойство("Организация") Тогда
		ЗначениеОтбора.Вставить("Организация", ЗначенияЗаполнения.Организация);
	КонецЕсли;
	
	Если ЗначенияЗаполнения.Свойство("Контрагент") Тогда 
		ЗначениеОтбора.Вставить("Контрагент", ЗначенияЗаполнения.Контрагент);
	КонецЕсли;
	
	ЗначениеОтбора.Вставить("Исправление", Ложь);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Ключ);
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	КонецЕсли;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	СтруктураПараметров.Вставить("Отбор", ЗначениеОтбора);
		
	Модифицированность = Ложь;
	Закрыть();
	
	// Для корректировочного счета-фактуры показывается сначала форма подбора исходного документа,
	// поэтому счетчик для него здесь не включаем.
	КлючеваяОперация = "";
	Если ВыбранныйВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыВыставленного.НаРеализацию") Тогда
		КлючеваяОперация = "СозданиеФормыСчетФактураВыданныйНаРеализацию";
	ИначеЕсли ВыбранныйВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыВыставленного.НаАванс")
		ИЛИ ВыбранныйВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыВыставленного.НаАвансКомитента") 
		ИЛИ ВыбранныйВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыВыставленного.НаАвансКомитентаНаЗакупку") Тогда
		КлючеваяОперация = "СозданиеФормыСчетФактураВыданныйНаАванс";
	ИначеЕсли ВыбранныйВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыВыставленного.НалоговыйАгент") Тогда
		КлючеваяОперация = "СозданиеФормыСчетФактураВыданныйНалоговыйАгент";
	ИначеЕсли ВыбранныйВидСчетаФактуры = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыВыставленного.НаСуммовуюРазницу") Тогда
		КлючеваяОперация = "СозданиеФормыСчетФактураВыданныйНаСуммовуюРазницу";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючеваяОперация) Тогда
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
	ОткрытьФорму("Документ.СчетФактураВыданный.Форма." + ФормыСчетовФактур[ВыбранныйВидСчетаФактуры], СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

#КонецОбласти
