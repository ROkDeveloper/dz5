﻿
#Область ОбъявлениеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЦветПодсветки = ЦветаСтиля.ВыборСтандартногоПериодаФонКнопки;
	
	Параметры.Свойство("Организация",   Объект.Организация);
	Параметры.Свойство("Правило",       Правило);
	Параметры.Свойство("ПериодСобытия", Объект.Период);
	Параметры.Свойство("Срок",          Срок);
	
	МожноСоздаватьДокументыУплаты = ПравоДоступа("Изменение", Метаданные.Документы.ПлатежноеПоручение);
	МожноСоздаватьУведомления     = ПравоДоступа("Изменение", Метаданные.Документы.УведомлениеОбИсчисленныхСуммахНалогов);
	
	Элементы.Организация.Видимость = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
	ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		НачалоКвартала(Объект.Период), КонецКвартала(Объект.Период), Истина);
	Заголовок = СтрШаблон(НСтр("ru = 'Отчетность по НДС, уплата 1/3 за %1'"), ПредставлениеПериода);
	Элементы.НалогКУплате.Заголовок = СтрШаблон(НСтр("ru = 'Налог к уплате за %1'"), ПредставлениеПериода);
	
	Объект.Период = НачалоКвартала(Объект.Период);
	Объект.Организация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Объект.Организация);
	
	СрокУплатыНалога = Срок;
	Налог            = Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(Перечисления.ВидыНалогов.НДС);
	Правило          = Параметры.Правило;
	ПериодСобытия    = Параметры.ПериодСобытия;
	
	ОпределитьСвязанныеПравила();
	
	ПлательщикЕНП = ПомощникиПоУплатеНалоговИВзносов.ПрименяетсяОсобыйПорядокУплатыНалога(
		Объект.Организация,
		Срок);
		
	ПодаетсяУведомлениеПоНалогуЗаПериод = ?(ПериодСобытия >= НастройкиУчетаКлиентСервер.ДатаПереходаНаЕдиныйНалоговыйПлатеж(),
		Ложь,
		ЗначениеЗаполнено(ПравилоУведомления));
	
	Элементы.ГруппаУведомлениеОНалогах.Видимость = ПлательщикЕНП;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СоставРазделов = Новый Структура("Расчет, Уведомление, Уплата", Истина, ПлательщикЕНП, Истина);
	ЗаполнитьПомощник(СоставРазделов, "Подключаемый_ПроверитьВыполнениеЗаданияПриОткрытии", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеОбменСБанками" Тогда
		
		ОбработатьУплату();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПлатеж1ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ДекорацияПлатежОбработкаНавигационнойСсылки(0, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПлатеж2ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ДекорацияПлатежОбработкаНавигационнойСсылки(1, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПлатеж3ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ДекорацияПлатежОбработкаНавигационнойСсылки(2, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Оплатить(Команда)
	
	Если ПлательщикЕНП
		И Не ЗначениеЗаполнено(Уведомления[ИндексОчередногоПлатежа].Уведомление) Тогда
		ПредупредитьОбОтсутствииУведомления();
	Иначе
		ОплатитьНалог();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСсылкаПомощникНажатие(Элемент)
	
	ИмяФормыПлатежногоДокумента = "Обработка.ПомощникРасчетаНДС.Форма.Форма";
	
	ПараметрыФормыПомощника = ПараметрыФормыПомощника();
	
	ОповещениеУплаты = Новый ОписаниеОповещения("ОбработатьУплату", ЭтотОбъект);
	ОткрытьФорму(ИмяФормыПлатежногоДокумента, ПараметрыФормыПомощника, ЭтотОбъект,,,,ОповещениеУплаты);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУведомление1Нажатие(Элемент)
	
	ОткрытьУведомление(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУведомление2Нажатие(Элемент)
	
	ОткрытьУведомление(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУведомление3Нажатие(Элемент)
	
	ОткрытьУведомление(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеСформироватьУведомление(Команда)
	
	ПараметрыУведомления = Новый Структура;
	ПараметрыУведомления.Вставить("Организация",                 Объект.Организация);
	ПараметрыУведомления.Вставить("Налог",                       Налог);
	ПараметрыУведомления.Вставить("Правило",                     ПравилоУведомления);
	ПараметрыУведомления.Вставить("ПериодСобытия",               ПериодСобытия);
	ПараметрыУведомления.Вставить("Срок",                        СрокУплатыНалога);
	ПараметрыУведомления.Вставить("АдресХранилищаТаблицыНалоги", ОписаниеТаблицыНалоги());
	ПараметрыУведомления.Вставить("КонтекстныйВызов",            Истина);
	
	ОповещениеУведомления = Новый ОписаниеОповещения("ОбработатьУведомление", ЭтотОбъект);
	ОткрытьФорму("Документ.УведомлениеОбИсчисленныхСуммахНалогов.Форма.ФормаДокумента",
		ПараметрыУведомления,
		ЭтотОбъект,
		,
		,
		,
		ОповещениеУведомления,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеСформироватьОперациюПоЕНС(Команда)
	
	ВыполненоВТихомРежиме = Ложь;
	СформироватьОперациюПоЕНСВТихомРежиме(ВыполненоВТихомРежиме);
	Если ВыполненоВТихомРежиме Тогда
		// Только перерисуем форму
		ОбработатьУведомление();
		Возврат;
	КонецЕсли;
	
	ПараметрыУведомления = Новый Структура;
	ПараметрыУведомления.Вставить("Организация",                 Объект.Организация);
	ПараметрыУведомления.Вставить("Налог",                       Налог);
	ПараметрыУведомления.Вставить("Правило",                     Правило);
	ПараметрыУведомления.Вставить("ПериодСобытия",               ПериодСобытия);
	ПараметрыУведомления.Вставить("Срок",                        СрокУплатыНалога);
	ПараметрыУведомления.Вставить("АдресХранилищаТаблицыНалоги", ОписаниеТаблицыНалоги());
	ПараметрыУведомления.Вставить("КонтекстныйВызов",            Истина);
	
	ОповещениеУведомления = Новый ОписаниеОповещения("ОбработатьУведомление", ЭтотОбъект);
	ОткрытьФорму("Документ.ОперацияПоЕдиномуНалоговомуСчету.Форма.ФормаДокумента",
		ПараметрыУведомления,
		ЭтотОбъект,
		,
		,
		,
		ОповещениеУведомления,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПлатежиВБанк(Команда)
	
	ДокументыОплатыПоБанку = ПлатежныеДокументыДляОтправкиПоДиректБанку();
	
	Если ЗначениеЗаполнено(ДокументыОплатыПоБанку) Тогда
		ОбменСБанкамиКлиент.СформироватьПодписатьОтправитьЭД(ДокументыОплатыПоБанку);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПлатежи(Команда)
	
	ДокументыОплатыВФайл = ПлатежныеДокументыДляВыгрузкиВФайл();
	
	Оповещение = Новый ОписаниеОповещения("ВыгрузитьПлатежныеДокументыЗавершение", ЭтотОбъект);
	ПомощникиПоУплатеНалоговИВзносовКлиент.ПроверитьИВыгрузитьПлатежныеДокументы(
		Объект.Организация, ДокументыОплатыВФайл, Оповещение, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
		ЗагрузитьРезультат();
		Если ФормаДлительнойОперации.Открыта()
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		КонецЕсли;
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьВыполнениеЗадания", 
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПоказателиДляРасчетаНалогаНаСервере(СоставРазделов)
	
	Если Элементы.СтраницыПомощник.ТекущаяСтраница = Элементы.СтраницаРабочая Тогда
		Элементы.СтраницыПомощник.ТекущаяСтраница  = Элементы.СтраницаПустая;
	КонецЕсли;
	
	ПараметрыЗадачи = Обработки.ПомощникРасчетаНДС.НовыеПараметрыЗадачи();
	ПараметрыЗадачи.Организация      = Объект.Организация;
	ПараметрыЗадачи.ПериодСобытия    = Объект.Период;
	ПараметрыЗадачи.НачалоПериода    = НачалоКвартала(Объект.Период);
	ПараметрыЗадачи.КонецПериода     = КонецКвартала(Объект.Период);
	ПараметрыЗадачи.Правило          = Правило;
	ПараметрыЗадачи.Срок             = Срок;
	ПараметрыЗадачи.СрокУплатыНалога = СрокУплатыНалога;
	ПараметрыЗадачи.ЭтоЗадачаОплаты  = Истина;
	ЗаполнитьЗначенияСвойств(ПараметрыЗадачи.СоставРазделов, СоставРазделов);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("Обработки.ПомощникРасчетаНДС.ПоказателиДляРасчетаВФоне", 
		ПараметрыЗадачи, ПараметрыВыполнения);
		
	АдресХранилища = Результат.АдресРезультата;
	
	Если Результат.Статус = "Выполнено" Тогда
		ЗагрузитьРезультат();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьРезультат()
	
	ПомощникРасчетаНДС.ЗагрузитьРезультат(ЭтотОбъект, АдресХранилища);
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияПриОткрытии()
	
	Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
		ЗагрузитьРезультат();
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьВыполнениеЗаданияПриОткрытии", 
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПлатежныйДокумент(Идентификатор)
	
	ОповещениеУплаты = Новый ОписаниеОповещения("ОбработатьУплату", ЭтотОбъект);
	
	Если ТипЗнч(Платежи[Идентификатор].ПлатежныеПоручения) = Тип("Массив")
		И Платежи[Идентификатор].ПлатежныеПоручения.Количество() > 1 Тогда
		
		СписокДокументов = Новый СписокЗначений;
		СписокДокументов.ЗагрузитьЗначения(Платежи[Идентификатор].ПлатежныеПоручения);
		СписокВыделения = Новый Структура("Ссылка", СписокДокументов);
		
		Отбор = Новый Структура;
		Отбор.Вставить("Организация", Объект.Организация);
		
		ПервыйДокумент = Платежи[Идентификатор].ПлатежныеПоручения[0];
		
		ИмяФормыСписка = "Документ.ПлатежноеПоручение.ФормаСписка";
		ОткрытьФорму(ИмяФормыСписка, Новый Структура("Отбор, ТекущаяСтрока, СписокВыделения",
			Отбор, ПервыйДокумент, СписокВыделения), ЭтотОбъект, Истина,,,ОповещениеУплаты);
		
	Иначе
		ИмяФормыПлатежногоДокумента = "Документ.ПлатежноеПоручение.Форма.ФормаДокументаНалоговая";
		ПараметрыФормыПлатежногоДокумента = ПараметрыФормыПлатежногоДокументаПоСтроке(Идентификатор);
		
		ОткрытьФорму(ИмяФормыПлатежногоДокумента, ПараметрыФормыПлатежногоДокумента, ЭтотОбъект,,,,ОповещениеУплаты);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПлатежныйДокумент(Идентификатор)
	
	СтрокаПлатежа = Платежи[Идентификатор];
	Если ТипЗнч(СтрокаПлатежа.ПлатежныеПоручения) = Тип("Массив")
		И СтрокаПлатежа.ПлатежныеПоручения.Количество() = 1 Тогда
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Удалить %1?'"), СтрокаПлатежа.ПредставлениеПлатежногоПоручения);
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ДокументДляУдаления", СтрокаПлатежа.ПлатежныеПоручения[0]);
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьПлатежныйДокументЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПлатежныйДокументЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		УдалитьДокументУплаты(ДополнительныеПараметры.ДокументДляУдаления);
		
		ОбработатьУплату();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьДокументУплаты(ДокументУплатыДляУдаления)
	
	ДокументУплатыОбъект = ДокументУплатыДляУдаления.ПолучитьОбъект();
	ДокументУплатыОбъект.УстановитьПометкуУдаления(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУведомление(Идентификатор)
	
	ОповещениеУведомления = Новый ОписаниеОповещения("ОбработатьУведомление", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура("Ключ", Уведомления[Идентификатор].Уведомление);
	
	Если ПодаетсяУведомлениеПоНалогуЗаПериод Тогда
		ИмяОбъекта = "УведомлениеОбИсчисленныхСуммахНалогов";
	Иначе
		ИмяОбъекта = "ОперацияПоЕдиномуНалоговомуСчету";
	КонецЕсли;
	
	ОткрытьФорму("Документ." + ИмяОбъекта + ".ФормаОбъекта",
		ПараметрыФормы,
		ЭтотОбъект,
		,
		,
		,
		ОповещениеУведомления,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыПлатежногоДокументаПоСтроке(Идентификатор)
	
	Возврат ПомощникРасчетаНДС.ПараметрыФормыПлатежногоДокументаПоСтроке(ЭтотОбъект, Идентификатор);
	
КонецФункции

&НаСервере
Функция ПараметрыФормыПомощника()
	
	ПараметрыФормыПомощника =  Новый Структура();
	ПараметрыФормыПомощника.Вставить("ПериодСобытия",    Объект.Период);
	ПараметрыФормыПомощника.Вставить("Организация",      Объект.Организация);
	ПараметрыФормыПомощника.Вставить("КонтекстныйВызов", Истина);
	
	Возврат ПараметрыФормыПомощника;
	
КонецФункции

&НаСервере
Процедура УправлениеФормой()
	
	Если Элементы.СтраницыПомощник.ТекущаяСтраница = Элементы.СтраницаПустая Тогда
		Элементы.СтраницыПомощник.ТекущаяСтраница  = Элементы.СтраницаРабочая;
	КонецЕсли;

	ПомощникРасчетаНДС.НастроитьБлокОплата(ЭтотОбъект);
	ПомощникРасчетаНДС.НастроитьБлокУведомление(ЭтотОбъект);
	
	УстановитьКнопкуПоУмолчанию();
	
	Элементы.ГруппаНДСНалоговогоАгента.Видимость = СуммаНалоговыйАгентНДС <> 0;
	Элементы.ГруппаНДСТаможенныйСоюз.Видимость = СуммаТаможенныйСоюзНДС <> 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьУплату(РезультатЗакрытия = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СоставРазделов = Новый Структура("Расчет, Уведомление, Уплата", Ложь, Ложь, Истина);
	ЗаполнитьПомощник(СоставРазделов, "Подключаемый_ПроверитьВыполнениеЗадания", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьУведомление(РезультатЗакрытия = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СоставРазделов = Новый Структура("Расчет, Уведомление, Уплата", Ложь, Истина, Ложь);
	ЗаполнитьПомощник(СоставРазделов, "Подключаемый_ПроверитьВыполнениеЗадания", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредупредитьОбОтсутствииУведомления()

	Если ПодаетсяУведомлениеПоНалогуЗаПериод Тогда
		ТекстВопроса = НСтр("ru='Не подготовлено уведомление об исчисленной сумме налога.
		|Продолжить?'");
	Иначе
		ТекстВопроса = НСтр("ru='Не сформирована операция по единому налоговому счету.
		|Продолжить?'");
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПредупредитьОбОтсутствииУведомленияЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ПредупредитьОбОтсутствииУведомленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОплатитьНалог();
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьНалог()
	
	ОповещениеУплаты = Новый ОписаниеОповещения("ОбработатьУплату", ЭтотОбъект);
	ПараметрыФормыПлатежногоДокумента = ПараметрыФормыПлатежногоДокументаПоСтроке(ИндексОчередногоПлатежа);
	ОткрытьФорму("Документ.ПлатежноеПоручение.Форма.ФормаДокументаНалоговая",
		ПараметрыФормыПлатежногоДокумента, ЭтотОбъект, , , , ОповещениеУплаты);
	
КонецПроцедуры

&НаСервере
Функция ОписаниеТаблицыНалоги()
	
	Возврат ПомощникРасчетаНДС.ОписаниеТаблицыНалоги(ЭтотОбъект, ИндексОчередногоПлатежа);
	
КонецФункции

&НаСервере
Процедура ОпределитьСвязанныеПравила()
	
	ПараметрыНабораПравил = ВыполнениеЗадачБухгалтера.ПараметрыНабораПравил();
	ЗаполнитьЗначенияСвойств(ПараметрыНабораПравил, ЭтотОбъект);
	ПараметрыНабораПравил.Организация = Объект.Организация;
	ВыполнениеЗадачБухгалтера.ОпределитьСвязанныеПравила(ПараметрыНабораПравил);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыНабораПравил);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОперациюПоЕНСВТихомРежиме(ВыполненоВТихомРежиме)
	
	ЕдиныйНалоговыйСчет.СформироватьОперациюПоЕНСВТихомРежиме(Объект.Организация,
		ОписаниеТаблицыНалоги(),
		Правило,
		ПериодСобытия,
		ВыполненоВТихомРежиме);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПомощник(СоставРазделов, ИмяОбработчика, ОткрытьФормуДлительнойОперации = Ложь)
	
	Результат = ПолучитьПоказателиДляРасчетаНалогаНаСервере(СоставРазделов);
	
	Если Результат.Статус = "Выполнено" Тогда
		ЗагрузитьРезультат();
	Иначе
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресРезультата;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания(
			ИмяОбработчика,
			ПараметрыОбработчикаОжидания.ТекущийИнтервал,
			Истина);
		Если ОткрытьФормуДлительнойОперации Тогда
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, ИдентификаторЗадания);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПлатежныеДокументыЗавершение(ПлатежныеПоручения, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ПлатежныеПоручения) Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьВыгрузкуПлатежейНаСервере(ПлатежныеПоручения);
	
	ОбработатьУплату();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьВыгрузкуПлатежейНаСервере(ПлатежныеПоручения)
	
	Для Каждого ПлатежныйДокумент Из ПлатежныеПоручения Цикл
		РегистрыСведений.СостоянияБанковскихДокументов.УстановитьСостояниеДокумента(
			ПлатежныйДокумент, Перечисления.СостоянияБанковскихДокументов.Отправлено);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПлатежныеДокументыДляВыгрузкиВФайл()
	
	Возврат ПомощникРасчетаНДС.ПлатежныеДокументыДляВыгрузкиВФайл(ЭтотОбъект);
	
КонецФункции

&НаСервере
Функция ПлатежныеДокументыДляОтправкиПоДиректБанку()
	
	Возврат ПомощникРасчетаНДС.ПлатежныеДокументыДляОтправкиПоДиректБанку(ЭтотОбъект);
	
КонецФункции

&НаСервере
Процедура УстановитьКнопкуПоУмолчанию()
	
	КнопкаПоУмолчаниюУведомление = ПлательщикЕНП И Не УведомлениеПодготовлено;
	УстановитьВидПоУмолчаниюОформлением(ЭтотОбъект, Элементы.ВыполнитьДействиеСформироватьУведомление, КнопкаПоУмолчаниюУведомление);
	УстановитьВидПоУмолчаниюОформлением(ЭтотОбъект, Элементы.ВыполнитьДействиеСформироватьОперациюПоЕНС, КнопкаПоУмолчаниюУведомление);
	
	НеОтправленныеПлатежи = ПомощникРасчетаНДС.НеОтправленныеПлатежи(ЭтотОбъект);
	КнопкаПоУмолчаниюОтправитьВБанк = Не КнопкаПоУмолчаниюУведомление
		И ЗначениеЗаполнено(НеОтправленныеПлатежи);
	УстановитьВидПоУмолчаниюОформлением(ЭтотОбъект, Элементы.ОтправитьПлатежиВБанк, КнопкаПоУмолчаниюОтправитьВБанк);
	УстановитьВидПоУмолчаниюОформлением(ЭтотОбъект, Элементы.ВыгрузитьПлатежи, КнопкаПоУмолчаниюОтправитьВБанк);
	
	КнопкаПоУмолчаниюУплата = Не КнопкаПоУмолчаниюУведомление
		И Не КнопкаПоУмолчаниюОтправитьВБанк;
	УстановитьВидПоУмолчаниюОформлением(ЭтотОбъект, Элементы.Оплатить, КнопкаПоУмолчаниюУплата);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидПоУмолчаниюОформлением(Форма, Элемент, ЭтоКнопкаПоУмолчанию)
	
	ПолужирныйШрифт = ЭтоКнопкаПоУмолчанию;
	Шрифт = Новый Шрифт(Элемент.Шрифт, , , ПолужирныйШрифт);
	
	Элемент.Шрифт    = Шрифт;
	Элемент.ЦветФона = ?(ЭтоКнопкаПоУмолчанию, Форма.ЦветПодсветки, Новый Цвет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПлатежОбработкаНавигационнойСсылки(Идентификатор, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьДокумент" Тогда
		
		ОткрытьПлатежныйДокумент(Идентификатор);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "УдалитьДокумент" Тогда
		
		УдалитьПлатежныйДокумент(Идентификатор);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

