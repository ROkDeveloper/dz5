﻿
#Область ПрограммныйИнтерфейс

#Область ПроцедурыВыбораЗначенийПереопределяемыхТипов

// Открывает форму для выбора значения договора с установленными отборами.
//
// Параметры:
//	ПараметрыФормы - Структура - Содержит параметры, передаваемые в форму.
//	Элемент       - ПолеФормы - Элемент формы, из которого вызвана форма выбора.
//	ФормаВыбора   - Строка - имя открываемой формы выбора.
//	СтандартаяОбработка - Булево - выполнять ли стандартные действия платформы после вызова данной процедуры.
//
Процедура ОткрытьФормуВыбораДоговора(ПараметрыФормы, Элемент, ФормаВыбора = "ФормаВыбора", СтандартаяОбработка = Истина) Экспорт
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов." + ФормаВыбора, ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Открывает форму для выбора значения банковского счета с установленными отборами.
//
// Параметры:
//	ПараметрыФормы - Структура - Содержит параметры, передаваемые в форму.
//	Элемент - ПолеФормы - Элемент формы, из которого вызвана форма выбора.
//
Процедура ОткрытьФормуВыбораБанковскогоСчетОрганизации(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Открывает форму для выбора значения подразделениям с установленными отборами.
//
// Параметры:
//	ПараметрыФормы - Структура - Содержит параметры, передаваемые в форму.
//	Элемент - ПолеФормы - Элемент формы, из которого вызвана форма выбора.
//
Процедура ОткрытьФормуВыбораПодразделения(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

Процедура ОткрытьСчетФактуру(Форма, СчетФактура, ВидСчетаФактуры) Экспорт

	УчетНДСКлиент.ОткрытьСчетФактуру(Форма, СчетФактура, ВидСчетаФактуры);

КонецПроцедуры

#КонецОбласти

#Область АктуализацияДанных

// Формирует список имен реквизитов формы отчета, содержащих идентификаторы фоновых заданий,
// которые нужно отменить при закрытии отчета.
//
Функция ЗаданияОтменяемыеПриЗакрытииОтчета() Экспорт
	
	ОтменяемыеЗадания = Новый Массив;
	ОтменяемыеЗадания.Добавить("ИдентификаторЗадания");
	ОтменяемыеЗадания.Добавить("ИдентификаторЗаданияАктуализации");
	
	Возврат ОтменяемыеЗадания;
	
КонецФункции

// Выполняет действия после вывода результата в табличный документ на форме отчета.
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - место вывода результата отчета.
//
Процедура ПослеФормированияОтчета(Форма) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "КонтрольноеСоотношениеИтоговВыполняется") Тогда
		
		Если Форма.КонтрольноеСоотношениеИтоговВыполняется Тогда
			
			БухгалтерскиеОтчетыКлиент.УстановитьВидимостьПанелиПересчетаИтогов(Форма);
			
		Иначе
			
			БухгалтерскиеОтчетыКлиент.УстановитьВидимостьПанелиПересчетаИтогов(Форма, "ТребуетсяПересчет");

			Если Форма.ОписаниеЗаданияАктуализации <> Неопределено Тогда // задание дано этим отчетом
				
				ЗакрытиеМесяцаВызовСервера.ОтменитьВыполнениеЗадания(Форма.ОписаниеЗаданияАктуализации.ИдентификаторЗадания);
				Форма.ОписаниеЗаданияАктуализации = Неопределено;

			КонецЕсли;
			
			ЗакрытиеМесяцаКлиент.СкрытьПанельАктуализацииАвтоматически(Форма);
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗакрытиеМесяцаКлиент.ПодключитьПроверкуАктуальности(Форма);
	
КонецПроцедуры

// Проверяет актуальность для формы отчета.
//
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ПроверитьАктуальность(Форма, Организация, Период = Неопределено) Экспорт

	ЗакрытиеМесяцаКлиент.ПроверитьАктуальность(Форма, Организация, Период);
	
КонецПроцедуры

// Запускает актуализацию для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура Актуализировать(Форма, Организация, Период = Неопределено) Экспорт
	
	// Перед выполнением актуализации проверим количество документов требующих перепроведения.
	КоличествоДокументовДляПерепроведения = ЗакрытиеМесяцаВызовСервера.КоличествоДокументовДляПерепроведения(
		Организация, Период);
	
	Если КоличествоДокументовДляПерепроведения < ПредельноеКоличествоДокументовДляАктуализации() Тогда 
		
		ЗакрытиеМесяцаКлиент.Актуализировать(Форма, Организация, Период);
		
	Иначе
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для актуализации данных необходимо перепровести более %1 документов.'"),
			КоличествоДокументовДляПерепроведения);
		
		ПараметрыОповещения = Новый Структура("Форма, Организация, Период", Форма, Организация, Период);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВопросАктуализироватьЗавершение", ЭтотОбъект, ПараметрыОповещения);
		
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить("ВыполнитьВсе", НСтр("ru = 'Перепровести все'"));
		СписокКнопок.Добавить("Отмена", НСтр("ru = 'Отмена'"));
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстСообщения, СписокКнопок, , "Отмена");
	КонецЕсли
	
КонецПроцедуры

// Отменяет актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ОтменитьАктуализацию(Форма, Организация, Период = Неопределено) Экспорт
	
	ЗакрытиеМесяцаКлиент.ОтменитьАктуализацию(Форма, Организация, Период);
	
КонецПроцедуры

// Обработка оповещения об актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//	ИмяСобытия - Строка - Имя события оповещения.
//	Параметр - Произвольный - Параметр события оповещения.
//	Источник - Произвольный - Источник события оповещения.
//
Процедура ОбработкаОповещенияАктуализации(Форма, Организация, Период = Неопределено, ИмяСобытия, Параметр, Источник) Экспорт
	
	ЗакрытиеМесяцаКлиент.ОбработкаОповещенияАктуализации(Форма, Организация, Период, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

// Скрывает панель актуализации на форме отчета автоматически.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура СкрытьПанельАктуализацииАвтоматически(Форма) Экспорт
	
	ЗакрытиеМесяцаКлиент.СкрытьПанельАктуализацииАвтоматически(Форма);
	
КонецПроцедуры

// Скрывает панель актуализации на форме отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура СкрытьПанельАктуализации(Форма) Экспорт
	
	ЗакрытиеМесяцаКлиент.СкрытьПанельАктуализации(Форма);
	
КонецПроцедуры

// Обрабатывает навигационную ссылку, если данные не актуальны. Открывает форму обработки закрытия месяца.
//
//	Параметры:
//		ФормаОтчета - ФормаКлиентскогоПриложения - форма отчета, имеет основной реквизит "Отчет";
//		НавигационнаяСсылка - Строка - см. параметр обработки события формы "ОбработкаНавигационнойСсылки";
//		СтандартнаяОбработка - Булево - см. параметр обработки события формы "ОбработкаНавигационнойСсылки".
//
Процедура ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(ФормаОтчета, НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	Отчет = ФормаОтчета.Отчет;
	
	ПараметрыАктуализации = ЗакрытиеМесяцаКлиентСервер.НовыйПараметрыАктуализацииОтчета();
	ПараметрыАктуализации.Вставить("Организация",                       Отчет.Организация);
	ПараметрыАктуализации.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыАктуализации.Вставить("ДатаАктуальности",                  ФормаОтчета.ДатаАктуальности);
	ПараметрыАктуализации.Вставить("ДатаОкончанияАктуализации",         ?(Отчет.Свойство("КонецПериода"), Отчет.КонецПериода, Отчет.Период));

	ЗакрытиеМесяцаКлиент.ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(
		НавигационнаяСсылка,
		СтандартнаяОбработка,
		ФормаОтчета,
		ПараметрыАктуализации);
	
КонецПроцедуры

Процедура ВопросАктуализироватьЗавершение(ВыбранныйВариант, ДополнительныеПараметры) Экспорт

	Если ВыбранныйВариант = "ВыполнитьВсе" Тогда
		
		ЗакрытиеМесяцаКлиент.Актуализировать(ДополнительныеПараметры.Форма, ДополнительныеПараметры.Организация, ДополнительныеПараметры.Период);
		
	КонецЕсли;

КонецПроцедуры

Функция ПредельноеКоличествоДокументовДляАктуализации()
	
	// Считаем, что без дополнительного вопроса можем перепровести 100 документов.
	Возврат 100;
	
КонецФункции

#Область Устарело

// Устарела. Необходимо использовать ПослеФормированияОтчета() .
//
Процедура ПодключитьПроверкуАктуальности(Форма) Экспорт

	ЗакрытиеМесяцаКлиент.ПодключитьПроверкуАктуальности(Форма);
	
КонецПроцедуры

// Устарела. Проверяет завершение актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ПроверитьВыполнениеАктуализацииОтчета(Форма, Организация, Период = Неопределено) Экспорт

	ЗакрытиеМесяцаКлиент.ПроверитьВыполнениеАктуализацииОтчета(Форма, Организация, Период);

КонецПроцедуры

// Устарела. Проверяет завершение актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ПроверитьЗавершениеАктуализации(Форма, Организация, Период = Неопределено) Экспорт

	ЗакрытиеМесяцаКлиент.ПроверитьЗавершениеАктуализации(Форма, Организация, Период);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
