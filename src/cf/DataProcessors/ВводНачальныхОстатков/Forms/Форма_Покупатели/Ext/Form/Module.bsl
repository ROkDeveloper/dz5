﻿
#Область ПроцедурыИФункцииОбщегоНазначения

#Область ОбщегоНазначения

&НаСервереБезКонтекста
Функция ПеречитатьДатуНачалаУчета(Организация)
	
	Возврат Обработки.ВводНачальныхОстатков.ПеречитатьДатуНачалаУчета(Организация);
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Отказ = Ложь;
		ЗаписатьНаСервере(, Отказ);
		Если НЕ Отказ Тогда
			Закрыть();
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоляСтрокиТабличнойЧасти(СтрокаТаблицы)
	
	КолонкиТаблицы = СтруктураТаблиц.Получить(0).Значение;
	
	ПараметрыСтроки  = Новый Структура("Организация, ДатаВводаОстатков, ВалютаРегламентированногоУчета, ВестиУчетПоДоговорам", 
		Объект.Организация, Объект.ДатаВводаОстатков, Объект.ВалютаРегламентированногоУчета, ВестиУчетПоДоговорам);
	
	Для Каждого Колонка ИЗ КолонкиТаблицы Цикл
		ИмяКолонки = Колонка.Значение;
		ПараметрыСтроки.Вставить(ИмяКолонки, СтрокаТаблицы[ИмяКолонки]);
	КонецЦикла;
	
	Возврат ПараметрыСтроки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВалютаПриИзмененииСервер(ПараметрыСтроки, ИмяРеквизита)
	
	Если ПараметрыСтроки.Валюта = ПараметрыСтроки.ВалютаРегламентированногоУчета Тогда
		ПараметрыСтроки.ВалютнаяСумма = 0;
	КонецЕсли;
	Обработки.ВводНачальныхОстатков.ПересчитатьСуммуСервер(ПараметрыСтроки, ИмяРеквизита, "ВалютнаяСумма");
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписьДанных

Процедура ЗаполнитьДоговораПередЗаписьюВТабличнойЧасти()

	ПараметрыДоговора = Новый Структура;
	ПараметрыДоговора.Вставить("Организация", Объект.Организация);
	ПараметрыДоговора.Вставить("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	
	Для Каждого Строка Из Объект.Покупатели Цикл
		ПараметрыДоговора.Вставить("Владелец", Строка.Контрагент);
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
			
		РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
			ДоговорКонтрагента,
			ПараметрыДоговора.Владелец, 
			ПараметрыДоговора.Организация, 
			ПараметрыДоговора.ВидДоговора);
			
		Если НЕ ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
			ПараметрыСоздания = Новый Структура("ЗначенияЗаполнения", ПараметрыДоговора);
			ДоговорКонтрагента = РаботаСДоговорамиКонтрагентовБПВызовСервера.СоздатьОсновнойДоговорКонтрагента(ПараметрыСоздания);
		КонецЕсли;
		Строка.ДоговорКонтрагента = ДоговорКонтрагента;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере(ОбновитьОстатки = Истина, Отказ = Ложь)
	
	// Перед проверкой заполнения заполним договор контрагента в строках
	Если Не ВестиУчетПоДоговорам Тогда
		ЗаполнитьДоговораПередЗаписьюВТабличнойЧасти();
	КонецЕсли;
	
	Отказ = НЕ ПроверитьЗаполнение();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СинхронизироватьСостояниеДокументов(Объект.Покупатели, Объект.СуществующиеДокументы);
	
	СтруктураПараметровДокументов = Новый Структура("Организация, Дата, РазделУчета", 
		Объект.Организация, Объект.ДатаВводаОстатков, Перечисления.РазделыУчетаДляВводаОстатков.РасчетыСПокупателямиИЗаказчиками);
	
	Отбор = Новый Структура("НеЗаполненныеРеквизиты, ТабличнаяЧасть", Истина, "Покупатели");
	СчетаУчетаВДокументах.ЗаполнитьТаблицу(Обработки.ВводНачальныхОстатков, СтруктураПараметровДокументов, Объект.Покупатели, Отбор);
	
	ТаблицаДанных = ПодготовитьТабличнуюЧастьКЗаписи(Объект.Покупатели, СтруктураПараметровДокументов);
	
	МенеджерОбработки.ЗаписатьНаСервереДокументы(СтруктураПараметровДокументов, ТаблицаДанных, "РасчетыСКонтрагентами");
	МенеджерОбработки.ОбновитьФинансовыйРезультат(СтруктураПараметровДокументов, Объект.ФинансовыйРезультат);
	
	Если ОбновитьОстатки Тогда
		
		МенеджерОбработки.ОбновитьОстатки(Объект.Покупатели, "Покупатели", 
			Новый Структура("Организация,ДатаВводаОстатков",
				Объект.Организация,Объект.ДатаВводаОстатков),
			Объект.СуществующиеДокументы);
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьТабличнуюЧастьКЗаписи(Таблица, СтруктураПараметровДокументов);
	
	ТаблицаДанных = Таблица.Выгрузить();
	ТаблицаДанных.Очистить();
	ТаблицаДанных.Колонки.Задолженность.Имя = "Сумма";
	ТаблицаДанных.Колонки.Аванс.Имя         = "СуммаКт";
	ТаблицаДанных.Колонки.Добавить("Аванс");
	ТаблицаДанных.Колонки.Добавить("СуммаНУ");
	
	ТаблицаДанных.Колонки.Добавить("ДоходЕНВД");      // вид деятельности 1
	ТаблицаДанных.Колонки.Добавить("ДоходПатент");    // вид деятельности 2
	ТаблицаДанных.Колонки.Добавить("ДоходКомитента"); // вид деятельности 3
	
	Для Каждого СтрокаТаблицы ИЗ Таблица Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		НоваяСтрока.Сумма   = СтрокаТаблицы.Задолженность;
		НоваяСтрока.СуммаКт = СтрокаТаблицы.Аванс;
		НоваяСтрока.Аванс   = ЗначениеЗаполнено(СтрокаТаблицы.Аванс);
		НоваяСтрока.СуммаНУ = Макс(НоваяСтрока.Сумма, НоваяСтрока.СуммаКт);
		Если НЕ ЗначениеЗаполнено(НоваяСтрока.Документ) Тогда
			НоваяСтрока.Документ = Обработки.ВводНачальныхОстатков.ПолучитьДокумент(НоваяСтрока.Контрагент ,НоваяСтрока.ДоговорКонтрагента, СтруктураПараметровДокументов);
		КонецЕсли;
		
		Если СтрокаТаблицы.ВидДеятельности <> "" Тогда
			СуммаОтдельныйВидДеятельности = Макс(НоваяСтрока.Сумма, НоваяСтрока.СуммаКт);
		КонецЕсли;
		Если СтрокаТаблицы.ВидДеятельности = "ЕНВД" Тогда
			НоваяСтрока.ДоходЕНВД = СуммаОтдельныйВидДеятельности;
		ИначеЕсли СтрокаТаблицы.ВидДеятельности = "Патент" Тогда
			НоваяСтрока.ДоходПатент = СуммаОтдельныйВидДеятельности;
		ИначеЕсли СтрокаТаблицы.ВидДеятельности = "Комиссия" Тогда
			НоваяСтрока.ДоходКомитента = СуммаОтдельныйВидДеятельности;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область ОбработчикиЭлементовШапкиФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если Модифицированность Тогда
		НомерСтроки = 0;
		Если Элементы.Покупатели.ТекущиеДанные <> Неопределено Тогда
			НомерСтроки = Элементы.Покупатели.ТекущиеДанные.НомерСтроки;
		КонецЕсли;
		Отказ = Ложь;
		ЗаписатьНаСервере(Истина, Отказ);
		Если НЕ Отказ Тогда
			Если НомерСтроки <> 0 Тогда
				Элементы.Покупатели.ТекущаяСтрока = Объект.Покупатели[НомерСтроки-1].ПолучитьИдентификатор();
			КонецЕсли;
			Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Отказ = Ложь;
	Если Модифицированность Тогда
		ЗаписатьНаСервере(Ложь, Отказ);
		Если НЕ Отказ Тогда
			Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");
		КонецЕсли;
	КонецЕсли;
	Если НЕ Отказ Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличныхЧастей

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьМассивВидовДоговоров()

	СписокВидовДоговоров = Новый Массив;
	СписокВидовДоговоров.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"));
	Возврат СписокВидовДоговоров;

КонецФункции

&НаСервереБезКонтекста
Процедура КонтрагентПриИзмененииНаСервере(ПараметрыСтроки)
	
	ПараметрыСтроки.Документ  = "";
	ПараметрыСтроки.СчетУчета = "";
	
	Если ЗначениеЗаполнено(ПараметрыСтроки.Контрагент) Тогда
		РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ПараметрыСтроки.ДоговорКонтрагента, ПараметрыСтроки.Контрагент, ПараметрыСтроки.Организация, 
		ПолучитьМассивВидовДоговоров());
		
		Если ЗначениеЗаполнено(ПараметрыСтроки.ДоговорКонтрагента) Тогда
			ДоговорПриИзмененииСервер(ПараметрыСтроки);
		ИначеЕсли НЕ ПараметрыСтроки.ВестиУчетПоДоговорам Тогда
			ПараметрыСтроки.Валюта = ПараметрыСтроки.ВалютаРегламентированногоУчета;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДоговорПриИзмененииСервер(ПараметрыСтроки)
	
	ПараметрыСтроки.Документ  = "";
	ПараметрыСтроки.СчетУчета = "";
	
	Если ПараметрыСтроки.Свойство("Валюта") Тогда
		ПараметрыСтроки.Валюта = ПараметрыСтроки.ДоговорКонтрагента.ВалютаВзаиморасчетов;
		ВалютаПриИзмененииСервер(ПараметрыСтроки, "Задолженность");
		ВалютаПриИзмененииСервер(ПараметрыСтроки, "Аванс");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЗадолженностьИлиАванс(ИмяРеквизита, ИмяОбнуляемогоРеквизита)
	
	СтрокаТаблицы = Элементы.Покупатели.ТекущиеДанные;
	
	СтрокаТаблицы[ИмяОбнуляемогоРеквизита] = 0;
	СтрокаТаблицы[ИмяОбнуляемогоРеквизита + "Остаток"] = 0;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ВалютаПриИзмененииСервер(ПараметрыСтроки, ИмяРеквизита);
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиКонтрагентПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.Покупатели.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	КонтрагентПриИзмененииНаСервере(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиДоговорКонтрагентаПриИзменении(Элемент)
	
	СтрокаТаблицы   = Элементы.Покупатели.ТекущиеДанные;
	ПараметрыСтроки = ПоляСтрокиТабличнойЧасти(СтрокаТаблицы);
	ДоговорПриИзмененииСервер(ПараметрыСтроки);
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиАвансОстатокПриИзменении(Элемент)
	
	ПересчитатьЗадолженностьИлиАванс("Аванс", "Задолженность");
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиЗадолженностьОстатокПриИзменении(Элемент)
	
	ПересчитатьЗадолженностьИлиАванс("Задолженность", "Аванс");
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиВидДеятельностиОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		СтрокаТаблицы   = Элементы.Покупатели.ТекущиеДанные;
		СтрокаТаблицы.ВидДеятельности = ОсновнойВидДеятельности;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Объект.Организация                    = Параметры.Организация;
	Объект.ДатаВводаОстатков              = Параметры.ДатаВводаОстатков;
	Объект.ВалютаРегламентированногоУчета = Параметры.ВалютаРегламентированногоУчета;
	ВестиУчетПоДоговорам                  = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	
	ТекстЗаголовок = НСтр("ru = 'Начальные остатки: Покупатели (%1)'");
	ТекстЗаголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовок, Объект.Организация);
	ЭтаФорма.Заголовок = ТекстЗаголовок;
	ДатаУчетнойПолитики = Объект.ДатаВводаОстатков + 86400;
	Если УчетнаяПолитика.ПрименяетсяУСН(Объект.Организация, ДатаУчетнойПолитики) Тогда
		Элементы.ПокупателиВидДеятельности.СписокВыбора.Добавить("УСН", "УСН");
		ОсновнойВидДеятельности = "УСН";
		Если УчетнаяПолитика.ПлательщикЕНВД(Объект.Организация, ДатаУчетнойПолитики) Тогда
			Элементы.ПокупателиВидДеятельности.СписокВыбора.Добавить("ЕНВД", "ЕНВД");
		КонецЕсли;
		Если УчетнаяПолитика.ПрименяетсяУСНПатент(Объект.Организация, ДатаУчетнойПолитики) Тогда
			Элементы.ПокупателиВидДеятельности.СписокВыбора.Добавить("Патент", "Патент");
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ОсуществляетсяРеализацияТоваровУслугКомитентов") Тогда
			Элементы.ПокупателиВидДеятельности.СписокВыбора.Добавить("Комиссия", "Комиссия");
		КонецЕсли;
		
		Элементы.ПокупателиВидДеятельности.Видимость = Элементы.ПокупателиВидДеятельности.СписокВыбора.Количество() > 1;
	Иначе
		Если УчетнаяПолитика.ПлательщикЕНВД(Объект.Организация, ДатаУчетнойПолитики) Тогда
			ОсновнойВидДеятельности = "ЕНВД";
		ИначеЕсли УчетнаяПолитика.ПрименяетсяУСНПатент(Объект.Организация, ДатаУчетнойПолитики) Тогда
			ОсновнойВидДеятельности = "Патент";
		КонецЕсли;
	КонецЕсли;
	
	МенеджерОбработки = Обработки.ВводНачальныхОстатков;
	МенеджерОбработки.СобратьСтруктуруТаблиц(Объект.Покупатели, "Покупатели", СтруктураТаблиц);
	МенеджерОбработки.ОбновитьОстатки(Объект.Покупатели, "Покупатели", 
		Новый Структура("Организация,ДатаВводаОстатков",
					Объект.Организация,Объект.ДатаВводаОстатков),
		Объект.СуществующиеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененениеДатыВводаОстатков" И Источник = "ВводНачальныхОстатков" И Параметр = Объект.Организация Тогда
		Объект.ДатаВводаОстатков = ПеречитатьДатуНачалаУчета(Объект.Организация);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Оповещение = Новый ОписаниеОповещения(
		"ПередЗакрытиемЗавершение",
		ЭтотОбъект);
	
	ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

#КонецОбласти
