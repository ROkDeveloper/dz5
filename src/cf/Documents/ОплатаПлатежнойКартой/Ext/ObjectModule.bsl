﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Перем Основание, СуммаОперации;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	МетаданныеОбъекта = Метаданные();
	Если ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Основание", Основание) И ДанныеЗаполнения.Свойство("СуммаОперации", СуммаОперации)
		И ЗначениеЗаполнено(Основание) И МетаданныеОбъекта.ВводитсяНаОсновании.Содержит(Основание.Метаданные()) Тогда
		Если ЗначениеЗаполнено(СуммаОперации) Тогда
			ЗаполнитьПоДокументуОснованию(Основание, СуммаОперации);
		Иначе
			ЗаполнитьПоДокументуОснованию(Основание);
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И МетаданныеОбъекта.ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);
	
	ОбновитьРеквизитыОбъекта();
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОплатаПлатежнойКартой") Тогда
		БезЗакрывающихДокументов = ДанныеЗаполнения.БезЗакрывающихДокументов;
	Иначе
		БезЗакрывающихДокументов = УчетКассовымМетодом.БезЗакрывающихДокументов(Организация, Дата, ВидОперации);
	КонецЕсли;
	
	ПараметрыУСН = УчетУСН.СтруктураПараметровОбъектаДляУСН(ЭтотОбъект);
	НалоговыйУчетУСН.ЗаполнитьОтражениеДокументаВУСН(ЭтотОбъект, ПараметрыУСН);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	УчетПоПродажнойСтоимости =
		УчетнаяПолитика.СпособОценкиТоваровВРознице(Организация, Дата) = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости;
		
	ЕстьРасчетыСПокупателями = (ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя 
		ИЛИ ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ПлатежПоРеестру
		ИЛИ ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю);
	
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.Сделка");              // Проверяем построчно
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов"); // Проверяем построчно
	
	Если БезЗакрывающихДокументов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидОплаты");
	КонецЕсли;
		
	Если ЕстьРасчетыСПокупателями Тогда
		
		Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
			МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорКонтрагента");
		КонецЕсли;
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовСКонтрагентом"); // Проверяем построчно
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовПоАвансам");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СтавкаНДС");
		
		МассивНепроверяемыхРеквизитов.Добавить("Патент");
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.РозничнаяВыручка Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СпособПогашенияЗадолженности");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовСКонтрагентом");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовПоАвансам");
		
		Если БезЗакрывающихДокументов Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		КонецЕсли;
		
		Если НЕ УчетПоПродажнойСтоимости Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Патент");
			МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СтавкаНДС");
		КонецЕсли;
		
		Если НЕ ДеятельностьНаПатенте Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Патент");
		КонецЕсли;
	КонецЕсли;
	
	// Проверка соответствия суммы документа расшифровке платежа
	
	Если РасшифровкаПлатежа.Итог("СуммаПлатежа") <> СуммаДокумента Тогда
		ТекстСообщения = НСтр("ru = 'Не совпадают сумма документа и ее расшифровка'");
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Корректность", НСтр("ru = 'Сумма документа'"),,, ТекстСообщения); 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СуммаДокумента", "Объект", Отказ);
	КонецЕсли;
	
	// Построчная проверка заполнения отдельных реквизитов ТЧ РасшифровкаПлатежа
	
	ПрименяетсяУСН = УчетнаяПолитика.ПрименяетсяУСН(Организация, Дата);
	ПрименяетсяПатент = УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, Дата);
	
	ШаблонТекстаСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
		"Колонка", "Заполнение", "%1", "%2", НСтр("ru='Расшифровка платежа'"));
	
	Для Каждого СтрокаПлатежа Из РасшифровкаПлатежа Цикл
	
		Если ЗначениеЗаполнено(СтрокаПлатежа.ДоговорКонтрагента) 
			И (СтрокаПлатежа.СуммаПлатежа > 0)
			И (СтрокаПлатежа.СуммаВзаиморасчетов = 0) Тогда
		
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонТекстаСообщения, НСтр("ru = 'Сумма расчетов'"), СтрокаПлатежа.НомерСтроки);
			Поле = "РасшифровкаПлатежа[" + Формат((СтрокаПлатежа.НомерСтроки-1), "ЧН=0; ЧГ=") + "].СуммаВзаиморасчетов";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
		
		Если ЕстьРасчетыСПокупателями
			И СтрокаПлатежа.СпособПогашенияЗадолженности = Перечисления.СпособыПогашенияЗадолженности.ПоДокументу
			И НЕ ЗначениеЗаполнено(СтрокаПлатежа.Сделка) Тогда
		
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонТекстаСообщения, НСтр("ru = 'Документ расчетов'"), СтрокаПлатежа.НомерСтроки);
			Поле = "РасшифровкаПлатежа[" + Формат((СтрокаПлатежа.НомерСтроки-1), "ЧН=0; ЧГ=") + "].Сделка";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
		
	КонецЦикла;
	
	// В режиме отложенного проведения для организаций на УСН не поддерживаются операции по эквайрингу.
	Если Не БезЗакрывающихДокументов И (ПрименяетсяУСН ИЛИ ПрименяетсяПатент)
		И ПроведениеСервер.ИспользуетсяОтложенноеПроведение(Организация, Дата) Тогда
		ТекстСообщения = НСтр("ru = 'В разделе ""Администрирование"" - ""Проведение документов"" установлен режим ""Расчеты выполняются при закрытии месяца"".
			|В этом случае для организаций, применяющих упрощенную или патентную систему налогообложения, не поддерживается оплата платежной картой.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Объект", "Организация", Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Соберем все сообщения об ошибках заполнения и выведем их с учетом используемой формы документа.
	СообщенияПроверки = Документы.ОплатаПлатежнойКартой.ПодготовитьСообщенияПроверкиЗаполненияРасшифровкаПлатежа(
		ЭтотОбъект,
		,
		Отказ,
		ПроверяемыеРеквизиты,
		Ложь);
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(
		ЭтотОбъект,
		Отказ,
		ПроверяемыеРеквизиты,
		СообщенияПроверки,
		Ложь);
	
	Документы.ОплатаПлатежнойКартой.СообщитьРезультатПроверки(
		ЭтотОбъект,
		Отказ,
		СообщенияПроверки,
		Метаданные.Документы.ОплатаПлатежнойКартой.ТабличныеЧасти.РасшифровкаПлатежа);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю Тогда
		ПараметрыОбъекта = Документы.ОплатаПлатежнойКартой.ПараметрыОбъектаДляЗаполненияПатентаВозвратаОплаты(ЭтотОбъект);
		Патент = УчетПСН.ПатентВозвратаОплатыПоПлатежнойКарте(ПараметрыОбъекта);
	Иначе
		ПараметрыОбъекта = Документы.ОплатаПлатежнойКартой.ПараметрыОбъектаДляЗаполненияПатента(ЭтотОбъект);
		Патент = УчетПСН.ПатентВходящегоПлатежа(ПараметрыОбъекта);
	КонецЕсли;
	
	Если (ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя
		ИЛИ ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ПлатежПоРеестру
		ИЛИ ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю)
		И РасшифровкаПлатежа.Количество() > 0 Тогда
		РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорВТабличнойЧастиПередЗаписью(РасшифровкаПлатежа, ЭтотОбъект);
		ДоговорКонтрагента = РасшифровкаПлатежа[0].ДоговорКонтрагента;
	Иначе
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ОплатаПлатежнойКартой.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	ТаблицаВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.РасшифровкаПлатежа, ПараметрыПроведения.Реквизиты, Отказ);
	
	ТаблицаСуммовыхРазниц = УчетНДС.ПодготовитьТаблицуСуммовыхРазниц(ТаблицаВзаиморасчеты, 
		ПараметрыПроведения.Реквизиты, Отказ);
	
	ТаблицаПрочихРасчетовИП = Документы.ОплатаПлатежнойКартой.ПодготовитьТаблицуПрочиеРасчетыИП(
		ПараметрыПроведения.Реквизиты, ТаблицаВзаиморасчеты, Отказ);
	
	Если Не ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		ТаблицаСтатусовСчетов = СтатусыДокументов.ПодготовитьТаблицуСтатусовОплатыСчетов(
			ПараметрыПроведения.ОплатаСчетов, ПараметрыПроведения.Реквизиты);
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	Если Не БезЗакрывающихДокументов Тогда
		
		УчетВзаиморасчетов.СформироватьДвиженияПоПрочимРасчетам(ТаблицаПрочихРасчетовИП, Движения, Отказ);
		
		УчетВзаиморасчетов.СформироватьДвиженияРасчетыПоЭквайрингуПогашениеЗадолженности(ТаблицаВзаиморасчеты,
			ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
		УчетДоходовРасходов.СформироватьДвиженияРозничнаяВыручкаОплатаПлатежнойКартой(ПараметрыПроведения.РозничнаяВыручка, 
			ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
		УчетДоходовРасходов.СформироватьДвиженияСуммовыеРазницыРасчетыВУЕ(ТаблицаСуммовыхРазниц, 
			ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	КонецЕсли;
	
	Документы.ОплатаПлатежнойКартой.СформироватьДвиженияРозничнаяВыручка(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетНДС.СформироватьДвиженияКурсовыеРазницы(ПараметрыПроведения.Реквизиты, 
		ТаблицаВзаиморасчеты, Движения, Отказ);
	
	УчетНДС.СформироватьДвиженияСуммовыеРазницы(ТаблицаСуммовыхРазниц, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);	
	
	УчетНДС.СформироватьДвиженияРозничнаяВыручка(ПараметрыПроведения.РозничнаяВыручкаНДС, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетУСН.СформироватьДвиженияКнигаУчетаДоходовИРасходов(ПараметрыПроведения.ТаблицаКУДиР, Движения, Отказ);
		
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияРасчетПереоценкиВалютныхСредств(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	СтатусыДокументов.СформироватьДвиженияОплатаСчетов(
		ПараметрыПроведения.ОплатаСчетов, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	Если Не ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		СтатусыДокументов.СформироватьДвиженияСтатусовДокументов(
			ТаблицаСтатусовСчетов, ПараметрыПроведения.Реквизиты);
	КонецЕсли;

	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);

	// Регистрация в последовательности
	Документы.ОплатаПлатежнойКартой.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, ПараметрыПроведения, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата                 = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный        = Пользователи.ТекущийПользователь();
	
	ИдентификаторКорзины = Неопределено;
	СуммаСертификатамиНСПК = 0;
	
	ДокументОснование    = Неопределено;
	НомерЧекаККМ         = 0;
	НомерЧекаЭТ          = "";
	СсылочныйНомер       = "";
	НомерПлатежнойКарты  = "";
	СуммаКомиссии        = 0;
	
	ОбновитьРеквизитыОбъекта();
	НалоговыйУчетУСН.ПриКопированииДокумента(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьРеквизитыОбъекта()
	
	ПараметрыНастроек = ОплатаПлатежнойКартойВызовСервера.ПараметрыНастроекДокумента(Организация, Дата);
	
	// В простом интерфейсе розница ведётся черед интерфейс "Товары", схема НТТ недоступна для документа.
	Если ОплатаПлатежнойКартойКлиентСервер.ЭтоРозничнаяВыручка(ВидОперации)
		И ПараметрыНастроек.РозницаВключена
		И ПараметрыНастроек.УчетБезЗакрывающихДокументов
		И ПараметрыНастроек.ПростойИнтерфейс Тогда
		ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя;
	Иначе
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("СправочникСсылка.Склады");
	КонецЕсли;
	
	Если ОплатаПлатежнойКартойКлиентСервер.ЭтоРасчетыСКонтрагентом(ВидОперации) Тогда
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	КонецЕсли;
	
	Контрагент = ОграничениеТипаКонтрагента.ПривестиЗначение(Контрагент);
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание, СуммаОперации = Неопределено)
	
	// Заполнение реквизитов из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ВалютаДокумента = ВалютаРегламентированногоУчета;
	КурсДокумента      = 1;
	КратностьДокумента = 1;
	
	ВидДокументаОснования = ТипЗнч(Основание);
	
	ДокументОснование = Основание;
	
	Если ВидДокументаОснования = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
	
		СтруктураОснование = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание,
			"Контрагент, ДоговорКонтрагента,
			|СчетУчетаРасчетовПоАвансам,
			|СчетУчетаРасчетовСКонтрагентом,
			|Организация");
			
	ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.ОплатаПлатежнойКартой") Тогда 
			
		СтруктураОснование = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание,
			"Контрагент, ДоговорКонтрагента, СсылочныйНомер,
			|ВидОплаты, Эквайер, ДоговорЭквайринга, СчетКасса");
			
	Иначе
			
		СтруктураОснование = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание,
			"Контрагент, ДоговорКонтрагента, 
			|Организация, Дата");
			
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОплатуПоПлатежнымКартам") Тогда
		ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ПлатежПоРеестру;
	ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") 
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ОплатаПлатежнойКартой") Тогда
		ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю;
	Иначе
		ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя;
	КонецЕсли;
	
	Контрагент            = СтруктураОснование.Контрагент;
	ДоговорКонтрагента    = СтруктураОснование.ДоговорКонтрагента;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				ДоговорКонтрагента, "Валютный, РасчетыВУсловныхЕдиницах");
		Если РеквизитыДоговора.Валютный И Не РеквизитыДоговора.РасчетыВУсловныхЕдиницах Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя использовать валютный договор для оплаты по карте'");
		КонецЕсли;
	Иначе
		РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
				ДоговорКонтрагента,
				Контрагент,
				Организация,
				РаботаСДоговорамиКонтрагентовБПВызовСервера.ВидыДоговоровДокумента(ВидОперации),
				Новый Структура("ОплатаВВалюте", Новый Структура("ЗначениеОтбора", Ложь)));
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользуетсяНалогНаПрофессиональныйДоход")
		И ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю Тогда
		
		СведенияОЧекеНПД = РегистрыСведений.ЧекиНПД.СведенияОЧеке(ДокументОснование);
		
		Если ЗначениеЗаполнено(СведенияОЧекеНПД) Тогда
			НомерЧекаНПД = СведенияОЧекеНПД.НомерЧека;
		КонецЕсли;
		
	КонецЕсли;
	
	ВалютаВзаиморасчетов = ДоговорКонтрагента.ВалютаВзаиморасчетов;
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, Дата);
	
	Если ВидДокументаОснования = Тип("ДокументСсылка.ОплатаПлатежнойКартой") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураОснование,
			"ВидОплаты, Эквайер, ДоговорЭквайринга, СсылочныйНомер, СчетКасса");
		
		ТаблицаПлатежей = ДокументОснование.РасшифровкаПлатежа.Выгрузить();
		ТаблицаПлатежей.ЗаполнитьЗначения(Неопределено, "СчетНаОплату");
	Иначе
		ОснованияУслугНПД = Новый Массив;
		ОснованияУслугНПД.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
		ОснованияУслугНПД.Добавить(Тип("ДокументСсылка.СчетНаОплатуПокупателю"));
		
		ТаблицаПлатежей = РасшифровкаПлатежа.ВыгрузитьКолонки();
		Если УчетнаяПолитика.ПрименяетсяНалогНаПрофессиональныйДоход(Организация, Дата)
			И ОснованияУслугНПД.Найти(ВидДокументаОснования) <> Неопределено Тогда
			МенеджерОснования = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Основание);
			ТаблицаСуммОснования = МенеджерОснования.ТаблицаУслугПродукцииНПД(Основание);
		ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			СтруктураОснование.Вставить("Основание",     Основание);
			СтруктураОснование.Вставить("ДатаОснования", СтруктураОснование.Дата);
			ТаблицаСуммОснования = СтатусыДокументов.ТаблицаСуммКОплатеВРазрезеСтавокНДС(
				СтруктураОснование,
				УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДСВРазрезеСтавокНДС(Основание));
		Иначе
			ТаблицаСуммОснования = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДСВРазрезеСтавокНДС(Основание);
		КонецЕсли;
		
		ТаблицаСуммОснования.Колонки.Сумма.Имя = "СуммаПлатежа";
		
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаСуммОснования, ТаблицаПлатежей);
		
		Если ТаблицаПлатежей.Количество() = 0 Тогда
			ТаблицаПлатежей.Добавить();
		КонецЕсли;
		ТаблицаПлатежей.ЗаполнитьЗначения(ДоговорКонтрагента,                     "ДоговорКонтрагента");
		ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураКурсаВзаиморасчетов.Курс,      "КурсВзаиморасчетов");
		ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураКурсаВзаиморасчетов.Кратность, "КратностьВзаиморасчетов");
		
		Если ЗначениеЗаполнено(СуммаОперации)
			// Если передана суммы операции, то заполнение поддерживается только в случае,
			// если в платежном документе получается 1 строка в таблице - т.е. когда нет разных ставок НДС.
			И ТаблицаПлатежей.Количество() = 1
			И ТаблицаПлатежей[0].СуммаПлатежа <> СуммаОперации Тогда
			СуммаПлатежа = ТаблицаПлатежей[0].СуммаПлатежа;
			СуммаНДС     = ТаблицаПлатежей[0].СуммаНДС;
			СтавкаНДС    = ТаблицаПлатежей[0].СтавкаНДС;
			Если СуммаНДС > 0 Тогда
				Если СуммаОперации < СуммаПлатежа Тогда
					// В случае, когда сумма операции меньше суммы документа, для пересчета суммы НДС достаточно простой пропорции.
					ТаблицаПлатежей[0].СуммаНДС = Окр(СуммаНДС * СуммаОперации / СуммаПлатежа, 2, 1);
				Иначе
					// В случае, когда сумма операции больше суммы документа, использование пропорционального изменения суммы НДС
					// может привести к ошибкам округления. Поэтому в этом случае попробуем получить ставку НДС
					// и рассчитываем сумму НДС по ней. А если не получится, тогда используем пропорцию.
					СтавкаНДСРасчетная = Окр(СуммаНДС / (СуммаПлатежа - СуммаНДС) * 100, 0, 1);
					ЗначениеСтавкиНДС = УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтавкаНДС);
					Если СтавкаНДСРасчетная = ЗначениеСтавкиНДС Тогда
						ТаблицаПлатежей[0].СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
							СуммаОперации, Истина, СтавкаНДСРасчетная);
					Иначе
						// Расчетная ставка НДС не равна ставке из документа, поэтому для расчета суммы НДС используем пропорцию.
						ТаблицаПлатежей[0].СуммаНДС = Окр(СуммаНДС * СуммаОперации / СуммаПлатежа, 2, 1);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			ТаблицаПлатежей[0].СуммаПлатежа = СуммаОперации;
		КонецЕсли;
		
		ТаблицаПлатежей.ЗагрузитьКолонку(ТаблицаПлатежей.ВыгрузитьКолонку("СуммаПлатежа"), "СуммаВзаиморасчетов");
		Для каждого СтрокаПлатежа Из ТаблицаПлатежей Цикл
			Если ДоговорКонтрагента.РасчетыВУсловныхЕдиницах Тогда
				Если Основание.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
					СтрокаПлатежа.СуммаВзаиморасчетов = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
						СтрокаПлатежа.СуммаПлатежа,
						ВалютаРегламентированногоУчета, ВалютаВзаиморасчетов,
						1, Основание.КурсВзаиморасчетов,
						1, Основание.КратностьВзаиморасчетов);
					СтрокаПлатежа.СуммаНДС = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
						СтрокаПлатежа.СуммаНДС,
						ВалютаРегламентированногоУчета, ВалютаВзаиморасчетов,
						1, Основание.КурсВзаиморасчетов,
						1, Основание.КратностьВзаиморасчетов);
				КонецЕсли;
				СтрокаПлатежа.СуммаПлатежа = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаПлатежа.СуммаВзаиморасчетов,
					ВалютаВзаиморасчетов, ВалютаРегламентированногоУчета,
					СтрокаПлатежа.КурсВзаиморасчетов, 1,
					СтрокаПлатежа.КратностьВзаиморасчетов, 1);
				СтрокаПлатежа.СуммаНДС = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаПлатежа.СуммаНДС,
					ВалютаВзаиморасчетов, ВалютаРегламентированногоУчета,
					СтрокаПлатежа.КурсВзаиморасчетов, 1,
					СтрокаПлатежа.КратностьВзаиморасчетов, 1);
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураОснование.СчетУчетаРасчетовПоАвансам,     "СчетУчетаРасчетовПоАвансам");
			ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураОснование.СчетУчетаРасчетовСКонтрагентом, "СчетУчетаРасчетовСКонтрагентом");
		КонецЕсли;
		Если ТаблицаПлатежей.Количество() > 0 И НЕ ЗначениеЗаполнено(ТаблицаПлатежей[0].СчетУчетаРасчетовСКонтрагентом) Тогда
			СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
				СтруктураОснование.Организация, Контрагент, ДоговорКонтрагента);
			ТаблицаПлатежей.ЗаполнитьЗначения(СчетаУчета.СчетАвансовПокупателя, "СчетУчетаРасчетовПоАвансам");
			ТаблицаПлатежей.ЗаполнитьЗначения(СчетаУчета.СчетРасчетовПокупателя, "СчетУчетаРасчетовСКонтрагентом");
		КонецЕсли;
		
		Если ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(Основание, "СчетНаОплату");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидДокументаОснования <> Тип("ДокументСсылка.СчетНаОплатуПокупателю")
		И ПолучитьФункциональнуюОпцию("УправлениеЗачетомАвансовПогашениемЗадолженности") Тогда
		ТаблицаПлатежей.ЗаполнитьЗначения(Перечисления.СпособыПогашенияЗадолженности.ПоДокументу, "СпособПогашенияЗадолженности");
		ТаблицаПлатежей.ЗаполнитьЗначения(Основание,"Сделка");
	Иначе
		ТаблицаПлатежей.ЗаполнитьЗначения(Перечисления.СпособыПогашенияЗадолженности.Автоматически, "СпособПогашенияЗадолженности");
	КонецЕсли;
	
	РасшифровкаПлатежа.Загрузить(ТаблицаПлатежей);
	
	СуммаДокумента = РасшифровкаПлатежа.Итог("СуммаПлатежа");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли