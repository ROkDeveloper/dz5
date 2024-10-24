﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ОткрытьРасшифровкуСтатистики(ИмяОтчета, ИмяФормы, ИмяПоля, Параметры)  Экспорт
	
	Перем Организация, НачалоПериода, КонецПериода, НомерСтроки, АдресВременногоХранилищаРасшифровки;
	
	Если ТипЗнч(ИмяПоля) = Тип("Массив") Тогда
		
		Если ИмяПоля.Количество() > 0 Тогда
			ИмяПоля = ИмяПоля[0];	
		КонецЕсли;
		
	КонецЕсли;	
	
	Параметры.Свойство("Организация", 				Организация);
	Параметры.Свойство("мДатаНачалаПериодаОтчета", 	НачалоПериода);
	Параметры.Свойство("мДатаКонцаПериодаОтчета", 	КонецПериода);
	Параметры.Свойство("НомерСтроки", 				НомерСтроки);
	Параметры.Свойство("АдресВременногоХранилищаРасшифровки", АдресВременногоХранилищаРасшифровки);
		
	ПараметрыОтчета = Новый Структура();
	
	ПараметрыОтчета.Вставить("Организация", 	Организация);
	ПараметрыОтчета.Вставить("НачалоПериода", 	НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода", 	КонецПериода);
	ПараметрыОтчета.Вставить("ИмяПоля", 		ИмяПоля);
	ПараметрыОтчета.Вставить("ИмяФормы", 		ИмяФормы);
	ПараметрыОтчета.Вставить("ИмяОтчета", 		ИмяОтчета);
	ПараметрыОтчета.Вставить("НомерСтроки", 	НомерСтроки);
	ПараметрыОтчета.Вставить("АдресВременногоХранилищаРасшифровки", 	АдресВременногоХранилищаРасшифровки);
	
	Если ОткрытьФорму("Отчет.РасшифровкаСтатистики.Форма.ФормаОтчета", ПараметрыОтчета,,Истина) = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Для выбранной ячейки расшифровка не существует.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли; 
		
КонецПроцедуры
