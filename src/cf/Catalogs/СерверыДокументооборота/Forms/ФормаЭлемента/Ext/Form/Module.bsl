﻿&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.АдресЭлектроннойПочтыПФР.Заголовок = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(
		Элементы.АдресЭлектроннойПочтыПФР.Заголовок, Истина);
	
	МестоХраненияКлюча = ЭлектроннаяПодписьВМоделиСервисаБРОВызовСервера.ОпределитьМестоХраненияКлюча();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения(
		"СертификатНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));

	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, МестоХраненияКлюча, Объект.Сертификат, "AddressBook");

КонецПроцедуры

&НаКлиенте
Процедура СертификатОчистка(Элемент, СтандартнаяОбработка)
	
	Сертификат = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		МестоХраненияКлюча, 
		Элементы.Сертификат, 
		Объект.Сертификат,
		ЭтотОбъект,
		"СертификатПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОткрытие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.Сертификат) Тогда
		ДанныеСертификата = Новый Структура("Отпечаток", Объект.Сертификат);
		КриптографияЭДКОКлиентСервер.КонтекстМоделиХраненияКлюча(МестоХраненияКлюча, ДанныеСертификата);
		КриптографияЭДКОКлиент.ПоказатьСертификат(ДанныеСертификата);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		МестоХраненияКлюча, 
		Элементы.Сертификат, 
		Объект.Сертификат,
		ЭтотОбъект,
		"СертификатПредставление");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Объект.Сертификат = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			МестоХраненияКлюча, 
			Элемент, 
			Объект.Сертификат,
			ЭтотОбъект,
			"СертификатПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


