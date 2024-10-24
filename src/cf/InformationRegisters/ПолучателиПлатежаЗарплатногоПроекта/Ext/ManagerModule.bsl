﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПолучателяПлатежаЗарплатногоПроекта(Организация, Контрагент, Знач СчетКонтрагента, ПлатежнаяВедомость) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация)
		ИЛИ НЕ ЗначениеЗаполнено(Контрагент)
		ИЛИ НЕ ЗначениеЗаполнено(ПлатежнаяВедомость)
		Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПлатежнаяВедомость) <> Тип("ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк") Тогда
		Возврат;
	КонецЕсли;
	
	Если Константы.УчетЗарплатыИКадровВоВнешнейПрограмме.Получить() Тогда
		ЗарплатныйПроект = Справочники.ЗарплатныеПроекты.ПустаяСсылка();
	Иначе
		ЗарплатныйПроект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПлатежнаяВедомость, "ЗарплатныйПроект");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетКонтрагента) Тогда
		РеквизитыСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетКонтрагента, "ПометкаУдаления, ДатаЗакрытия");
		Если РеквизитыСчета.ПометкаУдаления Или ЗначениеЗаполнено(РеквизитыСчета.ДатаЗакрытия) Тогда
			СчетКонтрагента = Справочники.БанковскиеСчета.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ПолучателиПлатежаЗарплатногоПроекта.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация      = Организация;
	МенеджерЗаписи.ЗарплатныйПроект = ЗарплатныйПроект;
	МенеджерЗаписи.Контрагент       = Контрагент;
	МенеджерЗаписи.СчетКонтрагента  = СчетКонтрагента;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Функция РеквизитыПолучателяПлатежаЗарплатногоПроекта(Организация, ПлатежнаяВедомость) Экспорт
	
	РеквизитыПолучателяПлатежа = Новый Структура("Контрагент, СчетКонтрагента",
		Справочники.Контрагенты.ПустаяСсылка(), Справочники.БанковскиеСчета.ПустаяСсылка());
	
	Если НЕ ЗначениеЗаполнено(Организация)
		ИЛИ НЕ ЗначениеЗаполнено(ПлатежнаяВедомость) Тогда
		Возврат РеквизитыПолучателяПлатежа;
	КонецЕсли;
	
	Если ТипЗнч(ПлатежнаяВедомость) <> Тип("ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк") Тогда
		Возврат РеквизитыПолучателяПлатежа;
	КонецЕсли;
	
	Если Константы.УчетЗарплатыИКадровВоВнешнейПрограмме.Получить() Тогда
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПлатежнаяВедомость, "ВидМестаВыплаты") = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект Тогда
			ЗарплатныйПроект = Справочники.ЗарплатныеПроекты.ПустаяСсылка();
		Иначе
			Возврат РеквизитыПолучателяПлатежа;
		КонецЕсли;
	Иначе
		ЗарплатныйПроект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПлатежнаяВедомость, "ЗарплатныйПроект");
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ПолучателиПлатежаЗарплатногоПроекта.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация      = Организация;
	МенеджерЗаписи.ЗарплатныйПроект = ЗарплатныйПроект;
	МенеджерЗаписи.Прочитать();
	
	СчетКонтрагента = МенеджерЗаписи.СчетКонтрагента;
	Если ЗначениеЗаполнено(СчетКонтрагента) Тогда
		РеквизитыСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетКонтрагента, "ПометкаУдаления, ДатаЗакрытия");
		Если РеквизитыСчета.ПометкаУдаления Или ЗначениеЗаполнено(РеквизитыСчета.ДатаЗакрытия) Тогда
			СчетКонтрагента = Справочники.БанковскиеСчета.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	РеквизитыПолучателяПлатежа.Контрагент      = МенеджерЗаписи.Контрагент;
	РеквизитыПолучателяПлатежа.СчетКонтрагента = СчетКонтрагента;
	
	Возврат РеквизитыПолучателяПлатежа;
	
КонецФункции

#КонецОбласти

#КонецЕсли