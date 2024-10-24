﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет поддерживаемый набор суммовых показателей справки-расчета.
// См. соответствующие методы модулей подсистемы СправкиРасчеты.
// Справка-расчет должна поддерживать хотя бы один набор.
// Если поддерживается несколько наборов, то конкретный набор выбирается в форме
// и передается через свойство отчета НаборПоказателейОтчета.
//
// Возвращаемое значение:
//  Массив - номера наборов суммовых показателей.
//
Функция ПоддерживаемыеНаборыСуммовыхПоказателей() Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		СправкиРасчетыКлиентСервер.НомерНабораСуммовыхПоказателейНалоговыйУчет());
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБухгалтерскиеОтчеты

Функция ПолучитьТекстЗаголовка(Контекст) Экспорт 
	
	Возврат СправкиРасчеты.ЗаголовокОтчета(Контекст);
	
КонецФункции

Процедура ПриВыводеЗаголовка(Контекст, КомпоновщикНастроек, Результат) Экспорт
	
	СправкиРасчеты.ВывестиШапкуОтчета(Результат, Контекст, Истина);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	СправкиРасчеты.ДобавитьФиксациюПервойТаблицы(ПараметрыОтчета, МакетКомпоновки);
	
КонецПроцедуры                                          

Процедура ПослеВыводаРезультата(Контекст, Результат) Экспорт
	
	СправкиРасчеты.ОформитьРезультатОтчета(Результат, Контекст);
	
КонецПроцедуры

#КонецОбласти


Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Ложь);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	
	Возврат Результат;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	// Отчет выглядит, что он за полный отчетный период, но все данные для этого выбираются из записей,
	// сформированных регламентной операцией за последний месяц отчетного периода
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		Период = ПараметрыОтчета.КонецПериода;
	Иначе
		// "аварийно" ограничимся случайным периодом, так как выбирать все данные без отбора заведомо бессмысленно
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоМесяца", НачалоМесяца(Период));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецМесяца",  КонецМесяца(Период));
	
	// Параметры для заголовков колонок - СноскаНалоговыйПериод
	СноскаНалоговыйПериод = "";
	СправкиРасчеты.ДополнитьПериодОтчетаПримечанием(СноскаНалоговыйПериод, ПараметрыОтчета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СноскаНалоговыйПериод", СноскаНалоговыйПериод); 
	
	ПоказательДляОпределенияДолиПрибыли = Неопределено;
	НалоговыйУчетОбособленныхПодразделений.ПоказательОпределенияДолиПрибыли(ПоказательДляОпределенияДолиПрибыли, ПараметрыОтчета.Организация, КонецМесяца(Период));
	
	// основной вариант в гл. 25 - численность работников
	ПоказательПерсоналаПредставление = НСтр("ru = 'среднесписочной численности работников'");
	ПоказательПерсоналаКолонка       = НСтр("ru = 'гр.3'");
	ПредложенияИсточникДанных        = Новый Массив;
	Если ПоказательДляОпределенияДолиПрибыли = Перечисления.ПоказателиДляОпределенияДолиПрибыли.РасходыНаОплатуТруда Тогда
		ПоказательПерсоналаПредставление = НСтр("ru = 'расходов на оплату труда'");
		ПоказательПерсоналаКолонка       = НСтр("ru = 'гр.4'");
	ИначеЕсли ПолучитьФункциональнуюОпцию("УчетЗарплатыИКадровВоВнешнейПрограмме") Тогда
		ШаблонИсточникДанных = НСтр("ru = 'Данные о среднесписочной численности подразделений вводятся документом ""%1"".'");
		ПредложенияИсточникДанных.Добавить(СтрШаблон(ШаблонИсточникДанных, Метаданные.Документы.СтатистикаПерсонала.Синоним));
	КонецЕсли;
	
	ШаблонПорядокРасчета = НСтр("ru = 'Доля прибыли определяется исходя из %1 и стоимости амортизируемого имущества.'");
	
	ПредложенияПорядокРасчета = Новый Массив;
	ПредложенияПорядокРасчета.Добавить(СтрШаблон(ШаблонПорядокРасчета, ПоказательПерсоналаПредставление));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПредложенияПорядокРасчета, ПредложенияИсточникДанных);
	ВыбраннаяПолитика = СтрСоединить(ПредложенияПорядокРасчета, Символы.ПС);
	
	Формула = СтрШаблон(НСтр("ru = '(%1 / итог %1 + гр.8 / итог гр.8) / 2'"), ПоказательПерсоналаКолонка);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Формула", Формула);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВыбраннаяПолитика", ВыбраннаяПолитика);
	
	ПараметрыОтчета.ПоказательНУ = Истина;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("НУ");
	
	МассивСумм = Новый Массив;
	МассивСумм.Добавить("СреднесписочнаяЧисленность");
	МассивСумм.Добавить("РасходыПоОплатеТруда");
	МассивСумм.Добавить("СтоимостьОСПрошлыхМесяцев");
	МассивСумм.Добавить("СтоимостьОССледующегоМесяца");
	МассивСумм.Добавить("СтоимостьОС");
	МассивСумм.Добавить("СтоимостьАмортизируемогоИмущества");
	МассивСумм.Добавить("ДоляНалоговойБазы");
	
	Таблица = БухгалтерскиеОтчеты.НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"Доли");
	ГруппировкаПериод = БухгалтерскиеОтчеты.НайтиПоИмени(Таблица.Строки,"ГруппировкаПериодаРасчета");
	ГруппировкаСтатус = БухгалтерскиеОтчеты.НайтиПоИмени(Таблица.Строки,"ГруппировкаСтатусИФНС");
	ГруппировкаИФНС   = БухгалтерскиеОтчеты.НайтиПоИмени(Таблица.Строки,"ГруппировкаИФНС");
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"ПериодРасчета");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"КоличествоМесяцев");
	
	Для Каждого ИмяСумм Из МассивСумм Цикл
			ПодГруппа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяСумм);
		КонецЦикла;
	КонецЦикла;	
	
	ЕстьРасчетыПоЗакрытымПодразделениям = РегистрыСведений.РасчетДолейБазыНалогаНаПрибыль.ЕстьРасчетыПоЗакрытымПодразделениям(
											ПараметрыОтчета.Организация,
											НачалоГода(ПараметрыОтчета.НачалоПериода),
											ПараметрыОтчета.КонецПериода);
											
	Если ЕстьРасчетыПоЗакрытымПодразделениям Тогда										
											
		Группа = ГруппировкаСтатус.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Закрыто");
		Для Каждого ИмяСумм Из МассивСумм Цикл
				ПодГруппа = ГруппировкаСтатус.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
				ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяСумм);
			КонецЦикла;
		КонецЦикла;
		
		ГруппировкаИФНС.Использование = Ложь;
		ГруппировкаИФНС = БухгалтерскиеОтчеты.НайтиПоИмени(Таблица.Строки,"ГруппировкаИФНСПоСтатусам");
		
	Иначе
		ГруппировкаСтатус.Использование = Ложь;
	КонецЕсли;	
	
	Группа = ГруппировкаИФНС.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"РегистрацияВНалоговомОргане");
	Для Каждого ИмяСумм Из МассивСумм Цикл
			ПодГруппа = ГруппировкаИФНС.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяСумм);
		КонецЦикла;
	КонецЦикла;	
		
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.НалоговыйУчетПоНалогуНаПрибыль, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы.Подсистемы.ПростойИнтерфейс.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты, "");
	КонецЦикла;	
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры

#КонецЕсли
