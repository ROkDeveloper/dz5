﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПодготовкаПараметровПроведенияДокумента

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ПланируемаяДатаВыплаты КАК ПланируемаяДатаВыплаты
	|ИЗ
	|	Документ.НачислениеДивидендов КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Результат = Запрос.Выполнить();

	Реквизиты = ОбщегоНазначенияБПВызовСервера.ПолучитьСтруктуруИзРезультатаЗапроса(Результат);

	НомераТаблиц = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);

	Запрос.Текст =
		ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
		+ ТекстЗапросаДивиденды(НомераТаблиц, Реквизиты)
		+ ТекстЗапросаДивидендыНДФЛ(НомераТаблиц, Реквизиты)
	;

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка                         КАК Регистратор,
	|	Реквизиты.Дата                           КАК Период,
	|	Реквизиты.Организация                    КАК Организация,
	|	Реквизиты.ПланируемаяДатаВыплаты         КАК ПланируемаяДатаВыплаты
	|ИЗ
	|	Документ.НачислениеДивидендов КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаДивиденды(НомераТаблиц, Реквизиты)

	НомераТаблиц.Вставить("ТаблицаДивиденды", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	""ТаблицаДивиденды"" КАК ИмяСписка,
	|	Док.Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	Док.РасчетныйПериод КАК РасчетныйПериод,
	|	Док.ТипУчредителя КАК ТипУчредителя,
	|	Док.Учредитель КАК Учредитель,
	|	Док.СуммаДохода КАК СуммаДохода,
	|	Док.СуммаНалога КАК СуммаНалога,
	|	Док.СуммаНалогаСПревышения КАК СуммаНалогаСПревышения
	|ИЗ
	|	Документ.НачислениеДивидендов КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаДивидендыНДФЛ(НомераТаблиц, Реквизиты)

	НомераТаблиц.Вставить("ТаблицаДивидендыНДФЛ", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	""ТаблицаДивидендыНДФЛ"" КАК ИмяСписка,
	|	Док.Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	Док.Учредитель КАК Акционер,
	|	Док.СуммаДохода КАК Начислено,
	|	Док.СуммаНалога КАК НДФЛ,
	|	Док.СуммаНалогаСПревышения КАК НДФЛСПревышения
	|ИЗ
	|	Документ.НачислениеДивидендов КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка
	|	И Док.ТипУчредителя = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо)";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

#КонецОбласти

#Область ПроведениеДокумента

Процедура СформироватьПроводки(ТаблицаРеквизиты, ТаблицаОтраженияВУчете, Движения, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(ТаблицаОтраженияВУчете) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыДвиженийОтраженияДивидендов(ТаблицаОтраженияВУчете, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];
	
	РегистрацияВНалоговомОргане = Справочники.Организации.РегистрацияВНалоговомОрганеНаДату(Реквизиты.Организация, Реквизиты.Период);
	
	ТаблицаОтраженияВУчете = Параметры.ТаблицаОтраженияВУчете;

	Для Каждого СтрокаТаблицы из ТаблицаОтраженияВУчете Цикл
		
		ПериодНачисленияСтрокой = ПредставлениеПериода(НачалоГода(СтрокаТаблицы.РасчетныйПериод),
									КонецКвартала(СтрокаТаблицы.РасчетныйПериод),
									"ФП = Истина");
		Если ЗначениеЗаполнено(ПериодНачисленияСтрокой) Тогда
			ПериодНачисленияСтрокой = СтрШаблон(НСтр("ru=' за %1'"), ПериодНачисленияСтрокой);
		КонецЕсли;
		
		// Начисление
		Проводка = Движения.Хозрасчетный.Добавить();
		Проводка.Организация = Реквизиты.Организация;
		Проводка.Период      = Реквизиты.Период;
		
		Проводка.Сумма = СтрокаТаблицы.СуммаДохода;
		Проводка.Содержание = СтрШаблон(НСтр("ru='Начислены дивиденды%1'"), ПериодНачисленияСтрокой);
		
		Проводка.СчетДт = ПланыСчетов.Хозрасчетный.ПрибыльПодлежащаяРаспределению;
		Проводка.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыПоВыплатеДоходов;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Учредители", СтрокаТаблицы.Учредитель);
			
		// Налог
		Если СтрокаТаблицы.СуммаНалога <> 0 Тогда
			
			Проводка = Движения.Хозрасчетный.Добавить();
			Проводка.Организация = Реквизиты.Организация;
			Проводка.Период      = Реквизиты.Период;
			
			Проводка.Сумма = СтрокаТаблицы.СуммаНалога;
			
			Проводка.СчетДт = ПланыСчетов.Хозрасчетный.РасчетыПоВыплатеДоходов;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Учредители", СтрокаТаблицы.Учредитель);
			Если СтрокаТаблицы.ТипУчредителя = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
				Проводка.Содержание = СтрШаблон(НСтр("ru='НДФЛ с дивидендов%1'"), ПериодНачисленияСтрокой);
				Проводка.СчетКт     = ПланыСчетов.Хозрасчетный.НДФЛ;
			Иначе
				Проводка.Содержание = СтрШаблон(НСтр("ru='Налог на прибыль с дивидендов%1'"), ПериодНачисленияСтрокой);
				Проводка.СчетКт     = ПланыСчетов.Хозрасчетный.НалогНаПрибыльНалоговогоАгента;
			КонецЕсли;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, Перечисления.ВидыПлатежейВГосБюджет.Налог);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, РегистрацияВНалоговомОргане);
			
		КонецЕсли;
		
		Если СтрокаТаблицы.СуммаНалогаСПревышения <> 0
			И СтрокаТаблицы.ТипУчредителя = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
			
			Проводка = Движения.Хозрасчетный.Добавить();
			Проводка.Организация = Реквизиты.Организация;
			Проводка.Период      = Реквизиты.Период;
			
			Проводка.Сумма = СтрокаТаблицы.СуммаНалогаСПревышения;
			
			Проводка.СчетДт = ПланыСчетов.Хозрасчетный.РасчетыПоВыплатеДоходов;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Учредители", СтрокаТаблицы.Учредитель);
			Проводка.Содержание = СтрШаблон(НСтр("ru='НДФЛ с дивидендов (доходы свыше предельной величины)%1'"), ПериодНачисленияСтрокой);
			Проводка.СчетКт     = ПланыСчетов.Хозрасчетный.НДФЛ_ДоходыСвышеПредельнойВеличины;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, Перечисления.ВидыПлатежейВГосБюджет.Налог);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, РегистрацияВНалоговомОргане);
			
		КонецЕсли;
	
	КонецЦикла;
	
	Движения.Хозрасчетный.Записывать = Истина;
	
КонецПроцедуры

Функция ПодготовитьПараметрыДвиженийОтраженияДивидендов(ТаблицаОтраженияВУчете, ТаблицаРеквизиты)
	
	Параметры = Новый Структура;
	
	// Подготовка таблицы шапки документа
	СписокОбязательныхКолонок = ""
	+ "Регистратор,"	// <ДокументСсылка.НачислениеДивидендов> - Регистратор
	+ "Период,"			// <Дата> - счет по дебету проводки (счет учета денежных средств)
	+ "Организация"		// <СправочникСсылка.Организации> - организация документа
	;
	
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРеквизиты, СписокОбязательныхКолонок));
	
	// Подготовка таблицы по дивидендам:
	СписокОбязательныхКолонок = ""
	+ "РасчетныйПериод,"		// <Дата>
	+ "Учредитель,"				// <СправочникСсылка.ФизическиеЛица, СпраочникСсылка.Контрагенты>
	+ "ТипУчредителя,"			// <ПеречислениеСсылка.ЮридическоеФизическоеЛицо>
	+ "СуммаДохода,"			// <Число(15,2)>
	+ "СуммаНалога,"			// <Число(15,2)>
	+ "СуммаНалогаСПревышения"	// <Число(15,2)>
	;
	
	Параметры.Вставить("ТаблицаОтраженияВУчете", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаОтраженияВУчете, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция РассчитатьНалог(Учредитель, ТипУчредителя, СуммаДохода, Период, Организация, Регистратор) Экспорт
	
	Если ТипУчредителя = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		Возврат РассчитатьНДФЛ(Учредитель, СуммаДохода, Период, Организация, Регистратор);
	Иначе
		Возврат РассчитатьНалогНаПрибыль(СуммаДохода);
	КонецЕсли;
	
КонецФункции

Функция РассчитатьНДФЛ(Учредитель, СуммаДохода, ДатаПолученияДохода, Организация, Регистратор) Экспорт
	
	Возврат УчетЗарплаты.НалогСДивидендовАкционера(ДатаПолученияДохода, Организация, Учредитель, СуммаДохода, Регистратор);
	
КонецФункции

Функция РассчитатьНалогНаПрибыль(СуммаДохода) Экспорт
	
	Возврат Новый Структура("СуммаНалога", Окр(СуммаДохода * 13/ 100, 2));
	
КонецФункции

#КонецОбласти

#Область ОбработчикиОбновления

Процедура ЗаполнитьПланируемуюДатуВыплаты() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НачислениеДивидендов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.НачислениеДивидендов КАК НачислениеДивидендов
	|ГДЕ
	|	НачислениеДивидендов.ПланируемаяДатаВыплаты = ДАТАВРЕМЯ(1, 1, 1)";
	
	Выборка= Запрос.Выполнить().Выбрать();
	
	
	Пока Выборка.Следующий() Цикл
		Попытка
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.ПланируемаяДатаВыплаты = ДокументОбъект.Дата;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект);
		Исключение
			
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать документ: %1
				|%2'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				,
				Выборка.Ссылка,
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли