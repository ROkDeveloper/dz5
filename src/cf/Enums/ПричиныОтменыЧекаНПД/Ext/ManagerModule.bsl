﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает код причины отмены чека, соответствующий значению перечисления.
//
// Параметры:
//   Причина - ПеречислениеСсылка.ПричиныОтменыЧекаНПД - причина отмены чека.
//
// Возвращаемое значение:
//   Строка - код причины отмены чека.
//
Функция КодПричины(Причина) Экспорт
	
	Значение = КодыПричинОтмены().Получить(Причина);
	
	Возврат ?(Значение <> Неопределено, Значение, "");
	
КонецФункции

// Возвращает причину отмены чека, соответствующую коду причины отмены чека.
//
// Параметры:
//   КодПричины - Строка - код причины отмены чека.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ПричиныОтменыЧекаНПД - причина отмены чека.
//
Функция ПричинаПоКоду(КодПричины) Экспорт
	
	Для Каждого КлючИЗначение Из КодыПричинОтмены() Цикл
		Если ВРег(КлючИЗначение.Значение) = ВРег(КодПричины) Тогда
			Возврат КлючИЗначение.Ключ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПустаяСсылка();
	
КонецФункции

// Возвращает представление причины отмены чека для переданного значения перечисления.
//
// Параметры:
//   Причина - ПеречислениеСсылка.ПричиныОтменыЧекаНПД - причина отмены чека.
//
// Возвращаемое значение:
//   Строка - представление причины отмены чека.
//
Функция ПредставлениеПричины(Причина) Экспорт
	
	Значение = ПредставленияПричинОтмены().Получить(Причина);
	
	Возврат ?(Значение <> Неопределено, Значение, "");
	
КонецФункции

// Возвращает причину отмены чека, соответствующую переданному представлению причины отмены чека.
//
// Параметры:
//   Представление - Строка - представление причины отмены чека.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ПричиныОтменыЧекаНПД - причина отмены чека.
//
Функция ПричинаПоПредставлению(Представление) Экспорт
	
	Для Каждого КлючИЗначение Из ПредставленияПричинОтмены() Цикл
		Если ВРег(КлючИЗначение.Значение) = ВРег(Представление) Тогда
			Возврат КлючИЗначение.Ключ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодыПричинОтмены()
	
	СоответствиеЗначений = Новый Соответствие;
	
	СоответствиеЗначений.Вставить(ВозвратСредств, "REFUND");
	СоответствиеЗначений.Вставить(ЧекСформированОшибочно, "REGISTRATION_MISTAKE");
	
	Возврат СоответствиеЗначений;
	
КонецФункции

Функция ПредставленияПричинОтмены()
	
	СоответствиеЗначений = Новый Соответствие;
	
	СоответствиеЗначений.Вставить(ВозвратСредств, НСтр("ru = 'Возврат средств'"));
	СоответствиеЗначений.Вставить(ЧекСформированОшибочно, НСтр("ru = 'Чек сформирован ошибочно'"));
	
	Возврат СоответствиеЗначений;
	
КонецФункции

#КонецОбласти

#КонецЕсли
