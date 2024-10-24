﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ФОРМЫ

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПровестиПроверкиПередВыполнениемСервер()

	РезультатыПроверки = Новый Структура("НетНеиспользуемыхСчетовФактур", Истина);

	ОпределитьНаличиеНеиспользуемыхСчетовФактурЗаПериод();

	РезультатыПроверки.Вставить("НетНеиспользуемыхСчетовФактур", НеиспользуемыеСчетаФактуры.Количество() = 0);

	Возврат РезультатыПроверки;

КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если СтруктураДанных.Свойство("Список") Тогда
		Объект.Список.Загрузить(СтруктураДанных.Список);
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализацияКомандДокументаНаКлиенте(ПараметрЗаполненияДокумента = Ложь, ПараметрыОбработки = Неопределено)

	ОчиститьСообщения();

	ИБФайловая = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	Если ПараметрЗаполненияДокумента Тогда
		Результат = ЗаполнитьСчетаФактурыНаСервере(ИБФайловая);
	Иначе
		Результат = СоздатьСчетаФактурыНаСервере(ПараметрыОбработки, ИБФайловая);
	КонецЕсли;

	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);

		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
	КонецЕсли;

	Если Не ПараметрЗаполненияДокумента Тогда
		Оповестить("СостояниеРегламентнойОперации", 
				?(Результат.ЗаданиеВыполнено, ПредопределенноеЗначение("Перечисление.ВидыСостоянийРегламентныхОпераций.Выполнено"), 
								   ПредопределенноеЗначение("Перечисление.ВидыСостоянийРегламентныхОпераций.НеВыполнено")));
	КонецЕсли;
						   
КонецПроцедуры

&НаСервере
Функция СоздатьСчетаФактурыНаСервере(ПараметрыОбработки, ИБФайловая)

	СтруктураПараметров = Новый Структура("Организация, НачалоПериода, КонецПериода",
		Объект.Организация, Объект.НачалоПериода, Объект.КонецПериода);

	Если ПараметрыОбработки.Свойство("ОчиститьСписокНеиспользуемыхСчетовФактур")
		И ПараметрыОбработки.ОчиститьСписокНеиспользуемыхСчетовФактур Тогда
		НеиспользуемыеСчетаФактуры.Очистить();
	КонецЕсли;

	Если ПараметрыОбработки.Свойство("УстановитьПометкиУдаления") Тогда
		СтруктураПараметров.Вставить("УстановитьПометкиУдаления", ПараметрыОбработки.УстановитьПометкиУдаления);
	КонецЕсли;

	СтруктураПараметров.Вставить("ТаблицыСчетовФактур", Новый Структура("Список, НеиспользуемыеСчетаФактуры", Объект.Список.Выгрузить(), НеиспользуемыеСчетаФактуры.Выгрузить()));

	Если ИБФайловая Тогда
		ЭтаФорма.АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
		Обработки.РегистрацияСчетовФактурНаСуммовыеРазницы.СформироватьСчетаФактуры(СтруктураПараметров, ЭтаФорма.АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);

	Иначе
		НаименованиеФоновогоЗадания = НСтр("ru = 'Формирование счетов-фактур в ""Регистрация счетов-фактур на аванс""'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.РегистрацияСчетовФактурНаСуммовыеРазницы.СформироватьСчетаФактуры",
			СтруктураПараметров,
			НаименованиеФоновогоЗадания);

	КонецЕсли;

	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаСервере
Функция ЗаполнитьСчетаФактурыНаСервере(ИБФайловая)

	СтруктураПараметров = Новый Структура("Организация, НачалоПериода, КонецПериода, ТаблицаРезультатов",
		Объект.Организация,
		Объект.НачалоПериода,
		Объект.КонецПериода,
		Объект.Список.Выгрузить()); // Список уже пустой, выгрузится только структура

	Если ИБФайловая Тогда
		ЭтаФорма.АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
		Обработки.РегистрацияСчетовФактурНаСуммовыеРазницы.ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеФоновогоЗадания = НСтр("ru = 'Заполнение обработки ""Регистрация счетов-фактур на суммовые разницы""'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.РегистрацияСчетовФактурНаСуммовыеРазницы.ПодготовитьДанныеДляЗаполнения",
			СтруктураПараметров,
			НаименованиеФоновогоЗадания);

		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;

	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;

	Возврат Результат

КонецФункции

&НаСервере
Процедура ОпределитьНаличиеНеиспользуемыхСчетовФактурЗаПериод() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	СчетФактураВыданный.Ссылка,
		|	СчетФактураВыданный.ПометкаУдаления
		|ИЗ
		|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
		|ГДЕ
		|	СчетФактураВыданный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыВыставленного.НаСуммовуюРазницу)
		|	И СчетФактураВыданный.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|	И СчетФактураВыданный.Организация = &Организация
		|	И (НЕ СчетФактураВыданный.Ссылка В (&СФдляОбновления))
		|	И (НЕ СчетФактураВыданный.СформированПриВводеНачальныхОстатковНДС)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СчетФактураВыданный.Дата,
		|	СчетФактураВыданный.Номер
		|";

	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("НачалоПериода", Объект.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Объект.КонецПериода));
	Запрос.УстановитьПараметр("СФдляОбновления",
		ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(Объект.Список.Выгрузить(, "СчетФактура"), Истина));

	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Колонки.Добавить("Использован", Новый ОписаниеТипов("Булево"));

	НеиспользуемыеСчетаФактуры.Загрузить(Результат);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
//Пересчет суммы НДС и валютной суммы при изменении суммы регл.
Процедура ПересчетНДСиСуммыПоСтроке(ТД)

	ТД.СуммаНДС = 0;

	Если ТД.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20") Тогда
		ТД.СуммаНДС = ТД.Сумма * 20 / 100;
	ИначеЕсли ТД.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10") Тогда
		ТД.СуммаНДС = ТД.Сумма * 10 / 100;
	ИначеЕсли ТД.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18") Тогда
		ТД.СуммаНДС = ТД.Сумма * 18 / 100;
	ИначеЕсли ТД.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20_120") Тогда
		ТД.СуммаНДС = ТД.Сумма * 20 / 120;
	ИначеЕсли ТД.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10_110") Тогда
		ТД.СуммаНДС = ТД.Сумма * 10 / 110;
	ИначеЕсли ТД.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18_118") Тогда
		ТД.СуммаНДС = ТД.Сумма * 18 / 118;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСуммы(ТекущаяСтрока)

	ПересчетНДСиСуммыПоСтроке(Объект.Список[ТекущаяСтрока]);

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСтавкиНДС(ТекущаяСтрока)

	ПересчетНДСиСуммыПоСтроке(Объект.Список[ТекущаяСтрока]);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыИзПараметровФормы(Форма)
	
	ПараметрыЗаполненияФормы = Неопределено;
	
	Объект = Форма.Объект;

	Если Форма.Параметры.Свойство("ПараметрыЗаполненияФормы",ПараметрыЗаполненияФормы) Тогда
	
		ЗаполнитьЗначенияСвойств(Объект,ПараметрыЗаполненияФормы);			
	
	Иначе
		
		Объект.НачалоПериода = НачалоКвартала(ОбщегоНазначения.ТекущаяДатаПользователя());
		Объект.КонецПериода  = КонецКвартала(ОбщегоНазначения.ТекущаяДатаПользователя());
	
	КонецЕсли; 		

КонецПроцедуры

&НаКлиенте
Процедура ВопросИспользоватьРанееЗарегистрированныеСчетаФактуры(Результат, ПараметрыОбработки) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		// Отменено пользователем
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		// Помечаем документы на удаление. Использование документов
		// будет выполняться далее, непосредственно в процессе регистрации счетов-фактур
		ПараметрыОбработки.Вставить("УстановитьПометкиУдаления", Истина);
	Иначе
		ПараметрыОбработки.Вставить("ОчиститьСписокНеиспользуемыхСчетовФактур", Истина);
	КонецЕсли;
	
	ИнициализацияКомандДокументаНаКлиенте(Ложь, ПараметрыОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполненияТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Список.Очистить();
		Если ПроверитьЗаполнение() Тогда
			ИнициализацияКомандДокументаНаКлиенте(Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СписокСчетовФактур(Команда)

	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("Организация",		Объект.Организация);
	ПараметрыОтбор.Вставить("ВидСчетаФактуры",	ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыВыставленного.НаСуммовуюРазницу"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	
	Если Объект.НачалоПериода <> '00010101' ИЛИ Объект.КонецПериода <> '00010101' Тогда
		Если Объект.НачалоПериода = '00010101' Тогда
			ПараметрыФормы.Вставить("ДатаМеньшеИлиРавно", КонецДня(Объект.КонецПериода));
		ИначеЕсли Объект.КонецПериода = '00010101' Тогда
			ПараметрыФормы.Вставить("ДатаБольшеИлиРавно", Объект.НачалоПериода);
		Иначе
			// ИнтервалВключаяГраницы с НачалоПериода по КонецПериода
			ПараметрыФормы.Вставить("ДатаБольшеИлиРавно", Объект.НачалоПериода);
			ПараметрыФормы.Вставить("ДатаМеньшеИлиРавно", КонецДня(Объект.КонецПериода));
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Документ.СчетФактураВыданный.ФормаСписка", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)

	Если Объект.Список.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполненияТабличнойЧастиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, "Регистрация счетов-фактур на суммовые разницы");
	Иначе 
		Если ПроверитьЗаполнение() Тогда
			ИнициализацияКомандДокументаНаКлиенте(Истина);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнить(Команда)
	
	Если НЕ ПроверитьЗаполнение() ИЛИ НЕ Объект.Список.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;

	РезультатыПроверки = ПровестиПроверкиПередВыполнениемСервер();

	ПараметрыОбработки =
		Новый Структура("УстановитьПометкиУдаления,ОчиститьСписокНеиспользуемыхСчетовФактур,
		|Организация, НачалоПериода", Ложь, Ложь, Объект.Организация, Объект.НачалоПериода);
	
	Если НЕ РезультатыПроверки.НетНеиспользуемыхСчетовФактур Тогда
		ТекстВопроса = НСтр("ru='По организации обнаружены счета-фактуры на аванс за обрабатываемый период,
			|которые не используются в списке счетов-фактур к регистрации (значение поля ""Счет-фактура"" по строке).
			|Номера найденных документов могут быть использованы для тех строк, у которых не установлен соответствующий
			|строке счет-фактура.
			|Использовать номера ранее зарегистрированных счетов-фактур?
			|
			|Да - Использовать номера обнаруженных счетов-фактур, неиспользованные пометить на удаление
			|Нет - Оставить обнаруженные счета-фактуры без изменений, продолжить процедуру регистрации
			|Отмена - Отменить формирование счетов-фактур на аванс'");
			
		Оповещение = Новый ОписаниеОповещения(
			"ВопросИспользоватьРанееЗарегистрированныеСчетаФактуры", ЭтотОбъект, ПараметрыОбработки);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	Иначе
		ИнициализацияКомандДокументаНаКлиенте(Ложь, ПараметрыОбработки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Объект.НачалоПериода, Объект.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, РезультатВыбора, "НачалоПериода,КонецПериода");
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	Если Объект.НачалоПериода > Объект.КонецПериода Тогда
		Объект.КонецПериода = Объект.НачалоПериода;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	Если Объект.КонецПериода < Объект.НачалоПериода Тогда
		Объект.НачалоПериода = Объект.КонецПериода;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Объект.Список.Очистить();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ТАБЛИЦЫ СПИСОК

&НаКлиенте
Процедура СписокСуммаПриИзменении(Элемент)

	ПриИзмененииСуммы(Элементы.Список.ТекущиеДанные.НомерСтроки - 1);

КонецПроцедуры

&НаКлиенте
Процедура СписокСтавкаНДСПриИзменении(Элемент)

	ПриИзмененииСтавкиНДС(Элементы.Список.ТекущиеДанные.НомерСтроки - 1);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Объект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	ЗаполнитьРеквизитыИзПараметровФормы(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.Выполнить.Доступность = Форма.Объект.Список.Количество() <> 0;
	
КонецПроцедуры
