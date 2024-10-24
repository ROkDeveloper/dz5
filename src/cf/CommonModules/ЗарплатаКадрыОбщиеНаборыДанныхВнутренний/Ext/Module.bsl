﻿
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТекстОбщегоЗапроса(ИсточникДанных, ТолькоРазрешенные) Экспорт
	
	Возврат ЗарплатаКадрыОбщиеНаборыДанныхБазовый.ПолучитьТекстОбщегоЗапроса(ИсточникДанных, ТолькоРазрешенные);
	
КонецФункции

Функция ПолучитьЗапросПоПредставлению(ТекстЗапроса, СоответствиеПараметров) Экспорт
	
	Возврат ЗарплатаКадрыОбщиеНаборыДанныхБазовый.ПолучитьЗапросПоПредставлению(ТекстЗапроса, СоответствиеПараметров);
	
КонецФункции

Процедура ПриПолученииСвойствРегистра(ИмяРегистра, СтруктураОписанияРегистра) Экспорт
	ЗарплатаКадрыОбщиеНаборыДанныхБазовый.ПриПолученииСвойствРегистра(ИмяРегистра, СтруктураОписанияРегистра);	
КонецПроцедуры

Функция ЗапросВТПредставленияОтработанноеВремя(ИмяВТНачисленияИУдержания, НачалоПериода, ОкончаниеПериода, ИмяВТОтработанноеВремя) Экспорт
	
	Возврат ЗарплатаКадрыОбщиеНаборыДанныхБазовый.ЗапросВТПредставленияОтработанноеВремя(ИмяВТНачисленияИУдержания, НачалоПериода, ОкончаниеПериода, ИмяВТОтработанноеВремя);
	
КонецФункции

Функция ЗапросПредставленияКадровыеДанныеСотрудниковАнализНачисленийИУдержаний(ТекстИсходногоЗапроса, ТолькоРазрешенные) Экспорт
	
	Возврат ЗарплатаКадрыОбщиеНаборыДанныхБазовый.ЗапросПредставленияКадровыеДанныеСотрудниковАнализНачисленийИУдержаний(ТекстИсходногоЗапроса, ТолькоРазрешенные);
	
КонецФункции

Функция ЗапросПредставленияПодразделенияСортировкиСотрудников() Экспорт
	
	Возврат ЗарплатаКадрыОбщиеНаборыДанныхБазовый.ЗапросПредставленияПодразделенияСортировкиСотрудников();
	
КонецФункции

#КонецОбласти
