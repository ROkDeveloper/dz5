﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для печати договоров.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет команду формирования текста договора на основании шаблона.
//
Функция ВыполнитьКомандуПечатиТекстаДоговора(ОписаниеКоманды) Экспорт

	Если ТипЗнч(ОписаниеКоманды.ОбъектыПечати) <> Тип("Массив")
		ИЛИ ОписаниеКоманды.ОбъектыПечати.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Работаем только с одним объектом (первым в массиве)
	ОбъектПечати = ОписаниеКоманды.ОбъектыПечати[0];
	
	ПараметрыДоговора = ПечатьДоговоровВызовСервера.ПараметрыДоговораДляОбъекта(ОбъектПечати);
	ОбъектПечатиДоговор = ТипЗнч(ОбъектПечати) = Тип("СправочникСсылка.ДоговорыКонтрагентов");
	ИспользоватьФайлДоговора = ОбъектПечатиДоговор Или Не ПараметрыДоговора.ЭлектронныйФормат;
	
	Если ЗначениеЗаполнено(ПараметрыДоговора.ФайлДоговора) И ИспользоватьФайлДоговора Тогда

		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ОбъектПечати", ОбъектПечати);
		ПараметрыФормы.Вставить("ФайлДоговора", ПараметрыДоговора.ФайлДоговора);

		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаРедактированияТекстаДоговора", ПараметрыФормы, ОписаниеКоманды.Форма);
		
	Иначе
	
		// Это первый вызов печати текст договора, файл еще не был создан,
		// поэтому предложим пользователю сначала выбрать шаблон договора,
		// на основании которого создавать текст.
		ВыполнитьОткрытиеТекстаДоговора(ОбъектПечати, ОписаниеКоманды.Форма, ИспользоватьФайлДоговора, ОбъектПечатиДоговор);
		
	КонецЕсли;

КонецФункции

Функция ВыполнитьОткрытиеТекстаДоговора(ОбъектПечати, ФормаВладельца, ИспользоватьФайлДоговора, ОбъектПечатиДоговор) Экспорт

	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОбъектПечати", ОбъектПечати);
	ДополнительныеПараметры.Вставить("ВладелецФормы", ФормаВладельца);
	ДополнительныеПараметры.Вставить("ИспользоватьФайлДоговора", ИспользоватьФайлДоговора);

	ПараметрыОткрытия = Новый Структура("ОбъектПечатиДоговор", ОбъектПечатиДоговор);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыполнитьКомандуПечатиТекстаДоговораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
	ОткрытьФорму("Справочник.ШаблоныДоговоров.ФормаВыбора",
		ПараметрыОткрытия,
		,
		,
		,
		,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
КонецФункции

Процедура ОткрытьФормуНавигацииПоОшибкамВыгрузки(СообщенияОбОшибках) Экспорт 
		
	ПараметрыФормы = Новый Структура("ТаблицаСообщений", СообщенияОбОшибках);
		
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаНавигацииПоОшибкам", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьКомандуПечатиТекстаДоговораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если НЕ ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектПечати = ДополнительныеПараметры.ОбъектПечати;
	
	Если ТипЗнч(ОбъектПечати) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Шаблон = РезультатЗакрытия.Шаблон;
		ЭлектронныйФормат = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатЗакрытия, "ЭлектронныйФормат", Ложь);
	Иначе
		Шаблон = РезультатЗакрытия;
		ЭлектронныйФормат = Ложь;
	КонецЕсли;
	
	ИспользоватьФайлДоговора = 
		ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеПараметры, "ИспользоватьФайлДоговора", Ложь);

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ОбъектПечати",   ОбъектПечати);
	ПараметрыФормы.Вставить("ШаблонДоговора", Шаблон);
	ПараметрыФормы.Вставить("ЭлектронныйФормат",  ЭлектронныйФормат);
	ПараметрыФормы.Вставить("ИспользоватьФайлДоговора", ИспользоватьФайлДоговора);

	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаРедактированияТекстаДоговора",
		ПараметрыФормы,
		ДополнительныеПараметры.ВладелецФормы);

КонецПроцедуры

#КонецОбласти
