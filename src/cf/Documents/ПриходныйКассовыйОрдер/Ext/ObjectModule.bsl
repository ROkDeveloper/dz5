﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Проверяет установленные курсы валют документа перед пересчетом сумм
// Нулевые курсы устанавливаются в 1
//
Процедура ПроверкаКурсовВалют(СтрокаПлатежа) Экспорт
	
	Если СтрокаПлатежа <> Неопределено Тогда
		СтрокаПлатежа.КурсВзаиморасчетов      =
			?(СтрокаПлатежа.КурсВзаиморасчетов      = 0, 1, СтрокаПлатежа.КурсВзаиморасчетов);
		СтрокаПлатежа.КратностьВзаиморасчетов =
			?(СтрокаПлатежа.КратностьВзаиморасчетов = 0, 1, СтрокаПлатежа.КратностьВзаиморасчетов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
	// Заполнение реквизитов из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Если ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
		КурсДокумента      = 1;
		КратностьДокумента = 1;
	Иначе
		СтруктураКурсаДокумента = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
		КурсДокумента      = СтруктураКурсаДокумента.Курс;
		КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	
	ВидДокументаОснования = ТипЗнч(Основание);
	ДокументОснование     = Основание;
	
	Если ВидДокументаОснования = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ОтчетКомитентуОПродажах")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ПередачаОС")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ПередачаНМА")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.НачислениеПеней")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
		
		ВидОперации           = Перечисления.ВидыОперацийПКО.ОплатаПокупателя;
		Контрагент            = Основание.Контрагент;
		ДоговорКонтрагента    = Основание.ДоговорКонтрагента;
		ВидРасчетовПоДоговору = БухгалтерскийУчетПереопределяемый.ОпределениеВидаРасчетовПоПараметрамДоговора(ДоговорКонтрагента);
		Если ВидРасчетовПоДоговору = Перечисления.ВидыРасчетовПоДоговорам.РасчетыВИностраннойВалюте Тогда
			ВалютаДокумента   = ДоговорКонтрагента.ВалютаВзаиморасчетов;
		Иначе
			ВалютаДокумента   = ВалютаРегламентированногоУчета;
		КонецЕсли;
		
		СтруктураКурсаДокумента = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
		КурсДокумента           = СтруктураКурсаДокумента.Курс;
		КратностьДокумента      = СтруктураКурсаДокумента.Кратность;
		
		ВалютаВзаиморасчетов = ДоговорКонтрагента.ВалютаВзаиморасчетов;
		СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, Дата);
		
		ТаблицаПлатежей = РасшифровкаПлатежа.ВыгрузитьКолонки();
		
		ОснованияУслугНПД = Новый Массив;
		ОснованияУслугНПД.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
		ОснованияУслугНПД.Добавить(Тип("ДокументСсылка.СчетНаОплатуПокупателю"));
		
		Если УчетнаяПолитика.ПрименяетсяНалогНаПрофессиональныйДоход(Организация, Дата)
			И ОснованияУслугНПД.Найти(ВидДокументаОснования) <> Неопределено Тогда
			
			МенеджерОснования = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Основание);
			ТаблицаСуммОснования = МенеджерОснования.ТаблицаУслугПродукцииНПД(Основание);
			ТаблицаСуммОснования.Колонки.Сумма.Имя = "СуммаПлатежа";
			
		ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			
			ТаблицаСуммОснования = СтатусыДокументов.ТаблицаСуммКОплатеВРазрезеСтавокНДС(
				Новый Структура("Основание, ДатаОснования, Организация", Основание, Основание.Дата, Основание.Организация),
				УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДСВРазрезеСтавокНДС(Основание));
			ТаблицаСуммОснования.Колонки.Сумма.Имя = "СуммаПлатежа";
			
		ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
			
			ТаблицаСуммОснования = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДСВРазрезеСтавокНДС(Основание);
			ТаблицаСуммОснования.Колонки.Сумма.Имя = "СуммаПлатежа";
			
			МассивОснование = Новый Массив;
			МассивОснование.Добавить(Основание);
			СоотвествиеРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
				МассивОснование, "УдержатьВознаграждение, СуммаВознаграждения, СтавкаНДСВознаграждения");
			ПараметрыОснования = СоотвествиеРеквизитов[Основание];
			Если ПараметрыОснования <> Неопределено
					И ПараметрыОснования.УдержатьВознаграждение И ПараметрыОснования.СуммаВознаграждения > 0 Тогда
				ЕстьТакаяСтавка =
					ТаблицаСуммОснования.Найти(ПараметрыОснования.СтавкаНДСВознаграждения,  "СтавкаНДС") <> Неопределено;
				НоваяСтрока     = ТаблицаСуммОснования.Добавить();
				НоваяСтрока.СуммаПлатежа = - ПараметрыОснования.СуммаВознаграждения;
				НоваяСтрока.СтавкаНДС    =   ПараметрыОснования.СтавкаНДСВознаграждения;
				НоваяСтрока.СуммаНДС     = - (Основание.Товары.Итог("СуммаНДСВознаграждения")
					+ Основание.Услуги.Итог("СуммаНДСВознаграждения"));
				
				Если ЕстьТакаяСтавка Тогда
					ТаблицаСуммОснования.Свернуть("СтавкаНДС", "СуммаПлатежа, СуммаНДС");
				Иначе
					ТаблицаСуммОснования.Свернуть("", "СуммаПлатежа, СуммаНДС");
					ТаблицаСуммОснования.Колонки.Добавить("СтавкаНДС", Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС"));
				КонецЕсли;
			КонецЕсли;
		
		ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.ОтчетКомитентуОПродажах")
			ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ПередачаНМА") Тогда
			
			ТаблицаСуммОснования = Новый ТаблицаЗначений();
			ТаблицаСуммОснования.Колонки.Добавить("СуммаПлатежа", ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
			ТаблицаСуммОснования.Колонки.Добавить("СтавкаНДС",    Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС"));
			ТаблицаСуммОснования.Колонки.Добавить("СуммаНДС",     ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
			СтрокаТаблицыСумм = ТаблицаСуммОснования.Добавить();
			Если ВидДокументаОснования = Тип("ДокументСсылка.ОтчетКомитентуОПродажах") Тогда
				СтрокаТаблицыСумм.СуммаПлатежа = Основание.СуммаВознаграждения;
				СтрокаТаблицыСумм.СтавкаНДС    = Основание.СтавкаНДСВознаграждения;
				СтрокаТаблицыСумм.СуммаНДС     = Основание.Товары.Итог("СуммаНДСВознаграждения");
			ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.ПередачаНМА") Тогда
				СтрокаТаблицыСумм.СуммаПлатежа = Основание.СуммаДокумента;
				СтрокаТаблицыСумм.СтавкаНДС    = Основание.СтавкаНДС;
				СтрокаТаблицыСумм.СуммаНДС     = Основание.СуммаНДС;
			КонецЕсли;
			
		Иначе
			
			ТаблицаСуммОснования = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДСВРазрезеСтавокНДС(Основание);
			ТаблицаСуммОснования.Колонки.Сумма.Имя = "СуммаПлатежа";
			
		КонецЕсли;
		
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаСуммОснования, ТаблицаПлатежей);
		Если ТаблицаПлатежей.Количество() = 0 Тогда
			ТаблицаПлатежей.Добавить();
		КонецЕсли;
		
		ТаблицаПлатежей.ЗаполнитьЗначения(ДоговорКонтрагента,                     "ДоговорКонтрагента");
		ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураКурсаВзаиморасчетов.Курс,      "КурсВзаиморасчетов");
		ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураКурсаВзаиморасчетов.Кратность, "КратностьВзаиморасчетов");
		Если ВидДокументаОснования <> Тип("ДокументСсылка.СчетНаОплатуПокупателю")
			И ПолучитьФункциональнуюОпцию("УправлениеЗачетомАвансовПогашениемЗадолженности") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(Перечисления.СпособыПогашенияЗадолженности.ПоДокументу,   "СпособПогашенияЗадолженности");
		Иначе
			ТаблицаПлатежей.ЗаполнитьЗначения(Перечисления.СпособыПогашенияЗадолженности.Автоматически, "СпособПогашенияЗадолженности");
		КонецЕсли;
		
		ТаблицаПлатежей.ЗаполнитьЗначения(Основание,"Сделка");
		ТаблицаПлатежей.ЗагрузитьКолонку(ТаблицаПлатежей.ВыгрузитьКолонку("СуммаПлатежа"), "СуммаВзаиморасчетов");
		
		Для каждого СтрокаПлатежа Из ТаблицаПлатежей Цикл
			ПроверкаКурсовВалют(СтрокаПлатежа);
			Если ДоговорКонтрагента.РасчетыВУсловныхЕдиницах Тогда
				Если Основание.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
					СтрокаПлатежа.СуммаВзаиморасчетов = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
						СтрокаПлатежа.СуммаПлатежа,
						ВалютаРегламентированногоУчета, ВалютаВзаиморасчетов,
						1, Основание.КурсВзаиморасчетов,
						1, Основание.КратностьВзаиморасчетов);
					СтрокаПлатежа.СуммаНДС = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
						СтрокаПлатежа.СуммаНДС,
						ВалютаРегламентированногоУчета, ВалютаВзаиморасчетов,
						1, Основание.КурсВзаиморасчетов,
						1, Основание.КратностьВзаиморасчетов);
				КонецЕсли;
				
				СтрокаПлатежа.СуммаПлатежа = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаПлатежа.СуммаВзаиморасчетов,
					ВалютаВзаиморасчетов, ВалютаРегламентированногоУчета,
					СтрокаПлатежа.КурсВзаиморасчетов, 1,
					СтрокаПлатежа.КратностьВзаиморасчетов, 1);
				СтрокаПлатежа.СуммаНДС = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаПлатежа.СуммаНДС,
					ВалютаВзаиморасчетов, ВалютаРегламентированногоУчета,
					СтрокаПлатежа.КурсВзаиморасчетов, 1,
					СтрокаПлатежа.КратностьВзаиморасчетов, 1);
			КонецЕсли;
		КонецЦикла;
		
		Если ВидДокументаОснования = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(Основание.СчетУчетаРасчетовСКонтрагентом,       "СчетУчетаРасчетовСКонтрагентом");
			ТаблицаПлатежей.ЗаполнитьЗначения(Основание.СчетУчетаРасчетовПоАвансамПолученным, "СчетУчетаРасчетовПоАвансам");
		ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.НачислениеПеней") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(Перечисления.СтавкиНДС.БезНДС,            "СтавкаНДС");
			ТаблицаПлатежей.ЗаполнитьЗначения(Основание.СчетУчетаРасчетовСКонтрагентом, "СчетУчетаРасчетовСКонтрагентом");
		Иначе
			Если ВидДокументаОснования <> Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
				ТаблицаПлатежей.ЗаполнитьЗначения(Основание.СчетУчетаРасчетовПоАвансам,       "СчетУчетаРасчетовПоАвансам");
				ТаблицаПлатежей.ЗаполнитьЗначения(Основание.СчетУчетаРасчетовСКонтрагентом,   "СчетУчетаРасчетовСКонтрагентом");
			КонецЕсли;
		КонецЕсли;
		
		Если ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(Основание, "СчетНаОплату");
		ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			СчетНаОплатуПокупателю = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "СчетНаОплатуПокупателю");
			ТаблицаПлатежей.ЗаполнитьЗначения(СчетНаОплатуПокупателю, "СчетНаОплату");
		КонецЕсли;
		
		РасшифровкаПлатежа.Загрузить(ТаблицаПлатежей);
		СуммаДокумента = РасшифровкаПлатежа.Итог("СуммаПлатежа");
		
	ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		
		Документы.ПриходныйКассовыйОрдер.ЗаполнитьПоОтчетуОРозничныхПродажах(ЭтотОбъект, Основание);
		
	ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		
		ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПодотчетногоЛица;
		Контрагент  = Основание.ФизЛицо;
		
		ШаблонОснования = "Внесение остатка по авансовому отчету %1 от %2";
		ЭтотОбъект.Основание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОснования,
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Основание.Номер, Истина, Ложь),
			Формат(Основание.Дата, "ДФ=dd.MM.yyyy"));
		
		СуммаАванса    = Документы.АвансовыйОтчет.ПолучитьСуммуВыданныхАвансов(Основание);
		ОстатокАванса  = Макс(0, СуммаАванса - Основание.СуммаДокумента);
		СуммаДокумента = ОстатокАванса;
		
	ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.ИнвентаризацияКассы") Тогда
		
		Документы.ПриходныйКассовыйОрдер.ЗаполнитьПоИнвентаризацииКассы(ЭтотОбъект, Основание);
		
	КонецЕсли;
	
	ЕстьРасчетыСКонтрагентами = УчетДенежныхСредствКлиентСервер.ЕстьРасчетыСКонтрагентами(ВидОперации);
	ЕстьРасчетыПоКредитам     = УчетДенежныхСредствКлиентСервер.ЕстьРасчетыПоКредитам(ВидОперации);
	
	Если ПринятоОт = "" И ЗначениеЗаполнено(Контрагент) Тогда
		Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
			КонтрагентНаименование = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент, "НаименованиеПолное,Наименование");
			ПринятоОт = ?(ПустаяСтрока(КонтрагентНаименование.НаименованиеПолное),
				КонтрагентНаименование.Наименование, КонтрагентНаименование.НаименованиеПолное);
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПодотчетногоЛица Тогда
			ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(
				Основание.Организация, Контрагент, Дата, Истина);
			ПринятоОт = ДанныеФизЛица.Представление;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьСчетПриПолученииНаличных()
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке Тогда
		ИспользоватьПереводыВПути = УчетнаяПолитика.ИспользоватьПереводыВПутиПриПеремещенияДенежныхСредств(Организация, Дата);
		ТребуетсяЗаполнение = Ложь;
		Если ИспользоватьПереводыВПути Тогда
			Если СчетУчетаРасчетовСКонтрагентом <> ПланыСчетов.Хозрасчетный.ПереводыВПути
				И СчетУчетаРасчетовСКонтрагентом <> ПланыСчетов.Хозрасчетный.ПереводыВПутиВал Тогда
				ТребуетсяЗаполнение = Истина;
			КонецЕсли;
		Иначе
			СчетаБанка = УчетДенежныхСредствПовтИсп.ПолучитьСчетаССубконтоБанковскиеСчета();
			Если СчетаБанка.Найти(СчетУчетаРасчетовСКонтрагентом) = Неопределено Тогда
				ТребуетсяЗаполнение = Истина;
			КонецЕсли;
		КонецЕсли;
		Если ТребуетсяЗаполнение Тогда
			Отбор = Новый Структура("РеквизитыПолноеИмя", Новый Соответствие);
			Отбор.РеквизитыПолноеИмя.Вставить("СчетУчетаРасчетовСКонтрагентом", Истина);
			Отбор.РеквизитыПолноеИмя.Вставить("СубконтоКт1", Истина);
			Отбор.РеквизитыПолноеИмя.Вставить("СубконтоКт2", Истина);
			Отбор.РеквизитыПолноеИмя.Вставить("СубконтоКт3", Истина);
			Отбор.РеквизитыПолноеИмя.Вставить("ПодразделениеКт", Истина);
			СчетаУчетаВДокументах.Заполнить(ЭтотОбъект, Отбор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПорядокОтраженияРозничнойВыручки()

	// Корр. счет для печатной формы заполняем следующим образом:
	//  для неавтоматизированной торговой точки - исходя из настройки счетов учета в НТТ;
	//  для розничного магазина (АТТ) - из настроек учетной политики, если счет не заполнен из документа-основания.
	Если ВидОперации = Перечисления.ВидыОперацийПКО.РозничнаяВыручка Тогда
		
		ЗаполненИзОРП = ЗначениеЗаполнено(ДокументОснование)
			И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах");
		
		Если ВыручкаСНТТ Или Не ЗначениеЗаполнено(СчетУчетаРасчетовСКонтрагентом) Или Не ЗаполненИзОРП Тогда
		
			РозничнаяТорговляОблагаетсяЕНВД = УчетнаяПолитика.РозничнаяТорговляОблагаетсяЕНВД(Организация, Дата);
			
			СчетаДоходовРасходов = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаВНТТ(Организация,
				Контрагент,
				Дата,
				Новый Структура("РозничнаяТорговляОблагаетсяЕНВД", РозничнаяТорговляОблагаетсяЕНВД));
			
			СчетУчетаРасчетовСКонтрагентом = СчетаДоходовРасходов.СчетДоходовОтРеализации;
			
			ОбновитьНастройкуУСНПриИзмененииСчетаВыручки();
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьНастройкуУСНПриИзмененииСчетаВыручки()
	
	Если ВидОперации <> Перечисления.ВидыОперацийПКО.РозничнаяВыручка
		Или Не ВыручкаСНТТ
		Или Не УчетнаяПолитика.ПрименяетсяУСН(Организация, Дата) Тогда
		Возврат;
	КонецЕсли;
	
	ПлательщикЕНВД = УчетнаяПолитика.ПлательщикЕНВД(Организация, Дата);
	
	ОсобыйПорядокОтраженияВыручки = (ПлательщикЕНВД
		И БухгалтерскийУчетПовтИсп.СчетОтноситсяКДеятельностиЕНВД(СчетУчетаРасчетовСКонтрагентом))
		Или (ДеятельностьНаПатенте И ЗначениеЗаполнено(Патент));
	
	Если ОсобыйПорядокОтраженияВыручки И Не ДоходыЕНВД_УСН Тогда
		ДоходыЕНВД_УСН = Истина;
		Графа5_УСН = 0;
	ИначеЕсли ДоходыЕНВД_УСН И Не ОсобыйПорядокОтраженияВыручки Тогда
		ДоходыЕНВД_УСН = Ложь;
		Графа5_УСН = СуммаДокумента;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВводНаОсновании = Ложь;
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
		ВводНаОсновании = Истина;
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);
	
	БезЗакрывающихДокументов = УчетКассовымМетодом.БезЗакрывающихДокументов(Организация, Дата, ВидОперации);
	
	//определяем счет банка по валюте
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ОплатаВВалюте = ЗначениеЗаполнено(ВалютаДокумента) И ВалютаДокумента <> ВалютаРегламентированногоУчета;
	
	Если НЕ Документы.ПриходныйКассовыйОрдер.ЕстьРасшифровкаПлатежа(ВидОперации) Тогда
		РасшифровкаПлатежа.Очистить();
	КонецЕсли;
	
	Если ВидОперации      = Перечисления.ВидыОперацийПКО.ОплатаПокупателя
		ИЛИ ВидОперации   = Перечисления.ВидыОперацийПКО.ВозвратОтПоставщика
		ИЛИ ВидОперации   = Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймам
		ИЛИ ВидОперации   = Перечисления.ВидыОперацийПКО.ВозвратЗаймаКонтрагентом
		ИЛИ ВидОперации   = Перечисления.ВидыОперацийПКО.ПолучениеЗайма
		ИЛИ ВидОперации   = Перечисления.ВидыОперацийПКО.ПолучениеКредита Тогда
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПодотчетногоЛица
		ИЛИ ВидОперации   = Перечисления.ВидыОперацийПКО.ВозвратЗаймаРаботником Тогда
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке Тогда
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.РозничнаяВыручка Тогда
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("СправочникСсылка.Склады");
	Иначе
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("Неопределено");
	КонецЕсли;
	
	Если ОграничениеТипаКонтрагента.Типы().Количество() = 0 Тогда
		Контрагент = Неопределено;
	Иначе
		Контрагент = ОграничениеТипаКонтрагента.ПривестиЗначение(Контрагент);
	КонецЕсли;
	
	Если УчетДенежныхСредствБП.ЗаполнитьДоговорКонтрагента(ЭтотОбъект, ДанныеЗаполнения, ОплатаВВалюте) Тогда
		
		СчетаУчетаВДокументах.ЗаполнитьСтроки(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РасшифровкаПлатежа[0]),
			"РасшифровкаПлатежа",
			ЭтотОбъект,
			Документы.ПриходныйКассовыйОрдер,
			Истина);
		
	КонецЕсли;
	
	ПараметрыУСН = УчетУСН.СтруктураПараметровОбъектаДляУСН(ЭтотОбъект);
	НалоговыйУчетУСН.ЗаполнитьОтражениеДокументаВУСН(ЭтотОбъект, ПараметрыУСН);
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.РозничнаяВыручка И ЗначениеЗаполнено(Контрагент) Тогда
		ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ТипСклада");
		ВыручкаСНТТ = (ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	УчетПоПродажнойСтоимости =
		УчетнаяПолитика.СпособОценкиТоваровВРознице(Организация, Дата) = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости;
	
	// Отключаем проверку реквизитов шапки
	
	Если  ВидОперации <> Перечисления.ВидыОперацийПКО.ОплатаПокупателя
		И ВидОперации <> Перечисления.ВидыОперацийПКО.ВозвратОтПоставщика
		И ВидОперации <> Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймам
		И ВидОперации <> Перечисления.ВидыОперацийПКО.ВозвратЗаймаКонтрагентом
		И ВидОперации <> Перечисления.ВидыОперацийПКО.ПолучениеЗайма
		И ВидОперации <> Перечисления.ВидыОперацийПКО.ПолучениеКредита Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		
	КонецЕсли;
	
	// Отключаем проверку реквизитов ТЧ РасшифровкаПлатежа
	
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.Сделка");              // Проверяем построчно
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов"); // Проверяем построчно
	
	Если ВидОперации  <> Перечисления.ВидыОперацийПКО.ОплатаПокупателя
		И ВидОперации <> Перечисления.ВидыОперацийПКО.ВозвратОтПоставщика
		И ВидОперации <> Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймам
		И ВидОперации <> Перечисления.ВидыОперацийПКО.ВозвратЗаймаКонтрагентом
		И ВидОперации <> Перечисления.ВидыОперацийПКО.ПолучениеЗайма
		И ВидОперации <> Перечисления.ВидыОперацийПКО.ПолучениеКредита Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СпособПогашенияЗадолженности");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовПоАвансам");
		
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймам
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратЗаймаКонтрагентом 
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеЗайма
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеКредита Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СпособПогашенияЗадолженности");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовПоАвансам");
		
	КонецЕсли;
	
	Если ВидОперации <> Перечисления.ВидыОперацийПКО.РозничнаяВыручка ИЛИ НЕ УчетПоПродажнойСтоимости Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Патент");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СтавкаНДС");
		
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.РозничнаяВыручка Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовСКонтрагентом");
		
		Если НЕ (ВыручкаСНТТ И ДеятельностьНаПатенте) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Патент");
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорКонтрагента");
	КонецЕсли;
	
	ИспользуетсяНесколькоБанковскихСчетовОрганизации = Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(Организация);
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке Тогда
		ПроверкаРеквизитовОрганизации.ОбработкаПроверкиЗаполнения(Организация, Контрагент, ИспользуетсяНесколькоБанковскихСчетовОрганизации, Отказ);
	КонецЕсли;

	Если    ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПодотчетногоЛица
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.РозничнаяВыручка И ВыручкаСНТТ
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратЗаймаРаботником
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке
			И ИспользуетсяНесколькоБанковскихСчетовОрганизации Тогда
		
		Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
			Если ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПодотчетногоЛица Тогда
				НезаполненноеПоле = НСтр("ru = 'Подотчетное лицо'");
			ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке Тогда
				НезаполненноеПоле = НСтр("ru = 'Банковский счет'");
			ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратЗаймаРаботником Тогда
				НезаполненноеПоле = НСтр("ru = 'Работник'");
			Иначе
				НезаполненноеПоле = НСтр("ru = 'Склад'");
			КонецЕсли;
			
			ШаблонТекстаСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, "%1");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонТекстаСообщения, НезаполненноеПоле);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Контрагент", "Объект", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	// Проверка соответствия суммы документа расшифровке платежа
	
	Если    ВидОперации = Перечисления.ВидыОперацийПКО.ОплатаПокупателя
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратОтПоставщика
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймам
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ВозвратЗаймаКонтрагентом
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеЗайма
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеКредита Тогда
		
		Если РасшифровкаПлатежа.Итог("СуммаПлатежа") <> СуммаДокумента Тогда
			ТекстСообщения = НСтр("ru = 'Не совпадают сумма документа и ее расшифровка'");
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Корректность", НСтр("ru = 'Сумма документа'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СуммаДокумента", "Объект", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	// Соберем все сообщения об ошибках заполнения и выведем их с учетом используемой формы документа.
	СообщенияПроверки = Документы.ПриходныйКассовыйОрдер.ПодготовитьСообщенияПроверкиЗаполненияРасшифровкаПлатежа(
		ЭтотОбъект,
		,
		Отказ,
		ПроверяемыеРеквизиты,
		Ложь);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты,, СообщенияПроверки, Ложь);
	
	Документы.ПриходныйКассовыйОрдер.СообщитьРезультатПроверки(
		ЭтотОбъект,
		Отказ,
		СообщенияПроверки,
		Метаданные.Документы.ПриходныйКассовыйОрдер.ТабличныеЧасти.РасшифровкаПлатежа);
	
	// Для отдельных видов операций некоторые счета проверяются вне зависимости от настроек пользователя,
	// кроме режима Интеграции с банком
	Если ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход
		И Не ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
		ПроверяемыеРеквизиты.Добавить("СчетУчетаРасчетовСКонтрагентом");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймам Тогда
		ПроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовСКонтрагентом");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление реквизитов УСН выполняем всегда для учета возможных изменений в учетной политике.
	
	ПараметрыУСН = УчетУСН.СтруктураПараметровОбъектаДляУСН(ЭтотОбъект);
	Если НЕ УчетУСН.СодержаниеУСНРедактируетсяПользователем(ЭтотОбъект) Тогда
		Содержание_УСН = НалоговыйУчетУСН.СодержаниеОперацииДляКУДиР(ПараметрыУСН);
	КонецЕсли;
	НалоговыйУчетУСН.ЗаполнитьДоходыРасходыВсего(ЭтотОбъект, ПараметрыУСН);
	
	// Обновление счета для видов операции ПолучениеНаличныхВБанке и РозничнаяВыручка выполняем всегда
	// для учета возможных изменений в учетной политике.
	УстановитьСчетПриПолученииНаличных();
	УстановитьПорядокОтраженияРозничнойВыручки();
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбъекта = Документы.ПриходныйКассовыйОрдер.ПараметрыОбъектаДляЗаполненияПатента(ЭтотОбъект);
	Патент = УчетПСН.ПатентВходящегоПлатежа(ПараметрыОбъекта);
	
	Если Документы.ПриходныйКассовыйОрдер.ЕстьРасшифровкаПлатежа(ВидОперации)
		И РасшифровкаПлатежа.Количество() > 0 Тогда
		РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорВТабличнойЧастиПередЗаписью(РасшифровкаПлатежа, ЭтотОбъект);
		ДоговорКонтрагента            = РасшифровкаПлатежа[0].ДоговорКонтрагента;
		СтатьяДвиженияДенежныхСредств = РасшифровкаПлатежа[0].СтатьяДвиженияДенежныхСредств;
	Иначе
		ДоговорКонтрагента            = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПКО.ПолучениеНаличныхВБанке
		И ЗначениеЗаполнено(Организация) И НЕ ЗначениеЗаполнено(Контрагент)
		И НЕ Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(Организация) Тогда
		Контрагент = Справочники.БанковскиеСчета.ПустаяСсылка();
		УчетДенежныхСредствБП.УстановитьБанковскийСчет(
			Контрагент, Организация,
			ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(), Истина);
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ПриходныйКассовыйОрдер.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	ТаблицаВзаиморасчеты  = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.РасшифровкаПлатежа, ПараметрыПроведения.Реквизиты, Отказ);
	
	ТаблицаВозвратОтПодотчетногоЛицаВВалюте = УчетДенежныхСредств.ПодготовитьТаблицуВозвратОтПодотчетногоЛицаВВалюте(
		ПараметрыПроведения.ВозвратОтПодотчетногоЛицаВВалюте);
	
	ТаблицаПрочихРасчетов = УчетВзаиморасчетов.ПодготовитьТаблицуПрочихРасчетовОплатаПокупателя(
		ТаблицаВзаиморасчеты, ПараметрыПроведения.Реквизиты);
	
	ТаблицаСуммовыхРазниц = УчетНДС.ПодготовитьТаблицуСуммовыхРазниц(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.Реквизиты, Отказ);
	
	ТаблицаНДСПоРеализациямНеплательщика = УчетУСН.ПодготовитьТаблицуНДСПоРеализацииНеплательщиком(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.Реквизиты);
		
	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура("ТаблицаРасчетов, ТаблицаНДСПродажи",
		ТаблицаВзаиморасчеты, ТаблицаНДСПоРеализациямНеплательщика);
	
	// Учет доходов и расходов ИП
	ТаблицаОплатПокупателяИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуОплатыПокупателя(
		ТаблицаВзаиморасчеты, ПараметрыПроведения.Реквизиты);
	
	Если Не ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		ТаблицаСтатусовСчетов = СтатусыДокументов.ПодготовитьТаблицуСтатусовОплатыСчетов(
			ПараметрыПроведения.ОплатаСчетов, ПараметрыПроведения.Реквизиты);
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УчетВзаиморасчетов.СформироватьДвиженияПогашениеЗадолженности(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетВзаиморасчетов.СформироватьДвиженияПоПрочимРасчетам(ТаблицаПрочихРасчетов, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияРозничнаяВыручка(ПараметрыПроведения.РозничнаяВыручка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияСуммовыеРазницыРасчетыВУЕ(ТаблицаСуммовыхРазниц,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетНДС.СформироватьДвиженияКурсовыеРазницы(ПараметрыПроведения.Реквизиты,
		ТаблицаВзаиморасчеты, Движения, Отказ);
	
	УчетНДС.СформироватьДвиженияСуммовыеРазницы(ТаблицаСуммовыхРазниц,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетНДС.СформироватьДвиженияРозничнаяВыручка(ПараметрыПроведения.РозничнаяВыручкаНДС,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДенежныхСредств.СформироватьДвиженияВозвратОтПодотчетногоЛицаВВалюте(
		ТаблицаВозвратОтПодотчетногоЛицаВВалюте, Движения, Отказ);
	
	УчетДенежныхСредств.СформироватьДвиженияПрочееПоступление(ПараметрыПроведения.РасшифровкаПлатежаПрочее,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УставныйКапитал.СформироватьДвиженияВзносВУставныйКапитал(ПараметрыПроведения.ВзносВУставныйКапитал,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураТаблицУСН);
	
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкиДвиженийДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияРасчетПереоценкиВалютныхСредств(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетУСН.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияОплатаПокупателя(
		ТаблицаОплатПокупателяИП,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияВыручкаНТТ(
		ПараметрыПроведения.РозничнаяВыручка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	СтатусыДокументов.СформироватьДвиженияОплатаСчетов(
		ПараметрыПроведения.ОплатаСчетов, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	Если Не ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		СтатусыДокументов.СформироватьДвиженияСтатусовДокументов(
			ТаблицаСтатусовСчетов, ПараметрыПроведения.Реквизиты);
		
		ТаблицаЗадачОплатыУставногоКапитала = ВыполнениеЗадачБухгалтера.ЗадачиПоОплатеУставногоКапитала(Организация);
		Если ТаблицаЗадачОплатыУставногоКапитала.Количество() > 0 Тогда 
			СтатусОплатыУставногоКапитала = УставныйКапитал.СтатусОплатыУставногоКапиталаПоДаннымДокумента(
				ПараметрыПроведения.ВзносВУставныйКапитал,
				ПараметрыПроведения.Реквизиты);
			
			ВыполнениеЗадачБухгалтера.ОбновитьСтатусОплатыУставногоКапитала(
				ТаблицаЗадачОплатыУставногоКапитала, СтатусОплатыУставногоКапитала);
		КонецЕсли;
	КонецЕсли;

	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	// Регистрация в последовательности
	РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);
	
	ТаблицаЗадачОплатыУставногоКапитала = ВыполнениеЗадачБухгалтера.ЗадачиПоОплатеУставногоКапитала(Организация);
	Если ТаблицаЗадачОплатыУставногоКапитала.Количество() > 0 Тогда 
		СтатусОплатыУставногоКапитала = УставныйКапитал.СтатусОплатыУставногоКапитала(Ссылка);
		
		ВыполнениеЗадачБухгалтера.ОбновитьСтатусОплатыУставногоКапитала(
			ТаблицаЗадачОплатыУставногоКапитала, СтатусОплатыУставногоКапитала);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата              = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный     = Пользователи.ТекущийПользователь();
	НомерЧекаККМ      = 0;
	ДокументОснование = Неопределено;
	
	УстановитьСчетПриПолученииНаличных();
	
	НалоговыйУчетУСН.ПриКопированииДокумента(ЭтотОбъект, ОбъектКопирования);
	
	Если ОбъектКопирования.БезЗакрывающихДокументов Тогда
		БезЗакрывающихДокументов = УчетКассовымМетодом.БезЗакрывающихДокументов(Организация, Дата, ВидОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
