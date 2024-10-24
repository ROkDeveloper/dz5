﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда



Процедура ДобавитьОбороты(РабочаяТаблица, Валюта, ВалПриход, Приход, ВалРасход, Расход)

	СтрокаТаблицы = РабочаяТаблица.Найти(Валюта, "Валюта");

	Если СтрокаТаблицы = Неопределено Тогда

		НоваяСтрока = РабочаяТаблица.Добавить();

		НоваяСтрока.Валюта     = Валюта;
		НоваяСтрока.ВалютаПредставление = Строка(Валюта);
		НоваяСтрока.ВалОстаток = 0;
		НоваяСтрока.Остаток    = 0;
		НоваяСтрока.ВалПриход  = ВалПриход; 
		НоваяСтрока.Приход     = Приход;
		НоваяСтрока.ВалРасход  = ВалРасход;
		НоваяСтрока.Расход     = Расход;

	Иначе

		СтрокаТаблицы.ВалПриход = СтрокаТаблицы.ВалПриход + ВалПриход; 
		СтрокаТаблицы.Приход    = СтрокаТаблицы.Приход    + Приход;
		СтрокаТаблицы.ВалРасход = СтрокаТаблицы.ВалРасход + ВалРасход;
		СтрокаТаблицы.Расход    = СтрокаТаблицы.Расход    + Расход;

	КонецЕсли;

КонецПроцедуры 

Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт

	НачалоГода      = НачалоГода(ПараметрыОтчета.НачалоПериода);
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();

	ДокументРезультат = Новый ТабличныйДокумент;
	
	// расчет номера начального листа
	// осуществляется по проводкам так как не все операции по
	// кассе оформляются приходными/расходными ордерами

	ЛистовЗаГод   = 0;

	// Инициируем области отчета

	Макет = ПолучитьМакет("ДвижениеДенежныхСредств");

	//////////////////////////////////////////////////////////////////////////////////////////
	
	ОбластьВалОстатокОтчет 				= Макет.ПолучитьОбласть("ВалОстаток|Отчет");
	ОбластьПодвалОтчет 					= Макет.ПолучитьОбласть("Подвал|Отчет");
	ОбластьВТомЧислеОтчет 				= Макет.ПолучитьОбласть("ВТомЧисле|Отчет");
	ОбластьОстатокОтчет 				= Макет.ПолучитьОбласть("Остаток|Отчет");
	ОбластьВкладнойЛистОтчет 			= Макет.ПолучитьОбласть("ВкладнойЛист|Отчет");
	ОбластьШапкаОтчет 					= Макет.ПолучитьОбласть("Шапка|Отчет");
	ОбластьОстатокНаНДОтчет 			= Макет.ПолучитьОбласть("ОстатокНаНД|Отчет");
	ОбластьКурсовыеРазницыОтчет 		= Макет.ПолучитьОбласть("КурсовыеРазницы|Отчет");
	ОбластьКурсовыеРазницыПоВалютеОтчет = Макет.ПолучитьОбласть("КурсовыеРазницыПоВалюте|Отчет");
	ОбластьПереносОтчет 				= Макет.ПолучитьОбласть("Перенос|Отчет");
	ОбластьСтрокаВалШирокаяОтчет 		= Макет.ПолучитьОбласть("СтрокаВалШирокая|Отчет");
	ОбластьСтрокаВалОтчет 				= Макет.ПолучитьОбласть("СтрокаВал|Отчет");
	ОбластьСтрокаШирокаяОтчет 			= Макет.ПолучитьОбласть("СтрокаШирокая|Отчет");
	ОбластьСтрокаОтчет 					= Макет.ПолучитьОбласть("Строка|Отчет");
	ОбластьОборотОтчет 					= Макет.ПолучитьОбласть("Оборот|Отчет");
	ОбластьОборотРубОтчет 				= Макет.ПолучитьОбласть("ОборотРуб|Отчет");
	ОбластьОборотВалОтчет 				= Макет.ПолучитьОбласть("ОборотВал|Отчет");
	ОбластьКурсоваяРазницаОтчет 		= Макет.ПолучитьОбласть("КурсоваяРазница|Отчет");
	ОбластьКурсоваяРазницаПоВалютеОтчет = Макет.ПолучитьОбласть("КурсоваяРазницаПоВалюте|Отчет");
	ОбластьКонечныйОстатокОтчет 		= Макет.ПолучитьОбласть("КонечныйОстаток|Отчет");

	////////////////////////////////////////////////////////////////////////////////////////////////

	НачИтоги = ПараметрыОтчета.НачалоПериода;

	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДенежныеДокументы);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ДенежныеДокументыВал);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет
	|ПОМЕСТИТЬ ВТ_МассивСчетов
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&МассивСчетов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстаткиИОбороты.Период КАК Период,
	|	ХозрасчетныйОстаткиИОбороты.Валюта КАК Валюта,
	|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстатокДт КАК СуммаНачальныйОстатокДт,
	|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаНачальныйОстатокДт КАК ВалютнаяСуммаНачальныйОстатокДт,
	|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстатокДт КАК СуммаКонечныйОстатокДт,
	|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаКонечныйОстатокДт КАК ВалютнаяСуммаКонечныйОстатокДт,
	|	ХозрасчетныйОстаткиИОбороты.СуммаОборотДт КАК СуммаОборотДт,
	|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт КАК СуммаОборотКт
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
	|			&НачИтоги,
	|			&КонецПериода,
	|			ДЕНЬ,
	|			ДвиженияИГраницыПериода,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_МассивСчетов.Счет
	|				ИЗ
	|					ВТ_МассивСчетов),
	|			,
	|			Организация = &Организация
	|				И (&ПодразделениеОрганизации = &ПустоеПодразделение
	|					ИЛИ Подразделение = &ПодразделениеОрганизации)) КАК ХозрасчетныйОстаткиИОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ
	|	СУММА(СуммаНачальныйОстатокДт),
	|	СУММА(ВалютнаяСуммаНачальныйОстатокДт),
	|	СУММА(СуммаКонечныйОстатокДт),
	|	СУММА(ВалютнаяСуммаКонечныйОстатокДт),
	|	СУММА(СуммаОборотДт),
	|	СУММА(СуммаОборотКт)
	|ПО
	|	ОБЩИЕ,
	|	Период ПЕРИОДАМИ(ДЕНЬ, , ),
	|	Валюта
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДенежныеДокументы.Документ КАК Документ,
	|	НАЧАЛОПЕРИОДА(ДенежныеДокументы.Документ.Дата, ДЕНЬ) КАК День,
	|	ДенежныеДокументы.Документ.Дата КАК ДатаДок,
	|	ДенежныеДокументы.Документ.Номер КАК НомерДок,
	|	ДенежныеДокументы.Документ.ВалютаДокумента КАК Валюта,
	|	ВЫБОР
	|		КОГДА ДенежныеДокументы.Документ ССЫЛКА Документ.ПоступлениеДенежныхДокументов
	|			ТОГДА ДенежныеДокументы.Документ.ПринятоОт
	|		ИНАЧЕ ДенежныеДокументы.Документ.Выдано
	|	КОНЕЦ КАК ТекстДок,
	|	ВЫБОР
	|		КОГДА ДенежныеДокументы.Документ ССЫЛКА Документ.ПоступлениеДенежныхДокументов
	|			ТОГДА ДенежныеДокументы.Документ.СуммаДокумента
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Приход,
	|	ВЫБОР
	|		КОГДА ДенежныеДокументы.Документ ССЫЛКА Документ.ВыдачаДенежныхДокументов
	|			ТОГДА ДенежныеДокументы.Документ.СуммаДокумента
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Расход,
	|	ВЫБОР
	|		КОГДА ДенежныеДокументы.Документ ССЫЛКА Документ.ВыдачаДенежныхДокументов
	|			ТОГДА Проводки.СчетДт
	|		ИНАЧЕ Проводки.СчетКт
	|	КОНЕЦ КАК Счет
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПоступлениеДенежныхДокументов.Ссылка КАК Документ
	|	ИЗ
	|		Документ.ПоступлениеДенежныхДокументов КАК ПоступлениеДенежныхДокументов
	|	ГДЕ
	|		ПоступлениеДенежныхДокументов.ПометкаУдаления = ЛОЖЬ
	|		И ПоступлениеДенежныхДокументов.Дата МЕЖДУ &НачИтоги И &КонецПериода
	|		И ПоступлениеДенежныхДокументов.Организация = &Организация
	|		И ПоступлениеДенежныхДокументов.Проведен
	|		И ПоступлениеДенежныхДокументов.СчетУчетаДенежныхДокументов В
	|				(ВЫБРАТЬ
	|					ВТ_МассивСчетов.Счет
	|				ИЗ
	|					ВТ_МассивСчетов)
	|		И (&ПодразделениеОрганизации = &ПустоеПодразделение
	|				ИЛИ ПоступлениеДенежныхДокументов.ПодразделениеОрганизации = &ПодразделениеОрганизации)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВыдачаДенежныхДокументов.Ссылка
	|	ИЗ
	|		Документ.ВыдачаДенежныхДокументов КАК ВыдачаДенежныхДокументов
	|	ГДЕ
	|		ВыдачаДенежныхДокументов.Дата МЕЖДУ &НачИтоги И &КонецПериода
	|		И ВыдачаДенежныхДокументов.Организация = &Организация
	|		И (&ПодразделениеОрганизации = &ПустоеПодразделение
	|				ИЛИ ВыдачаДенежныхДокументов.ПодразделениеОрганизации = &ПодразделениеОрганизации)
	|		И ВыдачаДенежныхДокументов.СчетУчетаДенежныхДокументов В
	|				(ВЫБРАТЬ
	|					ВТ_МассивСчетов.Счет
	|				ИЗ
	|					ВТ_МассивСчетов)
	|		И ВыдачаДенежныхДокументов.Проведен
	|		И ВыдачаДенежныхДокументов.ПометкаУдаления = ЛОЖЬ) КАК ДенежныеДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Хозрасчетный.СчетДт КАК СчетДт,
	|			Хозрасчетный.СчетКт КАК СчетКт,
	|			Хозрасчетный.Регистратор КАК Регистратор
	|		ИЗ
	|			РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|		ГДЕ
	|			(Хозрасчетный.СчетДт В
	|							(ВЫБРАТЬ
	|								ВТ_МассивСчетов.Счет
	|							ИЗ
	|								ВТ_МассивСчетов)
	|						И (НЕ Хозрасчетный.СчетДт.Валютный
	|							ИЛИ Хозрасчетный.ВалютнаяСуммаДт <> 0)
	|						И (&ПодразделениеОрганизации = &ПустоеПодразделение
	|							ИЛИ Хозрасчетный.ПодразделениеДт = &ПодразделениеОрганизации)
	|					ИЛИ Хозрасчетный.СчетКт В
	|							(ВЫБРАТЬ
	|								ВТ_МассивСчетов.Счет
	|							ИЗ
	|								ВТ_МассивСчетов)
	|						И (НЕ Хозрасчетный.СчетКт.Валютный
	|							ИЛИ Хозрасчетный.ВалютнаяСуммаКт <> 0)
	|						И (&ПодразделениеОрганизации = &ПустоеПодразделение
	|							ИЛИ Хозрасчетный.ПодразделениеКт = &ПодразделениеОрганизации)
	|						И (Хозрасчетный.Период МЕЖДУ &НачИтоги И &КонецПериода)
	|						И Хозрасчетный.Организация = &Организация
	|						И Хозрасчетный.Активность = ИСТИНА)) КАК Проводки
	|		ПО ДенежныеДокументы.Документ = Проводки.Регистратор
	|
	|УПОРЯДОЧИТЬ ПО
	|	День,
	|	ДатаДок,
	|	Документ
	|ИТОГИ ПО
	|	День,
	|	Документ,
	|	Счет
	|АВТОУПОРЯДОЧИВАНИЕ";

	Запрос.УстановитьПараметр("НачИтоги",    			  	НачалоДня(НачИтоги));
	Запрос.УстановитьПараметр("КонецПериода",     		  	КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("Организация", 			 	ПараметрыОтчета.Организация);
	Запрос.УстановитьПараметр("МассивСчетов",        	  	МассивСчетов);
	Запрос.УстановитьПараметр("ПодразделениеОрганизации", 	ПараметрыОтчета.ПодразделениеОрганизации);
	Запрос.УстановитьПараметр("ПустоеПодразделение", 		БухгалтерскийУчетПереопределяемый.ПустоеПодразделение());
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	РезультатЗапросаПоИтогам 	 = РезультатыЗапроса[1];
	РезультатЗапросаПоДокументам = РезультатыЗапроса[2];
	
	ТаблицаДокументы = РезультатЗапросаПоДокументам.Выгрузить();
	ТаблицаДокументы.Очистить();
	ТаблицаДокументы.Колонки.Добавить("СтрокаСчет");
	ТаблицаДокументы.Колонки.Добавить("Валютный");
	ТаблицаДокументы.Колонки.Добавить("ВидДокумента");
	
	ТипЧисло=ОбщегоНазначения.ОписаниеТипаЧисло(15,2);
	
	РабочаяТаблица = Новый ТаблицаЗначений;
	РабочаяТаблица.Колонки.Добавить("Валюта",Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	РабочаяТаблица.Колонки.Добавить("ВалютаПредставление",Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(100)));
	РабочаяТаблица.Колонки.Добавить("ВалОстаток",ТипЧисло);
	РабочаяТаблица.Колонки.Добавить("Остаток",ТипЧисло);
	РабочаяТаблица.Колонки.Добавить("ВалПриход",ТипЧисло);
	РабочаяТаблица.Колонки.Добавить("Приход",ТипЧисло);
	РабочаяТаблица.Колонки.Добавить("ВалРасход",ТипЧисло);
	РабочаяТаблица.Колонки.Добавить("Расход",ТипЧисло);
	РабочаяТаблица.Индексы.Добавить("Валюта");
		
	ВыборкаПоВалюте = РезультатЗапросаПоИтогам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Валюта");
		
	Пока ВыборкаПоВалюте.Следующий() Цикл
		Если НЕ ВыборкаПоВалюте.Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
			Строка            = РабочаяТаблица.Добавить();
			Строка.Валюта     = ВыборкаПоВалюте.Валюта;
			Строка.ВалютаПредставление = Строка(ВыборкаПоВалюте.Валюта);
			Строка.Остаток    = ВыборкаПоВалюте.СуммаНачальныйОстатокДт;
			Строка.ВалОстаток = ВыборкаПоВалюте.ВалютнаяСуммаНачальныйОстатокДт;
		КонецЕсли;
	КонецЦикла;
	
	ВыборкаОбщихИтогов = РезультатЗапросаПоИтогам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Общие");
	
	Строка        = РабочаяТаблица.Добавить();
	Строка.Валюта = Справочники.Валюты.ПустаяСсылка();
	
	Если ВыборкаОбщихИтогов.Следующий() Тогда		
		
		Строка.Остаток    = ВыборкаОбщихИтогов["СуммаНачальныйОстатокДт"]-РабочаяТаблица.Итог("Остаток");
		Строка.ВалОстаток = ВыборкаОбщихИтогов["ВалютнаяСуммаНачальныйОстатокДт"]-РабочаяТаблица.Итог("ВалОстаток");
		
	Иначе
		
		Строка.Остаток    = 0;
		Строка.ВалОстаток = 0;
		
	КонецЕсли;

	РабочаяТаблица.Сортировать("ВалютаПредставление");
	
	ВыборкаИтоговПоДням     = РезультатЗапросаПоИтогам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Период");
	ВыборкаДокументовПоДням = РезультатЗапросаПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"День");
	
	ПоПроводкам  = ВыборкаИтоговПоДням.Следующий();
	ПоДокументам = ВыборкаДокументовПоДням.Следующий();
	
	БылиОшибки    = Ложь;
	ВывестиПодвал = Ложь;
	
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, КонецДня(ПараметрыОтчета.КонецПериода));
	
	ТипПДД = Тип("ДокументСсылка.ПоступлениеДенежныхДокументов");
		
	Пока ПоПроводкам Или ПоДокументам  Цикл
		Если НЕ ПоПроводкам  Тогда
			ДатаЛиста = ВыборкаДокументовПоДням.День;
		ИначеЕсли НЕ ПоДокументам Тогда
			ДатаЛиста = ВыборкаИтоговПоДням.Период;
		Иначе                 
			ДатаЛиста = Мин(ВыборкаДокументовПоДням.День, ВыборкаИтоговПоДням.Период);
		КонецЕсли;
		Если ВыборкаИтоговПоДням.СуммаОборотДт = 0 И ВыборкаИтоговПоДням.СуммаОборотКт = 0 Тогда
			Если НЕ ПоДокументам ИЛИ ДатаЛиста <> ВыборкаДокументовПоДням.День Тогда
				ПоПроводкам = ВыборкаИтоговПоДням.Следующий();
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НомерЛиста = ЛистовЗаГод + 1;
		ЛистовЗаГод = ЛистовЗаГод + 1;
		
		СчетКурсовыхРазниц = ПланыСчетов.Хозрасчетный.ПрочиеДоходыИРасходы;
		Остаток = РабочаяТаблица.Итог("Остаток");
		Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
			
			НаименованиеОрганизации = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, , ПараметрыОтчета.КонецПериода);
			Если ЗначениеЗаполнено(ПараметрыОтчета.ПодразделениеОрганизации) Тогда
				НаименованиеОрганизации = НаименованиеОрганизации + Символы.ПС + ?(ПустаяСтрока(ПараметрыОтчета.ПодразделениеОрганизации.НаименованиеПолное), ПараметрыОтчета.ПодразделениеОрганизации, ПараметрыОтчета.ПодразделениеОрганизации.НаименованиеПолное);
			КонецЕсли;
			ОбластьВкладнойЛистОтчет.Параметры.НазваниеОрганизации = НаименованиеОрганизации;
			
			ОбластьВкладнойЛистОтчет.Параметры.ЗаголовокЛиста=НСтр("ru='Отчет по движению денежных документов за'") + " " + Формат(ДатаЛиста, "ДФ=dd.MM.yyyy");
			ДокументРезультат.Вывести(ОбластьВкладнойЛистОтчет);
						
			ОбластьШапкаОтчет.Параметры.ТекстНомерЛиста=НСтр("ru='Лист'") + " " + НомерЛиста;
			ДокументРезультат.Вывести(ОбластьШапкаОтчет);
			
			ОбластьОстатокНаНДОтчет.Параметры.ОстатокНачало=Остаток;
			ДокументРезультат.Вывести(ОбластьОстатокНаНДОтчет);
		КонецЕсли;
	
		ПоВалютам = Ложь;
		Для Каждого Строка Из РабочаяТаблица Цикл  
			Если ((Строка.Остаток <> 0) Или (Строка.ВалОстаток <> 0)) И (НЕ Строка.Валюта=Справочники.Валюты.ПустаяСсылка()) Тогда
				ПоВалютам = Истина;      
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
//		Высота каждой строки = 13 пунктов
//      На стандартную страницу помещается 59 строк

//		Высоты секций в строках:
//      Шапка = 5 стр
//		ВкладнойЛист = 3 стр
//		ОтчетКассира = 3 стр
//		ОстатокНаНачало = 1 стр
//		ВТомЧисле = 1 стр
//		Остаток = 1 стр
//		ВалОстаток = 2 стр
//		КурсовыеРазницы = 2 стр
//		КурсовыеРазницыПоВалюте = 1 стр
//		Строка = 2 стр
//		СтрокаШирокая = 4 стр
//		СтрокаВал = 2 стр
//		СтрокаВалШирокая = 4 стр
//		Перенос = 1 стр
//		Оборот = 1 стр
//		ОборотРуб = 1 стр
//		ОборотВал = 2 стр
//		КурсоваяРазница = 1 стр
//		КурсоваяРазницаПоВалюте = 1 стр
//		КонечныйОстаток = 1 стр
//		Подвал = 11 стр
//		ЛистовЗаМесяц = 1 стр
//		ЛистовЗаГод = 1 стр

		ВысотаСтроки = 2; // высота секции документа
		СтрокШапки = 9;
		СтрокПодвала = 13;
		
		Если ПоВалютам Тогда
			Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
				ДокументРезультат.Вывести(ОбластьВТомЧислеОтчет);
			КонецЕсли;
			СтрокШапки = СтрокШапки + 1;
			Для Каждого Строка ИЗ РабочаяТаблица Цикл    
				Валюта     = Строка.Валюта;
				РубОстаток = Строка.Остаток;
				ВалОстаток = Строка.ВалОстаток;
				Если Строка.Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
					Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
						
						ОбластьОстатокОтчет.Параметры.ВалютаРеглУчета = СтрЗаменить(НСтр("ru='национальная валюта (%1):"), "%1", Константы.ВалютаРегламентированногоУчета.Получить().НаименованиеПолное);
						ОбластьОстатокОтчет.Параметры.РеглОстаток = РубОстаток;
						
						ДокументРезультат.Вывести(ОбластьОстатокОтчет);
						
					КонецЕсли;
					СтрокШапки = СтрокШапки + 1;
				Иначе
					Если (РубОстаток <> 0) Или (ВалОстаток <> 0) Тогда
						Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
							
							ОбластьВалОстатокОтчет.Параметры.ВалютаВалУчета = СтрЗаменить(НСтр("ru='иностранная валюта (%1):"), "%1", Валюта.НаименованиеПолное);
							ОбластьВалОстатокОтчет.Параметры.ВалОстатокРегл = РубОстаток;
							ОбластьВалОстатокОтчет.Параметры.ВалОстатокВал = Формат(ВалОстаток,"ЧЦ=15; ЧДЦ=2; ЧРД==")+" "+Валюта.Наименование;
							
							ДокументРезультат.Вывести(ОбластьВалОстатокОтчет);
							
						КонецЕсли;
						СтрокШапки = СтрокШапки + 2;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ТаблицаДокументы.Очистить();
		Валюты = Новый СписокЗначений;
				
		Если ПоДокументам И ВыборкаДокументовПоДням.День = ДатаЛиста Тогда
			
			ВыборкаДокументов = ВыборкаДокументовПоДням.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Документ");
			
			Пока ВыборкаДокументов.Следующий() Цикл
				
				НоваяСтрока = ТаблицаДокументы.Добавить();
				НоваяСтрока.ВидДокумента = ?(ТипЗнч(ВыборкаДокументов.Документ) = ТипПДД, "ПоступлениеДенежныхДокументов", "ВыдачаДенежныхДокументов");
				НоваяСтрока.Документ     = ВыборкаДокументов.Документ;
				НоваяСтрока.ДатаДок      = ВыборкаДокументов.ДатаДок;
				НоваяСтрока.День         = ВыборкаДокументов.День;
				НоваяСтрока.НомерДок     = ВыборкаДокументов.НомерДок;
				НоваяСтрока.Валюта       = ВыборкаДокументов.Валюта;
				НоваяСтрока.Приход       = ВыборкаДокументов.Приход;
				НоваяСтрока.Расход       = ВыборкаДокументов.Расход;
				НоваяСтрока.ТекстДок     = ВыборкаДокументов.ТекстДок;
				
				НоваяСтрока.Валютный = ВыборкаДокументов.Валюта <> ВалютаРеглУчета;
				Если НоваяСтрока.Валютный И Валюты.НайтиПоЗначению(ВыборкаДокументов.Валюта) = Неопределено Тогда
					Валюты.Добавить(ВыборкаДокументов.Валюта);
				КонецЕсли;
				
				ВыборкаСчетов = ВыборкаДокументов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Счет");
				СписокСчетов  = Новый ТаблицаЗначений;
				СписокСчетов.Колонки.Добавить("Счет");
				Пока ВыборкаСчетов.Следующий() Цикл
					
					СтрокаТаблицыСчетов      = СписокСчетов.Добавить();
					СтрокаТаблицыСчетов.Счет = ВыборкаСчетов.Счет;
					
				КонецЦикла;
				
				СписокСчетов.Свернуть("Счет");
				
				СтрокаСчет = "";
				Для Каждого СтрокаТаблицыСчетов Из СписокСчетов Цикл
					СтрокаСчет = СтрокаСчет + СтрокаТаблицыСчетов.Счет + Символы.ПС;
				КонецЦикла;
				
				НоваяСтрока.СтрокаСчет = СтрокаСчет;
				
			КонецЦикла;
			
		КонецЕсли;
		
		СумПриход    = 0;
		СумРасход    = 0;
		ПерваяСтрока = 1;
		Для Каждого СтрокаТаблица ИЗ РабочаяТаблица Цикл
			
			Если СтрокаТаблица.Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
				Продолжить;
			КонецЕсли;

			Если ДатаЛиста <> НачалоДня(КонецМесяца(ДатаЛиста)) Тогда
				Если Валюты.НайтиПоЗначению(СтрокаТаблица.Валюта) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			СтруктураКурсов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(СтрокаТаблица.Валюта,ДатаЛиста);
			
			Курс      = СтруктураКурсов.Курс;
			Кратность = СтруктураКурсов.Кратность;
			Кратность = ?(Кратность=0, 1, Кратность);
			КурсоваяРазница = Окр(СтрокаТаблица.ВалОстаток * Курс / Кратность - СтрокаТаблица.Остаток, 2, 1);
			Если КурсоваяРазница <> 0 Тогда
				Если ПерваяСтрока = 1 Тогда
					Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
												
						ДокументРезультат.Вывести(ОбластьКурсовыеРазницыОтчет);
						
					КонецЕсли;
					СтрокШапки   = СтрокШапки + 2;
					ПерваяСтрока = 0;
				КонецЕсли;
				Валюта = СтрокаТаблица.Валюта;
				Приход = 0;
				Расход = 0;
				КоррСчет = СчетКурсовыхРазниц;
				Если КурсоваяРазница > 0 Тогда
					Приход    = КурсоваяРазница;
					СумПриход = СумПриход+КурсоваяРазница;
				Иначе
					Расход    = -КурсоваяРазница;
					СумРасход = СумРасход-КурсоваяРазница;
				КонецЕсли;   
				СтрокаТаблица.Приход = СтрокаТаблица.Приход+Приход;
				СтрокаТаблица.Расход = СтрокаТаблица.Расход+Расход;
				Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
					
					ОбластьКурсовыеРазницыПоВалютеОтчет.Параметры.НадписьКРВалюта = "по " + Валюта.Наименование;
					ОбластьКурсовыеРазницыПоВалютеОтчет.Параметры.КоррСчет = КоррСчет;
					ОбластьКурсовыеРазницыПоВалютеОтчет.Параметры.Приход   = Приход;
					ОбластьКурсовыеРазницыПоВалютеОтчет.Параметры.Расход   = Расход;
					
					ДокументРезультат.Вывести(ОбластьКурсовыеРазницыПоВалютеОтчет);
					
				КонецЕсли;
				СтрокШапки = СтрокШапки + 1;
			КонецЕсли;
		КонецЦикла;
		          
		// Для простоты настройки печатной формы примем следующие соглашения:
		//	-	высота строк в таблице печатной формы задана жестко,
		//		тогда известно, сколько строк помещается на странице;
		СтрокНаСтранице = 58;
		//	-	высота шапки и подвала задана жестко и кратна высоте строк таблицы,
		//		тогда можно указать, сколько строк занимают шапка и подвал
		//		в пересчете на строки таблицы;
		//  -   Количество строк шапки определено при выводе валюты в шапку;
		//  -   Количество строк подвала определим позже по количеству валют;
		//	-	для нормальной работы алгоритма необходимо, чтобы шапка и подвал
		//		могли поместиться на одной странице + хотя бы одна строка таблицы:
		//		СтрокНаСтранице >= СтрокШапки + СтрокПодвала + 1
		//	-	если подвал не помещается на странице, он переносится на другую
		//		страницу с последней строкой; исключение составляет случай,
		//		когда в таблице всего одна строка.
		
		// Резервирование строк для вывода сведений о валюте в подвале.
		// Найдем количество валют, по которым будет остаток в конце дня.
		КоличествоВалютВПодвале = РабочаяТаблица.Количество() - 1; // без рублей
		// Добавим валюты, по которым нет итогов, но по которым есть оборот,
		// введенный документами.
		Для Каждого Валюта ИЗ Валюты Цикл
			
			Если РабочаяТаблица.Найти(Валюта.Значение, "Валюта") = Неопределено Тогда
				КоличествоВалютВПодвале = КоличествоВалютВПодвале + 1;
			КонецЕсли;
			
		КонецЦикла;
		// По каждой валюте добавляется:
		//  2 строки для оборота;
		//  2 строки для остатка;
		//  1 строка под курсовую разницу.
		// Для рублей добавляется:
		//  1 строка для оборота;
		//  1 строка для остатка.
		// Добавляет строка для секции "КурсоваяРазница" и "ВТомЧисле".
		СтрокПодвала = СтрокПодвала + ?(КоличествоВалютВПодвале > 0, КоличествоВалютВПодвале * 5 + 4, 0);
		
		// Если ПереноситьПоследнююСтроку = 1 - переносить,
		// если ПереноситьПоследнююСтроку = 0 - не надо переносить:
		Если (ТаблицаДокументы.Количество() * ВысотаСтроки) <= (СтрокНаСтранице - СтрокШапки - СтрокПодвала) Тогда
			ПереноситьПоследнююСтроку = 0;
		Иначе
			ЦелыхСтраницСПодвалом = Цел(((СтрокШапки-5)+ТаблицаДокументы.Количество()*ВысотаСтроки+СтрокПодвала-1)/(СтрокНаСтранице-5));
			ЦелыхСтраницБезПодвала = Цел(((СтрокШапки-5)+ТаблицаДокументы.Количество()*ВысотаСтроки-1)/(СтрокНаСтранице-5));
			ПереноситьПоследнююСтроку = ЦелыхСтраницСПодвалом - ЦелыхСтраницБезПодвала;
		КонецЕсли;
		
		КоличествоСтраниц = 1;
		Индекс            = 1;
		Для Каждого Документ Из ТаблицаДокументы Цикл
			
			Если Документ.ВидДокумента = "ПоступлениеДенежныхДокументов" или Документ.ВидДокумента = "ВыдачаДенежныхДокументов" Тогда
				ЕстьВалюта = Документ.Валютный;
			Иначе
				ЕстьВалюта = Ложь;
			КонецЕсли;
			
			Если ЕстьВалюта Тогда
				Валюта          = Документ.Валюта;
				СтруктураКурсов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта,Документ.ДатаДок);
				
				Курс      = СтруктураКурсов.Курс;
				Кратность = СтруктураКурсов.Кратность;
				Кратность = ?(Кратность = 0, 1, Кратность);
			Иначе
				Валюта    = Справочники.Валюты.ПустаяСсылка();
				Курс      = 1;
				Кратность = 1;
			КонецЕсли;
				
			Если Документ.ВидДокумента = "ВыдачаДенежныхДокументов" Тогда
				Клиент = "Выдано " + СокрЛП(Документ.ТекстДок);
				ВалРасход = Документ.Расход;
				Расход    = Окр(Документ.Расход*Курс/Кратность,2,1);
				ВалПриход = 0;
				Приход    = 0;
			Иначе
				Клиент = "Принято от " + СокрЛП(Документ.ТекстДок);
				ВалПриход = Документ.Приход;
				Приход    = Окр(Документ.Приход*Курс/Кратность,2,1);
				ВалРасход = 0;
				Расход    = 0;
			КонецЕсли;
			
			НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Документ.НомерДок, Истина, Ложь);
			КоррСчет = Документ.СтрокаСчет;
			
			// Начинаем новую страницу, если предыдущая строка была последней на странице
			// или пора переносить последнюю строку на последнюю страницу с подвалом.
			ЦелаяСтраница = Цел(((СтрокШапки-5)+(КоличествоСтраниц - 1)+(Индекс*ВысотаСтроки)-1)/(СтрокНаСтранице-5));
			Если (ЦелаяСтраница = КоличествоСтраниц) или 
				 ((ПереноситьПоследнююСтроку = 1) и (Индекс = ТаблицаДокументы.Количество())) Тогда
				ПриходЗаДень = РабочаяТаблица.Итог("Приход");
				РасходЗаДень = РабочаяТаблица.Итог("Расход");
				Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
					
					ОбластьПереносОтчет.Параметры.ПриходЗаДень = ПриходЗаДень;
					ОбластьПереносОтчет.Параметры.РасходЗаДень = РасходЗаДень;
					
					ДокументРезультат.Вывести(ОбластьПереносОтчет);
					
				КонецЕсли;
				НомерЛиста        = НомерЛиста + 1;
				КоличествоСтраниц = КоличествоСтраниц + 1;
				ЛистовЗаГод       = ЛистовЗаГод + 1;
				Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
					ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
					ОбластьШапкаОтчет.Параметры.ТекстНомерЛиста = НСтр("ru='Лист'") + " " + НомерЛиста;
					ДокументРезультат.Вывести(ОбластьШапкаОтчет);
				КонецЕсли;
			КонецЕсли;
			
			Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
				Если ЕстьВалюта Тогда
					ОбластьСтрокаВалОтчет.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
					ОбластьСтрокаВалОтчет.Параметры.Контрагент = Клиент;
					ОбластьСтрокаВалОтчет.Параметры.КоррСчет   = КоррСчет;
					ОбластьСтрокаВалОтчет.Параметры.Приход     = Приход;
					ОбластьСтрокаВалОтчет.Параметры.Расход     = Расход;
					ОбластьСтрокаВалОтчет.Параметры.ВалПриход  = Формат(ВалПриход,"ЧЦ=15; ЧДЦ=2; ЧРД==")+" "+Валюта.Наименование;
					ОбластьСтрокаВалОтчет.Параметры.ВалРасход  = Формат(ВалРасход,"ЧЦ=15; ЧДЦ=2; ЧРД==")+" "+Валюта.Наименование;
					ОбластьСтрокаВалОтчет.Параметры.Документ   = Документ.Документ;
					
					ДокументРезультат.Вывести(ОбластьСтрокаВалОтчет);
				Иначе
					ОбластьСтрокаОтчет.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
					ОбластьСтрокаОтчет.Параметры.Контрагент = Клиент;
					ОбластьСтрокаОтчет.Параметры.КоррСчет   = КоррСчет;
					ОбластьСтрокаОтчет.Параметры.Приход     = Приход;
					ОбластьСтрокаОтчет.Параметры.Расход     = Расход;
					ОбластьСтрокаОтчет.Параметры.Документ   = Документ.Документ;
					
					ДокументРезультат.Вывести(ОбластьСтрокаОтчет);
				КонецЕсли;
			КонецЕсли;
			
			ДобавитьОбороты(РабочаяТаблица, Валюта, ВалПриход, Приход, ВалРасход, Расход);
			Индекс = Индекс + 1;
		КонецЦикла;
		
		ПриходЗаДень = РабочаяТаблица.Итог("Приход");
		РасходЗаДень = РабочаяТаблица.Итог("Расход");
		Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
			
			ОбластьОборотОтчет.Параметры.ПриходЗаДень = ПриходЗаДень;
			ОбластьОборотОтчет.Параметры.РасходЗаДень = РасходЗаДень;
			
			ДокументРезультат.Вывести(ОбластьОборотОтчет);
			
			ПоВалютам = Ложь;
			Для Каждого Строка ИЗ РабочаяТаблица Цикл    
				Если ((Строка.ВалПриход <> 0) Или (Строка.Приход <> 0) Или 
					  (Строка.ВалРасход <> 0) Или (Строка.Расход <> 0)) И
					 (НЕ Строка.Валюта=Справочники.Валюты.ПустаяСсылка()) Тогда
					ПоВалютам = Истина ;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ПоВалютам Тогда
				Для Каждого Строка ИЗ РабочаяТаблица Цикл
					Валюта = Строка.Валюта;
					ВалПриходЗаДень = Строка.ВалПриход;
					РубПриходЗаДень = Строка.Приход;
					ВалРасходЗаДень = Строка.ВалРасход;
					РубРасходЗаДень = Строка.Расход;
					Если Строка.Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
						
						ОбластьОборотРубОтчет.Параметры.РеглПриходЗаДень = РубПриходЗаДень;
						ОбластьОборотРубОтчет.Параметры.РеглРасходЗаДень = РубРасходЗаДень;
						ОбластьОборотРубОтчет.Параметры.ВалютаРеглУчета  = СтрЗаменить(НСтр("ru='национальная валюта (%1):"), "%1", Константы.ВалютаРегламентированногоУчета.Получить().НаименованиеПолное);
						
						ДокументРезультат.Вывести(ОбластьОборотРубОтчет);
					Иначе
						Если (ВалПриходЗаДень <> 0) Или (РубПриходЗаДень <> 0) Или 
							 (ВалРасходЗаДень <> 0) Или (РубРасходЗаДень <> 0) Тогда
							
							ОбластьОборотВалОтчет.Параметры.ВалютаВалУчета      = СтрЗаменить(НСтр("ru='иностранная валюта (%1):"), "%1", Валюта.НаименованиеПолное);
							ОбластьОборотВалОтчет.Параметры.ВалПриходЗаДеньРегл = РубПриходЗаДень;
							ОбластьОборотВалОтчет.Параметры.ВалРасходЗаДеньРегл = РубРасходЗаДень;
							ОбластьОборотВалОтчет.Параметры.ВалПриходЗаДеньВал  = Формат(ВалПриходЗаДень,"ЧЦ=15; ЧДЦ=2; ЧРД==")+" "+Валюта;
							ОбластьОборотВалОтчет.Параметры.ВалРасходЗаДеньВал  = Формат(ВалРасходЗаДень,"ЧЦ=15; ЧДЦ=2; ЧРД==")+" "+Валюта;
							
							ДокументРезультат.Вывести(ОбластьОборотВалОтчет);							
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		ПерваяСтрока = Истина;
		Остаток      = Остаток + ПриходЗаДень - РасходЗаДень;
		Для Каждого Строка ИЗ РабочаяТаблица Цикл
			Если Строка.Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
				Продолжить;
			КонецЕсли;
			
			Если ДатаЛиста <> НачалоДня(КонецМесяца(ДатаЛиста)) Тогда
				Если Валюты.НайтиПоЗначению(Строка.Валюта) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			СтруктураКурсов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Строка.Валюта, ДатаЛиста);
			
			Курс      = СтруктураКурсов.Курс;
			Кратность = СтруктураКурсов.Кратность;
			Кратность = ?(Кратность=0, 1, Кратность);
			КурсоваяРазница = Окр((Строка.ВалОстаток+Строка.ВалПриход-Строка.ВалРасход)*Курс/Кратность-(Строка.Остаток+Строка.Приход-Строка.Расход), 2, 1);
			Если КурсоваяРазница <> 0 Тогда
				Если ПерваяСтрока Тогда
					Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
						ДокументРезультат.Вывести(ОбластьКурсоваяРазницаОтчет);
					КонецЕсли;
					ПерваяСтрока = Ложь;
				КонецЕсли;
				Валюта       = Строка.Валюта;
				ПриходЗаДень = 0;
				РасходЗаДень = 0;
				Если КурсоваяРазница > 0 Тогда
					ПриходЗаДень  = КурсоваяРазница;
					Строка.Приход = Строка.Приход + КурсоваяРазница;
				Иначе
					РасходЗаДень  = -КурсоваяРазница;
					Строка.Расход = Строка.Расход - КурсоваяРазница;
				КонецЕсли;
				Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
					
					ОбластьКурсоваяРазницаПоВалютеОтчет.Параметры.Валюта       = Валюта;
					ОбластьКурсоваяРазницаПоВалютеОтчет.Параметры.ПриходЗаДень = ПриходЗаДень;
					ОбластьКурсоваяРазницаПоВалютеОтчет.Параметры.РасходЗаДень = РасходЗаДень;
					
					ДокументРезультат.Вывести(ОбластьКурсоваяРазницаПоВалютеОтчет);
					
				КонецЕсли;
				Остаток = Остаток + КурсоваяРазница;
			КонецЕсли;
		КонецЦикла;
		
		Если ДатаЛиста >= ПараметрыОтчета.НачалоПериода Тогда
			
			ОбластьКонечныйОстатокОтчет.Параметры.ОстатокКонец = Остаток;
			
			ДокументРезультат.Вывести(ОбластьКонечныйОстатокОтчет);
		
			ПоВалютам = Ложь;
			Для Каждого Строка ИЗ РабочаяТаблица Цикл
				Если ((Строка.Остаток+Строка.Приход-Строка.Расход <> 0) Или (Строка.ВалОстаток+Строка.ВалПриход-Строка.ВалРасход <> 0)) И (НЕ Строка.Валюта=Справочники.Валюты.ПустаяСсылка()) Тогда
					ПоВалютам = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ПоВалютам Тогда
				ДокументРезультат.Вывести(ОбластьВТомЧислеОтчет);
				Для Каждого Строка ИЗ РабочаяТаблица Цикл
					Валюта     = Строка.Валюта;
					РубОстаток = Строка.Остаток + Строка.Приход - Строка.Расход;
					ВалОстаток = Строка.ВалОстаток + Строка.ВалПриход - Строка.ВалРасход;
					Если Строка.Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
						
						ОбластьОстатокОтчет.Параметры.ВалютаРеглУчета = СтрЗаменить(НСтр("ru='национальная валюта (%1):"), "%1", Константы.ВалютаРегламентированногоУчета.Получить().НаименованиеПолное);
						ОбластьОстатокОтчет.Параметры.РеглОстаток     = РубОстаток;
						
						ДокументРезультат.Вывести(ОбластьОстатокОтчет);
						
					Иначе
						Если (РубОстаток <> 0) Или (ВалОстаток <> 0) Тогда
							
							ОбластьВалОстатокОтчет.Параметры.ВалютаВалУчета = СтрЗаменить(НСтр("ru='иностранная валюта (%1):"), "%1", Валюта.НаименованиеПолное);
							ОбластьВалОстатокОтчет.Параметры.ВалОстатокРегл = РубОстаток;
							ОбластьВалОстатокОтчет.Параметры.ВалОстатокВал  = Формат(ВалОстаток,"ЧЦ=15; ЧДЦ=2; ЧРД==")+" "+Валюта.Наименование;
							
							ДокументРезультат.Вывести(ОбластьВалОстатокОтчет);
							
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			ЗначениеОрганизации = ПараметрыОтчета.Организация;
			ЗначениеОрганизации = ?(ЗначениеЗаполнено(ПараметрыОтчета.ПодразделениеОрганизации), ПараметрыОтчета.ПодразделениеОрганизации, ПараметрыОтчета.Организация);
			Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(ЗначениеОрганизации, КонецДня(ДатаЛиста));
			
			ОбластьПодвалОтчет.Параметры.ГлБухгалтер = Руководители.ГлавныйБухгалтерПредставление;
			ОбластьПодвалОтчет.Параметры.Кассир      = Руководители.КассирПредставление;
			
			ДокументРезультат.Вывести(ОбластьПодвалОтчет);
		КонецЕсли;
		
		Ошибка      = Ложь;
		Сортировать = Ложь;
		ВыборкаПоВалюте = ВыборкаИтоговПоДням.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Валюта");
		
		Пока ВыборкаПоВалюте.Следующий() Цикл
			Если НЕ ВыборкаПоВалюте.Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
				Строка = РабочаяТаблица.Найти(ВыборкаПоВалюте.Валюта, "Валюта");
				Если Строка = Неопределено Тогда
					Строка        = РабочаяТаблица.Добавить();
					Строка.Валюта = ВыборкаПоВалюте.Валюта;
					Строка.ВалютаПредставление = Строка(ВыборкаПоВалюте.Валюта);
					Сортировать   = Истина;
				КонецЕсли;
				Если (Строка.ВалОстаток + Строка.ВалПриход - Строка.ВалРасход <> ВыборкаПоВалюте.ВалютнаяСуммаКонечныйОстатокДт) Или
					 (Строка.Остаток + Строка.Приход - Строка.Расход <> ВыборкаПоВалюте.СуммаКонечныйОстатокДт) Тогда
					Ошибка = Истина;
				КонецЕсли;
				Строка.ВалОстаток = ВыборкаПоВалюте.ВалютнаяСуммаКонечныйОстатокДт;
				Строка.Остаток    = ВыборкаПоВалюте.СуммаКонечныйОстатокДт;
			КонецЕсли;
		КонецЦикла;
		
		Строка = РабочаяТаблица.Найти(Справочники.Валюты.ПустаяСсылка(), "Валюта");
		
		Если Строка = Неопределено Тогда
			Строка        = РабочаяТаблица.Добавить();
			Строка.Валюта = Справочники.Валюты.ПустаяСсылка();
			Сортировать   = Истина;
		Иначе
			Строка.Остаток = 0;
		КонецЕсли;
		
		Если (ДатаЛиста = ВыборкаИтоговПоДням.Период) Тогда
			Строка.Остаток = ВыборкаИтоговПоДням.СуммаКонечныйОстатокДт - РабочаяТаблица.Итог("Остаток");
			Если Остаток <> ВыборкаИтоговПоДням.СуммаКонечныйОстатокДт Тогда
				Ошибка = Истина;
			КонецЕсли;
			
		Иначе
			Если ПоПроводкам Тогда
				Строка.Остаток = ВыборкаИтоговПоДням.СуммаНачальныйОстатокДт - РабочаяТаблица.Итог("Остаток");
				Если Остаток <> ВыборкаИтоговПоДням.СуммаНачальныйОстатокДт Тогда
					Ошибка = Истина;
				КонецЕсли;
			Иначе
				Строка.Остаток = -РабочаяТаблица.Итог("Остаток");
				Если Остаток <> 0 Тогда
					Ошибка = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Ошибка Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрЗаменить(НСтр("ru='Обороты по документам и проводкам за %1 не совпадают!'"), "%1", Формат(ДатаЛиста, "ДФ=dd.MM.yyyy")));
		КонецЕсли;
		
		Если Сортировать Тогда
			РабочаяТаблица.Сортировать("ВалютаПредставление");
		КонецЕсли;
		РабочаяТаблица.ЗаполнитьЗначения(0,"ВалПриход, Приход, ВалРасход, Расход");
		
		Если ПоПроводкам И ДатаЛиста = ВыборкаИтоговПоДням.Период Тогда
			ПоПроводкам = ВыборкаИтоговПоДням.Следующий();
		КонецЕсли;
		Если ПоДокументам И ДатаЛиста = ВыборкаДокументовПоДням.День Тогда
			ПоДокументам = ВыборкаДокументовПоДням.Следующий();
		КонецЕсли;
		
		Если ПоПроводкам 
			И ВыборкаИтоговПоДням.Период = НачалоДня(ПараметрыОтчета.КонецПериода)
			И ВыборкаИтоговПоДням.СуммаОборотДт = 0 
			И ВыборкаИтоговПоДням.СуммаОборотКт = 0 
			Тогда
			Если МЕСЯЦ(ДатаЛиста) <> МЕСЯЦ(ВыборкаИтоговПоДням.Период) Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			ПоПроводкам = ВыборкаИтоговПоДням.Следующий();
		КонецЕсли;
		
		Если ПоПроводкам или ПоДокументам Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ВывестиПодвал = Истина;
		
	КонецЦикла;

	ДокументРезультат.ТолькоПросмотр = Истина;
	
	ПоместитьВоВременноеХранилище(ДокументРезультат, АдресХранилища);
			
КонецПроцедуры


#КонецЕсли