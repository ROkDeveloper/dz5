﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация             = Параметры.Организация;
	Настр_Кодировка         = Параметры.Кодировка;
	ВозможностьВыбораФайлов = Параметры.ВозможностьВыбораФайлов;
	
	Если ЗначениеЗаполнено(Параметры.БанковскийСчет)  Тогда
		ЦифровойСчет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.БанковскийСчет, "ЦифровойСчет");
	Если Не ЦифровойСчет Тогда
			Настр_БанковскийСчет    = Параметры.БанковскийСчет;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("СоглашениеПрямогоОбменаСБанками")
		И ЗначениеЗаполнено(Параметры.СоглашениеПрямогоОбменаСБанками) Тогда
		Настр_СоглашениеПрямогоОбменаСБанками = Параметры.СоглашениеПрямогоОбменаСБанками;
	КонецЕсли;
	
	КритическоеИзменение = Ложь;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ПрочитатьНастройкиБанковскогоСчета();
	ПрочитатьНастройкиПользователя();
	
	ПодготовитьФормуНаСервере();
	
	// Очистим кеш
	Если Не ПустаяСтрока(Параметры.КешНастроекЗагрузки) Тогда
		УдалитьИзВременногоХранилища(Параметры.КешНастроекЗагрузки);
	КонецЕсли;
	
	ИзменитьПараметрыВыбораБанковскогоСчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Настройки были изменены, сохранить?'");
		
		ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияЗавершение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ Настр_ПлатежноеПоручение И НЕ Настр_ПлатежноеТребование Тогда
		ТекстСообщения = НСтр("ru = 'Не выбраны документы для выгрузки'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Настр_ПлатежноеПоручение",, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Настр_ФайлЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайлаДляВыгрузкиИЗагрузки(Элемент, НСтр("ru = 'загрузки'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_ФайлЗагрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФайлДляПросмотра(Элемент, Настр_Кодировка, "Файл загрузки");
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_ФайлЗагрузкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	КритическоеИзменение = Истина;
	Настр_ФайлЗагрузки = Текст;
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_ФайлВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайлаДляВыгрузкиИЗагрузки(Элемент, НСтр("ru = 'выгрузки'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_ФайлВыгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФайлДляПросмотра(Элемент, Настр_Кодировка, "Файл выгрузки");
	
КонецПроцедуры

// Открывает для просмотра текстовой документ
//
&НаКлиенте
Процедура ОткрытьФайлДляПросмотра(Элемент, Кодировка, Заголовок)
	
	ДополнительныеПараметры = Новый Структура("ИмяФайла, Кодировка, Заголовок", Элемент.ТекстРедактирования, Кодировка, Заголовок);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраСозданиеФайла", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл = Новый Файл();
	Файл.НачатьИнициализацию(ОписаниеОповещения, ДополнительныеПараметры.ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаДляВыгрузкиИЗагрузки(Элемент, Режим) Экспорт
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(
		?(Режим = "выгрузки", РежимДиалогаВыбораФайла.Сохранение, РежимДиалогаВыбораФайла.Открытие));
	
	ДиалогВыбора.Фильтр                      = НСтр("ru = 'Текстовый файл'") + " (*.txt)|*.txt";
	ДиалогВыбора.Заголовок                   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выберите файл для %1 данных из банка'"), Режим);
	ДиалогВыбора.ПредварительныйПросмотр     = Ложь;
	ДиалогВыбора.Расширение                  = "txt";
	ДиалогВыбора.ИндексФильтра               = 0;
	ДиалогВыбора.ПолноеИмяФайла              = ?(ПустаяСтрока(Элемент.ТекстРедактирования),
		?(Режим = "выгрузки", "1c_to_kl.txt", "kl_to_1c.txt"), Элемент.ТекстРедактирования);
	ДиалогВыбора.ПроверятьСуществованиеФайла = Ложь;
	
	ДополнительныеПараметры = Новый Структура("Режим", Режим);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборФайлаДляВыгрузкиИЗагрузкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ДиалогВыбора.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_БанковскийСчетПриИзменении(Элемент)
	
	ПрочитатьНастройкиБанковскогоСчета();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_ПрограммаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура("Заголовок, Список, ТекущаяСтрока",
		НСтр("ru = 'Выберите название программы'"),
		Элементы.Настр_Программа.СписокВыбора,
		?(Настр_Программа = "", "АРМ ""Клиент"" АС ""Клиент-Сбербанк"" Сбербанка России", Настр_Программа));
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("Настр_ПрограммаНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораИзСписка", СтруктураПараметров, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_АвтоматическоеСозданиеНенайденныхЭлементовПриИзменении(Элемент)
	
	КритическоеИзменение = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_КодировкаПриИзменении(Элемент)
	
	КритическоеИзменение = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкаСтатейДДСНажатие(Элемент)
	Открытьформу("Справочник.СтатьиДвиженияДенежныхСредств.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		Если НЕ Модифицированность Тогда
			Закрыть();
		Иначе
			СохранитьНастройкиЗаполнения();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗавершениеАсинхронныхВызовов

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Если ПроверитьЗаполнение() Тогда
			СохранитьНастройкиЗаполнения();
		КонецЕсли;
	Иначе
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеИмениКаталогаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество() > 0 Тогда
		
		ИмяКаталога = ВыбранныеФайлы.Получить(0);
		ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталога);
		
		ЭтотОбъект.Настр_ФайлВыгрузки = ИмяКаталога + "1c_to_kl.txt";
		ЭтотОбъект.Настр_ФайлЗагрузки = ИмяКаталога + "kl_to_1c.txt";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаДляВыгрузкиИЗагрузкиЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество() > 0 Тогда
		
		Если ДополнительныеПараметры.Режим = НСтр("ru = 'загрузки'") Тогда
			Настр_ФайлЗагрузки = ВыбранныеФайлы[0];
		Иначе
			Настр_ФайлВыгрузки = ВыбранныеФайлы[0];
		КонецЕсли;
		
		Модифицированность   = Истина;
		КритическоеИзменение = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраСозданиеФайла(Файл, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("Файл", Файл);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраПроверкаСуществования", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраПроверкаСуществования(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не найден файл!'"));
		Возврат;
		
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.ИмяФайла));
	
	ПомещениеФайловЗавершение = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраЗавешениеПомещения", ЭтотОбъект, ДополнительныеПараметры);
	
	НачатьПомещениеФайлов(ПомещениеФайловЗавершение, ПомещаемыеФайлы, Ложь, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраЗавешениеПомещения(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено
		И ПомещенныеФайлы.Количество() > 0 Тогда
		ОписаниеФайлов = ПомещенныеФайлы.Получить(0);
		АдресФайла     = ОписаниеФайлов.Хранение;
		
		Если АдресФайла = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Текст = ПолучитьТекстовыйДокументИзВременногоХранилищаФайла(АдресФайла, ДополнительныеПараметры.Кодировка);
		Текст.Показать(ДополнительныеПараметры.Заголовок, ДополнительныеПараметры.ИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Настр_ПрограммаНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ВыбранныйЭлемент = РезультатЗакрытия;
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Настр_Программа    = ВыбранныйЭлемент;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Элементы.Организация.Видимость        = Не ЗначениеЗаполнено(Организация);
	Элементы.НастройкаСтатейДДС.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиДвиженияДенежныхСредств");
	
	Элементы.Настр_ФайлЗагрузки.Видимость = ВозможностьВыбораФайлов;
	Элементы.Настр_ФайлВыгрузки.Видимость = ВозможностьВыбораФайлов;
	
	Элементы.Настр_Программа.СписокВыбора.ЗагрузитьЗначения(
		УчетДенежныхСредствБП.СписокСовместимыхПрограммКлиентовБанка(Истина));
	
	Если Не ЗначениеЗаполнено(Настр_БанковскийСчет) И ЗначениеЗаполнено(Настр_СоглашениеПрямогоОбменаСБанками) Тогда
		// Доступность настроек "по банковскому счету", которые записываются в регистр НастройкиОбменаСКлиентомБанка
		Элементы.ПлатежноеПоручение.Доступность  = Ложь;
		Элементы.ПлатежноеТребование.Доступность = Ложь;
		Элементы.Настр_КонтролироватьНекорректныеСимволыВНомере.Доступность   = Ложь;
		Элементы.Настр_КонтролироватьБезопасностьОбменаСБанком.Доступность    = Ложь;
		Элементы.Настр_АвтоматическоеСозданиеНенайденныхЭлементов.Доступность = Ложь;
		Элементы.Настр_ПередЗагрузкойПоказыватьФормуОбменаСБанком.Доступность = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.Настр_Программа.Видимость = Не ЗначениеЗаполнено(Форма.Настр_СоглашениеПрямогоОбменаСБанками);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаполнитьТаблицуПлатежныхДокументов(ПлатежноеПоручение, ПлатежноеТребование)
	
	ТаблицаДокументов = Новый ТаблицаЗначений();
	ТаблицаДокументов.Колонки.Добавить("Документ", ОбщегоНазначенияБПКлиентСервер.ПолучитьОписаниеТиповСтроки(24));
	ТаблицаДокументов.Колонки.Добавить("Пометка",  Новый ОписаниеТипов("Булево"));
	
	СтрокаДокумента = ТаблицаДокументов.Добавить();
	СтрокаДокумента.Документ = "Платежное поручение";
	СтрокаДокумента.Пометка  = ПлатежноеПоручение;
	
	СтрокаДокумента = ТаблицаДокументов.Добавить();
	СтрокаДокумента.Документ = "Платежное требование";
	СтрокаДокумента.Пометка  = ПлатежноеТребование;
	
	Возврат ТаблицаДокументов;
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Модифицированность = Истина;
	
	УчетДенежныхСредствБП.УстановитьБанковскийСчет(Настр_БанковскийСчет, Организация, ВалютаРегламентированногоУчета);
	
	ПрочитатьНастройкиБанковскогоСчета();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиБанковскогоСчета()
	
	Если Не ЗначениеЗаполнено(Настр_БанковскийСчет) И ЗначениеЗаполнено(Настр_СоглашениеПрямогоОбменаСБанками) Тогда
		Банк = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Настр_СоглашениеПрямогоОбменаСБанками, "Банк");
		Настройки = Обработки.КлиентБанк.ПолучитьНастройкиПрограммыКлиентаБанка(Организация, Настр_БанковскийСчет, Банк);
	Иначе
		Настройки = Обработки.КлиентБанк.ПолучитьНастройкиПрограммыКлиентаБанка(Организация, Настр_БанковскийСчет);
		Настр_СоглашениеПрямогоОбменаСБанками        = Настройки.СоглашениеПрямогоОбменаСБанками;
	КонецЕсли;
	
	Настр_Кодировка                                  = Настройки.Кодировка = "DOS";
	Настр_Программа                                  = Настройки.Программа;
	Настр_ФайлВыгрузки                               = Настройки.ФайлВыгрузки;
	Настр_ФайлЗагрузки                               = Настройки.ФайлЗагрузки;
	Настр_КонтролироватьНекорректныеСимволыВНомере   = Настройки.КонтролироватьНекорректныеСимволыВНомере;
	Настр_АвтоматическоеСозданиеНенайденныхЭлементов = Настройки.СоздаватьНенайденныеЭлементы;
	Настр_ПередЗагрузкойПоказыватьФормуОбменаСБанком = Настройки.ПередЗагрузкойПоказыватьФормуОбменаСБанком;
	Настр_КонтролироватьБезопасностьОбменаСБанком    = Настройки.КонтролироватьБезопасностьОбменаСБанком;
	
	Настройки.Свойство("Платежное_поручение",  Настр_ПлатежноеПоручение);
	Настройки.Свойство("Платежное_требование", Настр_ПлатежноеТребование);
	
	Если ЗначениеЗаполнено(Настр_СоглашениеПрямогоОбменаСБанками) Тогда
		Если Не ЗначениеЗаполнено(Настр_БанковскийСчет) Тогда
			Настр_ЗагружатьВыпискуПоВсемСчетамБанка = Истина;
		КонецЕсли;
		
		Элементы.ГруппаВидыОбмена.ТекущаяСтраница = Элементы.ГруппаПрямойОбмен;
		Элементы.ПлатежноеТребование.Доступность  = Ложь;
	Иначе
		Элементы.ГруппаВидыОбмена.ТекущаяСтраница = Элементы.ГруппаОбменЧерезФайл;
		Элементы.ПлатежноеТребование.Доступность  = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиПользователя()
	
	Настройки = Обработки.КлиентБанк.НастройкиЗагрузки();
	
	Настр_ПроводитьПриЗагрузкеСписаниеСРасчетногоСчета
		= Настройки.СозданиеДокументов[Тип("ДокументСсылка.СписаниеСРасчетногоСчета")].ПроводитьДокумент;
	Настр_ПроводитьПриЗагрузкеПоступлениеНаРасчетныйСчет
		= Настройки.СозданиеДокументов[Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет")].ПроводитьДокумент;
	
	НастройкиСозданияНовыхКонтрагентов = Настройки.ЗаполнениеНовыхЭлементов[Тип("СправочникСсылка.Контрагенты")];
	Если НастройкиСозданияНовыхКонтрагентов <> Неопределено Тогда
		Если НастройкиСозданияНовыхКонтрагентов.Свойство("Родитель") Тогда
			Настр_ГруппаДляНовыхКонтрагентов = НастройкиСозданияНовыхКонтрагентов.Родитель;
		Иначе
			Настр_ГруппаДляНовыхКонтрагентов = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Настр_СоглашениеПрямогоОбменаСБанками) Тогда
		ЗагружатьВыпискуПоВсемСчетамБанка = Настройки.ЗагружатьВыпискуПоВсемСчетам[Настр_СоглашениеПрямогоОбменаСБанками];
		Настр_ЗагружатьВыпискуПоВсемСчетамБанка =
			?(ЗагружатьВыпискуПоВсемСчетамБанка = Неопределено, Ложь, ЗагружатьВыпискуПоВсемСчетамБанка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройки()
	
	// В хранилище настроек пользователя
	НастройкиЗагрузки = ЗагрузкаВыпискиПоБанковскомуСчету.НовыйНастройкиОбменСБанком();
	НастройкиЗагрузки.СозданиеДокументов[Тип("ДокументСсылка.СписаниеСРасчетногоСчета")].ПроводитьДокумент
		= Настр_ПроводитьПриЗагрузкеСписаниеСРасчетногоСчета;
	НастройкиЗагрузки.СозданиеДокументов[Тип("ДокументСсылка.ПоступлениеНаРасчетныйСчет")].ПроводитьДокумент
		= Настр_ПроводитьПриЗагрузкеПоступлениеНаРасчетныйСчет;
	
	Если ЗначениеЗаполнено(Настр_ГруппаДляНовыхКонтрагентов) Тогда
		НастройкиСозданияНовыхКонтрагентов = Новый Структура;
		НастройкиСозданияНовыхКонтрагентов.Вставить("Родитель", Настр_ГруппаДляНовыхКонтрагентов);
		НастройкиЗагрузки.ЗаполнениеНовыхЭлементов.Вставить(Тип("СправочникСсылка.Контрагенты"), НастройкиСозданияНовыхКонтрагентов);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Настр_СоглашениеПрямогоОбменаСБанками) Тогда
		Настройки = Обработки.КлиентБанк.НастройкиЗагрузки();
		Если Настройки.ЗагружатьВыпискуПоВсемСчетам[Настр_СоглашениеПрямогоОбменаСБанками] <> Неопределено
			Или Настр_ЗагружатьВыпискуПоВсемСчетамБанка Тогда
			Настройки.ЗагружатьВыпискуПоВсемСчетам.Вставить(
				Настр_СоглашениеПрямогоОбменаСБанками, Настр_ЗагружатьВыпискуПоВсемСчетамБанка);
			НастройкиЗагрузки.ЗагружатьВыпискуПоВсемСчетам =
				ОбщегоНазначения.СкопироватьРекурсивно(Настройки.ЗагружатьВыпискуПоВсемСчетам);
		КонецЕсли;
	КонецЕсли;
	
	Обработки.КлиентБанк.ЗаписатьНастройкиЗагрузки(НастройкиЗагрузки);
	
	Если Не ЗначениеЗаполнено(Настр_БанковскийСчет) И ЗначениеЗаполнено(Настр_СоглашениеПрямогоОбменаСБанками) Тогда
		// Для 1С:ДиректБанк, "по банку" сохраняем только пользовательские настройки,
		// т.к. настройки в регистре привязаны к банковским счетам.
		Возврат;
	КонецЕсли;
	
	// В регистр сведений
	НастройкиОбменаСКлиентомБанка = РегистрыСведений.НастройкиОбменаСКлиентомБанка.СоздатьМенеджерЗаписи();
	НастройкиОбменаСКлиентомБанка.БанковскийСчет = Настр_БанковскийСчет;
	НастройкиОбменаСКлиентомБанка.Организация = Организация;
	НастройкиОбменаСКлиентомБанка.Прочитать();
	
	ТаблицаДокументов = ЗаполнитьТаблицуПлатежныхДокументов(Настр_ПлатежноеПоручение, Настр_ПлатежноеТребование);
	
	НастройкиОбменаСКлиентомБанка.Организация                              = Организация;
	НастройкиОбменаСКлиентомБанка.БанковскийСчет                           = Настр_БанковскийСчет;
	НастройкиОбменаСКлиентомБанка.Программа                                = Настр_Программа;
	НастройкиОбменаСКлиентомБанка.Кодировка                                = ?(Настр_Кодировка, "DOS", "Windows");
	НастройкиОбменаСКлиентомБанка.ФайлВыгрузки                             = Настр_ФайлВыгрузки;
	НастройкиОбменаСКлиентомБанка.ФайлЗагрузки                             = Настр_ФайлЗагрузки;
	НастройкиОбменаСКлиентомБанка.ВидыВыгружаемыхПлатДокументов            = Новый ХранилищеЗначения(ТаблицаДокументов);
	НастройкиОбменаСКлиентомБанка.КонтролироватьНекорректныеСимволыВНомере = Настр_КонтролироватьНекорректныеСимволыВНомере;
	НастройкиОбменаСКлиентомБанка.ОтключитьАвтоматическоеСозданиеНенайденныхЭлементов = НЕ Настр_АвтоматическоеСозданиеНенайденныхЭлементов;
	НастройкиОбменаСКлиентомБанка.ПередЗагрузкойПоказыватьФормуОбменаСБанком = Настр_ПередЗагрузкойПоказыватьФормуОбменаСБанком;
	НастройкиОбменаСКлиентомБанка.НеКонтролироватьБезопасностьОбменаСБанком  = НЕ Настр_КонтролироватьБезопасностьОбменаСБанком;
	
	НастройкиОбменаСКлиентомБанка.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиЗаполнения()
	
	ЗаписатьНастройки();
	
	ИсходящиеПараметры = Новый Структура;
	ИсходящиеПараметры.Вставить("Организация",                              Организация);
	ИсходящиеПараметры.Вставить("БанковскийСчет",                           Настр_БанковскийСчет);
	ИсходящиеПараметры.Вставить("ФайлВыгрузки",                             Настр_ФайлВыгрузки);
	ИсходящиеПараметры.Вставить("ФайлЗагрузки",                             Настр_ФайлЗагрузки);
	ИсходящиеПараметры.Вставить("Кодировка",                                ?(Настр_Кодировка, "DOS", "Windows"));
	ИсходящиеПараметры.Вставить("Программа",                                Настр_Программа);
	ИсходящиеПараметры.Вставить("ВыгружатьПлатежноеПоручение",              Настр_ПлатежноеПоручение);
	ИсходящиеПараметры.Вставить("ВыгружатьПлатежноеТребование",             Настр_ПлатежноеТребование);
	ИсходящиеПараметры.Вставить("КонтролироватьНекорректныеСимволыВНомере", Настр_КонтролироватьНекорректныеСимволыВНомере);
	ИсходящиеПараметры.Вставить("СоздаватьНенайденныеЭлементы",             Настр_АвтоматическоеСозданиеНенайденныхЭлементов);
	ИсходящиеПараметры.Вставить("КритическоеИзменение",                     КритическоеИзменение);
	ИсходящиеПараметры.Вставить("КонтролироватьБезопасностьОбменаСБанком",  Настр_КонтролироватьБезопасностьОбменаСБанком);
	
	Если ЗначениеЗаполнено(Настр_СоглашениеПрямогоОбменаСБанками) Тогда
		ИсходящиеПараметры.Вставить("ЗагружатьВыпискуПоВсемСчетамБанка", Настр_ЗагружатьВыпискуПоВсемСчетамБанка);
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	Закрыть(ИсходящиеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстовыйДокументИзВременногоХранилищаФайла(АдресФайла, Кодировка)
	
	ИмяВременногоФайла  = ПолучитьИмяВременногоФайла("txt");
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайла);
	Текст = Новый ТекстовыйДокумент();
	Если Кодировка = "DOS" Тогда
		Кодир = "cp866";
	Иначе
		Кодир = "windows-1251";
	КонецЕсли;
	
	Текст.Прочитать(ИмяВременногоФайла, Кодир);
	
	Возврат Текст;
	
КонецФункции

&НаСервере
Процедура ИзменитьПараметрыВыбораБанковскогоСчета()
	
	МассивПараметров = Новый Массив();
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ЦифровойСчет", Ложь));
	
	Элементы.Настр_БанковскийСчет.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

#КонецОбласти
