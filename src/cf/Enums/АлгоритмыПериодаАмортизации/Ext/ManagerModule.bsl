﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет алгоритм расчета амортизации, используемый в указанном периоде для указанной организации.
//
// Параметры:
//  Период - Дата
//  Организация - СправочникСсылка.Организации
//  ДопускаетсяПрименениеАлгоритмовПБУ6 - Булево - Истина, если применение алгоритма на основе ПБУ 6 допустимо
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.АлгоритмыПериодаАмортизации - решение, принятое в соответствии с п.33 ФСБУ 6;
//                                                 - ПустаяСсылка, если применяется алгоритм на основе ПБУ 6
//                                                   (пустая ссылка может вернуться, если применение алгоритмов
//                                                   на основе ПБУ 6 допускается).
//
Функция АлгоритмРасчетаАмортизации(Период, Организация, ДопускаетсяПрименениеАлгоритмовПБУ6 = Истина) Экспорт
	
	Если УчетОС.ПрименяетсяПБУ6(Период, Организация) Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	УстановленныйАлгоритм = УчетнаяПолитика.АлгоритмПериодаАмортизации(Период, Организация);
	
	Если ДопускаетсяПрименениеАлгоритмовПБУ6
		И УстановленныйАлгоритм = СМесяцаСледующегоПослеПризнания
		И Константы.КонецПримененияАлгоритмовАмортизацииПБУ6.Получить() > Период Тогда
		// совместимость с ПБУ 6
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	Возврат УстановленныйАлгоритм;
	
КонецФункции

// Определяет, поддерживается ли выбор алгоритма конфигурацией (тарифом)
// 
// Возвращаемое значение:
//  Булево - Ложь, если не поддерживается
//
Функция ПоддерживаетсяВыборАлгоритма() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("РасширенныйФункционал");
	
КонецФункции

// Определяет значение по умолчанию.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.АлгоритмыПериодаАмортизации
//
Функция ЗначениеПоУмолчанию() Экспорт
	
	Возврат Метаданные.РегистрыСведений.УчетнаяПолитика.Ресурсы.ПериодАмортизации.ЗначениеЗаполнения;
	
КонецФункции

// Определяет, нужно ли при расчете амортизации в бухгалтерском учете
// задерживать начало и конец амортизации на месяц, следующий за признанием и списанием объекта.
//
// Параметры:
//  Период      - Дата
//  Организация - СправочникСсылка.Организации
// 
// Возвращаемое значение:
//  Булево - Истина, если нужно задерживать.
//           Ложь, если амортизация начинается со дня признания.
//
Функция ЗадерживатьАмортизацию(Период, Организация) Экспорт
	
	Возврат АлгоритмРасчетаАмортизации(Период, Организация) <> СДатыПризнания;
	
КонецФункции

// Определяет дату отказа от учетной политики,
// предписывающей в бухгалтерском учете при расчете амортизации задерживать начало и конец амортизации
// на месяц, следующий за признанием и списанием объекта.
// Такая учетная политика считалась обязательной, когда применялось ПБУ 6, но допускается к применению и позднее.
//
// Параметры:
//  Период      - Дата
//  Организация - СправочникСсылка.Организации
// 
// Возвращаемое значение:
//  Неопределено - задержка применяется в запрошенную дату
//  Дата - задержка прекращена в возвращенную дату
//
Функция КонецЗадержкиАмортизации(Период, Организация) Экспорт
	
	// Обращения не должны быть частыми, поэтому кеширование не используется
	Если Не ПоддерживаетсяВыборАлгоритма() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если УчетОС.ПрименяетсяПБУ6(Период, Организация) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", БухгалтерскийУчетПереопределяемый.ГоловнаяОрганизация(Организация));
	Запрос.УстановитьПараметр("Период",              Период);
	
	// Учтем вариант, когда задержка не используется изначально
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетнаяПолитика.Период КАК Период
	|ИЗ
	|	РегистрСведений.УчетнаяПолитика КАК УчетнаяПолитика
	|ГДЕ
	|	УчетнаяПолитика.Организация = &ГоловнаяОрганизация
	|	И УчетнаяПолитика.ПериодАмортизации <> ЗНАЧЕНИЕ(Перечисление.АлгоритмыПериодаАмортизации.СДатыПризнания)
	|	И УчетнаяПолитика.Период <= &Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ПериодЗадержки = Выборка.Период;
	Иначе
		ПериодЗадержки = '0001-01-01';
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Период", ПериодЗадержки);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетнаяПолитика.Период КАК Период
	|ИЗ
	|	РегистрСведений.УчетнаяПолитика КАК УчетнаяПолитика
	|ГДЕ
	|	УчетнаяПолитика.Организация = &ГоловнаяОрганизация
	|	И УчетнаяПолитика.ПериодАмортизации = ЗНАЧЕНИЕ(Перечисление.АлгоритмыПериодаАмортизации.СДатыПризнания)
	|	И УчетнаяПолитика.Период > &Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Период;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
