﻿
#Область ПрограммныйИнтерфейс

// Отображает форму с ожидаением фонового задания переключения отложенного проведения.
//
// Параметры:
//	ДанныеДлительнойОперации - Структура - см. результат ПроведениеСервер.НачатьПереключениеОтложенногоПроведения().
//
Процедура ОжидатьПереключенияОтложенногоПроведения(ДанныеДлительнойОперации) Экспорт

	Если ДанныеДлительнойОперации = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДлительнаяОперация = ДанныеДлительнойОперации.ДлительнаяОперация;

	// Покажем форму длительной операции, если было запущено переключение режима отложенного проведения
	// после записи изменений в справочник.
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда

		ФормаДлительнойОперации = ОткрытьФормуДлительнойОперации(
			ДлительнаяОперация.ИдентификаторЗадания,
			ДанныеДлительнойОперации.НаименованиеФоновогоЗадания);
	
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ИдентификаторЗадания",    ДлительнаяОперация.ИдентификаторЗадания);
		ДополнительныеПараметры.Вставить("ФормаДлительнойОперации", ФормаДлительнойОперации);
	
		ОповещениеОЗавершении = Новый ОписаниеОповещения(
			"ПереключениеРежимаОтложенногоПроведенияЗавершениеЗадания", ПроведениеКлиент, ДополнительныеПараметры);
	
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
		
	Иначе
	
		ОбщегоНазначенияБПВызовСервера.ОбработатьЗавершениеПереключенияОтложенногоПроведения(
			ДлительнаяОперация.ИдентификаторЗадания);

	КонецЕсли;

КонецПроцедуры

// Открывает форму длительной операции при переключении режима отложенного проведения.
//
// Параметры:
//	ИдентификаторЗадания - УникальныйИдентификатор - Идентификатор фонового задания.
//	НаименованиеФоновогоЗадания - Строка - Наименование фонового задания.
//
// Возвращаемое значение:
//	ФормаКлиентскогоПриложения.
//
Функция ОткрытьФормуДлительнойОперации(ИдентификаторЗадания, НаименованиеФоновогоЗадания) Экспорт

	// Выводим окно длительной операции самостоятельно,
	// т.к. возможно закрытие формы элемента справочника сразу после записи,
	// но при этом необходимо дождаться окончания фонового задания, чтобы обновить кеши.
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ТекстСообщения",       НаименованиеФоновогоЗадания);
	ПараметрыФормы.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
	
	ФормаДлительнойОперации = ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация", ПараметрыФормы, , ИдентификаторЗадания);

	Возврат ФормаДлительнойОперации;

КонецФункции

// Запускает удаление записей о ранее выполненной проверке реквизитов. Если далее будет запускаться групповое перепровеедние,
// то у документов будет выполняться проверка заполнения.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - код, выполняемый после очистки записей.
//                                              См. одноименный параметр в ДлительныеОперацииКлиент.ОжидатьЗавершение()
//  НачалоНепроверенногоПериода - Дата - месяц, начиная с которого документы считаются имеющими непроверенные реквизиты.
//  Организация  - СправочникСсылка.Организации, Неопределено - организация, по которой документы считаются непроверенными.
//
Процедура НачатьОчисткуРегистраПроверенныхДокументов(ОповещениеОЗавершении, НачалоНепроверенногоПериода, Организация = Неопределено) Экспорт
	
	ДлительнаяОперация = ОбщегоНазначенияБПВызовСервера.НачатьОчисткуРегистраПроверенныхДокументов(НачалоНепроверенногоПериода, Организация);
	
	Форма = ?(ТипЗнч(ОповещениеОЗавершении.Модуль) = Тип("ФормаКлиентскогоПриложения"), ОповещениеОЗавершении.Модуль, Неопределено);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ТекстСообщения             = НСтр("ru = 'Подготовка к перепроведению документов'");
	ПараметрыОжидания.ВыводитьОкноОжидания       = Истина;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ОтменятьПриЗакрытииФормыВладельца = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается из подсистемы БСП ДлительныеОперации при окончании фонового задания 
// по переключению режима отложенного проведения.
// См. ДлительныеОперацииКлиент.ОжидатьЗавершение().
//
Процедура ПереключениеРежимаОтложенногоПроведенияЗавершениеЗадания(Результат, ДополнительныеПараметры) Экспорт

	ИдентификаторЗадания = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		ДополнительныеПараметры, "ИдентификаторЗадания");

	ОбщегоНазначенияБПВызовСервера.ОбработатьЗавершениеПереключенияОтложенногоПроведения(ИдентификаторЗадания);

	Попытка
		// Закроем форму длительной операции, если она еще открыта.
		ФормаДлительнойОперации = Неопределено;
		Если ДополнительныеПараметры.Свойство("ФормаДлительнойОперации", ФормаДлительнойОперации) Тогда
			ДополнительныеПараметры.Удалить("ФормаДлительнойОперации");
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		КонецЕсли;
	Исключение
		// В случае, если формы уже нет, выдавать сообщение об ошибке не надо.
	КонецПопытки;

КонецПроцедуры

#КонецОбласти
