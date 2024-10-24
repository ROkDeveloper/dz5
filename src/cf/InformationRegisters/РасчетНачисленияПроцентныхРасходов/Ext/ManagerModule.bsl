﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиОбновления

Процедура ЗаполнитьПериод(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	РасчетНачисленияПроцентныхРасходов.Организация КАК Организация,
	|	РасчетНачисленияПроцентныхРасходов.Регистратор КАК Регистратор,
	|	РасчетНачисленияПроцентныхРасходов.ПериодРасчета КАК ПериодРасчета
	|ПОМЕСТИТЬ вт_Регистраторы
	|ИЗ
	|	РегистрСведений.РасчетНачисленияПроцентныхРасходов КАК РасчетНачисленияПроцентныхРасходов
	|ГДЕ
	|	РасчетНачисленияПроцентныхРасходов.Период = ДАТАВРЕМЯ(1, 1, 1)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт_Регистраторы.Регистратор КАК Регистратор,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.ДатаРегистратора, КОНЕЦПЕРИОДА(вт_Регистраторы.ПериодРасчета, МЕСЯЦ)) КАК Период
	|ИЗ
	|	вт_Регистраторы КАК вт_Регистраторы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО вт_Регистраторы.Организация = ДанныеПервичныхДокументов.Организация
	|			И вт_Регистраторы.Регистратор = ДанныеПервичныхДокументов.Документ";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	ВыборкаЗаписи = Результат.Выбрать();
	Пока ВыборкаЗаписи.Следующий() Цикл
	
		НаборЗаписей = РегистрыСведений.РасчетНачисленияПроцентныхРасходов.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаЗаписи.Регистратор);
		НаборЗаписей.Прочитать();
		
		Для каждого СтрокаНабора Из НаборЗаписей Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаНабора.Период) Тогда
				СтрокаНабора.Период = ВыборкаЗаписи.Период;
			КонецЕсли;
		КонецЦикла;
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		Исключение
			ШаблонСообщения = НСтр("ru = 'Не выполнено обновление записей регистра сведений ""Расчет начисления процентных расходов""
                                    |%1'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.РасчетНалогаНаИмущество,, 
				ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
