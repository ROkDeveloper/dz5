﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТарификацияБП.КонстантаФункциональностиПередЗаписью(Метаданные().Имя, Значение, Отказ);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ИспользоватьПроверкуРНПТ.Установить(Значение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
