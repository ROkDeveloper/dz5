﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипЗначения          = Параметры.ТипПараметра;
	Владелец             = Параметры.Владелец;
	СвязьПоВладельцу     = Параметры.СвязьПоВладельцу;
	ОтображатьНеИзменять = (ЗначениеЗаполнено(Параметры.ОтображатьНеИзменять) И Параметры.ОтображатьНеИзменять);
	Элементы.НеИзменять.Видимость = ОтображатьНеИзменять;
	
	НовыйПараметр	 = Новый ПараметрВыбора("Отбор.Владелец", Владелец);
	НовыйМассив		 = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НовыйПараметр);
	Элементы.Параметр.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.Значение.ПодсказкаВвода = Строка(ТипЗначения);
	
	Если ТипЗнч(Параметры.Значение) = Тип("СправочникСсылка.ПараметрыТиповойОперации")
		ИЛИ (ТипЗнч(Параметры.Значение) = Тип("Строка")
		И СтрНайти(Параметры.Значение," *") <> 0) Тогда
		Параметр	 = Параметры.Значение;
		ЭтоПараметр	 = 1;
		ЭтоЗначение	 = 0;
		НеИзменять	 = 0;
		Элементы.Значение.Доступность = Ложь;
	ИначеЕсли ОтображатьНеИзменять И ТипЗнч(Параметры.Значение) = Тип("Булево") Тогда
		ЭтоПараметр	 = 0;
		ЭтоЗначение	 = 0;
		НеИзменять	 = 1;
		Элементы.Параметр.Доступность = Ложь;
		Элементы.Значение.Доступность = Ложь;
	Иначе
		Значение	 = Параметры.Значение;
		ЭтоПараметр	 = 0;
		ЭтоЗначение	 = 1;
		НеИзменять	 = 0;
		Элементы.Параметр.Доступность = Ложь;
	КонецЕсли;
	
	// Установить связь параметров выбора
	Если СвязьПоВладельцу = "Параметр" Тогда
		ЭтоПараметр	 = 1;
		ЭтоЗначение	 = 0;
		НеИзменять	 = 0;
		Элементы.ЭтоЗначение.Доступность = Ложь;
		Элементы.Значение.Доступность = Ложь;
		Элементы.Параметр.Доступность = Истина;
	ИначеЕсли ЗначениеЗаполнено(СвязьПоВладельцу) Тогда
		МассивСвязейПараметровВыбора = Новый Массив;
		НоваяСвязь	 = Новый СвязьПараметраВыбора("Отбор.Владелец", "СвязьПоВладельцу");
		МассивСвязейПараметровВыбора.Добавить(НоваяСвязь);
		Элементы.Значение.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязейПараметровВыбора);
	КонецЕсли;

	Элементы.Значение.ОграничениеТипа = ТипЗначения;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	СтруктураВыбора = Новый Структура("Значение, ПараметрЗначениеНеИзменять");
	
	Если ЭтоПараметр Тогда
		СтруктураВыбора.Значение = Параметр;
		СтруктураВыбора.ПараметрЗначениеНеИзменять = 0;
	ИначеЕсли ЭтоЗначение Тогда
		СтруктураВыбора.Значение = Значение;
		СтруктураВыбора.ПараметрЗначениеНеИзменять = 1;
	Иначе
		СтруктураВыбора.Значение = "Не изменять";
		СтруктураВыбора.ПараметрЗначениеНеИзменять = 2;
	КонецЕсли;
	
	Закрыть(СтруктураВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭтоПараметрПриИзменении(Элемент)
	
	ЭтоЗначение						 = 0;
	НеИзменять						 = 0;
	Элементы.Значение.Доступность	 = Ложь;
	Элементы.Параметр.Доступность	 = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоЗначениеПриИзменении(Элемент)
	
	ЭтоПараметр						 = 0;
	НеИзменять						 = 0;
	Элементы.Значение.Доступность	 = Истина;
	Элементы.Параметр.Доступность	 = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура НеИзменятьПриИзменении(Элемент)

	ЭтоЗначение						 = 0;
	ЭтоПараметр						 = 0;
	Элементы.Значение.Доступность	 = Ложь;
	Элементы.Параметр.Доступность	 = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПараметрНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		ПараметрыОтбора = Новый Структура("Владелец, ТипПараметра", Владелец, ТипЗначения);
		ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьВыбранныйПараметрЗавершение", ЭтотОбъект);
		ОткрытьФорму("Справочник.ПараметрыТиповойОперации.ФормаВыбора", ПараметрыОтбора, , , , , ОписаниеОповещения);
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Параметр не может быть изменен.'")
			+ Символы.ПС
			+ НСтр("ru = 'Для выбора параметра вручную необходимо записать типовую операцию'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОписаниеОповещений

&НаКлиенте
Процедура УстановитьВыбранныйПараметрЗавершение(Результат, Параметры) Экспорт

	Если Результат <> Неопределено Тогда
		Параметр = Результат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти