﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПростойИнтерфейсКасса");
	
	ОткрытьФорму(
		"Обработка.ПанелиПростойИнтерфейс.Форма.ПанельКасса",,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанелиПростойИнтерфейс.Форма.ПанельКасса" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
