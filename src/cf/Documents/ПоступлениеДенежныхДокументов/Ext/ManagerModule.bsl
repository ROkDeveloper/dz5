﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 7, 0);
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

// ПОДГОТОВКА ПАРАМЕТРОВ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ, ДоговорДляОтложенногоПроведения = Неопределено) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	ЭтоОтложенноеПроведение = ЗначениеЗаполнено(ДоговорДляОтложенногоПроведения);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	Реквизиты.ВалютаДокумента КАК ВалютаДокумента,
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Реквизиты.ДоговорКонтрагента.ВидДоговора КАК ВидДоговора,
	|	Реквизиты.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	Реквизиты.ДоговорКонтрагента.УчетАгентскогоНДС КАК УчетАгентскогоНДС,
	|	Реквизиты.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	|	Реквизиты.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	Реквизиты.ВидОперации КАК ВидОперации,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом КАК СчетУчетаРасчетовСКонтрагентом,
	|	Реквизиты.СчетУчетаДенежныхДокументов КАК СчетУчетаДенежныхДокументов,
	|	Реквизиты.СубконтоКт1,
	|	Реквизиты.СубконтоКт2,
	|	Реквизиты.СубконтоКт3
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ПоступлениеДенежныхДокументов КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Период,
	|	Реквизиты.Организация,
	|	Реквизиты.ВалютаДокумента,
	|	Реквизиты.ВидОперации
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	Результат = Запрос.Выполнить();
	Реквизиты = ОбщегоНазначенияБПВызовСервера.ПолучитьСтруктуруИзРезультатаЗапроса(Результат);
	
	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	// Коэффициенты пересчета сумм
	// - из валюты документа в рубли
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	Если Реквизиты.ВалютаДокумента = ВалютаРеглУчета Тогда
		КоэффициентРуб = 1;
	Иначе
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Реквизиты.ВалютаДокумента, Реквизиты.Период);
		КоэффициентРуб = ?(СтруктураКурса.Кратность = 0, 0, СтруктураКурса.Курс / СтруктураКурса.Кратность);
	КонецЕсли;
	
	Реквизиты.Вставить("ЭтоОтложенноеПроведение",          ЭтоОтложенноеПроведение);
	Реквизиты.Вставить("ИспользуетсяОтложенноеПроведение",
		Реквизиты.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПоставщика
		И ПроведениеСервер.ИспользуетсяОтложенноеПроведение(Реквизиты.Организация, Реквизиты.Период));
	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРеглУчета);
	Запрос.УстановитьПараметр("КоэффициентРуб",                 КоэффициентРуб);
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
		+ ТекстЗапросаТаблицыДокумента(НомераТаблиц)
		+ ТекстЗапросаЗачетАвансов(НомераТаблиц)
		+ ТекстЗапросаПоступлениеДенежныхДокументов(НомераТаблиц)
		+ ТекстЗапросаРегистрацияОтложенныхРасчетовСКонтрагентами(НомераТаблиц, ПараметрыПроведения, Реквизиты);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.ВидОперации,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ВалютаДокумента,
	|	ЗНАЧЕНИЕ(Перечисление.СпособыЗачетаАвансов.Автоматически) КАК СпособЗачетаАвансов,
	|	ЛОЖЬ КАК УчитыватьЗадолженностьУСН,
	|	ЛОЖЬ КАК УчитыватьЗадолженностьУСНПатент,
	|	ЛОЖЬ КАК ДеятельностьНаПатенте,
	|	ЛОЖЬ КАК ДеятельностьНаТорговомСборе,
	|	""Поступление"" КАК НаправлениеДвижения,
	|	ЛОЖЬ КАК ЭтоВозврат,
	|	ИСТИНА КАК НДСВключенВСтоимость,
	|	Реквизиты.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	|	Реквизиты.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	Реквизиты.УчетАгентскогоНДС КАК УчетАгентскогоНДС
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаТаблицыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаДенежныеДокументы", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДенежныеДокументы.Ссылка,
	|	ДенежныеДокументы.НомерСтроки,
	|	ДенежныеДокументы.ДенежныйДокумент,
	|	ДенежныеДокументы.Количество,
	|	ДенежныеДокументы.Сумма КАК СуммаВзаиморасчетов,
	|	ВЫРАЗИТЬ(ДенежныеДокументы.Сумма * &КоэффициентРуб КАК ЧИСЛО(15, 2)) КАК СуммаРуб
	|ПОМЕСТИТЬ ТаблицаДенежныеДокументы
	|ИЗ
	|	Документ.ПоступлениеДенежныхДокументов.ДенежныеДокументы КАК ДенежныеДокументы
	|ГДЕ
	|	ДенежныеДокументы.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаЗачетАвансов(НомераТаблиц)
	
	НомераТаблиц.Вставить("ЗачетАвансов", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК ДокументРасчетов,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом КАК СчетРасчетов,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом КАК СчетАвансов,
	|	Реквизиты.Контрагент,
	|	Реквизиты.ДоговорКонтрагента,
	|	Реквизиты.ВидДоговора КАК ВидДоговора,
	|	Реквизиты.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ЛОЖЬ КАК РасчетыВУсловныхЕдиницах,
	|	ЛОЖЬ КАК УчетАгентскогоНДС,
	|	ВЫБОР
	|		КОГДА Реквизиты.ВалютаВзаиморасчетов = &ВалютаРегламентированногоУчета
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК РасчетыВВалюте,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	СУММА(ТаблицаДенежныеДокументы.СуммаВзаиморасчетов) КАК СуммаВзаиморасчетов,
	|	СУММА(ТаблицаДенежныеДокументы.СуммаРуб) КАК СуммаРуб,
	|	0 КАК СуммаВзаиморасчетовКомитента,
	|	0 КАК СуммаВзаиморасчетовЕНВД,
	|	0 КАК СуммаВзаиморасчетовПатент,
	|	0 КАК СуммаВзаиморасчетовТорговыйСбор
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДенежныеДокументы КАК ТаблицаДенежныеДокументы
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Реквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПоставщика)
	|
	|СГРУППИРОВАТЬ ПО
	|	Реквизиты.Ссылка,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом,
	|	Реквизиты.Контрагент,
	|	Реквизиты.ДоговорКонтрагента,
	|	Реквизиты.ПодразделениеОрганизации,
	|	Реквизиты.ВидДоговора,
	|	Реквизиты.ВалютаВзаиморасчетов,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаПоступлениеДенежныхДокументов(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизитыДокумента", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ПоступлениеДенежныхДокументов",      НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.СчетУчетаДенежныхДокументов КАК СчетУчета,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	ВЫБОР
	|		КОГДА Реквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПодотчетногоЛица)
	|			ТОГДА ВЫБОР
	|					КОГДА Реквизиты.СчетУчетаДенежныхДокументов.Валютный
	|						ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицамиВал)
	|					ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами)
	|				КОНЕЦ
	|		ИНАЧЕ Реквизиты.СчетУчетаРасчетовСКонтрагентом
	|	КОНЕЦ КАК КорСчет,
	|	Реквизиты.ПодразделениеОрганизации КАК КорПодразделение,
	|	ВЫБОР
	|		КОГДА Реквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПрочееПоступление)
	|			ТОГДА Реквизиты.СубконтоКт1
	|		ИНАЧЕ Реквизиты.Контрагент
	|	КОНЕЦ КАК КорСубконто1,
	|	ВЫБОР
	|		КОГДА Реквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПрочееПоступление)
	|			ТОГДА Реквизиты.СубконтоКт2
	|		КОГДА Реквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПоставщика)
	|			ТОГДА Реквизиты.ДоговорКонтрагента
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК КорСубконто2,
	|	ВЫБОР
	|		КОГДА Реквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПрочееПоступление)
	|			ТОГДА Реквизиты.СубконтоКт3
	|		КОГДА Реквизиты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПоставщика)
	|			ТОГДА Реквизиты.Ссылка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК КорСубконто3
	|ПОМЕСТИТЬ РеквизитыДокумента
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДенежныеДокументы.НомерСтроки,
	|	РеквизитыДокумента.СчетУчета,
	|	РеквизитыДокумента.Подразделение,
	|	ДенежныеДокументы.ДенежныйДокумент,
	|	ДенежныеДокументы.Количество,
	|	ДенежныеДокументы.СуммаРуб КАК СуммаБУ,
	|	ДенежныеДокументы.СуммаВзаиморасчетов КАК ВалютнаяСумма,
	|	РеквизитыДокумента.КорСчет,
	|	РеквизитыДокумента.КорПодразделение,
	|	РеквизитыДокумента.КорСубконто1,
	|	РеквизитыДокумента.КорСубконто2,
	|	РеквизитыДокумента.КорСубконто3
	|ИЗ
	|	ТаблицаДенежныеДокументы КАК ДенежныеДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РеквизитыДокумента КАК РеквизитыДокумента
	|		ПО (ИСТИНА)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДенежныеДокументы.НомерСтроки";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

// ОТЛОЖЕННОЕ ПРОВЕДЕНИЕ

Функция ТекстЗапросаРегистрацияОтложенныхРасчетовСКонтрагентами(НомераТаблиц, ПараметрыПроведения, Реквизиты)

	Если Не Реквизиты.ИспользуетсяОтложенноеПроведение
		ИЛИ Реквизиты.ЭтоОтложенноеПроведение Тогда
		ПараметрыПроведения.Вставить("РасчетыСКонтрагентамиОтложенноеПроведение", Неопределено);
		Возврат "";
	КонецЕсли;

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Реквизиты.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	Реквизиты.ВидДоговора КАК ВидДоговора,
	|	Реквизиты.Период КАК Дата
	|ИЗ
	|	Реквизиты КАК Реквизиты";

	НомераТаблиц.Вставить("РасчетыСКонтрагентамиОтложенноеПроведение", НомераТаблиц.Количество());
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Процедура ОбработкаОтложенногоПроведения(Параметры, Отказ) Экспорт
	
	ПараметрыПроведения = ПодготовитьПараметрыПроведения(
		Параметры.Регистратор,
		Отказ,
		Параметры.ДоговорКонтрагента);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	

	ТаблицаВзаиморасчетов = УчетВзаиморасчетовОтложенноеПроведение.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		Параметры,
		ПараметрыПроведения.ЗачетАвансов, Неопределено,
		ПараметрыПроведения.Реквизиты, Отказ);

	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура("ТаблицаРасчетов", ТаблицаВзаиморасчетов);

	УчетВзаиморасчетовОтложенноеПроведение.СформироватьДвиженияЗачетАвансов(
		Параметры,
		ТаблицаВзаиморасчетов,
		ПараметрыПроведения.Реквизиты,
		Отказ);

	УчетВзаиморасчетовОтложенноеПроведение.СформироватьДвиженияУСН(
		Параметры,
		СтруктураТаблицУСН);

КонецПроцедуры

// ПРОЦЕДУРЫ ФОРМИРОВАНИЯ ДВИЖЕНИЙ

Процедура СформироватьДвиженияПоступлениеДенежныхДокументов(ТаблицаПоступлениеДенежныхДокументов, ТаблицаРеквизиты, Движения, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(ТаблицаПоступлениеДенежныхДокументов) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыПоступлениеДенежныхДокументов(ТаблицаПоступлениеДенежныхДокументов, ТаблицаРеквизиты);	
	Реквизиты = Параметры.Реквизиты[0];
	
	Для каждого СтрокаТаблицы Из Параметры.ПоступлениеДенежныхДокументов Цикл
		
		Проводка = Движения.Хозрасчетный.Добавить();
		
		Проводка.Период      = Реквизиты.Период;
		Проводка.Организация = Реквизиты.Организация;
		Проводка.Содержание  = "Поступление денежных документов "
			+ "по вх.д." + Реквизиты.НомерВходящегоДокумента + " от " + Формат(Реквизиты.ДатаВходящегоДокумента, "ДЛФ=Д");
		
		Проводка.СчетДт  = СтрокаТаблицы.СчетУчета;
		
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт,
			"ДенежныеДокументы", СтрокаТаблицы.ДенежныйДокумент);
		
		СвойстваСчетаДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
		
		Если СвойстваСчетаДт.Количественный Тогда
			Проводка.КоличествоДт = СтрокаТаблицы.Количество;
		КонецЕсли;
		Если СвойстваСчетаДт.Валютный Тогда
			Проводка.ВалютаДт = Реквизиты.ВалютаДокумента;
			Проводка.ВалютнаяСуммаДт = СтрокаТаблицы.ВалютнаяСумма;
		КонецЕсли;
		Если СвойстваСчетаДт.УчетПоПодразделениям Тогда
			Проводка.ПодразделениеДт = СтрокаТаблицы.Подразделение;
		КонецЕсли;
		
		Проводка.СчетКт  = СтрокаТаблицы.КорСчет;
		
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт,
			1, СтрокаТаблицы.КорСубконто1);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт,
			2, СтрокаТаблицы.КорСубконто2);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт,
			3, СтрокаТаблицы.КорСубконто3);
		
		СвойстваСчетаКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
		
		Если СвойстваСчетаКт.Количественный Тогда
			Проводка.КоличествоКт = СтрокаТаблицы.Количество;
		КонецЕсли;
		Если СвойстваСчетаКт.Валютный Тогда
			Проводка.ВалютаКт = Реквизиты.ВалютаДокумента;
			Проводка.ВалютнаяСуммаКт = СтрокаТаблицы.ВалютнаяСумма;
		КонецЕсли;
		Если СвойстваСчетаКт.УчетПоПодразделениям Тогда
			Проводка.ПодразделениеКт = СтрокаТаблицы.КорПодразделение;
		КонецЕсли;
		
		Проводка.Сумма = СтрокаТаблицы.СуммаБУ;
		
	КонецЦикла;
	
	Движения.Хозрасчетный.Записывать = Истина;
	
КонецПроцедуры

Функция ПодготовитьПараметрыПоступлениеДенежныхДокументов(ТаблицаПоступлениеДенежныхДокументов, ТаблицаРеквизиты)
	
	Параметры = Новый Структура;
	
	// Подготовка таблицы Параметры.ПоступлениеДенежныхДокументов
	
	СписокОбязательныхКолонок = ""
		+ "НомерСтроки,"       // <Число,6,0> - номер строки ТЧ ДенежныеДокументы
		+ "СчетУчета,"         // <ПланСчетовСсылка.Хозрасчетный> - счет учета денежного документа
		+ "Подразделение,"     // <Ссылка на справочник подразделений> - подразделение в проводке для счета учета денежного документа
		+ "ДенежныйДокумент,"  // <СправочникСсылка.ДенежныеДокументы>
		+ "Количество,"        // <Число,15,3> - количество поступивших денежных документов
		+ "СуммаБУ,"           // <Число,15,2> - сумма в рублях поступивших денежных документов
		+ "ВалютнаяСумма,"     // <Число,15,2> - сумма поступивших денежных документов в валюте документа
		+ "КорСчет,"           // <ПланСчетовСсылка.Хозрасчетный> - счет, корреспондирующий в проводке по поступлению со счетом учета денежного документа
		+ "КорПодразделение,"  // <Ссылка на справочник подразделений> - подразделение в проводке для кор.счета
		+ "КорСубконто1,"      // <Характеристика.ВидыСубконтоХозрасчетные> - субконто 1 в проводке для кор.счета
		+ "КорСубконто2,"      // <Характеристика.ВидыСубконтоХозрасчетные> - субконто 2 в проводке для кор.счета
		+ "КорСубконто3";      // <Характеристика.ВидыСубконтоХозрасчетные> - субконто 3 в проводке для кор.счета
	
	Параметры.Вставить("ПоступлениеДенежныхДокументов", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаПоступлениеДенежныхДокументов, СписокОбязательныхКолонок));
	
	// Подготовка таблицы Параметры.Реквизиты
	
	СписокОбязательныхКолонок = ""
		+ "Период,"
		+ "Организация,"
		+ "ВалютаДокумента,"
		+ "НомерВходящегоДокумента,"
		+ "ДатаВходящегоДокумента";
	
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));
	
	Возврат Параметры;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приходный ордер
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриходныйОрдер";
	КомандаПечати.Представление = НСтр("ru = 'Приходный ордер'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Поступление денежных документов""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

// Формирует и возвращает текст запроса для выборки данных,
// необходимых для формирования печатной формы
Функция ПолучитьТекстЗапросаДляФормированияПечатнойФормыПриходногоОрдера()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Док.Ссылка,
	|	Док.Номер,
	|	Док.ВидОперации,
	|	Док.Дата,
	|	Док.ПринятоОт КАК ПринятоОт,
	|	Док.Организация,
	|	ВЫБОР
	|		КОГДА Док.ПодразделениеОрганизации.НаименованиеПолное = """"
	|			ТОГДА Док.ПодразделениеОрганизации.Наименование
	|		ИНАЧЕ Док.ПодразделениеОрганизации.НаименованиеПолное
	|	КОНЕЦ КАК ПредставлениеПодразделения,
	|	Док.СуммаДокумента,
	|	Док.ВалютаДокумента,
	|	Док.ДенежныеДокументы.(
	|		НомерСтроки КАК НомерСтроки,
	|		ДенежныйДокумент КАК ДенежныйДокумент,
	|		ПРЕДСТАВЛЕНИЕ(Док.ДенежныеДокументы.ДенежныйДокумент) КАК ДенежныйДокументПредставление,
	|		Количество КАК Количество,
	|		Сумма КАК Сумма
	|	)
	|ИЗ
	|	Документ.ПоступлениеДенежныхДокументов КАК Док
	|ГДЕ
	|	Док.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Док.Дата,
	|	Док.Ссылка,
	|	Док.ДенежныеДокументы.НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Функция формирует табличный документ с печатной формой расходного ордера на выдачу денежных документов
//
// Возвращаемое значение:
//  Табличный документ - печатная форма расходного ордера
//
Функция ПечатьПоступлениеДенежныхДокументов(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб         = Истина;
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПоступлениеДенежныхДокументов_ПриходныйОрдер";
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = ПолучитьТекстЗапросаДляФормированияПечатнойФормыПриходногоОрдера();
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий() Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПоступлениеДенежныхДокументов.ПФ_MXL_ПриходныйОрдер");
		
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, "Приходный ордер");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Организация");
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата);
		ОбластьМакета.Параметры.ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(
			СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подразделение");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПринятоОт");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		ТаблицаДенежныхДокументов = Шапка.ДенежныеДокументы.Выгрузить();
		Для каждого СтрокаДенежногоДокумента Из ТаблицаДенежныхДокументов Цикл
			ОбластьМакета.Параметры.Заполнить(СтрокаДенежногоДокумента);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		// Вывести Итого
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ТаблицаДенежныхДокументов.Итог("Сумма"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего наименований " + ТаблицаДенежныхДокументов.Количество()
			+ ", на сумму " + ОбщегоНазначенияБПВызовСервера.ФорматСумм(Шапка.СуммаДокумента, Шапка.ВалютаДокумента);
		ОбластьМакета.Параметры.СуммаПрописью =
			ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// В табличном документе зададим имя области, в которую был
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент,
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Проверяем, нужно ли для макета ПлатежноеПоручение формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриходныйОрдер") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПриходныйОрдер", "Приходный ордер",
			ПечатьПоступлениеДенежныхДокументов(МассивОбъектов, ОбъектыПечати), , "Документ.ПоступлениеДенежныхДокументов.ПФ_MXL_ПриходныйОрдер");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ ИБ

// Для документов, в которых настройка УСН отредактирована пользователем вручную, устанавливается признак ручной корректировки движений
//
Процедура ОбработатьРучнуюНастройкуКУДиР() Экспорт

	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеДенежныхДокументов.Ссылка
	|ИЗ
	|	Документ.ПоступлениеДенежныхДокументов КАК ПоступлениеДенежныхДокументов
	|ГДЕ
	|	ПоступлениеДенежныхДокументов.УдалитьРучнаяНастройка_УСН"	
	;	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ВыборкаДокументы = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДокументы.Следующий() Цикл
			
			НачатьТранзакцию();
			
			Попытка
				
				ДокументОбъект = ВыборкаДокументы.Ссылка.ПолучитьОбъект();
				ДокументОбъект.РучнаяКорректировка = Истина;
				ДокументОбъект.УдалитьРучнаяНастройка_УСН = Ложь;
				
				// Запись обработанного объекта.
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
				
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось установить признак ручной корректировки движений у документа: %1 по причине:
						|%2'"),
						ВыборкаДокументы.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
					Метаданные.Документы.ПоступлениеДенежныхДокументов, ВыборкаДокументы.Ссылка, ТекстСообщения);
					
				ОтменитьТранзакцию();
				
			КонецПопытки;
			
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли