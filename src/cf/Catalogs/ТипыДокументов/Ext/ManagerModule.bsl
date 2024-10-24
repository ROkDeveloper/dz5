﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает тип документа, подтверждающего налогувую льготу по НДС.
//
// Параметры:
//  ВидЭД - ПеречислениеСсылка.ВидыЭД - вид электронного документа, указанный в документе реализации
//
// Возвращаемое значение:
// ТипПодтверждающегоДокумента - СправочникСсылка.ТипыДокументов или Неопределено
//
Функция ТипПодтверждающегоДокументаПоВидуЭД(ВидЭД) Экспорт
	
	Если ВидЭД = Перечисления.ТипыДокументовЭДО.АктВыполненныхРабот
	 ИЛИ ВидЭД = Перечисления.ТипыДокументовЭДО.АктНаПередачуПрав Тогда 
		Возврат Справочники.ТипыДокументов.Акт;
	ИначеЕсли ВидЭД = Перечисления.ТипыДокументовЭДО.ТоварнаяНакладная Тогда 
		Возврат Справочники.ТипыДокументов.Накладная;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик обновления 3.0.51.5
// Устанавливает полное наименование для типов документов.
Процедура УстановитьПолноеНаименование() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТипыДокументов.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.Акт)
	|			ТОГДА &НаименованиеАкт
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.Договор)
	|			ТОГДА &НаименованиеДоговор
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.КорректировочныйСчетФактура)
	|			ТОГДА &НаименованиеКСФ
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.Накладная)
	|			ТОГДА &НаименованиеТоварнаяНакладная
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.ОтчетКомитенту)
	|			ТОГДА &НаименованиеОтчетКомитенту
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.ОтчетОРозничныхПродажах)
	|			ТОГДА &НаименованиеОтчетОРозничныхПродажах
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.СправкаРасчет)
	|			ТОГДА &НаименованиеСправкаРасчет
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.СчетФактура)
	|			ТОГДА &НаименованиеСчетФактура
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.УПД)
	|			ТОГДА &НаименованиеУПД
	|		КОГДА ТипыДокументов.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументов.УКД)
	|			ТОГДА &НаименованиеУКД
	|	КОНЕЦ КАК ПолноеНаименование
	|ИЗ
	|	Справочник.ТипыДокументов КАК ТипыДокументов
	|ГДЕ
	|	ТипыДокументов.ПолноеНаименование = """"
	|	И ТипыДокументов.Предопределенный";
	
	Запрос.УстановитьПараметр("НаименованиеАкт",               НСтр("ru='Акт'"));
	Запрос.УстановитьПараметр("НаименованиеДоговор",           НСтр("ru='Договор'"));
	Запрос.УстановитьПараметр("НаименованиеКСФ",               НСтр("ru='Корректировочный счет-фактура'"));
	Запрос.УстановитьПараметр("НаименованиеТоварнаяНакладная", НСтр("ru='Товарная накладная'"));
	Запрос.УстановитьПараметр("НаименованиеОтчетКомитенту",    НСтр("ru='Отчет комитенту'"));
	Запрос.УстановитьПараметр("НаименованиеОтчетОРозничныхПродажах", НСтр("ru='Отчет о розничных продажах'"));
	Запрос.УстановитьПараметр("НаименованиеСправкаРасчет",     НСтр("ru='Справка-расчет'"));
	Запрос.УстановитьПараметр("НаименованиеСчетФактура",       НСтр("ru='Счет-фактура'"));
	Запрос.УстановитьПараметр("НаименованиеУПД",               НСтр("ru='Универсальный передаточный документ'"));
	Запрос.УстановитьПараметр("НаименованиеУКД",               НСтр("ru='Универсальный корректировочный документ'"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТипДокументаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ТипДокументаОбъект.ПолноеНаименование = Выборка.ПолноеНаименование;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ТипДокументаОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли