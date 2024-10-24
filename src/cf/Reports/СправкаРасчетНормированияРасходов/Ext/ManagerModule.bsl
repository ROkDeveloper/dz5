﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет поддерживаемый набор суммовых показателей справки-расчета.
// См. соответствующие методы модулей подсистемы СправкиРасчеты.
// Справка-расчет должна поддерживать хотя бы один набор.
// Если поддерживается несколько наборов, то конкретный набор выбирается в форме
// и передается через свойство отчета НаборПоказателейОтчета.
//
// Возвращаемое значение:
//  Массив из Число - номера наборов суммовых показателей.
//
Функция ПоддерживаемыеНаборыСуммовыхПоказателей() Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		СправкиРасчетыКлиентСервер.НомерНабораСуммовыхПоказателейНалоговыйУчет());
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиБухгалтерскиеОтчеты

Функция ПолучитьТекстЗаголовка(Контекст) Экспорт 
	
	Возврат СправкиРасчеты.ЗаголовокОтчета(Контекст);
	
КонецФункции

Процедура ПриВыводеЗаголовка(Контекст, КомпоновщикНастроек, Результат) Экспорт
	
	СправкиРасчеты.ВывестиШапкуОтчета(Результат, Контекст, Истина);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(Контекст, МакетКомпоновки) Экспорт
	
	СправкиРасчеты.ДобавитьФиксациюПервойТаблицы(Контекст, МакетКомпоновки);
	
	НайтиНастраиваемыйМакетКомментарий(Контекст, МакетКомпоновки);
		
КонецПроцедуры

Процедура ПослеВыводаРезультата(Контекст, Результат) Экспорт
	
	СчетчикПримечаний = СправкиРасчеты.ОформитьРезультатОтчета(Результат, Контекст);
	
	Если Контекст.Свойство("ВыводитьКомментарийСтрахование") Тогда
		ТекстПримечания = НСтр("ru = 'Предельный размер расходов на страхование определяется с учетом периода действия договоров страхования.'");
		СправкиРасчеты.ДобавитьПримечание(Результат, ТекстПримечания, СчетчикПримечаний);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",           Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",           Истина);
	Результат.Вставить("ИспользоватьПередВыводомЭлементаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",               Истина);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",              Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);

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
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоМесяца(ПараметрыОтчета.НачалоПериода));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода",  КонецМесяца(Период));
	
	// Параметр для заголовков колонок - СноскаНалоговыйПериод
	// Текст примечания выводится в СправкиРасчеты.ОформитьРезультатОтчета()
	СноскаНалоговыйПериод = "";
	СправкиРасчеты.ДополнитьПериодОтчетаПримечанием(СноскаНалоговыйПериод, ПараметрыОтчета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СноскаНалоговыйПериод", СноскаНалоговыйПериод);
	
	ПараметрыОтчета.ПоказательНУ = Истина;
	
	МассивСумм = Новый Массив;
	МассивСумм.Добавить("ЗатратыГод");
	МассивСумм.Добавить("СуммаБазы");
	МассивСумм.Добавить("ПредельныйРазмер");
	МассивСумм.Добавить("РасходыГод");
	МассивСумм.Добавить("РасходыПрошлыеМесяцы");
	МассивСумм.Добавить("РасходыМесяц");
	МассивСумм.Добавить("Доля");
	МассивСумм.Добавить("РазницыГод");
	МассивСумм.Добавить("РазницыПрошлыеМесяцы");
	МассивСумм.Добавить("РазницыМесяц");
	
	Таблица = БухгалтерскиеОтчеты.НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура, "Нормирование");
	ГруппировкаВидРасхода   = БухгалтерскиеОтчеты.НайтиПоИмени(Таблица.Строки, "ГруппировкаВидРасхода");
	ГруппировкаПериод = БухгалтерскиеОтчеты.НайтиПоИмени(Таблица.Строки, "ГруппировкаПериодаРасчета");
	
	Группа = ГруппировкаВидРасхода.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "ВидОперации");
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Период");
	
	Для Каждого ИмяСумм Из МассивСумм Цикл
		ПодГруппа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяСумм);

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

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеОтчета.ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОтчета.Объект.СхемаКомпоновкиДанных));
	
	// Массив значений полей строки, ячейка которой расшифровывается, отборы отчета, а также значение
	// расшифровываемого ресурса.
	ПоляРасшифровки = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(
		Расшифровка, ДанныеОтчета.ДанныеРасшифровки, КомпоновщикНастроек, Истина);
	
	ЗначенияПолейРасшифровки = Новый Структура;
	Для Каждого ПолеРасшифровки Из ПоляРасшифровки Цикл
		
		Если ТипЗнч(ПолеРасшифровки) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			ЗначенияПолейРасшифровки.Вставить(ПолеРасшифровки.Поле, ПолеРасшифровки.Значение);
		КонецЕсли;
	КонецЦикла;
	
	// Проверим возможность расшифровки: расшифровка возможна только для трех полей,
	// а также должна быть заполнена организация.
	Если Не ЗначенияПолейРасшифровки.Свойство("ЗатратыГод")
		И Не ЗначенияПолейРасшифровки.Свойство("ПредельныйРазмер")
		И Не ЗначенияПолейРасшифровки.Свойство("СуммаБазы") Тогда
			
		Возврат;
		
	КонецЕсли;
	
	// Расшифровывать поля "ПредельныйРазмер" и "СуммаБазы" можно только если расшифровывается строка, а не итоги
	// (в расшифровке присутствует поле "ВидОперации"), так как база для разных видов операции рассчитывается по-разному.
	Если (ЗначенияПолейРасшифровки.Свойство("ПредельныйРазмер") Или ЗначенияПолейРасшифровки.Свойство("СуммаБазы"))
		И Не ЗначенияПолейРасшифровки.Свойство("ВидОперации") Тогда
			
		Возврат;
		
	КонецЕсли;

	ОтчетОбъект = ДанныеОтчета.Объект;
	НастройкиРасшифровки = Новый Структура;
		
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;

	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Организация", ОтчетОбъект.Организация);
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("НачалоПериода", НачалоГода(ОтчетОбъект.НачалоПериода));
	
	Если ЗначенияПолейРасшифровки.Свойство("Период") Тогда
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КонецПериода", КонецМесяца(ЗначенияПолейРасшифровки.Период));
	Иначе
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КонецПериода", КонецМесяца(ОтчетОбъект.КонецПериода));
	КонецЕсли;
	
	// Периодичность месяц
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Периодичность", 9);
	
	ЭтоРасшифровкаБазы = ЗначенияПолейРасшифровки.Свойство("СуммаБазы") Или ЗначенияПолейРасшифровки.Свойство("ПредельныйРазмер");
	
	// Расшифровка базы расходов на страхование может выполняться только по всей организации в целом из-за особенностей
	// алгоритма расчета. В отчете-расшифровке базы нормирования для таких расходов из списка организаций исключаются обособленные подразделения.
	ИсключитьФилиалы = Ложь;
	Если ЗначенияПолейРасшифровки.Свойство("ЗатратыГод") Тогда
				
		Счета = Новый СписокЗначений;
		Счета.ЗагрузитьЗначения(БухгалтерскийУчет.СформироватьМассивСубсчетов(НалоговыйУчет.ПолучитьМассивСчетовУчетаРасходов()));

		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Счета", Счета);
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ЗаголовокОтчета", НСтр("ru = 'Нормируемые расходы'"));

		ИмяОтчета = "РасходыПоСтатьямЗатрат";

		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ЭтоРасшифровкаНормируемыхРасходов", Истина);
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПоКорСчетам", Ложь);
	
		Отбор = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
		Отбор.ИдентификаторПользовательскойНастройки = "Отбор";
		
		Если ЗначенияПолейРасшифровки.Свойство("ВидОперации") Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
				Отбор,
				"ПолеГруппировки1",
				ЗначенияПолейРасшифровки.ВидОперации,
				ВидСравненияКомпоновкиДанных.Равно);
		Иначе
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
				Отбор,
				"ПолеГруппировки1",
				Перечисления.ВидыРасходовНУ.НормируемыеРасходы(),
				ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;
			
	ИначеЕсли ЭтоРасшифровкаБазы И ЗначенияПолейРасшифровки.Свойство("ВидОперации") 
		И ЗначенияПолейРасшифровки.ВидОперации =
			Перечисления.ВидыРасходовНУ.ДобровольноеЛичноеСтрахованиеНаСлучайСмертиИлиУтратыРаботоспособности Тогда
				
		ИмяОтчета = "БазаНормируемыхРасходов";

		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КлючВарианта", "КоличествоЗастрахованных");
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ВидРасходовНУ", ЗначенияПолейРасшифровки.ВидОперации);
		ИсключитьФилиалы = Истина;
		
	ИначеЕсли ЭтоРасшифровкаБазы И ЗначенияПолейРасшифровки.Свойство("ВидОперации")
		И ЗначенияПолейРасшифровки.ВидОперации = Перечисления.ВидыРасходовНУ.РасходыНаРекламуНормируемые Тогда
		
		ИмяОтчета = "БазаНормируемыхРасходов";

		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КлючВарианта", "Выручка");
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ВидРасходовНУ", ЗначенияПолейРасшифровки.ВидОперации);
	ИначеЕсли ЭтоРасшифровкаБазы И ЗначенияПолейРасшифровки.Свойство("ВидОперации")
		И (ЗначенияПолейРасшифровки.ВидОперации =
			Перечисления.ВидыРасходовНУ.РасходыНаВозмещениеЗатратРаботниковПоУплатеПроцентов) Тогда
				
		ИмяОтчета = "БазаНормируемыхРасходов";

		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КлючВарианта", "ОплатаТруда");
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ВидРасходовНУ", ЗначенияПолейРасшифровки.ВидОперации);
	ИначеЕсли ЭтоРасшифровкаБазы И ЗначенияПолейРасшифровки.Свойство("ВидОперации")
		И ЗначенияПолейРасшифровки.ВидОперации = Перечисления.ВидыРасходовНУ.ПредставительскиеРасходы Тогда	
	
		ИмяОтчета = "БазаНормируемыхРасходов";
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КлючВарианта", "Вознаграждение");
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ВидРасходовНУ", ЗначенияПолейРасшифровки.ВидОперации);
	ИначеЕсли ЭтоРасшифровкаБазы И ЗначенияПолейРасшифровки.Свойство("ВидОперации")
		И (ЗначенияПолейРасшифровки.ВидОперации =
			Перечисления.ВидыРасходовНУ.ДобровольноеСтрахованиеПоДоговорамДолгосрочногоСтрахованияЖизниРаботников 
			Или ЗначенияПолейРасшифровки.ВидОперации = Перечисления.ВидыРасходовНУ.ДобровольноеЛичноеСтрахование ) Тогда
				
		ИмяОтчета = "БазаНормируемыхРасходов";

		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КлючВарианта", "СтрахованиеБазаОплатаТруда");
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ВидРасходовНУ", ЗначенияПолейРасшифровки.ВидОперации);
		ИсключитьФилиалы = Истина;
	Иначе
		Возврат;
	КонецЕсли;
	
	НастройкиРасшифровки.Вставить(ИмяОтчета, ПользовательскиеНастройки);
	
	Если Справочники.Организации.ВсяОрганизация(ОтчетОбъект.Организация).Количество() > 1 И Не ИсключитьФилиалы Тогда
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Истина);
	КонецЕсли;
	
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ИсключитьФилиалы", ИсключитьФилиалы);
	
	СписокПунктовМеню = Новый СписокЗначений;
	СписокПунктовМеню.Добавить(ИмяОтчета);
	
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
КонецПроцедуры


// В процедуре можно уточнить особенности вывода в отчет отдельного элемента в структуре данных.
//
// Параметры:
//  Контекст          - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки   - МакетКомпоновкиДанных - описание выводимых данных.
//  ДанныеРасшифровки - ДанныеРасшифровкиКомпоновкиДанных - описание расшифровки для элемента в структуре данных.
//  ЭлементРезультата - ЭлементРезультатаКомпоновкиДанных - описание элемента в структуре данных.
//  ПропуститьЭлемент - Булево - если Истина, то не выводить эти данные в отчет.
//
Процедура ПередВыводомЭлементаРезультата(Контекст, МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, ПропуститьЭлемент) Экспорт
	
	Если Контекст.Свойство("ВыводитьКомментарийСтрахование")Тогда
		ПропуститьЭлемент = Истина;
	КонецЕсли;
	
	// Параметризуемый макет задействуется только в случае, когда происходит подстановка параметра.
	Если Контекст.Свойство("МакетКомментарийСтрахование")
		И ЭлементРезультата.Макет = Контекст.МакетКомментарийСтрахование Тогда
		Контекст.Вставить("ВыводитьКомментарийСтрахование", Истина);
		ПропуститьЭлемент = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НайтиНастраиваемыйМакетКомментарий(Контекст, МакетКомпоновки)

	Если Контекст.Свойство("МакетКомментарийСтрахование")Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
		Для Каждого ПараметрМакета Из Макет.Параметры Цикл
			Если ТипЗнч(ПараметрМакета) = Тип("ПараметрОбластиВыражениеКомпоновкиДанных") 
				И СтрНайти(ПараметрМакета.Выражение, "&КомментарийСтрахование") <> 0 Тогда
				Контекст.Вставить("МакетКомментарийСтрахование", Макет.Имя);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры
#КонецОбласти

#КонецЕсли