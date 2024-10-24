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
	
	Константы.ИспользоватьДокументыПоступления.Установить(Значение);
	
	ОбщегоНазначенияБП.УстановитьОпциюОтображатьКомандыГлавноеПродажиПокупки();
	
	// Обеспечение функциональности
	Если Не Значение Тогда
		Возврат;
	КонецЕсли;
	
	КлассификаторыДоходовРасходов.ОбеспечитьФункциональность(
		Справочники.ПрочиеДоходыИРасходы,
		"ВестиУчетРасчетовСКонтрагентами");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли