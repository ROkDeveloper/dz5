﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Заполняет ТЧ Товары и Услуги по расчетному документу
//
Процедура ЗаполнитьПоРасчетномуДокументу(РежимДобавления) Экспорт

	Перем ВидыЦенностейПоСчетамУчета;

	Если НЕ ЗначениеЗаполнено(РасчетныйДокумент) тогда
		Возврат;
	КонецЕсли;

	ТаблицаДокумента = УчетНДСПереопределяемый.ПолучитьТаблицуДокументаНДС(РасчетныйДокумент, , Истина);
	
	Если ТаблицаДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТаблицаДокумента.Колонки.Найти("СуммаБезНДСВал") <> Неопределено Тогда
		Если ТаблицаДокумента.Колонки.Найти("Сумма") <> Неопределено Тогда
			ТаблицаДокумента.Колонки.Удалить("Сумма");
		КонецЕсли;
		ТаблицаДокумента.Колонки.СуммаБезНДСВал.Имя = "Сумма";
		Если ТаблицаДокумента.Колонки.Найти("НДСВал") <> Неопределено Тогда
			ТаблицаДокумента.Колонки.НДСВал.Имя = "СуммаНДС";
		Иначе
			ТаблицаДокумента.Колонки.НДС.Имя = "СуммаНДС";
		КонецЕсли;
	ИначеЕсли ТаблицаДокумента.Колонки.Найти("СуммаБезНДС") <> Неопределено Тогда
		Если ТаблицаДокумента.Колонки.Найти("Сумма") <> Неопределено Тогда
			ТаблицаДокумента.Колонки.Удалить("Сумма");
		КонецЕсли;
		ТаблицаДокумента.Колонки.СуммаБезНДС.Имя = "Сумма";
		Если (ТаблицаДокумента.Колонки.Найти("НДС") <> Неопределено)
			И (ТаблицаДокумента.Колонки.Найти("СуммаНДС") = Неопределено) Тогда
			ТаблицаДокумента.Колонки.НДС.Имя = "СуммаНДС";
		КонецЕсли;
	ИначеЕсли (ТаблицаДокумента.Колонки.Найти("НДС") <> Неопределено)
		И (ТаблицаДокумента.Колонки.Найти("СуммаНДС") = Неопределено) Тогда
		ТаблицаДокумента.Колонки.НДС.Имя = "СуммаНДС";
	КонецЕсли;
	
	Если ТаблицаДокумента.Колонки.Найти("СчетУчетаБУ") <> Неопределено 
		И ТаблицаДокумента.Колонки.Найти("СчетУчета") = Неопределено Тогда
		ТаблицаДокумента.Колонки.СчетУчетаБУ.Имя = "СчетУчета";
	КонецЕсли;
	
	Если ТаблицаДокумента.Колонки.Найти("СчетУчета") = Неопределено Тогда
		ТаблицаДокумента.Колонки.Добавить("СчетУчета", Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	КонецЕсли;
	
	Если ТаблицаДокумента.Колонки.Найти("СчетДоходовБУ") <> Неопределено Тогда
		ТаблицаДокумента.Колонки.СчетДоходовБУ.Имя = "СчетДоходов";
	КонецЕсли;

	Если ТаблицаДокумента.Колонки.Найти("СубконтоБУ") <> Неопределено Тогда
		ТаблицаДокумента.Колонки.СубконтоБУ.Имя = "Субконто";
	КонецЕсли;
		
	Если ТаблицаДокумента.Колонки.Найти("Событие") = Неопределено Тогда
		ТаблицаДокумента.Колонки.Добавить("Событие", Новый ОписаниеТипов("ПеречислениеСсылка.СобытияПоНДСПродажи"));
	ИначеЕсли НЕ ТаблицаДокумента.Колонки.Событие.ТипЗначения.СодержитТип(Тип("ПеречислениеСсылка.СобытияПоНДСПродажи")) Тогда
		ТаблицаДокумента.Колонки.Удалить("Событие");
		ТаблицаДокумента.Колонки.Добавить("Событие", Новый ОписаниеТипов("ПеречислениеСсылка.СобытияПоНДСПродажи"));
	КонецЕсли;
	
	Если ТаблицаДокумента.Колонки.Найти("ВидЦенности") = Неопределено Тогда
		ТаблицаДокумента.Колонки.Добавить("ВидЦенности", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыЦенностей"));
	КонецЕсли;
	
	Если ТаблицаДокумента.Колонки.Найти("Номенклатура") = Неопределено Тогда
		ТаблицаДокумента.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	КонецЕсли;
	
	ПересчитыватьЗаполненнуюЦену = НЕ (ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", РасчетныйДокумент.Метаданные())
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РасчетныйДокумент, "СуммаВключаетНДС") = СуммаВключаетНДС);

	РеквизитыДоговора = БухгалтерскийУчетПереопределяемый.ПолучитьРеквизитыДоговораКонтрагента(ДоговорКонтрагента);
	НаличиеЦены = (ТаблицаДокумента.Колонки.Найти("Цена") <> Неопределено);

	Для Каждого СтрокаДокумента Из ТаблицаДокумента Цикл

		Если СуммаВключаетНДС Тогда
			// В поле Сумма из запроса должно передаваться всегда значение без НДС
			СтрокаДокумента.Сумма = СтрокаДокумента.Сумма + СтрокаДокумента.СуммаНДС;
		КонецЕсли;

		Если НаличиеЦены И (СтрокаДокумента.Цена = 0 ИЛИ ПересчитыватьЗаполненнуюЦену) И СтрокаДокумента.Сумма <> 0 Тогда
			Если СтрокаДокумента.Количество = 0 Тогда
				СтрокаДокумента.Количество = 1;
			КонецЕсли;
			СтрокаДокумента.Цена = СтрокаДокумента.Сумма / СтрокаДокумента.Количество;
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(СтрокаДокумента.ВидЦенности) Тогда
			СтрокаДокумента.ВидЦенности = УчетНДС.ОпределитьВидЦенностиПоОперации(СтрокаДокумента.Номенклатура,
				СтрокаДокумента.СчетУчета, Ложь, РеквизитыДоговора.УчетАгентскогоНДС,
				РеквизитыДоговора.ВидАгентскогоДоговора, ВидыЦенностейПоСчетамУчета);
		КонецЕсли;

		Если Перечисления.ВидыЦенностей.ЭтоНалоговыйАгент(СтрокаДокумента.ВидЦенности) Тогда
			СтрокаДокумента.Событие = Перечисления.СобытияПоНДСПродажи.НДСНачисленКУплате;
		ИначеЕсли СтрокаДокумента.ВидЦенности = Перечисления.ВидыЦенностей.АвансыВыданные Тогда
			СтрокаДокумента.Событие = Перечисления.СобытияПоНДСПродажи.ВосстановлениеНДС;
		Иначе
			СтрокаДокумента.Событие = Перечисления.СобытияПоНДСПродажи.Реализация;
		КонецЕсли;
	
	КонецЦикла;

	ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаДокумента, ТоварыИУслуги);
	
	ТоварыИУслуги.Свернуть("ВидЦенности, Номенклатура, Цена, СчетУчета, СчетДоходов, Субконто, СчетУчетаНДСПоРеализации,
		|СтавкаНДС, НомерГТД, СтранаПроисхождения, Событие", "Количество, Сумма, СуммаНДС");

КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	РасчетныйДокумент = Основание;
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
	ЗаполнитьПоРасчетномуДокументу(Ложь);
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.СчетФактураПолученный")
		И Основание.ВидСчетаФактуры = Перечисления.ВидСчетаФактурыПолученного.НаАванс Тогда
		ИспользоватьДокументРасчетовКакСчетФактуру = Истина;
		ФормироватьПроводки = Истина;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ДоговорКонтрагента = БухгалтерскийУчетПереопределяемый.ПолучитьДоговорКонтрагентаИзДокумента(Основание);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("СуммаВключаетНДС") Тогда
		СуммаВключаетНДС = ДанныеЗаполнения.СуммаВключаетНДС;
	Иначе
		СуммаВключаетНДС = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию(
			"ОсновнойВариантРасчетаИсходящегоНДС") = Перечисления.ВариантыРасчетаНДС.НДСВСумме;
	КонецЕсли;

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипЗнч(РасчетныйДокумент) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		ВидСчетаФактуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РасчетныйДокумент, "ВидСчетаФактуры");
		Если ВидСчетаФактуры = Перечисления.ВидСчетаФактурыПолученного.НаАванс
			ИЛИ ВидСчетаФактуры = Перечисления.ВидСчетаФактурыПолученного.НаАвансКомитента Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
		КонецЕсли;
	КонецЕсли;
		
	Если НЕ ЗаписьДополнительногоЛиста Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КорректируемыйПериод");
	КонецЕсли;

	Если НЕ ИспользоватьДокументРасчетовКакСчетФактуру Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасчетныйДокумент");
	КонецЕсли;

	// Проверка табличной части "Товары и услуги
	Если ПрямаяЗаписьВКнигу Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыИУслуги.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыИУслуги.СчетУчета");
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыИУслуги.СчетДоходов");
	КонецЕсли;

	Если НЕ ПрямаяЗаписьВКнигу Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыИУслуги.ВидЦенности");
	КонецЕсли;
	
	Если Не УчетНДСКлиентСервер.ФорматныйКонтрольКодаВидаОперацииПройден(КодВидаОперации) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Корректность", НСтр("ru = 'Код вида операции'"), , ,
			НСтр("ru='Код вида операции может содержать только цифры и символ "";""'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "КодВидаОперации", , Отказ);
	КонецЕсли;
	
	Если ПрямаяЗаписьВКнигу Тогда
		
		Для каждого СтрокаТаблицы Из ТоварыИУслуги Цикл
			Префикс = "ТоварыИУслуги[%1].";
			Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Префикс, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));
			
			ИмяСписка = НСтр("ru = 'ТоварыИУслуги'");
			
			// Проверка счета НДС.
			Если ФормироватьПроводки И СтрокаТаблицы.СуммаНДС <> 0
					И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетУчетаНДСПоРеализации) Тогда
					
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", ,
					НСтр("ru = 'Счет учета НДС по реализации'"), СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "СчетУчетаНДСПоРеализации";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	// Посчитать сумму документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "ТоварыИУслуги");

	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("ПометкаУдаления", ЭтотОбъект);
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
	
	Документы.КорректировкаРеализации.ОбновитьРеквизитыСвязанныхДокументовКорректировки(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
	
		УчетНДСПереопределяемый.ПроверитьСоответствиеРеквизитовСчетаФактурыВыданного(ЭтотОбъект);		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);

	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ОтражениеНачисленияНДС.ПодготовитьПараметрыПроведения(Ссылка, Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	ТаблицаТоваровУслуг = ПараметрыПроведения.ТоварыУслуги.Скопировать();

	Документы.ОтражениеНачисленияНДС.СформироватьДвиженияОтражениеНачисленияНДС(
		ТаблицаТоваровУслуг,
		ПараметрыПроведения.ДокументыОплаты,
		ПараметрыПроведения.ТаблицаРеквизиты,
		Движения,
		Отказ);
		
	//Движения регистра "Рублевые суммы документов в валюте"
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалюте(ПараметрыПроведения.ТоварыУслуги, 
		ПараметрыПроведения.ТаблицаРеквизиты, Движения, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
	Движения.Записать();
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект);	
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
			
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
		
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект);	
	ПараметрыДействия.СостояниеФлага = Ложь;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
		
КонецПроцедуры

#КонецЕсли