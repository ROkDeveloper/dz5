﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",         Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",          Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",              Истина);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",             Истина);
	Результат.Вставить("ИспользоватьПередВыводомЭлементаРезультата", Ложь);
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",            Истина);
	Результат.Вставить("ИспользоватьПривилегированныйРежим",         Истина);
	
	Возврат Результат;
	
КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	//Организация
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(
		ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения, ПараметрыОтчета.КонецПериода);
		
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	Результат.Вывести(ОбластьОрганизация);
	
	//Заголовок
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета);
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
	// Единица измерения
	Если ПараметрыОтчета.Свойство("ВыводитьЕдиницуИзмерения")
		И ПараметрыОтчета.ВыводитьЕдиницуИзмерения Тогда
		ОбластьОписаниеЕдиницыИзмерения = Макет.ПолучитьОбласть("ОписаниеЕдиницыИзмерения");
		Результат.Вывести(ОбластьОписаниеЕдиницыИзмерения);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт
	
	ТекстЗаголовка = Нстр("ru = 'Справка-расчет расходов, уменьшающих %1 %2'");
	
	ИмяНалога = ПараметрыОтчета.Налог;
	Если ПараметрыОтчета.Налог = "УСН" Тогда
		ИмяНалога = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Нстр("ru = 'налог %1'"), ПараметрыОтчета.Налог);
	ИначеЕсли ПараметрыОтчета.Налог = "ЕНВД"
		И УчетЕНВД.РасходыПериодаУменьшаютЕНВДПослеОтмены(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода) Тогда
		ИмяНалога = СтрШаблон(НСтр("ru = 'ЕНВД (за %1)'"),
			УчетЕНВДКлиентСервер.ПредставлениеПоследнегоНалоговогоПериодаЕНВД());
	КонецЕсли;
	
	Если ПараметрыОтчета.РежимРасшифровкиРасходовЕНВДПослеОтмены Или ПараметрыОтчета.РежимРасшифровкиПомощникОплатыПатента Тогда
		ПредставлениеПериода = СтрШаблон(НСтр("ru = 'в %1 году'"), Формат(Год(ПараметрыОтчета.КонецПериода), "ЧГ=0"));
	Иначе
		НомерКвартала = ОбщегоНазначенияБПКлиентСервер.НомерКвартала(ПараметрыОтчета.КонецПериода);
		ПредставлениеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 %2 квартале %3 г.'"),
				?(НомерКвартала = 2, НСтр("ru = 'во'"), НСтр("ru = 'в'")),
				НомерКвартала,
				Формат(Год(ПараметрыОтчета.КонецПериода), "ЧГ=0"));
	КонецЕсли;
	
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, ИмяНалога, ПредставлениеПериода);
	
	Если ПараметрыОтчета.НалоговыйПериодУСНРасширен Тогда
		ТекстЗаголовка = ТекстЗаголовка + " *";
	КонецЕсли;
	
	Возврат ТекстЗаголовка;
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт

	Возврат Новый Структура("КлассификацияРасходов", УчетРасходовУменьшающихОтдельныеНалоги.СчетаРасходовУменьшающихНалог());

КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	// Устанавливаем параметры отчета
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		Если ПараметрыОтчета.Налог = "УСН" И ПараметрыОтчета.НалоговыйПериодУСНРасширен Тогда
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
				"НачалоПериода", НачалоДня(ПараметрыОтчета.ДатаНачалаДеятельности));
		Иначе
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
				"НачалоПериода", НачалоКвартала(ПараметрыОтчета.НачалоПериода));
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
			"КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Налог", ПараметрыОтчета.Налог);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "ЗаголовокДобровольноеСтрахование", Нстр("ru = 'Добровольное страхование'"));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "ЗаголовокУведомления", Нстр("ru = 'Использовано для уменьшения налога'"));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "СноскаДоляДоходовВзносыИП", СноскаДоляДоходовВзносыИП(ПараметрыОтчета));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "РежимРасшифровкиПомощникОплатыПатента", ПараметрыОтчета.РежимРасшифровкиПомощникОплатыПатента);
	
	ГруппировкиСтраховыхВзносов = НайтиГруппировкуПоИмени(
		КомпоновщикНастроек.Настройки.Структура, "ТаблицаСтраховыхВзносов").Строки;
	Если ВыводитьУпрощенныйВариантПоСтраховымВзносам(ПараметрыОтчета) Тогда
		ГруппировкиСтраховыхВзносов[0].Использование = Ложь;
		ГруппировкиСтраховыхВзносов[1].Использование = Истина;
		
		КомпоновщикНастроек.Настройки.Структура[0].Структура[1].Использование = Ложь;
	Иначе
		ГруппировкиСтраховыхВзносов[0].Использование = Истина;
		ГруппировкиСтраховыхВзносов[1].Использование = Ложь;
		
		КомпоновщикНастроек.Настройки.Структура[0].Структура[1].Использование = Истина;
	КонецЕсли;
	
	ГруппировкиПрочихВзносов = НайтиГруппировкуПоИмени(
		КомпоновщикНастроек.Настройки.Структура, "ТаблицаПрочихВзносов").Строки;
	Если ВыводитьУпрощенныйВариантПоФиксированнымВзносам(ПараметрыОтчета) Тогда
		ГруппировкиПрочихВзносов[0].Использование = Ложь;
		ГруппировкиПрочихВзносов[1].Использование = Истина;
	Иначе
		ГруппировкиПрочихВзносов[0].Использование = Истина;
		ГруппировкиПрочихВзносов[1].Использование = Ложь;
	КонецЕсли;
	
	// Информация в таблице "Расчет доли налога" может быть полезной для ЕНВД, после отмены ЕНВД таблицу в отчет выводить не будем
	Если ПараметрыОтчета.НачалоПериода >= УчетЕНВДКлиентСервер.ДатаОтменыЕНВД()
		И Не УчетЕНВД.РасходыПериодаУменьшаютЕНВДПослеОтмены(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода) Тогда
		
		ГруппировкаРасчетДоли = НайтиГруппировкуПоИмени(КомпоновщикНастроек.Настройки.Структура, "РасчетДолиНалога");
		ГруппировкаРасчетДоли.Использование = Ложь;
		
		ГруппировкаЗаголовокРасчетДоли = НайтиГруппировкуПоИмени(КомпоновщикНастроек.Настройки.Структура, "ЗаголовокРасчетДолиНалога");
		ГруппировкаЗаголовокРасчетДоли.Использование = Ложь;
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	// Удаляем дубли итогов группировок для больничных, взносов ИП и поданных уведомлений об уменьшении налога по патентам
	ПараметрыПоиска = БухгалтерскиеОтчеты.ПараметрыПоискаВТелеМакетаКомпоновки();
	ЭлементТела = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(
							МакетКомпоновки, "Больничные", ПараметрыПоиска);
	ЭлементТела.Тело.Удалить(ЭлементТела.Тело[1]);
	
	Если ПараметрыОтчета.РежимРасшифровкиПомощникОплатыПатента Тогда
		ЭлементТела = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(
			МакетКомпоновки, "Уведомления", ПараметрыПоиска);
		Если ТипЗнч(ЭлементТела) <> Неопределено Тогда
			ЭлементТела.Тело.Удалить(ЭлементТела.Тело[1]);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыПоиска.МножественныйПодбор = Истина;
	ЭлементТела = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(
							МакетКомпоновки, "ВзносыПрочие", ПараметрыПоиска);
	ЭлементТела[0].Тело.Удалить(ЭлементТела[0].Тело[1]);
	ЭлементТела[1].Тело.Удалить(ЭлементТела[1].Тело[1]);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Если ПараметрыОтчета.НалоговыйПериодУСНРасширен Тогда
		
		ОбластьСноска = Результат.Область(Результат.ВысотаТаблицы, 1, Результат.ВысотаТаблицы, 1);
		
		ОбластьСноска.Текст = ПояснениеРасширенныйНалоговыйПериодУСН(
			ПараметрыОтчета.ДатаНачалаДеятельности, ПараметрыОтчета.КонецПериода);
		ОбластьСноска.Шрифт = Новый Шрифт(, 8);
		ОбластьСноска.ВысотаСтроки = 16;
		
	ИначеЕсли ВыводитьСноскуДляРаспределенияВзносовИП(ПараметрыОтчета) Тогда
		
		ОбластьСноска = Результат.Область(Результат.ВысотаТаблицы, 1, Результат.ВысотаТаблицы, 1);
		
		ОбластьСноска.Текст = ПояснениеДоляДоходовВзносыИП();
		
		ОбластьСноска.Шрифт = Новый Шрифт(, 8);
		ОбластьСноска.ВысотаСтроки = 16;
		
	КонецЕсли;
	
	Результат.ФиксацияСлева = 0;
	Результат.ФиксацияСверху = 0;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	
	Возврат НаборПоказателей;
	
КонецФункции

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы.Подсистемы.ПростойИнтерфейс.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты, "");
	КонецЦикла;
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","СправкаРасчетРасходовУменьшающихОтдельныеНалоги", "Расчет расходов, уменьшающих налог УСН и ЕНВД"));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыводитьУпрощенныйВариантПоСтраховымВзносам(ПараметрыОтчета)
	
	ПлательщикУСН  = УчетнаяПолитика.ПрименяетсяУСН(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	ПлательщикЕНВД = УчетнаяПолитика.ПлательщикЕНВД(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	ПрименяетсяПСН = УчетнаяПолитика.ПрименяетсяУСНПатент(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	
	УменьшениеЕНВДПослеОтмены = УчетЕНВД.РасходыПериодаУменьшаютЕНВДПослеОтмены(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	УпрощенныйРасчетРасходовЕНВДПослеОтмены = УменьшениеЕНВДПослеОтмены И (ПараметрыОтчета.Налог = "ЕНВД")
		И УчетнаяПолитика.ПрименяетсяОсобыйПорядокНалогообложения(
			ПараметрыОтчета.Организация,
			УчетЕНВДКлиентСервер.ПоследнийДеньДействияЕНВД());
	
	КоличествоСовмещаемыхРежимов = Число(ПлательщикУСН) + Число(ПрименяетсяПСН)
		+ Число(ПлательщикЕНВД Или УменьшениеЕНВДПослеОтмены);
	
	Возврат (КоличествоСовмещаемыхРежимов <= 1) Или УпрощенныйРасчетРасходовЕНВДПослеОтмены;
	
КонецФункции

Функция ВыводитьУпрощенныйВариантПоФиксированнымВзносам(ПараметрыОтчета)
	
	Если Не УчетЕНВД.НалогУменьшаетсяНаФиксированныеВзносыИПРаботодателей(ПараметрыОтчета.КонецПериода) Тогда
		// До 2017 года фиксированные взносы не распределялись.
		Возврат Истина;
	КонецЕсли;
	
	УменьшатьУСН = УчетнаяПолитика.ПрименяетсяУСН(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	УменьшатьЕНВД = УчетнаяПолитика.ПлательщикЕНВД(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	УменьшатьПСН = ПараметрыОтчета.КонецПериода >= УчетПСНКлиентСервер.ДатаНачалаУменьшенияПСННаСтраховыеВзносы()
		И УчетнаяПолитика.ПрименяетсяУСНПатент(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	
	УменьшениеЕНВДПослеОтмены = УчетЕНВД.РасходыПериодаУменьшаютЕНВДПослеОтмены(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	УпрощенныйРасчетРасходовЕНВДПослеОтмены = УменьшениеЕНВДПослеОтмены И (ПараметрыОтчета.Налог = "ЕНВД")
		И УчетнаяПолитика.ПрименяетсяОсобыйПорядокНалогообложения(
			ПараметрыОтчета.Организация,
			УчетЕНВДКлиентСервер.ПоследнийДеньДействияЕНВД());
	
	КоличествоНалоговыхРежимов = Число(УменьшатьУСН) + Число(УменьшатьПСН)
		+ Число(УменьшатьЕНВД Или УменьшениеЕНВДПослеОтмены);
	
	Возврат (КоличествоНалоговыхРежимов <= 1) Или УпрощенныйРасчетРасходовЕНВДПослеОтмены;
	
КонецФункции

Функция ПояснениеРасширенныйНалоговыйПериодУСН(ДатаРегистрации, КонецПериодаОтчета)
	
	// Пояснение выводится только в 1 квартале расширенного налогового периода по УСН.
	ШаблонПояснения = НСтр("ru = '* Учитываются расходы за отчетный период с даты регистрации %1 по %2 (п.2 ст. 55 НК РФ)'");
	
	ФорматнаяСтрокаПериода = "ДФ=dd.MM.yyyy";
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПояснения,
		Формат(ДатаРегистрации, ФорматнаяСтрокаПериода),
		Формат(КонецКвартала(КонецПериодаОтчета), ФорматнаяСтрокаПериода));
	
КонецФункции

// Возвращает элемент структуры настроек компоновки данных содержащий поле группировки с указанным именем
// Поиск осуществляется по указанной структуре и все ее подчиненным структурам,
// В случае неудачи возвращает Неопределено
//
// Параметры:
// - Структура 	- (ГруппировкаТаблицыКомпоновкиДанных или ГруппировкаКомпоновкиДанных, КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных) 
// 					Элемент структуры компоновки данных,
// - ИмяПоля 	- (Строка) Имя поля группировки
//
// Возвращаемое значение:
// ГруппировкаТаблицыКомпоновкиДанных, ГруппировкаКомпоновкиДанных, Неопределено
//
Функция НайтиГруппировкуПоИмени(Структура, ИмяПоля) Экспорт
	
	Для каждого Элемент Из Структура Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппировкаКомпоновкиДанных") 
			Или ТипЗнч(Элемент) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
			
			Если Элемент.Имя = ИмяПоля Тогда
				Возврат Элемент;
			КонецЕсли;
			
			Группировка = НайтиГруппировкуПоИмени(Элемент.Структура, ИмяПоля);
			Если Группировка <> Неопределено тогда
				Прервать;
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = ИмяПоля Тогда
				Возврат Элемент;
			КонецЕсли;
			
			Для каждого ГруппировкаТаблицы Из Элемент.Строки Цикл
				Если ГруппировкаТаблицы.Имя = ИмяПоля Тогда
					Возврат ГруппировкаТаблицы;
				КонецЕсли;
				
				Группировка = НайтиГруппировкуПоИмени(ГруппировкаТаблицы.Структура, ИмяПоля);
				Если Группировка <> Неопределено тогда
					Прервать;
				КонецЕсли;
			
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Группировка;
	
КонецФункции

Функция СноскаДоляДоходовВзносыИП(ПараметрыОтчета)
	
	Если ВыводитьСноскуДляРаспределенияВзносовИП(ПараметрыОтчета) Тогда
		Возврат " * ";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ПояснениеДоляДоходовВзносыИП()
	
	Возврат НСтр("ru = '* Взносы, оплаченные в 2021 году за 2020 год, уменьшают ЕНВД за последний квартал 2020 года и распределяются пропорционально доходам 2020 года.'");
	
КонецФункции

Функция ВыводитьСноскуДляРаспределенияВзносовИП(ПараметрыОтчета)
	
	Возврат УчетЕНВД.РасходыПериодаУменьшаютЕНВДПослеОтмены(ПараметрыОтчета.Организация, ПараметрыОтчета.НачалоПериода)
		И ПараметрыОтчета.Налог = "ЕНВД";
	
КонецФункции

#КонецОбласти

#КонецЕсли