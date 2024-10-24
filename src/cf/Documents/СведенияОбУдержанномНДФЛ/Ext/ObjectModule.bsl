﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Не ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НДФЛ.КПП");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = НДФЛ.Итог("Сумма");
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	Если Дата >= ЕдиныйНалоговыйСчет.НачалоПростогоУчета()
		И Месяц >= ЕдиныйНалоговыйСчет.НачалоПростогоУчета() Тогда
		
		ПараметрыПроведения = Документы.СведенияОбУдержанномНДФЛ.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
		
		ТаблицаУдержанныйНДФЛ = Документы.СведенияОбУдержанномНДФЛ.ПодготовитьТаблицуУдержанногоНалога(
			ПараметрыПроведения.Реквизиты, ПараметрыПроведения.УдержанныйНДФЛ);
		
		// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
		
		УчетЗарплаты.СформироватьДвиженияПоУдержанномуНДФЛ(
			ПараметрыПроведения.Реквизиты,
			ТаблицаУдержанныйНДФЛ,
			Движения,
			Отказ);
			
	КонецЕсли;
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли