﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущаяДата = ТекущаяДатаСеанса();
	Организация = Параметры.Организация;
	
	ПеречитатьНастройкиНаТекущуюДату();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПлательщикСтраховыхВзносовПФР_ФФОМСПриИзменении(Элемент)
	
	Если Не НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.ПлательщикСтраховыхВзносовПФР_ФФОМС Тогда
		НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.Тариф = Неопределено;
	Иначе
		НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.Тариф =
			ПредопределенноеЗначение("Перечисление.ИПТарифыФиксированныхВзносов.Единый");
	КонецЕсли;
	
	ДатаИзменения = ДатаИзмененияТарифаПоУмолчанию();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТарифПриИзменении(Элемент)
	
	ДатаИзменения = ДатаИзмененияТарифаПоУмолчанию();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура История(Команда)
	
	ПараметрыСписка = Новый Структура;
	ПараметрыСписка.Вставить("Отбор", Новый Структура("Организация", Организация));
	ПараметрыСписка.Вставить("ВедущийОбъект", Организация);
	ПараметрыСписка.Вставить("ТекущийПериод", ТекущаяДата);
	
	ОткрытьФорму("РегистрСведений.НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.Форма.ФормаСписка",
		ПараметрыСписка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура _ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(ТекущийЭлемент.Имя, "ОК_") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьИзменения();
	
	ПараметрыОповещения = Новый Структура(
		"Организация, Период",
		НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.Организация,
		НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.Период);
	Оповестить("Запись_НастройкиУчетаСтраховыхВзносовИП", ПараметрыОповещения);
	
	Модифицированность = Ложь;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИзмененияИстории(Команда)
	
	Если СтрНайти(ТекущийЭлемент.Имя, "Отменить_") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	ПеречитатьНастройкиНаТекущуюДату();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьИзменения()
	
	МенеджерЗаписи = РегистрыСведений.НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС);
	МенеджерЗаписи.Период = ДатаИзменения;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьНастройкиНаТекущуюДату()
	
	Отбор = Новый Структура("Организация", Организация);
	ТекущиеНастройки = РегистрыСведений.НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.СрезПоследних(ТекущаяДата, Отбор);
	
	Если ЗначениеЗаполнено(ТекущиеНастройки) Тогда
		ЗаполнитьЗначенияСвойств(НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС, ТекущиеНастройки[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДатаИзмененияТарифаПоУмолчанию()
	
	Если НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.Тариф = ПредопределенноеЗначение("Перечисление.ИПТарифыФиксированныхВзносов.ВоенныйПенсионер")
		И НачалоГода(ДатаИзменения) = НастройкиУчетаКлиентСервер.ДатаПереходаНаЕдиныйНалоговыйПлатеж() Тогда
		// Тариф для военных пенсионеров действует с конкретной даты
		Результат = УчетСтраховыхВзносовИПКлиентСервер.ДатаНачалаДействияТарифаДляВоенныхПенсионеров();
	Иначе
		Результат = НачалоДня(ТекущаяДата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.Модифицированность Тогда
		Элементы.СтраницыНастройкиУчетаСтраховыхВзносовИПИстория.ТекущаяСтраница = Элементы.СтраницаИзменениеНастройки;
	Иначе
		Элементы.СтраницыНастройкиУчетаСтраховыхВзносовИПИстория.ТекущаяСтраница = Элементы.СтраницаИсторияИзменения;
	КонецЕсли;
	
	Элементы.Тариф.Видимость = Форма.НастройкиУчетаСтраховыхВзносовИП_ПФР_ФФОМС.ПлательщикСтраховыхВзносовПФР_ФФОМС;
	
КонецПроцедуры

#КонецОбласти