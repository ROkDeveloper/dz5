﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗаполнитьСвойстваШапки() Экспорт

	Если НЕ ЗначениеЗаполнено(ДокументПоступления) Тогда
		Возврат;
	КонецЕсли;

	ДокументПоступленияСсылка = УчетНДСПереопределяемый.ПолучитьИсправляемыйДокументПоступления(ДокументПоступления, Истина);
	
	Если НЕ ЗначениеЗаполнено(ДокументПоступленияСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	КорректировкаКорректировочногоСчетаФактуры = Ложь;
		
	Если ТипЗнч(УчетНДСПереопределяемый.ПолучитьИсправляемыйДокументПоступления(ДокументПоступления, Ложь)) = Тип("ДокументСсылка.КорректировкаПоступления") 
		И ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.СогласованноеИзменение Тогда
		КорректировкаКорректировочногоСчетаФактуры = Истина;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.СогласованноеИзменение Тогда
		Если КорректировкаКорректировочногоСчетаФактуры Тогда
			ИсправляемыйДокументПоступления = УчетНДСПереопределяемый.ПолучитьИсправляемыйДокументПоступления(ДокументПоступления, Ложь);
		Иначе	
			ИсправляемыйДокументПоступления = УчетНДСПереопределяемый.ПолучитьИсправляемыйДокументПоступления(ДокументПоступления, Истина);
		КонецЕсли;	
	Иначе
		ИсправляемыйДокументПоступления = УчетНДСПереопределяемый.ПолучитьИсправляемыйДокументПоступления(ДокументПоступления, Ложь);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, ДокументПоступленияСсылка);
	
	Если ТипЗнч(ДокументПоступленияСсылка) = Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом") Тогда 
		
		РасчетыВУсловныхЕдиницах = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументПоступленияСсылка, "ДоговорКонтрагента.РасчетыВУсловныхЕдиницах");
		Если РасчетыВУсловныхЕдиницах = Истина Тогда 
			ВалютаДокумента = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КонецЕсли;
		
	КонецЕсли;
		
	// Если в качестве корректируемого документа выбран счет-фактура полученный, то 
	// в корректировку реализации реквизиты СуммаВключаетНДС, НДСВключенВСтоимость, ТипЦен 
	// необходимо из основания счета-фактуры.
	Если ТипЗнч(ДокументПоступленияСсылка) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		РеквизитыСФ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументПоступленияСсылка, "ДокументОснование");
		Если ЗначениеЗаполнено(РеквизитыСФ.ДокументОснование) Тогда
			МетаданныеДокументаОснования = РеквизитыСФ.ДокументОснование.Метаданные();
			СписокРеквизитов = "";
			
			// ТипЦен.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ТипЦен", МетаданныеДокументаОснования) Тогда
				СписокРеквизитов = СписокРеквизитов + ", ТипЦен";
			КонецЕсли;

			// СуммаВключаетНДС.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаВключаетНДС", МетаданныеДокументаОснования) Тогда
				СписокРеквизитов = СписокРеквизитов + ", СуммаВключаетНДС";
			КонецЕсли;

			// НДСВключенВСтоимость.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("НДСВключенВСтоимость", МетаданныеДокументаОснования) Тогда
				СписокРеквизитов = СписокРеквизитов + ", НДСВключенВСтоимость";
			КонецЕсли;

			СписокРеквизитов = Сред(СписокРеквизитов, 3);
			Если ЗначениеЗаполнено(СписокРеквизитов) Тогда
				РеквизитыДокументаОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыСФ.ДокументОснование, СписокРеквизитов);
				
				Для Каждого Реквизит Из РеквизитыДокументаОснования Цикл
					ЭтотОбъект[Реквизит.Ключ] = Реквизит.Значение;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание, ВидОперацииЗаполнения = Неопределено) Экспорт
	
	ДокументПоступления = Основание;
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
		ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.КорректировкаПоступления") Тогда
		
		ЗаполнитьСвойстваШапки();
		Документы.КорректировкаПоступления.ЗаполнитьПоПоступлению(ЭтотОбъект);
		КорректироватьБУиНУ = Документы.КорректировкаПоступления.ДоступнаКорректировкаБУиНУ(ЭтотОбъект.ДокументПоступления);
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "Грузоотправитель, Грузополучатель");
		Грузоотправитель   = ЗначенияРеквизитов.Грузоотправитель;
		Грузополучатель    = ЗначенияРеквизитов.Грузополучатель;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.АктОРасхождениях") Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ДокументПоступления, ВидОперации");
		
		ДокументПоступления          = Реквизиты.ДокументПоступления;
		
		ЗаполнитьСвойстваШапки();
		Документы.КорректировкаПоступления.ЗаполнитьПоПоступлению(ЭтотОбъект);
		КорректироватьБУиНУ = Документы.КорректировкаПоступления.ДоступнаКорректировкаБУиНУ(ЭтотОбъект.ДокументПоступления);
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументПоступления, "Грузоотправитель, Грузополучатель");
		Грузоотправитель   = ЗначенияРеквизитов.Грузоотправитель;
		Грузополучатель    = ЗначенияРеквизитов.Грузополучатель;
		
		Если Реквизиты.ВидОперации = Перечисления.ВидыОперацийАктОРасхождениях.РасхожденияПослеПриемки Тогда
			Документы.КорректировкаПоступления.ЗаполнитьТабличныеЧастиПоАктуОРасхождениях(ЭтотОбъект, Основание);
		КонецЕсли; 
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		
		ЕстьСделкаПоДокументу = ЗначениеЗаполнено(Документы.ВозвратТоваровПоставщику.СделкаПоДокументу(Основание));
		
		Если НЕ ЕстьСделкаПоДокументу Тогда
			// Если нет сделки по документу - корректировка возможна только к КСФ к возврату
			ДокументПоступления = УчетНДСПереопределяемый.НайтиПодчиненныйСчетФактуруПолученный(Основание);
			Если НЕ ЗначениеЗаполнено(ДокументПоступления) Тогда
				СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не зарегистрирован счет-фактура к документу %1.'"),
					ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Основание));
					
				ВызватьИсключение СообщениеОбОшибке;
			КонецЕсли; 
		Иначе
			КорректироватьБУиНУ = Документы.КорректировкаПоступления.ДоступнаКорректировкаБУиНУ(Основание);
		КонецЕсли; 
		
		ЗаполнитьСвойстваШапки();
		Документы.КорректировкаПоступления.ЗаполнитьПоВозвратуПоставщику(ЭтотОбъект, Основание);
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеДопРасходов") Тогда
		
		ЗаполнитьСвойстваШапки();
		Документы.КорректировкаПоступления.ЗаполнитьПоДопРасходам(ЭтотОбъект);
		КорректироватьБУиНУ = Документы.КорректировкаПоступления.ДоступнаКорректировкаБУиНУ(ЭтотОбъект.ДокументПоступления);
		
	Иначе
		
		ЗаполнитьСвойстваШапки();
		
	КонецЕсли;
	
	КорректироватьНДС = Истина;
	
	ПараметрыИсправления = Документы.КорректировкаПоступления.СформироватьПараметрыИсправленияКорректировочногоДокумента(
		?(ВидОперацииЗаполнения <> Неопределено, ВидОперацииЗаполнения, ВидОперации), Дата, ДокументПоступления);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыИсправления);
	
	Если КорректироватьБУиНУ Тогда
		ДокументПоступленияСсылка = УчетНДСПереопределяемый.ПолучитьИсправляемыйДокументПоступления(ДокументПоступления, Истина);
		
		РеквизитыДокументаПоступления = Неопределено;
		Если ЗначениеЗаполнено(ДокументПоступленияСсылка) Тогда
			РеквизитыДокументаПоступления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументПоступленияСсылка, "Дата");
		КонецЕсли;
		ДатаДокументаПоступления	= ?(РеквизитыДокументаПоступления <> Неопределено, РеквизитыДокументаПоступления.Дата, '00010101');
		
		Если ЗначениеЗаполнено(ДокументПоступленияСсылка) 
			И Год(ДатаДокументаПоступления) < Год(Дата) Тогда
			
			Если НЕ ЗначениеЗаполнено(СтатьяПрочихДоходовИРасходов) Тогда
				СтатьяПрочихДоходовИРасходов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПрочиеДоходыИРасходы.ИсправительныеЗаписиПоОперациямПрошлыхЛет");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьПредставлениеНомера() Экспорт
	
	Если НЕ ЗначениеЗаполнено(Номер) Тогда
		ЭтотОбъект.УстановитьНовыйНомер();	
	КонецЕсли;
	
	Если НЕ (ДополнительныеСвойства.Свойство("ПропуститьОбновлениеРеквизитовВСвязанныхДокументах") 
		И ДополнительныеСвойства.ПропуститьОбновлениеРеквизитовВСвязанныхДокументах = Истина) Тогда
		
		Если ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.ИсправлениеОшибки Тогда
			Если ЗначениеЗаполнено(ИсправляемыйДокументПоступления) Тогда
				НомерПредставления 	= ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсправляемыйДокументПоступления, "Номер"), Истина, Ложь); 
				ПредставлениеНомера = Строка(НомерПредставления) + " (испр. " + НомерИсправления + ")";
			Иначе
				ПредставлениеНомера = "(испр. " + НомерИсправления + ")";	
			КонецЕсли;
		Иначе
			ПредставлениеНомера = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Номер, Истина, Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") И ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
		ВидОперацииЗаполнения = ?(ДанныеЗаполнения.Свойство("ВидОперации"), ДанныеЗаполнения.ВидОперации, Неопределено);
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения.ДокументОснование, ВидОперацииЗаполнения);	
	Иначе
		СуммаВключаетНДС = Истина;
	КонецЕсли;
	ПризнаватьЗачитыватьАванс = Истина;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.ИсправлениеСобственнойОшибки Тогда
		
		Если Дата < '20150101' Тогда 
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Корректность", НСтр("ru = 'Дата документа'"), , ,
				НСтр("ru = 'Исправление собственной ошибки не поддерживается до 01.01.2015 г.'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Дата", "Объект", Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада");
	
	ЭтоКомиссия = ЗначениеЗаполнено(ДоговорКонтрагента)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ВидДоговора") = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом;

	СпособОценкиТоваровВРознице = УчетнаяПолитика.СпособОценкиТоваровВРознице(Организация, Дата);

	ЭтоВвозИзЕАЭС = Справочники.Контрагенты.КонтрагентРезидентТаможенногоСоюза(Контрагент);
	
	РозницаВПродажныхЦенах = (СпособОценкиТоваровВРознице = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости)
		И ТипСклада <> Перечисления.ТипыСкладов.ОптовыйСклад
		И НЕ ЭтоКомиссия;

	Если РозницаВПродажныхЦенах Тогда
		Для Каждого Строка Из Товары Цикл
			Если ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин Тогда
				Строка.СчетУчета    = ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахАТТ;
				Строка.СчетУчетаНДС = ПланыСчетов.Хозрасчетный.НДСпоПриобретеннымМПЗ;
			Иначе
				Строка.СчетУчета = ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ;
				Строка.СчетУчетаНДС = ПланыСчетов.Хозрасчетный.НДСпоПриобретеннымМПЗ;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата) Тогда
		НДСВключенВСтоимость = Ложь;
	КонецЕсли;

	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	УстановитьПредставлениеНомера();
	
	ЭтоУниверсальныйДокументСохраненноеЗначение = ЭтоУниверсальныйДокумент;
	ЗаполнитьСвойстваШапки();
	// При заполнении шапки значение признака УПД/УКД будет установлено по документу-основанию.
	ЭтоУниверсальныйДокумент = ЭтоУниверсальныйДокументСохраненноеЗначение;

	ОбработатьСуммыДокорректировки();

	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);

	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("ПометкаУдаления", ЭтотОбъект, "СчетФактураПолученный");
	Если НЕ (КорректироватьБУиНУ ИЛИ КорректироватьНДС) Тогда
		ПараметрыДействия.СостояниеФлага = Истина;
	КонецЕсли;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
	
	Если НЕ (ДополнительныеСвойства.Свойство("ПропуститьОбновлениеРеквизитовВСвязанныхДокументах") 
		И ДополнительныеСвойства.ПропуститьОбновлениеРеквизитовВСвязанныхДокументах = Истина) Тогда
		Документы.КорректировкаПоступления.ОбновитьРеквизитыСвязанныхДокументовКорректировки(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	МассивТабличныхЧастейДляРасчетаИтогов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		"Товары,Услуги,АгентскиеУслуги", ",");
		
	СуммаУвеличение		= 0;
	СуммаУменьшение		= 0;
	СуммаНДСДокумента	= 0;
	СуммаНДСУвеличение	= 0;
	СуммаНДСУменьшение	= 0;
	Для каждого ИмяТабличнойЧасти Из МассивТабличныхЧастейДляРасчетаИтогов Цикл
		СуммаНДСДокумента	= СуммаНДСДокумента + ЭтотОбъект[ИмяТабличнойЧасти].Итог("СуммаНДС");
		Для каждого СтрокаТабличнойЧасти Из ЭтотОбъект[ИмяТабличнойЧасти] Цикл
			СуммаУвеличение		= СуммаУвеличение + Макс(СтрокаТабличнойЧасти.Сумма - СтрокаТабличнойЧасти.СуммаДоИзменения, 0);
			СуммаУменьшение		= СуммаУменьшение + Макс(СтрокаТабличнойЧасти.СуммаДоИзменения - СтрокаТабличнойЧасти.Сумма, 0);
			СуммаНДСУвеличение	= СуммаНДСУвеличение + Макс(СтрокаТабличнойЧасти.СуммаНДС - СтрокаТабличнойЧасти.СуммаНДСДоИзменения, 0);
			СуммаНДСУменьшение	= СуммаНДСУменьшение + Макс(СтрокаТабличнойЧасти.СуммаНДСДоИзменения - СтрокаТабличнойЧасти.СуммаНДС, 0);
		КонецЦикла;
	КонецЦикла;
	
	ИменаТабличныхЧастей = Новый Массив;
	ИменаТабличныхЧастей.Добавить("Товары");
	ИменаТабличныхЧастей.Добавить("Услуги");
	ИменаТабличныхЧастей.Добавить("АгентскиеУслуги");

	ОбщегоНазначенияБП.ЗаполнитьИдентификаторыСтрок(ЭтотОбъект, ИменаТабличныхЧастей);
	
	ВедетсяУчетПрослеживаемыхТоваров = ПолучитьФункциональнуюОпцию("ВестиУчетПрослеживаемыхТоваров")
		И ПрослеживаемостьБРУ.ВедетсяУчетПрослеживаемыхТоваров(Дата);
		
	Если ВедетсяУчетПрослеживаемыхТоваров Тогда
		Для Каждого СтрокаТабличнойЧасти Из ЭтотОбъект.Товары Цикл
			Если СтрокаТабличнойЧасти.ПрослеживаемыйТовар = Ложь Тогда
				СтрокиСРНПТ = СведенияПрослеживаемости.НайтиСтроки(
				Новый Структура("ИдентификаторСтроки", СтрокаТабличнойЧасти.ИдентификаторСтроки));
				Для Каждого СтрокаСРНПТ Из СтрокиСРНПТ Цикл
					СведенияПрослеживаемости.Удалить(СтрокаСРНПТ);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		УчетНДСПереопределяемый.СинхронизироватьРеквизитыСчетаФактурыПолученного(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив();

	// проверки из шапки
	Если ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.ИсправлениеОшибки Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДокументПоступления", ДокументПоступления);
		Запрос.УстановитьПараметр("ЭтотДокумент"       , Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КорректировкаПоступления.Ссылка
		|ИЗ
		|	Документ.КорректировкаПоступления КАК КорректировкаПоступления
		|ГДЕ
		|	КорректировкаПоступления.ДокументПоступления = &ДокументПоступления
		|	И КорректировкаПоступления.ВидОперации <> ЗНАЧЕНИЕ(Перечисление.ВидыОперацийИсправленияПоступленияРеализации.СогласованноеИзменение)
		|	И КорректировкаПоступления.Ссылка <> &ЭтотДокумент
		|	И КорректировкаПоступления.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	КорректировкаПоступления.Дата УБЫВ";

		Результат = Запрос.Выполнить().Выбрать();
		Если Результат.Следующий() Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='К документу %1 введено больше одного корректировочного документа с видом операции ""Исправление первичных документов"". 
					|Каждую последующую корректировку следует вводить на основании предыдущей.'"),
					ДокументПоступления);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДокументПоступления", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(ДокументПоступления) Тогда
		ДокументПоступленияСсылка = УчетНДСПереопределяемый.ПолучитьИсправляемыйДокументПоступления(ДокументПоступления, Истина);
		Если ТипЗнч(ДокументПоступленияСсылка) <> Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом") Тогда
			Если НЕ ЗначениеЗаполнено(ДокументПоступленияСсылка) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнен исправляемый документ поступления!'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДокументПоступления", "Объект", Отказ);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ЭтоКомиссияПоПродаже = ЗначениеЗаполнено(ДоговорКонтрагента)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ВидДоговора") = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом;

	// Установка значений переменных для дальнейшей проверки

	Счет4112 = ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ;
	РазделятьПоСтавкамНДС = Счет4112.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС,
		"ВидСубконто") <> Неопределено;

	УчетВПродажныхЦенах = УчетнаяПолитика.СпособОценкиТоваровВРознице(Организация, Дата) =
		Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости;
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада");
	ОптовыйСклад = ТипСклада = Перечисления.ТипыСкладов.ОптовыйСклад;
	СкладНТТ = ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка;

	РозницаВПродажныхЦенах = УчетВПродажныхЦенах И НЕ ОптовыйСклад И НЕ ЭтоКомиссияПоПродаже;
	НТТ = РозницаВПродажныхЦенах И СкладНТТ;

	ПрименяетсяУСН = УчетнаяПолитика.ПрименяетсяУСН(Организация, Дата);
	ЕстьКомиссияПоЗакупке = ПолучитьФункциональнуюОпцию("ОсуществляетсяЗакупкаТоваровУслугДляКомитентов");
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ТекстСообщения = "";
		Если НЕ УчетВзаиморасчетов.ПроверитьВозможностьПроведенияВРеглУчете(
			ЭтотОбъект, ДоговорКонтрагента, ТекстСообщения) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
				НСтр("ru = 'Договор'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,
				"ДоговорКонтрагента", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;

	Если ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.СогласованноеИзменение
		ИЛИ ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.ИсправлениеСобственнойОшибки
		ИЛИ НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаИсправления");
	КонецЕсли;
	
	Если Не Документы.КорректировкаПоступления.ЭтоКорректировка(ВидОперации, ДокументПоступления) Или Не ЭтотОбъект.ЭтоУниверсальныйДокумент Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерВходящегоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВходящегоДокумента");
	КонецЕсли;
	
	// Табличная часть "Товары".
	Если НТТ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	КонецЕсли;

	Если НЕ НТТ ИЛИ НЕ РазделятьПоСтавкамНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДСВРознице");
	КонецЕсли;

	ПроверятьСтавкуНДС = НЕ ЭтоКомиссияПоПродаже
		И НЕ НДСВключенВСтоимость
		И НЕ РозницаВПродажныхЦенах;

	Для каждого СтрокаТаблицы Из Товары Цикл
		Префикс = "Товары[%1].";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Префикс, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));

		ИмяСписка = НСтр("ru = 'Товары'");

		// Проверка договора комитента по закупке для товаров, учитываемых за балансом.
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетУчета);
		Если НЕ ЭтоКомиссияПоПродаже И ЕстьКомиссияПоЗакупке И КорректироватьБУиНУ Тогда
			Если СвойстваСчета.Забалансовый Тогда
				// Если заполнен контрагент, то это комиссия по закупке, иначе это ответ.хранение.
				Если ЗначениеЗаполнено(СтрокаТаблицы.Контрагент) И НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДоговорКонтрагента) Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Договор с комитентом'"),
					СтрокаТаблицы.НомерСтроки, ИмяСписка);
					Поле = Префикс + "ДоговорКонтрагента";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;

				Если ЗначениеЗаполнено(СтрокаТаблицы.Контрагент) И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетРасчетов) Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Счет расчетов'"),
					СтрокаТаблицы.НомерСтроки, ИмяСписка);
					Поле = Префикс + "СчетРасчетов";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;				
			КонецЕсли;
		КонецЕсли;
		
		// Проверка заполнения таблицы СведенияПрослеживаемости
		Если СтрокаТаблицы.ПрослеживаемыйТовар Тогда
			
			СтруктураОтбора = Новый Структура("ИдентификаторСтроки, ЭтоСтрокаСИсходнымиРНПТ", СтрокаТаблицы.ИдентификаторСтроки, Ложь);
			РНПТПоСтроке = СведенияПрослеживаемости.Выгрузить(СтруктураОтбора);
			КоличествоРНПТ = РНПТПоСтроке.Итог("Количество");
			Если СтрокаТаблицы.ПрослеживаемыйКомплект Тогда
				Если КоличествоРНПТ = 0 Тогда
					ТекстСообщенияРасшифрвка = НСтр("ru = 'Не заполнены данные по РНПТ'");
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка","Корректность", НСтр("ru = 'РНПТ'"),
					СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстСообщенияРасшифрвка);
					Поле = Префикс + "РНПТ";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;
			Иначе
				
				Если СтрокаТаблицы.Количество <> КоличествоРНПТ Тогда
					ТекстСообщенияРасшифрвка = НСтр("ru = 'Количество РНПТ не совпадает с количеством товара в строке.'");
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка","Корректность", НСтр("ru = 'РНПТ'"),
					СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстСообщенияРасшифрвка);
					Поле = Префикс + "РНПТ";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;
			КонецЕсли;
			
			Если СтрокаТаблицы.ПрослеживаемыйКомплект И Не ЭтоКомиссияПоПродаже Тогда
				СуммаБезНДС = ?(СуммаВключаетНДС, СтрокаТаблицы.Сумма - СтрокаТаблицы.СуммаНДС, СтрокаТаблицы.Сумма);
				Если СуммаБезНДС < РНПТПоСтроке.Итог("Сумма") Тогда 
					ТекстСообщения = НСтр("ru = 'Сумма без НДС по прослеживаемым комплектующим больше суммы без НДС по товару'");
					
					Поле = "" + ИмяСписка + "["+ Формат(СтрокаТаблицы.НомерСтроки-1,"ЧГ=") + "].РНПТ";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

	// Табличная часть "Услуги"
	Если НЕ ПроверятьСтавкуНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
	КонецЕсли;

	// Табличная часть "АгентскиеУслуги"
	Если НЕ ПроверятьСтавкуНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("АгентскиеУслуги.СтавкаНДС");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	// Принудительная очистка движений, т.к. движения документа могут быть сформированы задним числом.
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект, Ложь);
	// Далее вызов ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей() не требуется,
	// т.к. был передан параметр ВыборочноОчищатьРегистры = Ложь, и все действия уже выполнены.
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.КорректировкаПоступления.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Если ПараметрыПроведения = Неопределено Тогда
		// В текущем виде документ не требуется проводить по регистрам (например, он был введен только для печатной формы),
		// но, возможно, что он ранее был проведен с другими данными и отражался в последовательности.
		// Чтобы теперь он не мешал последовательности, исключим его.
		РаботаСПоследовательностями.ЗарегистрироватьВПоследовательности(ЭтотОбъект, Отказ, Истина);
		УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(ЭтотОбъект, Отказ);
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ (АНАЛИЗ ОСТАТКОВ И Т.П.)
	
	// Таблица взаиморасчетов
	ТаблицаВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ТаблицаЗачетАвансов, 
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
	ТаблицаВзаиморасчетыВозврат = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ТаблицаЗачетАвансов, 
		ПараметрыПроведения.ВыделениеАвансаРеквизиты, Отказ);
		
	ТаблицаВзаиморасчетыДляУСНиИП = ТаблицаВзаиморасчеты.Скопировать();	
	
	ТаблицыПоВзаиморасчетам = Документы.КорректировкаПоступления.ПодготовитьТаблицыАвансовОплат(ТаблицаВзаиморасчеты, ПараметрыПроведения.Реквизиты);
	
	ТаблицаВзаиморасчетыВозврат = Документы.КорректировкаПоступления.ПодготовитьТаблицуВыделениеАвансов(ТаблицаВзаиморасчетыВозврат, ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаТовары, ПараметрыПроведения.ТаблицаУслуги, ПараметрыПроведения.ТаблицаАгентскиеУслуги);
	
	СтруктураТаблицДокумента = Документы.КорректировкаПоступления.ПодготовитьТаблицуДокументаПоКурсуАвансов(
	ПараметрыПроведения.Реквизиты,
	ПараметрыПроведения.ТаблицаТовары,
	ПараметрыПроведения.ТаблицаУслуги,
	ПараметрыПроведения.ТаблицаАгентскиеУслуги,
	ТаблицыПоВзаиморасчетам.ТаблицаАвансов);

	ТаблицаПоТоварам = Документы.КорректировкаПоступления.ПодготовитьТаблицыТоваровУслуг(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаТовары);

	ТаблицаПоТоварам = Документы.КорректировкаПоступления.ДополнитьОстаткамиБУТаблицуКорректировкиТоваров(
		ПараметрыПроведения.Реквизиты, ТаблицаПоТоварам);

	ТаблицаПоУслугам = Документы.КорректировкаПоступления.ПодготовитьТаблицыТоваровУслуг(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаУслуги, Истина);

	ТаблицаПоАгентскимУслугам = Документы.КорректировкаПоступления.ПодготовитьТаблицыТоваровУслуг(
		ПараметрыПроведения.Реквизиты, ПараметрыПроведения.ТаблицаАгентскиеУслуги, Истина);
		
	// Таблица товаров, закупленных по поручению комитентов
	ТаблицаОстаткиТоварыКомитентов = УчетТоваров.ПодготовитьТаблицуЗакупленныхТоварыКомитентов(
		ПараметрыПроведения.ЗакупленныеТоварыКомитента,
		ПараметрыПроведения.Реквизиты, Отказ);
		
	ЗакупленныеТоварыКомитента = Документы.КорректировкаПоступления.ПодготовитьТаблицуТоварыУслугиКомиссияПоЗакупке(
		ПараметрыПроведения.ЗакупленныеТоварыКомитента, 
		ПараметрыПроведения.Реквизиты, Отказ);

	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура;
	СтруктураТаблицУСН.Вставить("УСНРеквизиты", ПараметрыПроведения.УСНРеквизиты);
	СтруктураТаблицУСН.Вставить("ТаблицаРасчетов", ТаблицыПоВзаиморасчетам.ТаблицаВзаиморасчеты);
	СтруктураТаблицУСН.Вставить("ТаблицаПриход",   ПараметрыПроведения.УСНТаблицаПриход);
	СтруктураТаблицУСН.Вставить("ТаблицаКорректировка", ПараметрыПроведения.УСНТаблицаКорректировка);
	
	// Учет доходов и расходов ИП
	ИПТаблицыКорректировкиПоступления = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицыКорректировкиПоступленияМПЗ(
		ПараметрыПроведения.ИПТаблицаТоваров, ПараметрыПроведения.ИПТаблицаУслуг, ПараметрыПроведения.ИПРеквизиты, Отказ);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	// Алгоритмы формирования проводок этого документа рассчитывают суммы проводок налогового учета
	Движения.Хозрасчетный.ДополнительныеСвойства.Вставить("СуммыНалоговогоУчетаЗаполнены", Истина);
		
	// Рублевые суммы документов в валюте
	
	ТаблицаДляПроведенияПоРегиструРублевыеСуммыДокументовВВалюте = Документы.КорректировкаПоступления.ПодготовитьТаблицуДляПроведенияПоРублевымСуммам(ПараметрыПроведения.Реквизиты, 
	СтруктураТаблицДокумента, ПараметрыПроведения.РублевыеСуммыДокументовВВалюте);
	
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалюте(ТаблицаДляПроведенияПоРегиструРублевыеСуммыДокументовВВалюте,
		ПараметрыПроведения.РеквизитыРублевыеСуммыДокументыВВалюте, Движения, Отказ);

	Документы.КорректировкаПоступления.СформироватьДвиженияВыделениеАванса(
		ТаблицаВзаиморасчетыВозврат, ПараметрыПроведения.ВыделениеАвансаРеквизиты, Движения, Отказ);
	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансов(
		ТаблицыПоВзаиморасчетам.ТаблицаВзаиморасчеты, ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	СтруктураТаблицНДСПоКурсуАванса = Документы.КорректировкаПоступления.ТаблицыНДСПоКурсуАванса(
		ПараметрыПроведения.НДСТаблицыДокумента,
		ТаблицаДляПроведенияПоРегиструРублевыеСуммыДокументовВВалюте,
		ПараметрыПроведения.Реквизиты);
	
	// Учет НДС
	УчетНДС.СформироватьДвиженияНДСКорректировкиПоступлениеТоваровУслуг(
		ПараметрыПроведения.Реквизиты, СтруктураТаблицНДСПоКурсуАванса, Движения, Отказ);
		
	УчетНДСРаздельный.СформироватьДвиженияНДСКорректировкиПоступлениеТоваровУслуг(
		ПараметрыПроведения.Реквизиты, СтруктураТаблицНДСПоКурсуАванса, Движения, Отказ);
		
	// Учет прослеживаемых товаров
	ПрослеживаемыеОперации = ПараметрыПроведения.ПрослеживаемыеОперации;
	
	ПрослеживаемостьБП.РассчитатьТаблицуПрослеживаемыеОперацииВРублях(
		ПрослеживаемыеОперации,
		ТаблицаДляПроведенияПоРегиструРублевыеСуммыДокументовВВалюте,
		ПараметрыПроведения.Реквизиты,
		Ложь,
		Истина);

	ПрослеживаемостьБП.СформироватьДвиженияКорректировкаПоступленияТоваров(
		ПараметрыПроведения.ПрослеживаемыеТоварыУвеличение,
		ПараметрыПроведения.ПрослеживаемыеТоварыУменьшение,
		ПараметрыПроведения.ПрослеживаемыеОперации,
		ПараметрыПроведения.Реквизиты,
		Движения);
		
	// Учет товаров
	УчетТоваров.СформироватьДвиженияКорректировкиПоступленияТоваров(
		ПараметрыПроведения.Реквизиты, ТаблицаПоТоварам, Движения, Отказ);
	УчетТоваров.СформироватьДвиженияКорректировкиПоступленияУслуг(
		ПараметрыПроведения.Реквизиты, ТаблицаПоУслугам, Движения, Отказ);
	УчетТоваров.СформироватьДвиженияКорректировкиПоступленияАгентскихУслуг(
		ПараметрыПроведения.Реквизиты, ТаблицаПоАгентскимУслугам, Движения, Отказ);
	УчетТоваров.СформироватьДвиженияКорректировкаПоступленияПоЗакупленнымТоварамКомитента(
		ЗакупленныеТоварыКомитента, ТаблицаОстаткиТоварыКомитентов,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Учет УСН
	
	// приход УСН
	УчетУСН.КорректировкаПоступленияПоступлениеРасходовУСН(ПараметрыПроведения.УСНТаблицаПриход,
		ПараметрыПроведения.УСНРеквизиты, Движения, Отказ);

	Если НЕ Отказ И Движения.РасходыПриУСН.Количество() > 0 Тогда
		Движения.РасходыПриУСН.Записать(Истина);
		Движения.РасходыПриУСН.Записывать = Ложь;
	КонецЕсли;
	// корректировка УСН
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураТаблицУСН);
	
	СтруктураТаблицИППоКурсуАванса = Документы.КорректировкаПоступления.ТаблицыИППоКурсуАванса(
		ИПТаблицыКорректировкиПоступления,
		ТаблицаДляПроведенияПоРегиструРублевыеСуммыДокументовВВалюте,
		ПараметрыПроведения.Реквизиты);
	
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияКорректировкиПоступленияМПЗ(СтруктураТаблицИППоКурсуАванса,
		ТаблицаВзаиморасчетыДляУСНиИП, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// ПЕРЕОЦЕНКА ВАЛЮТНЫХ ОСТАТКОВ
		
	ТаблицаПереоценкаДвиженийДокумента = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкиДвиженийДокумента(ПараметрыПроведения.Реквизиты, Движения, Отказ);	

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценкаДвиженийДокумента,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияРасчетПереоценкиВалютныхСредств(ТаблицаПереоценкаДвиженийДокумента,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	// Регистрация в последовательности
	Документы.КорректировкаПоступления.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, ПараметрыПроведения, Отказ);
		
	ПроведениеСервер.ЗапомнитьПризнакПроверкиРеквизитов(ЭтотОбъект);
		
	Движения.Записать();
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект, "СчетФактураПолученный");	
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект, "СчетФактураПолученный");	
	ПараметрыДействия.СостояниеФлага = Ложь;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);

	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);

	ПрослеживаемостьБП.УдалениеПроведенияПервичногоДокумента(Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ОбработатьСуммыДокорректировки()

	ИсправлениеКорректировки = ЗначениеЗаполнено(ИсправляемыйДокументПоступления)
		И (ТипЗнч(ИсправляемыйДокументПоступления) = Тип("ДокументСсылка.КорректировкаПоступления"))
		И (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			ИсправляемыйДокументПоступления, "ВидОперации") = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.СогласованноеИзменение);

	Если ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.СогласованноеИзменение Тогда
		Товары.ЗагрузитьКолонку(Товары.ВыгрузитьКолонку("КоличествоДоИзменения"), 	"КоличествоДоКорректировки");
		Товары.ЗагрузитьКолонку(Товары.ВыгрузитьКолонку("ЦенаДоИзменения"), 		"ЦенаДоКорректировки");
		Товары.ЗагрузитьКолонку(Товары.ВыгрузитьКолонку("СуммаДоИзменения"), 		"СуммаДоКорректировки");
		Товары.ЗагрузитьКолонку(Товары.ВыгрузитьКолонку("СуммаНДСДоИзменения"), 	"СуммаНДСДоКорректировки");

		Услуги.ЗагрузитьКолонку(Услуги.ВыгрузитьКолонку("КоличествоДоИзменения"), 	"КоличествоДоКорректировки");
		Услуги.ЗагрузитьКолонку(Услуги.ВыгрузитьКолонку("ЦенаДоИзменения"), 		"ЦенаДоКорректировки");
		Услуги.ЗагрузитьКолонку(Услуги.ВыгрузитьКолонку("СуммаДоИзменения"), 		"СуммаДоКорректировки");
		Услуги.ЗагрузитьКолонку(Услуги.ВыгрузитьКолонку("СуммаНДСДоИзменения"), 	"СуммаНДСДоКорректировки");
		
		АгентскиеУслуги.ЗагрузитьКолонку(АгентскиеУслуги.ВыгрузитьКолонку("КоличествоДоИзменения"), 	"КоличествоДоКорректировки");
		АгентскиеУслуги.ЗагрузитьКолонку(АгентскиеУслуги.ВыгрузитьКолонку("ЦенаДоИзменения"), 		"ЦенаДоКорректировки");
		АгентскиеУслуги.ЗагрузитьКолонку(АгентскиеУслуги.ВыгрузитьКолонку("СуммаДоИзменения"), 		"СуммаДоКорректировки");
		АгентскиеУслуги.ЗагрузитьКолонку(АгентскиеУслуги.ВыгрузитьКолонку("СуммаНДСДоИзменения"), 	"СуммаНДСДоКорректировки");
		
	ИначеЕсли Не ИсправлениеКорректировки Тогда

		Для Каждого СтрокаТаблицы из Товары Цикл
			СтрокаТаблицы.КоличествоДоКорректировки = 0;
			СтрокаТаблицы.ЦенаДоКорректировки       = 0;
			СтрокаТаблицы.СуммаДоКорректировки      = 0;
			СтрокаТаблицы.СуммаНДСДоКорректировки   = 0;
		КонецЦикла;

		Для Каждого СтрокаТаблицы из Услуги Цикл
			СтрокаТаблицы.КоличествоДоКорректировки = 0;
			СтрокаТаблицы.ЦенаДоКорректировки       = 0;
			СтрокаТаблицы.СуммаДоКорректировки      = 0;
			СтрокаТаблицы.СуммаНДСДоКорректировки   = 0;
		КонецЦикла;

		Для Каждого СтрокаТаблицы из АгентскиеУслуги Цикл
			СтрокаТаблицы.КоличествоДоКорректировки = 0;
			СтрокаТаблицы.ЦенаДоКорректировки       = 0;
			СтрокаТаблицы.СуммаДоКорректировки      = 0;
			СтрокаТаблицы.СуммаНДСДоКорректировки   = 0;
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

#КонецЕсли