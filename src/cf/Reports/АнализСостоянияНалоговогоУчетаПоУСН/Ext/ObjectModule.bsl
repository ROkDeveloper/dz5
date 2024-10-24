﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НачалоПериода > КонецПериода Тогда		
		ТекстСообщения = НСтр("ru = 'Неправильно задан период формирования отчета!
			|Дата начала больше даты окончания периода.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Отчет.НачалоПериода", , Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) 
		И Не УчетнаяПолитика.ПрименяетсяУСНЗаПериод(Организация, НачалоПериода, КонецДня(КонецПериода)) Тогда
		ТекстСообщения = НСтр("ru = 'Выбранная организация не применяет 
			|упрощенную систему налогообложения!'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Отчет.Организация", , Отказ);
	КонецЕсли;
	
	Если ДатаИзмененияУПпоНДС > НачалоПериода Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отчет не может включать периоды с различным 
			|порядком признания расходов по входящему НДС.
			|Порядок признания расходов по НДС был изменен %1.
			|Измените период отчета так, чтобы указанная дата была одной из границ периода.'"),
			Формат(ДатаИзмененияУПпоНДС, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Отчет.НачалоПериода", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли