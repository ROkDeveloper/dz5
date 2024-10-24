﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстЗаголовка = НСтр("ru = 'Подключенные кассы'");
	Если Параметры.Свойство("Склад") Тогда
		Склад = Параметры.Склад;
		ЭтаФорма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1: %2", ТекстЗаголовка, Склад);
	Иначе
		ЭтаФорма.Заголовок = ТекстЗаголовка;
	КонецЕсли;
	
	Элементы.ДеревоКассГруппаУправление.Видимость = РольДоступна("ДобавлениеИзменениеДанныхБухгалтерии") ИЛИ РольДоступна("ПолныеПрава");
	Элементы.ДеревоКассДобавить.Видимость = ПравоДоступа("Редактирование", Метаданные.Справочники.ПодключаемоеОборудование)
		ИЛИ ПравоДоступа("Редактирование", Метаданные.ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат);
	
	УстановитьУсловноеОформление();
	ОбновитьСписокОборудования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеСтатусаКассовойСмены" Тогда
		ОбновитьСписокКасс();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокОборудования()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущееРабочееМесто", МенеджерОборудованияВызовСервера.РабочееМестоКлиента());
	Запрос.УстановитьПараметр("Склад", Склад); 
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""Кассы, подключенные к 1С:Бухгалтерии на этом компьютере"" КАК ТипПодключения,
	|	1 КАК ТипОборудования,
	|	ЕСТЬNULL(ДрайверыОборудования.Наименование, ПодключаемоеОборудование.Наименование) КАК Наименование,
	|	ЕСТЬNULL(ОборудованиеПоОрганизациям.Организация, ПодключаемоеОборудование.Организация) КАК Организация,
	|	ОборудованиеПоОрганизациям.Склад КАК Склад,
	|	"""" КАК ИмяКомпьютера,
	|	ПодключаемоеОборудование.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|		ПО (ОборудованиеПоОрганизациям.Оборудование = ПодключаемоеОборудование.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДрайверыОборудования КАК ДрайверыОборудования
	|		ПО ПодключаемоеОборудование.ДрайверОборудования = ДрайверыОборудования.Ссылка
	|ГДЕ
	|	ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ККТ)
	|	И ПодключаемоеОборудование.РабочееМесто = &ТекущееРабочееМесто
	|	И ПодключаемоеОборудование.УстройствоИспользуется
	|	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ОборудованиеПоОрганизациям.Склад = &Склад)
	|	И НЕ ПодключаемоеОборудование.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Кассы, подключенные к 1С:Бухгалтерии на другом компьютере (или под другим пользователем)"",
	|	2,
	|	ЕСТЬNULL(ДрайверыОборудования.Наименование, ПодключаемоеОборудование.Наименование),
	|	ЕСТЬNULL(ОборудованиеПоОрганизациям.Организация, ПодключаемоеОборудование.Организация),
	|	ОборудованиеПоОрганизациям.Склад,
	|	РабочиеМеста.ИмяКомпьютера,
	|	ПодключаемоеОборудование.Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДрайверыОборудования КАК ДрайверыОборудования
	|		ПО ПодключаемоеОборудование.ДрайверОборудования = ДрайверыОборудования.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РабочиеМеста КАК РабочиеМеста
	|		ПО ПодключаемоеОборудование.РабочееМесто = РабочиеМеста.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|		ПО (ОборудованиеПоОрганизациям.Оборудование = ПодключаемоеОборудование.Ссылка)
	|ГДЕ
	|	ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ККТ)
	|	И ПодключаемоеОборудование.РабочееМесто <> &ТекущееРабочееМесто
	|	И ПодключаемоеОборудование.УстройствоИспользуется
	|	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ОборудованиеПоОрганизациям.Склад = &Склад)
	|	И НЕ ПодключаемоеОборудование.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Умные кассы с выгрузкой продаж по итогам смены"",
	|	3,
	|	ОфлайнОборудование.ОбработчикОфлайнОборудования,
	|	ЕСТЬNULL(ОборудованиеПоОрганизациям.Организация, ОфлайнОборудование.Организация),
	|	ОборудованиеПоОрганизациям.Склад,
	|	"""",
	|	ОфлайнОборудование.Ссылка
	|ИЗ
	|	Справочник.ОфлайнОборудование КАК ОфлайнОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|		ПО (ОборудованиеПоОрганизациям.Оборудование = ОфлайнОборудование.Ссылка)
	|ГДЕ
	|	ОфлайнОборудование.ТипОфлайнОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыОфлайнОборудования.ККМ)
	|	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ОборудованиеПоОрганизациям.Склад = &Склад)
	|	И НЕ ОфлайнОборудование.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Кассы, для которых настроена загрузка из ОФД"",
	|	5,
	|	ОфлайнОборудование.ОбработчикОфлайнОборудования,
	|	ЕСТЬNULL(ОборудованиеПоОрганизациям.Организация, ОфлайнОборудование.Организация),
	|	ОборудованиеПоОрганизациям.Склад,
	|	"""",
	|	ОфлайнОборудование.Ссылка
	|ИЗ
	|	Справочник.ОфлайнОборудование КАК ОфлайнОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|		ПО (ОборудованиеПоОрганизациям.Оборудование = ОфлайнОборудование.Ссылка)
	|ГДЕ
	|	ОфлайнОборудование.ТипОфлайнОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыОфлайнОборудования.ОФД)
	|	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ ОборудованиеПоОрганизациям.Склад = &Склад)
	|	И НЕ ОфлайнОборудование.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Умные кассы и кассы курьеров под управлением 1С:Мобильная касса"",
	|	4,
	|	СинхронизацияДанныхЧерезУниверсальныйФормат.Наименование,
	|	ВложенныйЗапрос.Организация,
	|	СинхронизацияДанныхЧерезУниверсальныйФормат.СкладПоУмолчанию,
	|	"""",
	|	СинхронизацияДанныхЧерезУниверсальныйФормат.Ссылка
	|ИЗ
	|	ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат КАК СинхронизацияДанныхЧерезУниверсальныйФормат
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СинхронизацияДанныхЧерезУниверсальныйФорматОрганизации.Ссылка КАК Ссылка,
	|			СинхронизацияДанныхЧерезУниверсальныйФорматОрганизации.Организация КАК Организация
	|		ИЗ
	|			ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Организации КАК СинхронизацияДанныхЧерезУниверсальныйФорматОрганизации) КАК ВложенныйЗапрос
	|		ПО СинхронизацияДанныхЧерезУниверсальныйФормат.Ссылка = ВложенныйЗапрос.Ссылка
	|ГДЕ
	|	НЕ СинхронизацияДанныхЧерезУниверсальныйФормат.ЭтотУзел
	|	И СинхронизацияДанныхЧерезУниверсальныйФормат.ВариантНастройки = ""ОбменМК""
	|	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ СинхронизацияДанныхЧерезУниверсальныйФормат.СкладПоУмолчанию = &Склад)
	|	И НЕ СинхронизацияДанныхЧерезУниверсальныйФормат.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Умные кассы и кассы курьеров под управлением 1С:Мобильная касса"",
	|	4,
	|	""Мобильная касса ("" + ОжиданиеПодключенияМК.ИдентификаторМК + "") - ожидает завершения настройки"",
	|	ОжиданиеПодключенияМК.Организация,
	|	ОжиданиеПодключенияМК.Склад,
	|	"""",
	|	ОжиданиеПодключенияМК.ИдентификаторМК
	|ИЗ
	|	РегистрСведений.ОжиданиеПодключенияМК КАК ОжиданиеПодключенияМК
	|ГДЕ
	|	&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|		ИЛИ ОжиданиеПодключенияМК.Склад = &Склад
	|ИТОГИ ПО
	|	ТипПодключения";	
	
	ТипПодключения = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ТипПодключения");
	
	ДеревоКасс.ПолучитьЭлементы().Очистить();
	
	Пока ТипПодключения.Следующий() Цикл
		
		НоваяГруппа = ДеревоКасс.ПолучитьЭлементы().Добавить();
		НоваяГруппа.Наименование = ТипПодключения.ТипПодключения;
		НоваяГруппа.Заголовок = Истина;
		Кассы = ТипПодключения.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Пока Кассы.Следующий() Цикл
			НоваяКасса = НоваяГруппа.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НоваяКасса, Кассы);
			
			Если Кассы.ТипОборудования = 1 
				ИЛИ Кассы.ТипОборудования = 2 Тогда
				ОписаниеПоследнейСмены = КассовыеСменыВызовСервера.ОписаниеПоследнейКассовойСмены(Кассы.Ссылка);
				Если ОписаниеПоследнейСмены <> Неопределено Тогда
					НоваяКасса.ПоследняяЗагрузка = ?(ЗначениеЗаполнено(ОписаниеПоследнейСмены.ОкончаниеКассовойСмены), 
														ОписаниеПоследнейСмены.ОкончаниеКассовойСмены, ОписаниеПоследнейСмены.НачалоКассовойСмены);
					НоваяКасса.КассоваяСменаОткрыта = ОписаниеПоследнейСмены.Статус = Перечисления.СтатусыКассовойСмены.Открыта;
				КонецЕсли;
				Если Кассы.ТипОборудования = 1 Тогда
					НоваяКасса.ОборудованиеПодключено = Истина;
				КонецЕсли;
			ИначеЕсли Кассы.ТипОборудования = 4 
				И ТипЗнч(Кассы.Ссылка) = Тип("Строка") Тогда
				НоваяКасса.ИдентификаторМК = Кассы.Ссылка;
			КонецЕсли;
			
			НоваяКасса.ОбновитьПрайс    = НСтр("ru='Выгрузить прайс'");
			НоваяКасса.ЗагрузитьПродажи = НСтр("ru='Загрузить продажи'");
			НоваяКасса.ОткрытьСмену     = НСтр("ru='Открыть смену'");
			НоваяКасса.ЗакрытьСмену     = НСтр("ru='Закрыть смену'");
			НоваяКасса.Синхронизировать = НСтр("ru='Синхронизировать'");
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//Видимость колонок для отображения заголовков
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассНаименование");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.Заголовок", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассСклад");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "Склад", ВидСравненияКомпоновкиДанных.Заполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассОткрытьСмену");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассЗакрытьСмену");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.ТипОборудования", ВидСравненияКомпоновкиДанных.НеРавно, 1);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассОткрытьСмену");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.КассоваяСменаОткрыта", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.ТипОборудования", ВидСравненияКомпоновкиДанных.Равно, 1);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассЗакрытьСмену");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.КассоваяСменаОткрыта", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.ТипОборудования", ВидСравненияКомпоновкиДанных.Равно, 1);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассОбновитьПрайс");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассЗагрузитьПродажи");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.ТипОборудования", ВидСравненияКомпоновкиДанных.НеРавно, 3);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассСинхронизировать");
	ГруппаОтбора1 = КомпоновкаДанныхКлиентСервер.ДобавитьГруппуОтбора(ЭлементУО.Отбор.Элементы, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИЛИ);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1, "ДеревоКасс.ТипОборудования", ВидСравненияКомпоновкиДанных.НеРавно, 4);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора1, "ДеревоКасс.Ссылка", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассЗагрузитьПродажиОФД");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.ТипОборудования", ВидСравненияКомпоновкиДанных.НеРавно, 5);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассТипОборудования");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.ТипОборудования", ВидСравненияКомпоновкиДанных.НеРавно, 0);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь); 
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКассТипОборудования");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, "ДеревоКасс.ТипОборудования", ВидСравненияКомпоновкиДанных.Равно, 0);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", ""); 
	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокКассНаСервере()
	
	ОбновитьСписокОборудования();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокКасс()
	ОбновитьСписокКассНаСервере();
	ЗаголовкиКасс = ДеревоКасс.ПолучитьЭлементы();
	Для Каждого ЗаголовокКассы Из ЗаголовкиКасс Цикл
		Элементы.ДеревоКасс.Развернуть(ЗаголовокКассы.ПолучитьИдентификатор());
	КонецЦикла
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	ОбработкаОповещения = Новый ОписаниеОповещения("ДобавлениеКассы_Завершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("Склад", Склад);
	ОткрытьФорму("Обработка.ПодключенныеКассы.Форма.ПомощникПодключенияКассы", ПараметрыФормы, , , , , ОбработкаОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеКассы_Завершение(Результат, Параметры) Экспорт
	
	ОбновитьСписокКассНаСервере();
	ЗаголовкиКасс = ДеревоКасс.ПолучитьЭлементы();
	Для Каждого ЗаголовокКассы Из ЗаголовкиКасс Цикл
		Элементы.ДеревоКасс.Развернуть(ЗаголовокКассы.ПолучитьИдентификатор());
	КонецЦикла
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКассПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ДеревоКасс.ТекущиеДанные;
	Отказ = Истина;
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
		Если ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ПодключаемоеОборудование") Тогда
			ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаОбъекта", ПараметрыФормы, , , , , );
		ИначеЕсли ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ОфлайнОборудование") Тогда
			ОткрытьФорму("Справочник.ОфлайнОборудование.ФормаОбъекта", ПараметрыФормы, , , , , );
		ИначеЕсли ТипЗнч(ТекущиеДанные.Ссылка) = Тип("ПланОбменаСсылка.СинхронизацияДанныхЧерезУниверсальныйФормат") Тогда
			ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ФормаОбъекта", ПараметрыФормы, , , , , );
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.ТипОборудования = 4
		И ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторМК) Тогда
		ПараметрыФормы = Новый Структура("Ключ", КлючЗаписиОжиданиеПодключенияМК(ТекущиеДанные.ИдентификаторМК));
		ОткрытьФорму("РегистрСведений.ОжиданиеПодключенияМК.ФормаЗаписи", ПараметрыФормы, , , , , );
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КлючЗаписиОжиданиеПодключенияМК(ЗначениеКлюча)
	
	СтруктураКлючаЗаписи = Новый Структура;
	СтруктураКлючаЗаписи.Вставить("ИдентификаторМК", ЗначениеКлюча);
	Возврат РегистрыСведений.ОжиданиеПодключенияМК.СоздатьКлючЗаписи(СтруктураКлючаЗаписи);
	
КонецФункции

&НаКлиенте
Процедура ДеревоКассВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДеревоКассОткрытьСмену" Тогда
		СтандартнаяОбработка = Ложь;
		СтрокаДерева = ДеревоКасс.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(СтрокаДерева.Ссылка) И ТипЗнч(СтрокаДерева.Ссылка) = Тип("СправочникСсылка.ПодключаемоеОборудование") Тогда
			СтруктураПараметров = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперацииНаОборудовании(Истина, Неопределено, СтрокаДерева.Ссылка);
			КассовыеСменыКлиентБП.ОткрытьСменуПослеВыбораУстройства(СтруктураПараметров, УникальныйИдентификатор);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "ДеревоКассЗакрытьСмену" Тогда
		СтандартнаяОбработка = Ложь;
		СтрокаДерева = ДеревоКасс.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(СтрокаДерева.Ссылка) И ТипЗнч(СтрокаДерева.Ссылка) = Тип("СправочникСсылка.ПодключаемоеОборудование") Тогда
			КассовыеСменыКлиентБП.ЗакрытьСмену(УникальныйИдентификатор, Неопределено, СтрокаДерева.Ссылка);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "ДеревоКассОбновитьПрайс" Тогда
		СтандартнаяОбработка = Ложь;
		СтрокаДерева = ДеревоКасс.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(СтрокаДерева.Ссылка) И ТипЗнч(СтрокаДерева.Ссылка) = Тип("СправочникСсылка.ОфлайнОборудование") Тогда
			МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуДанныхНаККМ(СтрокаДерева.Ссылка, УникальныйИдентификатор, Неопределено);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "ДеревоКассЗагрузитьПродажи" Тогда
		СтандартнаяОбработка = Ложь;
		СтрокаДерева = ДеревоКасс.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(СтрокаДерева.Ссылка) И ТипЗнч(СтрокаДерева.Ссылка) = Тип("СправочникСсылка.ОфлайнОборудование") Тогда
			МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(СтрокаДерева.Ссылка, УникальныйИдентификатор, Неопределено);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "ДеревоКассСинхронизировать" Тогда
		СтандартнаяОбработка = Ложь;
		СтрокаДерева = ДеревоКасс.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(СтрокаДерева.Ссылка) И ТипЗнч(СтрокаДерева.Ссылка) = Тип("ПланОбменаСсылка.СинхронизацияДанныхЧерезУниверсальныйФормат") Тогда
			ОбменДаннымиКлиент.ВыполнитьОбменДаннымиОбработкаКоманды(СтрокаДерева.Ссылка, ЭтотОбъект);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "ДеревоКассЗагрузитьПродажиОФД" Тогда
		СтандартнаяОбработка = Ложь;
		СтрокаДерева = ДеревоКасс.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(СтрокаДерева.Ссылка) И ТипЗнч(СтрокаДерева.Ссылка) = Тип("СправочникСсылка.ОфлайнОборудование") Тогда
			МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуЧековИзОФД(СтрокаДерева.Ссылка, УникальныйИдентификатор, Неопределено, 0);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

