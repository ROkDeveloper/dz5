﻿
#Область ПрограммныйИнтерфейс

// Переопределние условного оформления формы "Новое" 1С-Отчетности
Процедура ФормаНовыхСобытий_ПриСозданииНаСервере(Форма) Экспорт
	
	ЗапросыИОНДляУсловногоОформления = ЗапросыИОНДляУсловногоОформления();
	
	ЭлементУО = Форма.УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТаблицаНовоеОбъектНаименованиеСсылка");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ЭлементУО.Отбор,
		"Новое.Ссылка",
		ВидСравненияКомпоновкиДанных.ВСписке,
		ЗапросыИОНДляУсловногоОформления.ЗапросыДляЗаменыТекста);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Сверка налогов с ФНС'"));
	
	Если Форма.ИмяФормы = "Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.ФормаНовыхСобытий" Тогда
		ЭлементУО = Форма.УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТаблицаНовоеОбъектНаименованиеСсылка");
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ЭлементУО.Отбор,
			"Новое.Ссылка",
			ВидСравненияКомпоновкиДанных.ВСписке,
			ЗапросыИОНДляУсловногоОформления.ЗапросыДляИзмененияЦветаТекста);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОплатаНалогаНеОбнаружена);
	КонецЕсли;
	
КонецПроцедуры

Функция ДоступностьОтчетности(Организация) Экспорт

	ДоступностьОтчетности = Новый Структура("РазрешеноИспользование, ОтчетностьПодключена, ОтчетностьДоступна");
	ДоступностьОтчетности.РазрешеноИспользование = ИнтерфейсыВзаимодействияБРО.УТекущегоПользователяЕстьДоступКЭДО();
	ДоступностьОтчетности.ОтчетностьПодключена = ИнтерфейсыВзаимодействияБРО.ПодключенДокументооборотСКонтролирующимОрганом(
		Организация, Перечисления.ТипыКонтролирующихОрганов.ФНС, Истина);
	ДоступностьОтчетности.ОтчетностьДоступна = (ДоступностьОтчетности.РазрешеноИспользование
		И ДоступностьОтчетности.ОтчетностьПодключена);
	
	Возврат ДоступностьОтчетности;

КонецФункции

Процедура СохранитьСсылкуПриОтправкеЗапросаИОН(Ссылка) Экспорт
	
	Если ЗапросИОНОтправлен(Ссылка) Тогда
		ЗаписатьВРегистрСостояниеЗапросаИОН(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// Если это запрос на ИОН, который был отправлен для сверки оплат,
// то данные запроса сохраняются в регистр сведений.
Процедура ПослеДобавленияОтветаНаЗапросИОН(Ссылка, Данные) Экспорт
	
	ДаныеЗапроса = ДанныеЗапросаИОН(Ссылка);
	Если Не ДаныеЗапроса.ЭтоЗапросНаСверкуОплат Тогда
		Возврат;
	КонецЕсли;
	
	Обработки.СверкаНалоговСФНС.ОбработатьДанныеФНС(Ссылка, Данные);
	
	ДанныеДокументаОплаты = ДанныеДокументаНеПрошедшегоСверку(
			ДаныеЗапроса.Организация,
			ДаныеЗапроса.ДатаНачалаПериода);
	СверкаПройдена = (ДанныеДокументаОплаты = Неопределено);
	ЗаписатьВРегистрСостояниеЗапросаИОН(Ссылка, Истина, СверкаПройдена);
	
	// Обновим данные сервиса проверки оплаты налогов.
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru='Обновление данных сервиса проверки оплаты налогов'");

	ПараметрыДлительнойОперации = Новый Структура;
	ПараметрыДлительнойОперации.Вставить("Организация", ДаныеЗапроса.Организация);
	ПараметрыДлительнойОперации.Вставить(
		"РазделыПерсонализированныхДанных",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.РазделыПерсонализированныхДанных.СервисПроверкаОплатыНалогов));
	
	ДлительныеОперации.ВыполнитьВФоне(
		"ПерсонализированныеПредложенияСервисов.ПерезаписатьПерсонализированныеДанныеВФоне",
		ПараметрыДлительнойОперации,
		ПараметрыВыполнения);
		
	// В регистре сведений ОтчетностьСНарушеннымСрокомПодачи отметим все декларации
	// как прошедшие сверку
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		НСтр("ru = 'Записи регистра ""Отчетность с нарушенным сроком подачи""
		     |помечаются как прошедшие сверку'");
	
	ПараметрыДлительнойОперации = Новый Структура;
	ПараметрыДлительнойОперации.Вставить("Организация", ДаныеЗапроса.Организация);
	
	ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.СверкаНалоговСФНС.ЗарегистрироватьИзменениеСтатусаЗадачиПодготовкиОтчета",
		ПараметрыДлительнойОперации, ПараметрыВыполнения);
	
КонецПроцедуры

Функция ДанныеЗапросаИОН(Ссылка) Экспорт
	
	Результат = Новый Структура("ЭтоЗапросНаСверкуОплат, Организация, ДатаНачалаПериода"); 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗапросыНаПроверкуОплатНалогов.Организация КАК Организация,
	|	ЗапросыНаПроверкуОплатНалогов.Запрос.ДатаНачалаПериода КАК ДатаНачалаПериода
	|ИЗ
	|	РегистрСведений.ЗапросыНаПроверкуОплатНалогов КАК ЗапросыНаПроверкуОплатНалогов
	|ГДЕ
	|	ЗапросыНаПроверкуОплатНалогов.Запрос = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
		Результат.ЭтоЗапросНаСверкуОплат = Истина;
	Иначе
		Результат.ЭтоЗапросНаСверкуОплат = Ложь;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Процедура РегламентированнаяОтчетность_ТаблицаНовоеПриОбновлении(Форма) Экспорт
	
	ЗапросыИОНДляУсловногоОформления = ЗапросыИОНДляУсловногоОформления();
	
	ЭлементыУО = Форма.УсловноеОформление.Элементы;
	ЭлементУО = ЭлементыУО.Получить(Форма.УсловноеОформление.Элементы.Количество() - 1);
	ЭлементыУО.Удалить(ЭлементУО);
	
	ЭлементУО = ЭлементыУО.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТаблицаНовоеОбъектНаименованиеСсылка");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ЭлементУО.Отбор,
		"Новое.Ссылка",
		ВидСравненияКомпоновкиДанных.ВСписке,
		ЗапросыИОНДляУсловногоОформления.ЗапросыДляЗаменыТекста);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Сверка налогов с ФНС'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДанныеДокументаНеПрошедшегоСверку(
	Организация, Дата, ДатаНачалаПроверки = Неопределено, НуженПоследнийДокумент = Ложь) Экспорт
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(
	"ВЫБРАТЬ
	|	ДанныеСписаний.Ссылка КАК Ссылка,
	|	ДанныеСписаний.Дата КАК Дата
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 1
	|		СписаниеСРасчетногоСчета.Ссылка КАК Ссылка,
	|		СписаниеСРасчетногоСчета.ДатаВходящегоДокумента КАК Дата
	|	ИЗ
	|		Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияФНСОбОплатахНалогов КАК СведенияФНСОбОплатахНалогов
	|			ПО СписаниеСРасчетногоСчета.Организация = СведенияФНСОбОплатахНалогов.Организация
	|				И (СведенияФНСОбОплатахНалогов.Год = &Год)
	|				И СписаниеСРасчетногоСчета.ДатаВходящегоДокумента = СведенияФНСОбОплатахНалогов.ДатаПлатежа
	|				И СписаниеСРасчетногоСчета.НомерВходящегоДокумента = СведенияФНСОбОплатахНалогов.НомерПлатежа
	|				И СписаниеСРасчетногоСчета.СуммаДокумента = СведенияФНСОбОплатахНалогов.СуммаПлатежа
	|	ГДЕ
	|		СведенияФНСОбОплатахНалогов.КБК ЕСТЬ NULL
	|		И СписаниеСРасчетногоСчета.Организация = &Организация
	|		И СписаниеСРасчетногоСчета.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|		И СписаниеСРасчетногоСчета.Проведен
	|		И СписаниеСРасчетногоСчета.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога)
	|		И СписаниеСРасчетногоСчета.ДатаВходящегоДокумента > &ДатаНачалаПроверки
	|	
	|	УПОРЯДОЧИТЬ ПО
	|		Дата) КАК ДанныеСписаний
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеКассовыхОрдеров.Ссылка,
	|	ДанныеКассовыхОрдеров.Дата
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 1
	|		РасходныйКассовыйОрдер.Ссылка КАК Ссылка,
	|		НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ) КАК Дата
	|	ИЗ
	|		Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияФНСОбОплатахНалогов КАК СведенияФНСОбОплатахНалогов
	|			ПО РасходныйКассовыйОрдер.Организация = СведенияФНСОбОплатахНалогов.Организация
	|				И (СведенияФНСОбОплатахНалогов.Год = &Год)
	|				И (НАЧАЛОПЕРИОДА(РасходныйКассовыйОрдер.Дата, ДЕНЬ) = СведенияФНСОбОплатахНалогов.ДатаПлатежа)
	|				И РасходныйКассовыйОрдер.НомерВходящегоДокумента = СведенияФНСОбОплатахНалогов.НомерПлатежа
	|				И РасходныйКассовыйОрдер.СуммаДокумента = СведенияФНСОбОплатахНалогов.СуммаПлатежа
	|	ГДЕ
	|		СведенияФНСОбОплатахНалогов.КБК ЕСТЬ NULL
	|		И РасходныйКассовыйОрдер.Организация = &Организация
	|		И РасходныйКассовыйОрдер.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|		И РасходныйКассовыйОрдер.Проведен
	|		И РасходныйКассовыйОрдер.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРКО.УплатаНалога)
	|		И РасходныйКассовыйОрдер.Дата > &ДатаНачалаПроверки
	|	
	|	УПОРЯДОЧИТЬ ПО
	|		РасходныйКассовыйОрдер.Дата) КАК ДанныеКассовыхОрдеров
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата");
	
	Если НуженПоследнийДокумент Или Не ЗначениеЗаполнено(ДатаНачалаПроверки) Тогда
		ОбработатьТекстЗапросаПоДокументамНеПрошедшимСверку(
			СхемаЗапроса, НуженПоследнийДокумент, ЗначениеЗаполнено(ДатаНачалаПроверки));
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	Запрос.УстановитьПараметр("Организация",           Организация);
	Запрос.УстановитьПараметр("НачалоПериода",         НачалоГода(Дата));
	Запрос.УстановитьПараметр("КонецПериода",          КонецГода(Дата));
	Запрос.УстановитьПараметр("Год",                   Год(Дата));
	Запрос.УстановитьПараметр("ДатаНачалаПроверки",    ДатаНачалаПроверки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Новый Структура;
		Результат.Вставить("ДатаОплаты", Выборка.Дата);
		Результат.Вставить("Ссылка",     Выборка.Ссылка);
		Возврат Результат;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьВРегистрСостояниеЗапросаИОН(Ссылка, ОтветОбработан = Ложь, СверкаПройдена = Ложь)

	ДанныеЗапроса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Организация, Дата, ДатаНачалаПериода");
	
	МенеджерЗаписи = РегистрыСведений.ЗапросыНаПроверкуОплатНалогов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Запрос      = Ссылка;
	МенеджерЗаписи.Организация = ДанныеЗапроса.Организация;
	МенеджерЗаписи.Дата        = ДанныеЗапроса.Дата;
	МенеджерЗаписи.Год         = Год(ДанныеЗапроса.ДатаНачалаПериода);
	МенеджерЗаписи.ОтветОбработан = ОтветОбработан;
	МенеджерЗаписи.СверкаПройдена = СверкаПройдена;
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи.Записать(Истина);
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

Функция ЗапросыИОНДляУсловногоОформления()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗапросыНаПроверкуОплатНалогов.Запрос КАК Запрос,
	|	ЗапросыНаПроверкуОплатНалогов.СверкаПройдена КАК СверкаПройдена
	|ИЗ
	|	РегистрСведений.ЗапросыНаПроверкуОплатНалогов КАК ЗапросыНаПроверкуОплатНалогов
	|ГДЕ
	|	ЗапросыНаПроверкуОплатНалогов.ОтветОбработан";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЗапросыДляЗаменыТекста = Новый СписокЗначений;
	ЗапросыДляИзмененияЦветаТекста = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		ЗапросыДляЗаменыТекста.Добавить(Выборка.Запрос);
		Если Не Выборка.СверкаПройдена Тогда
			ЗапросыДляИзмененияЦветаТекста.Добавить(Выборка.Запрос);
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура(
		"ЗапросыДляЗаменыТекста, ЗапросыДляИзмененияЦветаТекста",
		ЗапросыДляЗаменыТекста,
		ЗапросыДляИзмененияЦветаТекста);
		
	Возврат Результат;

КонецФункции

Функция ЗапросИОНОтправлен(Ссылка)

	Возврат (СведенияПоОтправкам.СведенияПоВсемОтправкам(Ссылка).Количество() > 0);

КонецФункции

Процедура ОбработатьТекстЗапросаПоДокументамНеПрошедшимСверку(
	СхемаЗапроса, НуженПоследнийДокумент, ЕстьДатаНачалаПроверки)
	
	Для Каждого Оператор Из СхемаЗапроса.ПакетЗапросов[0].Операторы Цикл
		
		ВложенныйЗапрос = Оператор.Источники[0].Источник.Запрос;
		
		Если НуженПоследнийДокумент Тогда
			ВложенныйЗапрос.Порядок[0].Направление = НаправлениеПорядкаСхемыЗапроса.ПоУбыванию;
		КонецЕсли;
		
		Если ЕстьДатаНачалаПроверки Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ОператорВложенногоЗапроса Из ВложенныйЗапрос.Операторы Цикл
			Для Каждого УсловиеОтбора Из ОператорВложенногоЗапроса.Отбор Цикл
				Если СтрНайти(Строка(УсловиеОтбора), "ДатаНачалаПроверки") <> 0 Тогда
					ОператорВложенногоЗапроса.Отбор.Удалить(ОператорВложенногоЗапроса.Отбор.Индекс(УсловиеОтбора));
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;
	
	Если НуженПоследнийДокумент Тогда
		СхемаЗапроса.ПакетЗапросов[0].Порядок[0].Направление = НаправлениеПорядкаСхемыЗапроса.ПоУбыванию;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти