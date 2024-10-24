﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.Заголовок               = НСтр("ru = 'Поступление (акты, накладные, УПД)'");
	ПараметрыОткрытия.ИмяФормы                = "Документ.ПоступлениеТоваровУслуг.ФормаСписка";
	ПараметрыОткрытия.ЗамерПроизводительности = "СозданиеФормыСпискаПоступлениеТоваровУслуг";
	// Не связываем форму списка с навигационной ссылкой команды, 
	// чтобы не смущать пользователя словами про оценку производительности в тексте ссылки, 
	// который могут пересылать другим пользователям.
	ПараметрыОткрытия.НавигационнаяСсылка     = Неопределено;

	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия);
	
КонецПроцедуры
