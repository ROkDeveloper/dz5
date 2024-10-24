﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		ВалютаВзаиморасчетов = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПроверкуКлючевыхРеквизитов(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПроверкуКлючевыхРеквизитов(Отказ)
	
	Если ЭтоНовый() тогда
		// В случае нового основания финансирования не производить проверку
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Получим значения реквизитов основания финансирования из информационной базы
	РеквизитыОснованияФинансированияИзИБ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, 
		"ПометкаУдаления, НачислятьЗадолженностьПоФинансированию");
	
	Если ПометкаУдаления <> РеквизитыОснованияФинансированияИзИБ.ПометкаУдаления Тогда
		// В случае установки или снятия пометки удаления не производить проверку
		Возврат;
	КонецЕсли;
	
	// Проверим, можно ли изменять реквизиты основания финансирования.
	
	// Для элемента нужно получить документы, в которых использовано основание финансирование:
	Если ЕстьПроведенныеДокументыПоОснованию(РеквизитыОснованияФинансированияИзИБ) Тогда
		СписокРеквизитов = Новый Структура("НачислятьЗадолженностьПоФинансированию", 
			НСтр("ru = 'Начислять задолженность по финансированию'"));
		ТекстСообщения = НСтр("ru = 'Существуют документы, проведенные по основанию финансирования %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Наименование);
		ТекстСообщения = ТекстСообщения + НСтр("ru = '
			|Реквизит %2 не может быть изменен.'");
		Для Каждого КлючИЗначение Из СписокРеквизитов Цикл
			СообщитьОНекорректномРеквизите(РеквизитыОснованияФинансированияИзИБ, КлючИЗначение.Ключ, КлючИЗначение.Значение, ТекстСообщения, Отказ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьПроведенныеДокументыПоОснованию(РеквизитыОснованияФинансированияИзИБ)
	
	Если НачислятьЗадолженностьПоФинансированию = РеквизитыОснованияФинансированияИзИБ.НачислятьЗадолженностьПоФинансированию Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОснованиеФинансирования", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НачислениеЗадолженностиПоФинансированию.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.НачислениеЗадолженностиПоФинансированию КАК НачислениеЗадолженностиПоФинансированию
	|ГДЕ
	|	НачислениеЗадолженностиПоФинансированию.ОснованиеФинансирования = &ОснованиеФинансирования
	|	И НачислениеЗадолженностиПоФинансированию.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПоступлениеНаРасчетныйСчет.Ссылка
	|ИЗ
	|	Документ.ПоступлениеНаРасчетныйСчет КАК ПоступлениеНаРасчетныйСчет
	|ГДЕ
	|	ПоступлениеНаРасчетныйСчет.ОснованиеФинансирования = &ОснованиеФинансирования
	|	И ПоступлениеНаРасчетныйСчет.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПриходныйКассовыйОрдер.Ссылка
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|ГДЕ
	|	ПриходныйКассовыйОрдер.ОснованиеФинансирования = &ОснованиеФинансирования
	|	И ПриходныйКассовыйОрдер.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПоступлениеТоваровУслуг.Ссылка
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|ГДЕ
	|	ПоступлениеТоваровУслуг.ОснованиеФинансирования = &ОснованиеФинансирования
	|	И ПоступлениеТоваровУслуг.Проведен";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

Процедура СообщитьОНекорректномРеквизите(РеквизитыОбъекта, ИмяРеквизита, СинонимРеквизита, ШаблонСообщения, Отказ)
	
	Если РеквизитыОбъекта[ИмяРеквизита] <> ЭтотОбъект[ИмяРеквизита] Тогда
		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%2", СинонимРеквизита);
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность", 
			СинонимРеквизита, , , ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ИмяРеквизита, "Объект", Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли