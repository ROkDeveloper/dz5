﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОтбора = Новый Структура("Организация", ПараметрКоманды);
	
	ОткрытьФорму("РегистрСведений.УчетнаяПолитика.ФормаСписка",
		Новый Структура("Отбор", ПараметрыОтбора),
		ПараметрыВыполненияКоманды.Источник,
		,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
		,
		,
		);
	
КонецПроцедуры
