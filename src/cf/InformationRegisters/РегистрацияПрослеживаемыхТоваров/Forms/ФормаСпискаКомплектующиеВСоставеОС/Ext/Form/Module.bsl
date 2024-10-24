﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация =           Параметры.Организация;
	Период =                Параметры.Период;
	ОсновноеСредство =      Параметры.ОсновноеСредство;
	Основание =             Параметры.Основание;
	ОстаточнаяСтоимостьОС = Параметры.ОстаточнаяСтоимостьОС;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", 
		Организация, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ОсновноеСредство", 
		ОсновноеСредство, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Номенклатура", 
		, ВидСравненияКомпоновкиДанных.Заполнено,, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИтогоСуммаПоКомплектующим = СуммаПоКомплектующим(Организация, Период, ОсновноеСредство, Основание);
	
	Если ИтогоСуммаПоКомплектующим > ОстаточнаяСтоимостьОС Тогда
		
		ТекстСообщения = НСтр("ru = 'Сумма, по всем комплектующим(%1), больше, чем остаточная стоимость основного средства:%2(%3)'");
		
		ТекстСообщения = СтрШаблон(
			ТекстСообщения, 
			ИтогоСуммаПоКомплектующим,
			ОсновноеСредство,
			ОстаточнаяСтоимостьОС);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("ИзменениеСоставаТоваровПоОС",, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	
	ПараметрыФормы.Вставить("Ключ", ВыбраннаяСтрока);
	ПараметрыФормы.Вставить("РежимОткрытия", Истина);
	
	ОткрытьФорму("РегистрСведений.РегистрацияПрослеживаемыхТоваров.Форма.ФормаЗаписиКомплектующиеВСоставеОС", 
		ПараметрыФормы, 
		ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Основание) Тогда
		
		ОчиститьПоследнююЗаписьПоОСВРегистре(
			ТекущиеДанные.Организация,
			ТекущиеДанные.Основание,
			ТекущиеДанные.ОсновноеСредство,
			Отказ);
		
		Если Отказ Тогда
			Элементы.Список.Обновить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьЗаписьПрослеживаемогоТовара(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("Период",      Период);
	ПараметрыФормы.Вставить("ОсновноеСредство", ОсновноеСредство);
	ПараметрыФормы.Вставить("Основание", Основание);
	ПараметрыФормы.Вставить("Ключ", КлючЗаписиВРегистреСведений(Организация, ОсновноеСредство, Основание, Период));
	
	ОткрытьФорму("РегистрСведений.РегистрацияПрослеживаемыхТоваров.Форма.ФормаЗаписиКомплектующиеВСоставеОС",
		ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючЗаписиВРегистреСведений(Организация, ОсновноеСредство, Основание, Период)
	
	КлючЗаписи = РегистрыСведений.РегистрацияПрослеживаемыхТоваров.ПустойКлюч();
	
	МенеджерНаборЗаписей = РегистрыСведений.РегистрацияПрослеживаемыхТоваров.СоздатьНаборЗаписей();
	МенеджерНаборЗаписей.Отбор.Организация.Установить(Организация);
	МенеджерНаборЗаписей.Отбор.ОсновноеСредство.Установить(ОсновноеСредство);
	МенеджерНаборЗаписей.Отбор.Основание.Установить(Основание);
	МенеджерНаборЗаписей.Прочитать();
	Если МенеджерНаборЗаписей.Количество() = 1
		И Не ЗначениеЗаполнено(МенеджерНаборЗаписей[0].Номенклатура) Тогда
		
		ПараметрыКлючаЗаписи = 
			Новый Структура("Организация,ПериодСобытия,ВидОперации,ОсновноеСредство,Номенклатура,Основание,ТНВЭД,РНПТ");
		ЗаполнитьЗначенияСвойств(ПараметрыКлючаЗаписи, МенеджерНаборЗаписей[0]);
		КлючЗаписи = РегистрыСведений.РегистрацияПрослеживаемыхТоваров.СоздатьКлючЗаписи(ПараметрыКлючаЗаписи);
		
	КонецЕсли;
	
	Возврат КлючЗаписи;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОчиститьПоследнююЗаписьПоОСВРегистре(Организация, Основание, ОсновноеСредство, Отказ)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегистрацияПрослеживаемыхТоваров.Номенклатура КАК Номенклатура,
	|	РегистрацияПрослеживаемыхТоваров.ОсновноеСредство КАК ОсновноеСредство,
	|	РегистрацияПрослеживаемыхТоваров.Организация КАК Организация,
	|	РегистрацияПрослеживаемыхТоваров.ПериодСобытия КАК ПериодСобытия,
	|	РегистрацияПрослеживаемыхТоваров.ВидОперации КАК ВидОперации,
	|	РегистрацияПрослеживаемыхТоваров.Основание КАК Основание,
	|	РегистрацияПрослеживаемыхТоваров.ТНВЭД КАК ТНВЭД,
	|	РегистрацияПрослеживаемыхТоваров.РНПТ КАК РНПТ
	|ИЗ
	|	РегистрСведений.РегистрацияПрослеживаемыхТоваров КАК РегистрацияПрослеживаемыхТоваров
	|ГДЕ
	|	РегистрацияПрослеживаемыхТоваров.ОсновноеСредство = &ОсновноеСредство
	|	И РегистрацияПрослеживаемыхТоваров.Основание = &Основание
	|	И РегистрацияПрослеживаемыхТоваров.Организация = &Организация";
	
	
	Результат =  Запрос.Выполнить().Выбрать();
	
	Если Результат.Количество() <> 1 Тогда 
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Результат.Следующий();
	
	МенеджерЗаписи = РегистрыСведений.РегистрацияПрослеживаемыхТоваров.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Результат);
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Номенклатура = "";
		МенеджерЗаписи.ТНВЭД = "";
		МенеджерЗаписи.Количество = 0;
		МенеджерЗаписи.Сумма = 0;
		МенеджерЗаписи.ВсегоКоличествоКомплектующих = 0;
		МенеджерЗаписи.ВсегоКомлектующихНаСумму = 0;
		МенеджерЗаписи.СтранаПроисхождения = "";
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
	РегистрыСведений.РегистрацияПрослеживаемыхТоваров.ОбновитьСостояние(Основание, Основание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СуммаПоКомплектующим(Организация, Период, ОсновноеСредство, Основание)
	
	НаборЗаписей = РегистрыСведений.РегистрацияПрослеживаемыхТоваров.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Отбор.ПериодСобытия.Установить(Период);
	НаборЗаписей.Отбор.ОсновноеСредство.Установить(ОсновноеСредство);
	НаборЗаписей.Отбор.Основание.Установить(Основание);
	НаборЗаписей.Прочитать();
	
	ИтогоСуммаПоКомплектующим = 0;
	Для каждого ТекСтрокаНаборЗаписей Из НаборЗаписей Цикл
		
		ИтогоСуммаПоКомплектующим = ИтогоСуммаПоКомплектующим + ТекСтрокаНаборЗаписей.ВсегоКомлектующихНаСумму;
		
	КонецЦикла;

	Возврат ИтогоСуммаПоКомплектующим;
	
КонецФункции

#КонецОбласти
