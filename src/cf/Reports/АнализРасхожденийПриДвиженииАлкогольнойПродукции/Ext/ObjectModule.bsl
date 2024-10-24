﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыИС.ИнициализироватьСхемуКомпоновки(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = Форма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "АнализРасхожденийПриДвиженииАлкогольнойПродукцииТТН_ЕГАИС" Тогда
			
			ТипПараметраДокументаТТНВходящая                    = Метаданные.ОпределяемыеТипы.ОснованиеТТНВходящаяЕГАИС.Тип;
			ТипПараметраДокументаТТНИсходящая                   = Метаданные.ОпределяемыеТипы.ОснованиеТТНИсходящаяЕГАИС.Тип;
			ТипПараметраДокументаАктПостановкиНаБаланс          = Метаданные.ОпределяемыеТипы.ОснованиеАктаПостановкиНаБалансЕГАИС.Тип;
			ТипПараметраДокументаАктСписания                    = Метаданные.ОпределяемыеТипы.ОснованиеАктаСписанияЕГАИС.Тип;
			ТипПараметраДокументаЧекВозврат                     = Метаданные.ОпределяемыеТипы.ОснованиеЧекаЕГАИСВозврат.Тип;
			ТипПараметраДокументаЧек                            = Метаданные.ОпределяемыеТипы.ОснованиеЧекаЕГАИС.Тип;
			ТипПараметраДокументаОтчетОПроизводстве             = Метаданные.ОпределяемыеТипы.ОснованиеОтчетОПроизводствеЕГАИС.Тип;
			ТипПараметраДокументаУведомлениеОПланируемомИмпорте = Метаданные.ОпределяемыеТипы.ОснованиеУведомлениеОПланируемомИмпортеЕГАИС.Тип;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	ТТНВходящаяЕГАИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ТТНВходящаяЕГАИС КАК ТТНВходящаяЕГАИС
				|ГДЕ
				|	ТТНВходящаяЕГАИС.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ТТНВходящаяЕГАИС.ДокументОснование В (&ПустыеОснованияТТНВходящая)
				|	
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ТТНИсходящаяЕГАИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ТТНИсходящаяЕГАИС КАК ТТНИсходящаяЕГАИС
				|ГДЕ
				|	ТТНИсходящаяЕГАИС.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ТТНИсходящаяЕГАИС.ДокументОснование В (&ПустыеОснованияТТНИсходящая)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	АктПостановкиНаБалансЕГАИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.АктПостановкиНаБалансЕГАИС КАК АктПостановкиНаБалансЕГАИС
				|ГДЕ
				|	АктПостановкиНаБалансЕГАИС.Ссылка В(&МассивСсылок)
				|И
				|	НЕ АктПостановкиНаБалансЕГАИС.ДокументОснование В (&ПустыеОснованияАктПостановкиНаБаланс)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	АктСписанияЕГАИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.АктСписанияЕГАИС КАК АктСписанияЕГАИС
				|ГДЕ
				|	АктСписанияЕГАИС.Ссылка В(&МассивСсылок)
				|И
				|	НЕ АктСписанияЕГАИС.ДокументОснование В (&ПустыеОснованияАктСписания)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ЧекЕГАИСВозврат.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ЧекЕГАИСВозврат КАК ЧекЕГАИСВозврат
				|ГДЕ
				|	ЧекЕГАИСВозврат.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ЧекЕГАИСВозврат.ДокументОснование В (&ПустыеОснованияЧекВозврат)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ЧекЕГАИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ЧекЕГАИС КАК ЧекЕГАИС
				|ГДЕ
				|	ЧекЕГАИС.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ЧекЕГАИС.ДокументОснование В (&ПустыеОснованияЧек)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ОтчетОПроизводствеЕГАИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ОтчетОПроизводствеЕГАИС КАК ОтчетОПроизводствеЕГАИС
				|ГДЕ
				|	ОтчетОПроизводствеЕГАИС.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ОтчетОПроизводствеЕГАИС.ДокументОснование В (&ПустыеОснованияОтчетОПроизводстве)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	УведомлениеОПланируемомИмпортеЕГАИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.УведомлениеОПланируемомИмпортеЕГАИС КАК УведомлениеОПланируемомИмпортеЕГАИС
				|ГДЕ
				|	УведомлениеОПланируемомИмпортеЕГАИС.Ссылка В(&МассивСсылок)
				|И
				|	НЕ УведомлениеОПланируемомИмпортеЕГАИС.ДокументОснование В (&ПустыеОснованияУведомлениеОПланируемомИмпорте)
				|";
			
			Запрос.УстановитьПараметр("МассивСсылок",    Параметры.ПараметрКоманды);
			
			Запрос.УстановитьПараметр("ПустыеОснованияТТНВходящая",                    ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаТТНВходящая));
			Запрос.УстановитьПараметр("ПустыеОснованияТТНИсходящая",                   ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаТТНИсходящая));
			Запрос.УстановитьПараметр("ПустыеОснованияАктПостановкиНаБаланс",          ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаАктПостановкиНаБаланс));
			Запрос.УстановитьПараметр("ПустыеОснованияАктСписания",                    ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаАктСписания));
			Запрос.УстановитьПараметр("ПустыеОснованияЧекВозврат",                     ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаЧекВозврат));
			Запрос.УстановитьПараметр("ПустыеОснованияЧек",                            ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаЧек));
			Запрос.УстановитьПараметр("ПустыеОснованияОтчетОПроизводстве",             ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаОтчетОПроизводстве));
			Запрос.УстановитьПараметр("ПустыеОснованияУведомлениеОПланируемомИмпорте", ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипПараметраДокументаУведомлениеОПланируемомИмпорте));
			
			МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОснование");
			
			Форма.ФормаПараметры.Отбор.Вставить("ДокументОснование", МассивСсылок);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОтчетыИС.ИнициализироватьСхемуКомпоновки(ЭтотОбъект, Форма);
	
КонецПроцедуры

//Часть запроса отвечающего за данные прикладных документов
//
//Возвращаемое значение:
//   Строка - переопределяемая часть отчета о расхождениях
//
Функция ПереопределяемаяЧасть() Экспорт
	
	Возврат ОтчетыИС.ШаблонПолученияДанныхПрикладныхДокументов() + ОтчетыЕГАИС.ШаблонПолученияКоличестваЕГАИСИзНоменклатуры();
	
КонецФункции

#КонецОбласти

#КонецЕсли