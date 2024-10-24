﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Настроим видимость команд оплаты и подачи заявлений, колонок с данными о платежах
	ОплатаДоступна = ПравоДоступа("Использование", Метаданные.Обработки.ПомощникОплатыПатента);
	УменьшениеНалогаДоступно =
		ПравоДоступа("Использование", Метаданные.Обработки.ПомощникЗаполненияУведомленияОбУменьшенииНалогаПоПатенту);
	ЗаявленияДоступны = ПравоДоступа("Изменение", Метаданные.Документы.УведомлениеОСпецрежимахНалогообложения);
	ЗаявлениеНаПолучениеДоступно =
		ПравоДоступа("Использование", Метаданные.Обработки.ПомощникЗаполненияЗаявленияНаПолучениеПатента);
	ДоступенПросмотрПлатежей = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ЗадачиБухгалтера);
	
	Элементы.Оплатить.Видимость = ОплатаДоступна;
	Элементы.ФормаУведомлениеОбУменьшенииСуммыНалога.Видимость = УменьшениеНалогаДоступно И ЗаявленияДоступны;
	Элементы.ФормаЗаявлениеНаПатент.Видимость = ЗаявлениеНаПолучениеДоступно И ЗаявленияДоступны;
	Элементы.ФормаЗаявлениеУтратаПраваНаПатент.Видимость = ЗаявленияДоступны;
	Элементы.ФормаЗаявлениеПрекращениеДеятельности.Видимость = ЗаявленияДоступны;
	
	Период = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Параметры, "Период", ОбщегоНазначения.ТекущаяДатаПользователя());
	
	ВидПериода    = Перечисления.ДоступныеПериодыОтчета.Год;
	НачалоПериода = НачалоГода(Период);
	КонецПериода  = КонецГода(Период);
	
	ОтборПериодИспользование = Истина;
	ОтборПериод = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(ВидПериода, НачалоПериода, КонецПериода);
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
	ОсновнаяОрганизация = ОрганизацияПоУмолчанию();
	ОтборОрганизация = ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(
		ЭтотОбъект, , , ОсновнаяОрганизация);
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	Элементы.ГруппаОтборПоОрганизации.Видимость = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
	УстановитьУсловноеОформление();
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" И Не ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, "Организация", Параметр);
	ИначеЕсли ИмяСобытия = "Запись_ПлатежныйДокумент_УплатаНалогов"
		Или ИмяСобытия = "ИзменениеВыписки" Тогда
		ОбновитьСписокПатентов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПериодИспользованиеПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ОтборПериод) Тогда
		ОтборПериод   = Формат(Число(ОтборПериод) + Направление, "ЧГ=");
		НачалоПериода = ДобавитьМесяц(НачалоПериода, 12 * Направление);
		КонецПериода  = ДобавитьМесяц(КонецПериода, 12 * Направление);
	Иначе
		НачалоПериода = '00010101';
		КонецПериода  = '00010101';
	КонецЕсли;
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда
		Отказ = Истина;
		
		ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
		
		Если ОтборПериодИспользование Тогда
			ЗначенияЗаполнения.Вставить("ДатаНачала", НачалоПериода);
			ЗначенияЗаполнения.Вставить("ДатаОкончания", КонецПериода);
		КонецЕсли;
		
		ОткрытьФорму(
			"Документ.ОперацияСПатентом.ФормаОбъекта",
			Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения),
			ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Оплатить(Команда)
	
	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОплатитьПатент(ДанныеТекущейСтроки.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеОбУменьшенииСуммыНалога(Команда)
	
	Если ОтборОрганизацияИспользование Тогда
		Организация = ОтборОрганизация;
	Иначе
		Организация = ОсновнаяОрганизация;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Оповещение = Новый ОписаниеОповещения("УведомлениеОбУменьшенииНалогаОбработкаВводаОрганизации", ЭтотОбъект);
		ПоказатьВводЗначения(
			Оповещение,
			ОрганизацияПоУмолчанию(),
			НСтр("ru = 'Выберите организацию для заполнения уведомления'"),
			Тип("СправочникСсылка.Организации"));
	Иначе
		УведомлениеОбУменьшенииНалогаОбработкаВводаОрганизации(Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеНаПатент(Команда)
	
	ПараметрыВыполнения = Новый Структура("СоздатьНовоеЗаявление", Истина);
	Если ОтборОрганизацияИспользование Тогда
		ПараметрыВыполнения.Вставить("Организация", ОтборОрганизация);
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ПомощникЗаполненияЗаявленияНаПолучениеПатента.Форма",
		ПараметрыВыполнения,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеУтратаПраваНаПатент(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение(
		"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеПрекращениеДеятельности(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение(
		"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Сегодня = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Завтра = КонецДня(Сегодня) + 1;
	
	// Видимость второго платежа
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СуммаВторойПлатеж");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВторойПлатеж");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ВторойПлатеж", ВидСравненияКомпоновкиДанных.Равно, Дата("00010101"));
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Первый платеж оплачен
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПервыйПлатеж");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПервыйПлатежОплачен", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Оплачен'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветПлатежныйДокументОплачен);
	
	// Второй платеж оплачен
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВторойПлатеж");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ВторойПлатежОплачен", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Оплачен'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветПлатежныйДокументОплачен);
	
	// Первый платеж сегодня
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПервыйПлатеж");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПервыйПлатеж", ВидСравненияКомпоновкиДанных.Равно, Сегодня);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Сегодня'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ВажноеСобытие);
	
	// Второй платеж сегодня
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВторойПлатеж");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ВторойПлатеж", ВидСравненияКомпоновкиДанных.Равно, Сегодня);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Сегодня'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ВажноеСобытие);
	
	// Первый платеж завтра
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПервыйПлатеж");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ПервыйПлатеж", ВидСравненияКомпоновкиДанных.Равно, Завтра);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Завтра'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПриближающеесяСобытие);
	
	// Второй платеж завтра
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВторойПлатеж");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ВторойПлатеж", ВидСравненияКомпоновкиДанных.Равно, Завтра);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Завтра'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПриближающеесяСобытие);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериоду(Форма, НачалоПериода, КонецПериода, Использование)
	
	ОтборКомпоновкиДанных = Форма.Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ДатаНачала");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ДатаНачала", НачалоПериода, ВидСравненияКомпоновкиДанных.БольшеИлиРавно, , Использование);
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ДатаОкончания");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ДатаОкончания", КонецПериода, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, , Использование);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОрганизацияПоУмолчанию()
	
	ОрганизацияПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	Если ЗначениеЗаполнено(ОрганизацияПоУмолчанию)
		И Не ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(ОрганизацияПоУмолчанию) Тогда
		Возврат ОрганизацияПоУмолчанию;
	Иначе
		Возврат Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОплатитьПатент(ДокументПатент)
	
	ДанныеПатента = ДанныеПатента(ДокументПатент);
	
	ОписаниеПараметровОплаты = ОписаниеОплатыПатента(ДанныеПатента);
	
	ВыполнениеЗадачБухгалтераКлиент.ВыполнитьДействие(ОписаниеПараметровОплаты);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПатента(ДокументПатент)
	
	Возврат Документы.ОперацияСПатентом.ДанныеПатентаДляОплаты(ДокументПатент);
	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеОплатыПатента(ДанныеПатента)
	
	Возврат Документы.ОперацияСПатентом.ОписаниеОплатыПатента(ДанныеПатента);
	
КонецФункции

&НаКлиенте
Процедура СоздатьЗаявление(ВидЗаявления)
	
	ПараметрыФормы = Новый Структура;
	
	Если ОтборОрганизацияИспользование
		И ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ПараметрыФормы.Вставить("Организация", ОтборОрганизация);
	Иначе
		ПараметрыФормы.Вставить("Организация", ОсновнаяОрганизация);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
	
	Если ВидЗаявления = ПредопределенноеЗначение(
		"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме") Тогда
		
		ДанныеСписка = Элементы.Список.ТекущиеДанные;
		Если ДанныеСписка = Неопределено Тогда
			ПараметрыЗаполнения = Новый Структура("Патент", Неопределено);
		Иначе
			ПараметрыЗаполнения = Новый Структура("Патент", ДанныеСписка.Ссылка);
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
		
	КонецЕсли;
	
	УчетПСНКлиент.ОткрытьФормуЗаявления(ВидЗаявления, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеОбУменьшенииНалогаОбработкаВводаОрганизации(Организация, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОрганизацияПрименяетПатентнуюСистему(Организация) Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = '%1 не применяет Патентную систему налогообложения.'"), Организация);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Организация);
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура("Организация", Организация);
	
	ОткрытьФорму(
		"Обработка.ПомощникЗаполненияУведомленияОбУменьшенииНалогаПоПатенту.Форма",
		ПараметрыВыполнения,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОрганизацияПрименяетПатентнуюСистему(Организация)
	
	ДатаНачалаДействияПатентнойСистемы = УчетПСН.ДатаНачалаДействияПатентнойСистемы();
	
	ТекущаяДата = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	Возврат УчетнаяПолитика.ПрименяетсяУСНПатентЗаПериод(
		Организация, ДатаНачалаДействияПатентнойСистемы, КонецГода(ТекущаяДата));
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокПатентов()
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти