﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = ОбщегоНазначенияБПКлиентСервер.ПараметрыОткрытияФормыСОжиданием(ПараметрыВыполненияКоманды);
	ПараметрыОткрытия.ИмяФормы = "ЖурналДокументов.ЖурналОпераций.ФормаСпискаМаркетплейсы";
	ОбщегоНазначенияБПКлиент.ОткрытьФормуСОжиданием(ПараметрыОткрытия);
	
КонецПроцедуры
