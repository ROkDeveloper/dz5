﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область РегистрацияФизическихЛиц

// АПК:299-выкл: Особенности иерархии библиотек

Функция РеквизитГоловнаяОрганизация() Экспорт
	Возврат Метаданные.РегистрыСведений.ПериодыСтажаПФР.Измерения.ГоловнаяОрганизация.Имя;
КонецФункции

Функция РеквизитФизическоеЛицо() Экспорт
	Возврат Метаданные.РегистрыСведений.ПериодыСтажаПФР.Измерения.ФизическоеЛицо.Имя;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
