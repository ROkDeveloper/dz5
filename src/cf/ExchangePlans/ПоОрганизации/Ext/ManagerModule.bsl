﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;
	
	Настройки.НазначениеПланаОбмена = "РИБСФильтром";
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = Метаданные.Имя;
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, состоящую из отдельных информационных 
	|баз системы «1С:Предприятие» — узлов распределенной информационной базы, между которыми организована синхронизация 
	|конфигурации и данных. Главной особенностью распределенных информационных баз является передача изменений 
	|конфигурации в подчиненные узлы.
	|Необходимо указать ограничения миграции данных по организациям.'");
	КраткаяИнформацияПоОбмену = СтрЗаменить(КраткаяИнформацияПоОбмену, Символы.ПС, "");
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.ПоОрганизации.Форма.ПодробнаяИнформация";;
	
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена распределенной информационной базы'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Распределенная информационная база с фильтром по организации'");
	
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбменДанными

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегистрироватьИзменения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьКонтрагентыКонтактныеЛица(Параметры) Экспорт
	
	Если НЕ ОбщегоНазначения.РазделениеВключено()
		И ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("ЭтотУзел", ПланыОбмена.ПоОрганизации.ЭтотУзел());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланОбменаРИБ.Ссылка
		|ИЗ
		|	ПланОбмена.ПоОрганизации КАК ПланОбменаРИБ
		|ГДЕ
		|	ПланОбменаРИБ.Ссылка <> &ЭтотУзел";
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Параметры.ОбработкаЗавершена = Истина;
			Возврат;
		КонецЕсли;
		МассивУзлов = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.Справочники.Контрагенты);
		ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.Справочники.КонтактныеЛица);
		ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.РегистрыСведений.ЛицензииПоставщиковАлкогольнойПродукции);
		Если Метаданные.РегистрыСведений.Найти("УчастникиКонтролируемыхСделок") <> Неопределено Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.РегистрыСведений["УчастникиКонтролируемыхСделок"]);
		КонецЕсли;
		
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


