﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УсловияЗаполнения = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийОтчетОРозничныхПродажах.ОтчетНТТОПродажах"));
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", УсловияЗаполнения);
	
	ОткрытьФорму("Документ.ОтчетОРозничныхПродажах.ФормаОбъекта", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры