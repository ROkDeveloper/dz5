﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Баннер", Баннер);
	Если Баннер = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
	УстановитьТекстЗаголовка(Баннер.ДанныеБаннера.КоличествоКонтрагентов);
	УстановитьТекстРасчета(Баннер.ДанныеБаннера.КоличествоКонтрагентов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключить(Команда)
	
	ПерейтиПоНавигационнойСсылке("https://portal.1c.ru/applications/3");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТекстЗаголовка(КоличествоКонтрагентов)
	
	НомерКвартала = Формат(ТекущаяДатаСеанса(), "ДФ=q");
	ТекстЗаголовка = СтрШаблон(НСтр("ru='Работа с контрагентами %1 %2 квартале'"),
		?(НомерКвартала = "2", НСтр("ru='во'"), НСтр("ru='в'")),
		НомерКвартала);
	Элементы.ДекорацияЗаголовок.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстРасчета(КоличествоКонтрагентов)

	ТекстКоличествоКонтрагентов = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
		КоличествоКонтрагентов, НСтр("ru='контрагент, контрагента, контрагентов'"));
	ТекстВведеноВИБ = Новый ФорматированнаяСтрока(
		НСтр("ru='Введено в информационную базу:'"),
		" ",
		Новый ФорматированнаяСтрока(ТекстКоличествоКонтрагентов, Новый Шрифт(,,Истина)));
		
	МинутНаОдногоКонтрагента = 1;
	ТекстЗатратыВремени = Новый ФорматированнаяСтрока(
		НСтр("ru='Затраты времени:'"),
		" ",
		Новый ФорматированнаяСтрока(ПотраченоВремени(КоличествоКонтрагентов, МинутНаОдногоКонтрагента), Новый Шрифт(,,Истина)));
		
	МинутНаОдногоКонтрагента = 0.16;
	ТекстЗатратыВремениПри1СКонтрагента = Новый ФорматированнаяСтрока(
		НСтр("ru='Затраты времени при использовании 1С:Контрагент:'"),
		" ",
		Новый ФорматированнаяСтрока(ПотраченоВремени(КоличествоКонтрагентов, МинутНаОдногоКонтрагента), Новый Шрифт(,,Истина)));
	
	Элементы.ТекстРасчета.Заголовок = Новый ФорматированнаяСтрока(
		ТекстВведеноВИБ,
		РазделительСтрок(),
		ТекстЗатратыВремени,
		РазделительСтрок(),
		ТекстЗатратыВремениПри1СКонтрагента);
	
КонецПроцедуры

&НаСервере
Функция ПотраченоВремени(КоличествоКонтрагентов, МинутНаОдногоКонтрагента)

	ВсегоМинут = Окр(КоличествоКонтрагентов * МинутНаОдногоКонтрагента, 0);
	КоличествоЧасов = Цел(ВсегоМинут / 60);
	КоличествоМинут = ВсегоМинут % 60;
	
	Если КоличествоМинут = 0 Тогда
		ПотраченоВремени = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоЧасов, "час, часа, часов");
	ИначеЕсли КоличествоЧасов = 0 Тогда
		ПотраченоВремени = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(ВсегоМинут, "минута, минуты, минут");
	Иначе
		ПотраченоВремени = СтрШаблон("%1 %2",
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоЧасов, "час, часа, часов"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоМинут, "минута, минуты, минут"));
	КонецЕсли;
	
	Возврат ПотраченоВремени;
	
КонецФункции

&НаСервере
Функция РазделительСтрок()
	
	Возврат Новый ФорматированнаяСтрока(
		Символы.ПС,
		Новый ФорматированнаяСтрока(" ", Новый Шрифт(,3)),
		Символы.ПС);
	
КонецФункции

#КонецОбласти