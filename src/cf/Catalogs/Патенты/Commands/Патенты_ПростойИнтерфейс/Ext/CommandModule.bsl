﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПростойИнтерфейсБухгалтерия");
	
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Владелец", ПараметрыВыполненияКоманды.Источник.Организация));
	ОткрытьФорму(
		"Справочник.Патенты.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		"Справочник.Патенты.ФормаСписка" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
