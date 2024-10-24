﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьНастройкиФормированияКонтролируемыхСделок() Экспорт
	
	НастройкиФормированияКонтролируемыхСделок = Новый Структура();
	НастройкиФормированияКонтролируемыхСделок.Вставить("КомиссионноеВознаграждение", Справочники.Номенклатура.ПустаяСсылка());
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиФормированияКонтролируемыхСделок.КомиссионноеВознаграждение
	|ИЗ
	|	РегистрСведений.НастройкиФормированияКонтролируемыхСделок КАК НастройкиФормированияКонтролируемыхСделок";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Для Каждого НастройкаФормирования ИЗ НастройкиФормированияКонтролируемыхСделок Цикл
			НастройкиФормированияКонтролируемыхСделок[НастройкаФормирования.Ключ] = Выборка[НастройкаФормирования.Ключ];
		КонецЦикла;
	КонецЕсли;
	
	Возврат НастройкиФормированияКонтролируемыхСделок;
	
КонецФункции

Процедура ЗаписатьНастройкиФормированияКонтролируемыхСделок(НастройкиФормированияКонтролируемыхСделок) Экспорт
	
	Запись = РегистрыСведений.НастройкиФормированияКонтролируемыхСделок.СоздатьМенеджерЗаписи();
	Запись.Прочитать();
	Модифицированность = Ложь;
	Для Каждого НастройкаФормирования ИЗ НастройкиФормированияКонтролируемыхСделок Цикл
		Если Запись[НастройкаФормирования.Ключ] <> НастройкаФормирования.Значение Тогда
			Запись[НастройкаФормирования.Ключ] = НастройкаФормирования.Значение;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Модифицированность Тогда
		Запись.Записать();
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьЕдиницуИзмеренияШтука() Экспорт
	
	ЕдиницаИзмеренияШтука = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("796");
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияШтука) Тогда
		Возврат ЕдиницаИзмеренияШтука;
	Иначе
		Возврат Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьТекстНастроекФормированияКонтролируемыхСделок() Экспорт
	
	НастройкиФормированияКонтролируемыхСделок = ПолучитьНастройкиФормированияКонтролируемыхСделок();
	ТекстНастроек = НСтр("ru = 'Предмет сделки для комиссии: %1'");
	Если ЗначениеЗаполнено(НастройкиФормированияКонтролируемыхСделок.КомиссионноеВознаграждение) Тогда
		ТекстНастроек = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНастроек, НастройкиФормированияКонтролируемыхСделок.КомиссионноеВознаграждение);
	Иначе
		ТекстНастроек = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНастроек, НСтр("ru = '<не указан>'"));
	КонецЕсли;
	
	Возврат ТекстНастроек;
	
КонецФункции

#КонецЕсли