﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтозватьЦепочку = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отправить(Команда)
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Причина", 		Причина);
	СтруктураДанных.Вставить("ОтозватьЦепочку", ОтозватьЦепочку);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти
