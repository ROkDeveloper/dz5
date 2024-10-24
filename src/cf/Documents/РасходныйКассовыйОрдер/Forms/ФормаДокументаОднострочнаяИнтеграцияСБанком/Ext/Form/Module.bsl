﻿&НаКлиенте
Перем СтрокаПоискаПоКБК;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасходныйКассовыйОрдерФормы.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	РасходныйКассовыйОрдерФормы.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РасходныйКассовыйОрдерФормыКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Объект.ПометкаУдаления
		И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		
		ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение;
		
	КонецЕсли;
	
	РасходныйКассовыйОрдерФормыКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РасходныйКассовыйОрдерФормы.ПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	РасходныйКассовыйОрдерФормы.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	РасходныйКассовыйОрдерФормыКлиент.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
	Оповестить("ОбновитьПоказателиРасчетаУСН", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(
		ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(Параметры.ПериодПомощника)
		И ПлатежиВБюджетКлиентСерверПереопределяемый.ЭтоНалогУСН(ВидНалога) Тогда
		
		Если Объект.НалоговыйПериод < НачалоГода(Параметры.ПериодПомощника)
			Или Объект.НалоговыйПериод > КонецКвартала(Параметры.ПериодПомощника) Тогда
			
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Укажите период в интервале с %1 по %2'"),
				Формат(НачалоГода(Параметры.ПериодПомощника), "ДЛФ=D"),
				Формат(КонецКвартала(Параметры.ПериодПомощника), "ДЛФ=D"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "НалоговыйПериодСтрока",, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		Возврат;
	КонецЕсли;
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата,
		ТекущаяДатаДокумента);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииСервер();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииСервер();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НалогПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Налог) Тогда
		НалогПриИзмененииНаСервере(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Налог"), Ложь, СтрокаПоискаПоКБК);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РасходныйКассовыйОрдерФормыКлиент.НалогАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)

	РасходныйКассовыйОрдерФормыКлиент.НалогОкончаниеВводаТекста(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНалоговогоОбязательстваПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Налог) И ЗначениеЗаполнено(Объект.ВидНалоговогоОбязательства) Тогда
		
		ВидаНалоговогоОбязательстваОбработатьИзменение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйПериодПриИзменении(Элемент)
	
	ОбработатьИзменениеНалоговогоПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РасходныйКассовыйОрдерФормыКлиент.НалоговыйПериодНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	РасходныйКассовыйОрдерФормыКлиент.НалоговыйПериодРегулирование(ЭтотОбъект, Элемент, Направление, СтандартнаяОбработка);
	
	ОбработатьИзменениеНалоговогоПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РасходныйКассовыйОрдерФормыКлиент.НалоговыйПериодОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СтраховойПериодПриИзменении(Элемент)
	
	ОбработатьИзменениеНалоговогоПериода();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийРКО.УплатаНалога Тогда
		УстановитьПараметрыВыбораНалога();
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если Объект.Ссылка.Пустая() Тогда
		Заголовок = НСтр("ru = 'Оплата наличными (создание)'");
	Иначе
		Заголовок = СтрШаблон(НСтр("ru = 'Оплата наличными от %1'"), Формат(Объект.Дата, "ДЛФ=D"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораНалога()
	
	Если ЗначениеЗаполнено(Параметры.ВидыНалогов) И Элементы.Налог.Вид = ВидПоляФормы.ПолеВвода Тогда
		НовыйМассивПараметров = Новый Массив;
		НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВидНалога", Параметры.ВидыНалогов));
		Элементы.Налог.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	// При уплате фиксированных взносов из помощника предзаполненный страховой год изменять нельзя.
	ОграничитьИзменениеСтраховогоПериода = ЗначениеЗаполнено(Форма.Параметры.ПериодПомощника)
		И Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.УплатаНалога")
		И ПлатежиВБюджетКлиентСерверПереопределяемый.ЭтоФиксированныеВзносы(Форма.ВидНалога);
	Если ОграничитьИзменениеСтраховогоПериода Тогда
		Элементы.СтраховойПериод.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.СтраховойПериод.Формат = НСтр("ru = 'ДФ=""yyyy ''г.''""'");
	КонецЕсли;
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

#Область ОбработкаРеквизитовШапки

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	РасходныйКассовыйОрдерФормы.ДатаПриИзмененииСервер(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	РасходныйКассовыйОрдерФормы.ОрганизацияПриИзмененииСервер(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура НалогПриИзмененииНаСервере(ПричиныИзменения, АктуализированыРеквизитыПлатежаВБюджет, СтрокаПоискаПоКБК)
	
	РасходныйКассовыйОрдерФормы.НалогПриИзмененииНаСервере(
		ЭтотОбъект, ПричиныИзменения, АктуализированыРеквизитыПлатежаВБюджет, СтрокаПоискаПоКБК);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВидаНалоговогоОбязательстваОбработатьИзменение()
	
	РасходныйКассовыйОрдерФормы.ВидаНалоговогоОбязательстваОбработатьИзменение(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеНалоговогоПериода()
	
	РасходныйКассовыйОрдерФормы.ОбработатьИзменениеНалоговогоПериода(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

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

#КонецОбласти

#КонецОбласти
