﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ВключитьВозможностьИзменения() Экспорт
	
	Если РучноеИзменение = 0 Тогда
		РучноеИзменение = 1;
	КонецЕсли;
	
КонецПроцедуры

Процедура СнятьСПоддержки() Экспорт
	
	РучноеИзменение = 2;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Страна = Справочники.СтраныМира.Россия Тогда
		
		Если НЕ ЭтоГруппа Тогда
			
			Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СокрЛП(КоррСчет)) Тогда
				
				ШаблонОшибки = НСтр("ru = 'В составе корр.счета банка должны быть только цифры.'");
				ТекстОшибки  = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
					"Поле", "Корректность", НСтр("ru = 'Корр. счет'"),,, ШаблонОшибки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.КоррСчет",, Отказ);
				
			КонецЕсли;
			
			ТекстОшибки = "";
			Если Не БанковскийИдентификационныйКодКорректен(Код, ТекстОшибки) Тогда
				
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Проверка реквизитов. БИК не соответствует требованиям ЦБ РФ'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
					УровеньЖурналаРегистрации.Информация,
					Метаданные.Справочники.Банки,
					,
					ТекстОшибки);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		НепроверяемыеРеквизиты = Новый Массив;
		НепроверяемыеРеквизиты.Добавить("Код");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
		
	КонецЕсли;
	
	Если Не SWIFTКорректен(СокрЛП(СВИФТБИК), ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.СВИФТБИК",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Страна) Тогда
		Страна = Справочники.СтраныМира.Россия;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет корректность номера БИК банка
//
// Параметры:
//  БИК              - Строка - номер БИК проверяемого банка
//  ТекстСообщения   - Строка - в параметр передается текст сообщения об ошибке, если проверка не пройдена.
// 
// Возвращаемое значение:
//  Булево - Результат проверки БИК, если Ложь, тогда БИК некорректный
//
Функция БанковскийИдентификационныйКодКорректен(БИК, ТекстСообщения)
	
	Если ПустаяСтрока(БИК) Тогда
		Возврат Истина;
	КонецЕсли;
	
	БИККорректен = Ложь;
	ТекстСообщения = "";
	Если Не БанковскиеПравила.ПроверитьДлинуБИК(БИК) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'БИК банка должен состоять из 9 цифр'");
	ИначеЕсли Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(БИК) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'В составе БИК банка должны быть только цифры'");
	ИначеЕсли Не БанковскиеПравила.ЭтоБИКБанкаРФ(БИК) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Первые 2 цифры БИК банка должны быть ""00-02 или 04""'");
	Иначе
		БИККорректен = Истина;
	КонецЕсли;
	
	Возврат БИККорректен;
	
КонецФункции

// Проверяет корректность номера SWIFT банка
//
// Параметры:
//  СВИФТБИК          - Строка - номер SWIFT  проверяемого банка
//  ТекстСообщения - Строка - в параметр передается текст сообщения об ошибке, если проверка не пройдена.
// 
// Возвращаемое значение:
//  Булево - Результат проверки SWIFT, если Ложь, тогда SWIFT некорректный
//
Функция SWIFTКорректен(СВИФТБИК, ТекстСообщения)
	
	Если ПустаяСтрока(СВИФТБИК) Тогда
		Возврат Истина;
	КонецЕсли;
	
	SWIFTКорректен = Ложь;
	ТекстСообщения = "";
	Если Не БанковскиеПравила.ПроверитьДлинуSWIFT(СВИФТБИК) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'SWIFT должен состоять из 8 или 11 символов'");
	ИначеЕсли Не БанковскиеПравила.ПроверитьРазрешенныеСимволыSWIFT(СВИФТБИК) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Разрешены только буквы от A до Z и цифры'");
	Иначе
		SWIFTКорректен = Истина;
	КонецЕсли;
	
	Возврат SWIFTКорректен;
	
КонецФункции

#КонецОбласти

#КонецЕсли
