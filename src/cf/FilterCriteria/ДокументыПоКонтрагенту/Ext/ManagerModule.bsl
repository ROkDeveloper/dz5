﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список документов, реквизиты которых входят в состав критерия отбора.
// Из списка исключаются документы отключенные функциональными опциями.
//
// Возвращаемое значение:
// Массив объектов метаданных
//
Функция СоставДокументов() Экспорт
	
	СписокДокументов = Новый Массив;
	
	МетаданныеКритерия = Метаданные.КритерииОтбора.ДокументыПоКонтрагенту;
	
	Для Каждого МетаданныеРеквизита Из МетаданныеКритерия.Состав Цикл
		Родитель = МетаданныеРеквизита.Родитель();
		Если Метаданные.Документы.Содержит(Родитель) Тогда
			Если СписокДокументов.Найти(Родитель) = Неопределено Тогда
				СписокДокументов.Добавить(Родитель);
			КонецЕсли;
		ИначеЕсли ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Родитель) Тогда
			РодительРодителя = Родитель.Родитель();
			Если Метаданные.Документы.Содержит(РодительРодителя) Тогда
				Если СписокДокументов.Найти(РодительРодителя) = Неопределено Тогда
					СписокДокументов.Добавить(РодительРодителя);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СписокДокументовРазрешенные = Новый Массив;
	Для Каждого Документ Из СписокДокументов Цикл
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Документ) Тогда
			СписокДокументовРазрешенные.Добавить(Документ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокДокументовРазрешенные;
	
КонецФункции

#КонецОбласти

#КонецЕсли