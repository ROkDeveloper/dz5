﻿
#Область ОписаниеПеременных

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;
&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ОтправкаПочтовыхСообщений.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеСчетФактураВыданныйНалоговыйАгент";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	ПроведениеСервер.УстановитьПризнакПроверкиРеквизитов(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПредставлениеДокумента = Документы.СчетФактураВыданный.ПолучитьПредставлениеДокумента(Объект.Ссылка, Объект.ВидСчетаФактуры);
	УстановитьЗаголовокФормы(ЭтаФорма, ПредставлениеДокумента);
	УстановитьСостояниеДокумента();
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Оповестить("Запись_СчетФактураВыданный", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Проверка на изменение ответственных лиц.
	Если НЕ ТребуетсяВызовСервера Тогда
		Если ТипЗнч(ДатыИзмененияОтветственныхЛиц) = Тип("ФиксированныйМассив") Тогда
		 	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиентСервер.ДатыПринадлежатРазнымИнтервалам(Объект.Дата, 
		 		ТекущаяДатаДокумента, ДатыИзмененияОтветственныхЛиц);
		КонецЕсли;
	КонецЕсли;
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Объект.ДокументОснование	= Неопределено;
	Объект.ДокументыОснования.Очистить();
	Объект.ПлатежноРасчетныеДокументы.Очистить();
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("Организация",        Объект.Организация);
	ПараметрыДокумента.Вставить("Контрагент" ,        Объект.Контрагент);
	ПараметрыДокумента.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
		
	НовыеПараметры = ПолучитьДанныеКонтрагентПриИзменении(ПараметрыДокумента);
	ЗаполнитьЗначенияСвойств(Объект, НовыеПараметры,,"ДоговорКонтрагента");
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущийКод = Элемент.СписокВыбора.НайтиПоЗначению(Объект.КодВидаОперации);
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИзСпискаЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, Элемент.СписокВыбора, Элемент, ТекущийКод);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОтветственныйПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКомитентаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.ДоговорКомитента) Тогда
		Возврат;
	КонецЕсли;
	
	ДоговорКомитентаПриИзмененииНаСервере(
		Объект.Комитент,
		Объект.ДоговорКомитента,
		Объект.СчетРасчетов);
		
КонецПроцедуры

&НаКлиенте
Процедура КомитентПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Комитент) Тогда
		Возврат;
	КонецЕсли;
	
	КомитентПриИзмененииНаСервере(
		Объект.Комитент,
		Объект.ДоговорКомитента,
		Объект.СчетРасчетов);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАвансы

&НаКлиенте
Процедура АвансыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриНачалеРедактированияТабличнойЧасти(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОкончанииРедактированияТабличнойЧасти(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные  = Элементы.Авансы.ТекущиеДанные;
	НовыеПараметры = ПолучитьДанныеНоменклатураПриИзменении(ТекущиеДанные.Номенклатура, Объект.Дата);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, НовыеПараметры);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(ТекущиеДанные, Истина);
	РассчитатьСуммуБезНДС();
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(ТекущиеДанные, Истина);
	РассчитатьСуммуБезНДС();
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСтавкаНДСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Авансы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(ТекущиеДанные, Истина);
	РассчитатьСуммуБезНДС();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлению(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Комитент) Тогда 
		ТекстПредупреждения = НСтр("ru = 'Не выбран Комитент. Заполнение невозможно.'") ;
		ПоказатьПредупреждение( , ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ПараметрыОтбора = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, ВидОперации",
		Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента, ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия"));
	ПараметрыФормы = Новый Структура("Отбор, МножественныйВыбор", ПараметрыОтбора, Ложь);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьПоПоступлениюНаКлиентеЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	ТекущаяДатаДокумента          = Объект.Дата;
	ДатыИзмененияОтветственныхЛиц = ОтветственныеЛицаБППовтИсп.ДатыИзмененияОтветственныхЛицОрганизаций(Объект.Организация);

	ЗаполнитьСписокКодовОпераций();
	
	ПредставлениеДокумента = Документы.СчетФактураВыданный.ПолучитьПредставлениеДокумента(Объект.Ссылка, Объект.ВидСчетаФактуры);
	УстановитьЗаголовокФормы(ЭтаФорма, ПредставлениеДокумента);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Объект.КодВидаОперации = ПолучитьКодВидаОперации();
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	ИспользуетсяПостановлениеНДС1137	= УчетНДСПереопределяемый.ИспользуетсяПостановлениеНДС1137(Объект.Дата);
	
	ВедетсяУчетНДСПоФЗ81 = УчетНДС.ВедетсяУчетНДСПоФЗ81(Объект.Дата);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;
	
	Если Объект.СформированПриВводеНачальныхОстатковНДС Тогда
		Форма.ТолькоПросмотр	= Истина;
	КонецЕсли;

	Элементы.СуммаНДСДокумента.Доступность		= Форма.ИспользуетсяПостановлениеНДС1137;
	Элементы.СуммаБезНДС.Доступность	= Форма.ИспользуетсяПостановлениеНДС1137;
		
	Форма.СуммаБезНДС = Объект.Авансы.Итог("Сумма") - Объект.Авансы.Итог("СуммаНДС");
	
	Элементы.НомерИсправленияСистемный.Доступность	= Форма.ИспользуетсяПостановлениеНДС1137 И Объект.Исправление;
	Элементы.НомерИсходногоДокумента.Доступность	= Форма.ИспользуетсяПостановлениеНДС1137 И Объект.Исправление;
	Элементы.ДатаИсходногоДокумента.Доступность		= Форма.ИспользуетсяПостановлениеНДС1137 И Объект.Исправление;
	
	Если Форма.ИспользуетсяПостановлениеНДС1137 И Объект.Исправление Тогда
		Элементы.РеквизитыТекущийСФ.Видимость = Ложь;
		Элементы.РеквизитыИсправляемыйСФНадпись.Видимость = Истина;
		Элементы.ГруппаИсправление.Видимость              = Истина;
		Форма.РеквизитыИсправляемыйСФНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 от %2'"),
			Объект.НомерИсходногоДокумента,Формат(Объект.ДатаИсходногоДокумента,"ДЛФ=Д"));
	Иначе
		Элементы.РеквизитыТекущийСФ.Видимость = Истина;
		Элементы.РеквизитыИсправляемыйСФНадпись.Видимость = Ложь;
		Элементы.ГруппаИсправление.Видимость              = Ложь;
	КонецЕсли;
	
	// Перевыставление счета-фактуры налогового агента комитенту.
	ПеревыставлениеСчетаФактурыНА = ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.СчетФактураВыданный");
	Элементы.ГруппаКомитент.Видимость               = ПеревыставлениеСчетаФактурыНА;
	Элементы.ДоговорКомитента.Видимость             = ПеревыставлениеСчетаФактурыНА;
	Элементы.СчетРасчетов.Видимость                 = ПеревыставлениеСчетаФактурыНА;
	Элементы.АвансыЗаполнитьПоПоступлению.Видимость = ПеревыставлениеСчетаФактурыНА;
	
	Элементы.ГруппаВидаОперации.Видимость = Форма.ИспользуетсяПостановлениеНДС1137;
	
	ТекущийКод = Элементы.КодВидаОперации.СписокВыбора.НайтиПоЗначению(Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		Форма.НадписьВидОперации = Сред(ТекущийКод.Представление, 5);
	Иначе
		Форма.НадписьВидОперации = "";
	КонецЕсли;
	
	ЭтоЮрЛицо = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Объект.Организация);
	
	Элементы.Руководитель.Видимость = Истина;
	Если ЭтоЮрЛицо Тогда
		Элементы.ГлавныйБухгалтер.Видимость = Истина;
		Элементы.Руководитель.Заголовок     = НСтр("ru = 'Руководитель'");
	ИначеЕсли Форма.ВедетсяУчетНДСПоФЗ81 Тогда
		Элементы.ГлавныйБухгалтер.Видимость = Ложь;
		Элементы.Руководитель.Заголовок     = НСтр("ru = 'Предприниматель'");
	Иначе
		Элементы.Руководитель.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	Если ИспользуетсяПостановлениеНДС1137 Тогда
		Объект.КодВидаОперации         = ПолучитьКодВидаОперации();
	Иначе
		
		Объект.КодВидаОперации         = "";
		Объект.Исправление             = Ложь;
		Объект.НомерИсправления        = 0;
		Объект.НомерИсходногоДокумента = "";
		Объект.ДатаИсходногоДокумента  = '00010101';
	КонецЕсли;
	
	ЗаполнитьСписокКодовОпераций();
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовОпераций()
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры,
		Элементы.КодВидаОперации.СписокВыбора,
		Объект.Дата);
		
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.ДокументОснование	= Неопределено;
	Объект.ДокументыОснования.Очистить();
	Объект.ПлатежноРасчетныеДокументы.Очистить();
	
	УстановитьФункциональныеОпцииФормы();
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	ДатыИзмененияОтветственныхЛиц = ОтветственныеЛицаБППовтИсп.ДатыИзмененияОтветственныхЛицОрганизаций(Объект.Организация);
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("Организация",        Объект.Организация);
	ПараметрыДокумента.Вставить("Контрагент",         Объект.Контрагент);
	ПараметрыДокумента.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
	
	НовыеПараметры = ПолучитьДанныеОрганизацияПриИзменении(ПараметрыДокумента);
	ЗаполнитьЗначенияСвойств(Объект, НовыеПараметры);
	
	Объект.ДокументОснование	= Неопределено;
	Объект.ДокументыОснования.Очистить();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОтветственныйПриИзмененииНаСервере()
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДоговорКонтрагента(ПараметрыДокумента)
	
	ВидыДоговоров = Новый Массив;
	ВидыДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	ВидыДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);
	ВидыДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
	
	ДанныеДоговора = ЗаполнениеДокументов.ПолучитьДанныеКонтрагентПриИзменении(ПараметрыДокумента, ВидыДоговоров);
	
	Возврат ДанныеДоговора.ДоговорКонтрагента;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПараметрыДоговораКонтрагента(ДоговорКонтрагента)
	
	ПараметрыДоговора = Новый Структура;
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ПараметрыДоговора.Вставить("ВалютаВзаиморасчетов", 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ВалютаВзаиморасчетов"));
	Иначе
		ПараметрыДоговора.Вставить("ВалютаВзаиморасчетов", Справочники.Валюты.ПустаяСсылка());
	КонецЕсли;
	
	Возврат ПараметрыДоговора;
		
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Знач ПараметрыДокумента)
	
	НовыеПараметры = Новый Структура;
	
	НовыйДоговор = ПолучитьДоговорКонтрагента(ПараметрыДокумента);
	НовыеПараметры.Вставить("ДоговорКонтрагента", НовыйДоговор);
	
	ПараметрыДоговора = ПолучитьПараметрыДоговораКонтрагента(НовыйДоговор);
	НовыеПараметры.Вставить("ВалютаДокумента", ПараметрыДоговора.ВалютаВзаиморасчетов);
	
	НовыеПараметры.Вставить("СуммаДокумента",    0);
	НовыеПараметры.Вставить("ДокументОснование", Неопределено);
	НовыеПараметры.Вставить("ДатаПлатежноРасчетногоДокумента",  '00010101');
	НовыеПараметры.Вставить("НомерПлатежноРасчетногоДокумента", "");
	
	Возврат НовыеПараметры;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеКонтрагентПриИзменении(Знач ПараметрыДокумента)
	
	НовыеПараметры = Новый Структура;
	
	НовыйДоговор = ПолучитьДоговорКонтрагента(ПараметрыДокумента);
	НовыеПараметры.Вставить("ДоговорКонтрагента", НовыйДоговор);
	
	ПараметрыДоговора = ПолучитьПараметрыДоговораКонтрагента(НовыйДоговор);
	НовыеПараметры.Вставить("ВалютаДокумента", ПараметрыДоговора.ВалютаВзаиморасчетов);
	
	НовыеПараметры.Вставить("СуммаДокумента",    0);
	НовыеПараметры.Вставить("ДокументОснование", Неопределено);
	НовыеПараметры.Вставить("ДатаПлатежноРасчетногоДокумента",  '00010101');
	НовыеПараметры.Вставить("НомерПлатежноРасчетногоДокумента", "");
	
	Возврат НовыеПараметры;
		
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(Знач Номенклатура, Знач Дата)
	
	НовыеПараметры = Новый Структура;
	
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат НовыеПараметры;
	КонецЕсли;
	
	ПараметрыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "Услуга,НаименованиеПолное,ВидСтавкиНДС");
	
	ПараметрыНоменклатуры.Вставить("СтавкаНДС", Перечисления.СтавкиНДС.СтавкаНДС(ПараметрыНоменклатуры.ВидСтавкиНДС, Дата));
	
	Если ПараметрыНоменклатуры.Услуга Тогда
		НовыеПараметры.Вставить("Содержание", ПараметрыНоменклатуры.НаименованиеПолное);
	КонецЕсли;
	// Ставка НДС в счете-фактуре на аванс должна быть расчетная
	Если ПараметрыНоменклатуры.СтавкаНДС = Перечисления.СтавкиНДС.НДС0 
		ИЛИ ПараметрыНоменклатуры.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС 
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыНоменклатуры.СтавкаНДС) Тогда
		
		НовыеПараметры.Вставить("СтавкаНДС", УчетНДСКлиентСервер.РасчетнаяСтавкаНДСПользователя(Дата));

	Иначе
		НовыеПараметры.Вставить("СтавкаНДС", Перечисления.СтавкиНДС.РасчетнаяСтавкаНДСПоОбычной(ПараметрыНоменклатуры.СтавкаНДС));
	КонецЕсли;
	
	Возврат НовыеПараметры;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма, ПредставлениеДокумента)
	
	Форма.Заголовок = ПредставлениеДокумента.СчетФактураПредставление;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСчетФактуруНалоговыйАгентСервер(Знач ДокументОснование)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьСчетФактуруНалоговыйАгент(ДокументОснование, ДокументОбъект.Ссылка, Объект.ДоговорКонтрагента);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьКодВидаОперации()

	КодВидаОперации	= "06";
	
	Возврат КодВидаОперации;

КонецФункции

&НаКлиенте
Процедура НадписьСчетФактураНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение( , Объект.ИсправляемыйСчетФактура);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснование()
	
	ЕстьОшибкиЗаполнения = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Заполнение", НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Организация", "Объект" , ЕстьОшибкиЗаполнения);
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(Объект.Контрагент) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Заполнение", НСтр("ru = 'Контрагент'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Контрагент", "Объект" , ЕстьОшибкиЗаполнения);
	КонецЕсли;
	
	Если ЕстьОшибкиЗаполнения Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПолучитьСтруктуруПараметровФормы();
		
	ОткрытьФорму("Обработка.ПодборОснованийСчетаФактуры.Форма.ФормаВыбораОснованияСчетаФактуры", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
					
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы()
	
	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = Новый Структура();
	
	ЗначенияЗаполнения.Вставить("ТипСчетаФактуры", "Выданный");
	ЗначенияЗаполнения.Вставить("ВидСчетаФактуры", Объект.ВидСчетаФактуры);
	ЗначенияЗаполнения.Вставить("Исправление", Объект.Исправление);
	ЗначенияЗаполнения.Вставить("СчетФактура", Объект.Ссылка);
	
	ЗначениеОтбора = Новый Структура();
	
	ЗначениеОтбора.Вставить("Организация", Объект.Организация);
	ЗначениеОтбора.Вставить("Контрагент", Объект.Контрагент);
	
	СтруктураПараметров.Вставить("Документ", Объект.ДокументОснование);
	СтруктураПараметров.Вставить("Договор", Объект.ДоговорКонтрагента);
    СтруктураПараметров.Вставить("Отбор", ЗначениеОтбора);
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения); 
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ИсточникВыбора) = Тип("ФормаКлиентскогоПриложения")
		И ИсточникВыбора.ИмяФормы = "Обработка.ПодборОснованийСчетаФактуры.Форма.ФормаВыбораОснованияСчетаФактуры" Тогда 
		Объект.ПлатежноРасчетныеДокументы.Очистить();
		Объект.ДокументОснование = ВыбранноеЗначение.Документ;
		Модифицированность = Истина;
		Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
			ЗаполнитьСчетФактуруНалоговыйАгентСервер(Объект.ДокументОснование);
		КонецЕсли;
	КонецЕсли;
	
	ПриИзмененииДокументаОснованияНаСервере();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииДокументаОснованияНаСервере()
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ТекущийКод = Элемент.СписокВыбора.НайтиПоЗначению(Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		НадписьВидОперации = Сред(ТекущийКод.Представление, 5);
	Иначе
		НадписьВидОперации = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуБезНДС()
	
	СуммаБезНДС = Объект.Авансы.Итог("Сумма")-Объект.Авансы.Итог("СуммаНДС");
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОснование();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИзСпискаЗавершение(ВыбранныйКод, ДополнительныеПараметры) Экспорт

	Если ВыбранныйКод <> Неопределено Тогда
		Модифицированность = Истина;
		Объект.КодВидаОперации = ВыбранныйКод.Значение;
		НадписьВидОперации = Сред(ВыбранныйКод.Представление, 5);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДоговорКомитентаПриИзмененииНаСервере(Комитент, ДоговорКомитента, СчетРасчетовСКомитентом)
	
	СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
		Объект.Организация, Комитент, ДоговорКомитента);
		
	СчетРасчетовСКомитентом = СчетаУчета.СчетРасчетовСКомитентом;
	
КонецПроцедуры

&НаСервере
Процедура КомитентПриИзмененииНаСервере(Комитент, ДоговорКомитента, СчетРасчетовСКомитентом)
	
	ВидыДоговоров = Новый Массив;
	ВидыДоговоров.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку"));
	
	СтруктураОтбораДоговоров = Новый Структура("ВалютаВзаиморасчетов", Новый Структура("ЗначениеОтбора", ВалютаРегламентированногоУчета));
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ДоговорКомитента, Комитент, Объект.Организация,
		ВидыДоговоров, СтруктураОтбораДоговоров);
		
	Если ЗначениеЗаполнено(ДоговорКомитента) Тогда
		ДоговорКомитентаПриИзмененииНаСервере(Комитент, ДоговорКомитента, СчетРасчетовСКомитентом);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлениюНаКлиентеЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Поступление = РезультатЗакрытия;
	
	Если НЕ ЗначениеЗаполнено(Поступление) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗакупленнымиНаСервере(Поступление);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗакупленнымиНаСервере(Поступление)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Поступление", Поступление);
	СтруктураПараметров.Вставить("Комитент",    Объект.Комитент);
	СтруктураПараметров.Вставить("Сумма",       Объект.Авансы.Итог("Сумма"));
	СтруктураПараметров.Вставить("СуммаНДС",    Объект.Авансы.Итог("СуммаНДС"));
	
	ЗакупленныеТовары = Документы.СчетФактураВыданный.ТоварыУслугиЗакупленныеКомитентам(СтруктураПараметров);
	
	Если ЗакупленныеТовары <> Неопределено Тогда 
		Объект.Авансы.Загрузить(ЗакупленныеТовары);
	КонецЕсли;
	
КонецПроцедуры

#Область ПроверкаКонтрагентов

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#КонецОбласти

#КонецОбласти