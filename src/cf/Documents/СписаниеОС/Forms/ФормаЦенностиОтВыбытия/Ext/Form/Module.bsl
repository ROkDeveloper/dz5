﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Организация,ПодразделениеОрганизации,Склад,Дата,ОсновноеСредство,ВедетсяУчетПрослеживаемыхТоваров");
	
	Если ЗначениеЗаполнено(Параметры.АдресХранилищаЦенностей)
		И ЭтоАдресВременногоХранилища(Параметры.АдресХранилищаЦенностей) Тогда
		
		ТаблицыПараметров = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаЦенностей);
		ЦенностиИзПараметров = ТаблицыПараметров.ТаблицаЦенностей;
		СведенияИзПараметров = ТаблицыПараметров.ТаблицаСведенияПрослеживаемости;
		
		// Нам эти данные больше не нужны - удалим их.
		УдалитьИзВременногоХранилища(Параметры.АдресХранилищаЦенностей);
		
		Если ЗначениеЗаполнено(ЦенностиИзПараметров) Тогда
			ЦенностиОтВыбытия.Загрузить(ЦенностиИзПараметров);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СведенияИзПараметров) Тогда
			СведенияПрослеживаемости.Загрузить(СведенияИзПараметров);
		КонецЕсли;
		
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
	УстановитьВидимостьСчетовУчета();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	НастройкиУсловногоОформления = Новый Структура();

	ОбновитьУсловноеОформление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьУсловноеОформление(Форма)

	Элементы = Форма.Элементы;

	Форма.УстановитьУсловноеОформлениеЦенностиОтВыбытия();

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеЦенностиОтВыбытия() Экспорт
		
	// РНПТ
		ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЦенностиОтВыбытияРНПТ");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ВедетсяУчетПрослеживаемыхТоваров", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЦенностиОтВыбытияРНПТ");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ЦенностиОтВыбытия.ПрослеживаемыйТовар", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ЦенностиОтВыбытия.Номенклатура", ВидСравненияКомпоновкиДанных.Заполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПоля);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Не требуется>'"));
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЦенностиОтВыбытияРНПТ");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ЦенностиОтВыбытия.ПрослеживаемыйТовар", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ЦенностиОтВыбытия.РНПТ", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	// СтранаПроисхождения
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЦенностиОтВыбытияСтранаПроисхождения");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ВедетсяУчетПрослеживаемыхТоваров", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь); 
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЦенностиОтВыбытияСтранаПроисхождения");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ЦенностиОтВыбытия.ПрослеживаемыйТовар", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ЦенностиОтВыбытия.Номенклатура", ВидСравненияКомпоновкиДанных.Заполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПоля);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Не требуется>'"));
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЦенностиОтВыбытияСтранаПроисхождения");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ЦенностиОтВыбытия.ПрослеживаемыйТовар", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ЦенностиОтВыбытия.СтранаПроисхождения", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	// Признак прослеживаемости
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЦенностиОтВыбытияПрослеживаемыйТовар");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ВедетсяУчетПрослеживаемыхТоваров", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДанныеСкопированыВБуферОбмена" Тогда
		УстановитьДоступностьКомандыВставки(ЭтотОбъект, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РеквизитыТабличнойЧастиЦенностиОтВыбытия = Метаданные.Документы.СписаниеОС.ТабличныеЧасти.ЦенностиОтВыбытия.Реквизиты;
	
	ЭлементыИМетаданные = Новый Структура;
	ЭлементыИМетаданные.Вставить("Номенклатура", РеквизитыТабличнойЧастиЦенностиОтВыбытия.Номенклатура);
	ЭлементыИМетаданные.Вставить("Количество", РеквизитыТабличнойЧастиЦенностиОтВыбытия.Количество);
	ЭлементыИМетаданные.Вставить("Цена", РеквизитыТабличнойЧастиЦенностиОтВыбытия.Цена);
	ЭлементыИМетаданные.Вставить("Сумма", РеквизитыТабличнойЧастиЦенностиОтВыбытия.Сумма);
	Если СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета() Тогда
		ЭлементыИМетаданные.Вставить("СчетУчета", РеквизитыТабличнойЧастиЦенностиОтВыбытия.СчетУчета);
	КонецЕсли;
	
	ПроверяемыйСписок = РедактированиеВПодчиненныхФормах.НовыйПроверяемыйСписок();
	ПроверяемыйСписок.Таблица = ЦенностиОтВыбытия;
	ПроверяемыйСписок.Имя = "ЦенностиОтВыбытия";
	ПроверяемыйСписок.Синоним = СинонимТабличнойЧасти();
	
	РедактированиеВПодчиненныхФормах.ВыполнитьПроверкуЗаполненияТаблицыПоРеквизитамМетаданных(
		ПроверяемыйСписок, ЭлементыИМетаданные, Отказ);
		
	Ошибки = Неопределено;
	Для Каждого СтрокаТЧ Из ЦенностиОтВыбытия Цикл
		
		ИндексСтроки = ЦенностиОтВыбытия.Индекс(СтрокаТЧ);
		Если Не ЗначениеЗаполнено(СтрокаТЧ.СтранаПроисхождения) И СтрокаТЧ.ПрослеживаемыйТовар Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки, 
			"ЦенностиОтВыбытия[%1].СтранаПроисхождения",
			Нстр("ru='Не указана страна происхождения'"),
			"",
			ИндексСтроки);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТЧ.РНПТ) И СтрокаТЧ.ПрослеживаемыйТовар Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки, 
			"СведенияПрослеживаемости[%1].РНПТ",
			Нстр("ru='Не указан номер РНПТ'"),
			"",
			ИндексСтроки);
		КонецЕсли;
		
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
	Если НЕ Отказ И Модифицированность Тогда
		Отказ = Не ПроверитьЗаполнение();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыЦенностиОтВыбытия

&НаКлиенте
Процедура ЦенностиОтВыбытияПриИзменении(Элемент)
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиОтВыбытияНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЦенностиОтВыбытия.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура,Количество,Цена,Сумма, ПрослеживаемыйТовар, СтранаПроисхождения");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	ДанныеОбъекта.Вставить("СпособЗаполненияЦены", ПредопределенноеЗначение("Перечисление.СпособыЗаполненияЦен.ПоПродажнымЦенам"));
	ДанныеОбъекта.Вставить("СуммаВключаетНДС", Ложь);
	ДанныеОбъекта.Вставить("ВедетсяУчетПрослеживаемыхТоваров", ВедетсяУчетПрослеживаемыхТоваров);
	
	ПараметрыЗаполненияСчетовУчета = НачатьЗаполнениеСчетовУчета(
		"ЦенностиОтВыбытия.Номенклатура",
		Неопределено,
		ТекущиеДанные,
		ДанныеОбъекта,
		ДанныеСтрокиТаблицы);
		
	ЦенностиОтВыбытияНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта, ПараметрыЗаполненияСчетовУчета.КЗаполнению);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);
	Если Не ТекущиеДанные.ПрослеживаемыйТовар Тогда
		ТекущиеДанные.СтранаПроисхождения = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка");
		ТекущиеДанные.РНПТ = ПредопределенноеЗначение("Справочник.НомераГТД.ПустаяСсылка");
	КонецЕсли;
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиОтВыбытияНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиентБП.НоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиОтВыбытияНоменклатураАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Вставить("ВидыНоменклатуры", "Материалы,Товары");
	
	РаботаСНоменклатуройКлиентБП.НоменклатураАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиОтВыбытияНоменклатураОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Вставить("ВидыНоменклатуры", "Материалы,Товары");
	
	РаботаСНоменклатуройКлиентБП.НоменклатураОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиОтВыбытияКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЦенностиОтВыбытия.ТекущиеДанные;
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(ТекущиеДанные);
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиОтВыбытияЦенаПриИзменении(Элемент)
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(Элементы.ЦенностиОтВыбытия.ТекущиеДанные);
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиОтВыбытияСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЦенностиОтВыбытия.ТекущиеДанные;
	
	ТекущиеДанные.Цена = ТекущиеДанные.Сумма / ?(ТекущиеДанные.Количество = 0, 1, ТекущиеДанные.Количество);
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиОтВыбытияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ЦенностиОтВыбытияСтранаПроисхождения" Тогда
		ТекущиеДанные = Элементы.ЦенностиОтВыбытия.ТекущиеДанные;
		Если НЕ ТекущиеДанные.ПрослеживаемыйТовар Тогда
			СтандартнаяОбработка = Ложь;
		Конецесли;
	КонецЕсли;
	
	Если Поле.Имя = "ЦенностиОтВыбытияРНПТ" Тогда
		ТекущиеДанные = Элементы.ЦенностиОтВыбытия.ТекущиеДанные;
		Если НЕ ТекущиеДанные.ПрослеживаемыйТовар Тогда
			СтандартнаяОбработка = Ложь;
		Конецесли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗакрытьФормуИВернутьРезультат(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ЗакрытьФормуИВернутьРезультат(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПодбораМатериалы(Команда)
	
	ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма",
		ПолучитьПараметрыПодбора(),
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	КоличествоСтрок = Элементы.ЦенностиОтВыбытия.ВыделенныеСтроки.Количество();
	Если КоличествоСтрок = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СкопироватьСтрокиНаСервере();
	ОбработкаТабличныхЧастейКлиент.ОповеститьОКопированииСтрокВБуферОбмена(ЭтотОбъект, КоличествоСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	КоличествоСтрок = ВставитьСтрокиНаСервере();
	ОбработкаТабличныхЧастейКлиент.ОповеститьОВставкеСтрокИзБуфераОбмена(ЭтотОбъект, КоличествоСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Заголовок = СтрШаблон(НСтр("ru = '%1: %2'"), СинонимТабличнойЧасти(), ОсновноеСредство);
	
	ВалютаДокумента = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	УстановитьОграниченияЭлементовФормыИзМетаданных();
	
	ОбновитьИтоги(ЭтотОбъект);
	
	// Проверка буфера обмена на наличие скопированных строк
	УстановитьДоступностьКомандыВставки(ЭтотОбъект, Не ОбщегоНазначения.ПустойБуферОбмена());
	
КонецПроцедуры

&НаСервере
Функция СинонимТабличнойЧасти()
	
	Возврат НСтр("ru = 'Оставшиеся материалы'");
	
КонецФункции

&НаСервере
Процедура УстановитьОграниченияЭлементовФормыИзМетаданных()
	
	ЭлементыИМетаданные = Новый Соответствие;
	
	ЭлементыИМетаданные.Вставить(Элементы.ЦенностиОтВыбытияНоменклатура,
		Метаданные.Документы.СписаниеОС.ТабличныеЧасти.ЦенностиОтВыбытия.Реквизиты.Номенклатура);
	
	ЭлементыИМетаданные.Вставить(Элементы.ЦенностиОтВыбытияКоличество,
		Метаданные.Документы.СписаниеОС.ТабличныеЧасти.ЦенностиОтВыбытия.Реквизиты.Количество);
	
	ЭлементыИМетаданные.Вставить(Элементы.ЦенностиОтВыбытияЦена,
		Метаданные.Документы.СписаниеОС.ТабличныеЧасти.ЦенностиОтВыбытия.Реквизиты.Цена);
	
	ЭлементыИМетаданные.Вставить(Элементы.ЦенностиОтВыбытияСумма,
		Метаданные.Документы.СписаниеОС.ТабличныеЧасти.ЦенностиОтВыбытия.Реквизиты.Сумма);
	
	ЭлементыИМетаданные.Вставить(Элементы.ЦенностиОтВыбытияСчетУчета,
		Метаданные.Документы.СписаниеОС.ТабличныеЧасти.ЦенностиОтВыбытия.Реквизиты.СчетУчета);
	
	РедактированиеВПодчиненныхФормах.УстановитьСвойстваЭлементовПоРеквизитамМетаданных(ЭлементыИМетаданные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытьФормуИВернутьРезультат(Истина);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ЗакрытьФормуИВернутьРезультат(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуИВернутьРезультат(ПередатьВладельцуРезультат)
	
	РезультатЗаполнения = Неопределено;
	
	Если ПередатьВладельцуРезультат Тогда
		
		Если НЕ ПроверитьЗаполнение() Тогда
			Возврат;
		КонецЕсли;
		Для Каждого Стр Из ЦенностиОтВыбытия Цикл
			Если Стр.ПрослеживаемыйТовар Тогда
				Стр.КоличествоПрослеживаемости = Стр.Количество;
			КонецЕсли;
		КонецЦикла;
		РезультатЗаполнения = Новый Структура;
		РезультатЗаполнения.Вставить("ЦенностиОтВыбытия", ЦенностиОтВыбытия);
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть(РезультатЗаполнения);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)
	
	Форма.ИтогиВсего = Форма.ЦенностиОтВыбытия.Итог("Сумма");
	
КонецПроцедуры

#Область ПоборКопированиеИВставка

&НаКлиенте
Функция ПолучитьПараметрыПодбора()
	
	ПараметрыФормы = Новый Структура;
	
	ДатаРасчетов = ?(НачалоДня(Дата) = НачалоДня(ТекущаяДата()), Неопределено, Дата);
	
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Подбор номенклатуры в ""%1""'"), СинонимТабличнойЧасти());
	
	ПараметрыФормы.Вставить("ДатаРасчетов",          ДатаРасчетов);
	ПараметрыФормы.Вставить("Склад",                 Склад);
	ПараметрыФормы.Вставить("Организация",           Организация);
	ПараметрыФормы.Вставить("Подразделение",         ПодразделениеОрганизации);
	ПараметрыФормы.Вставить("Валюта",                ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	ПараметрыФормы.Вставить("ЕстьЦена",              Ложь);
	ПараметрыФормы.Вставить("ЕстьКоличество",        Истина);
	ПараметрыФормы.Вставить("Заголовок",             ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ИмяТаблицы",            "ЦенностиОтВыбытия");
	ПараметрыФормы.Вставить("Услуги",                Ложь);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	ОбщегоНазначения.СкопироватьСтрокиВБуферОбмена(ЦенностиОтВыбытия, 
		Элементы.ЦенностиОтВыбытия.ВыделенныеСтроки);
	
КонецПроцедуры

&НаСервере
Функция ВставитьСтрокиНаСервере()
	
	ПараметрыВставки = ОбработкаТабличныхЧастей.ПолучитьПараметрыВставкиДанныхИзБуфераОбмена(Документы.СписаниеОС.ПустаяСсылка(), "ЦенностиОтВыбытия");
	ОпределитьСписокСвойствДляВставкиИзБуфера(ПараметрыВставки);
	ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ПараметрыВставки);
	
	Возврат ПараметрыВставки.КоличествоДобавленныхСтрок;
	
КонецФункции

&НаСервере
Процедура ОпределитьСписокСвойствДляВставкиИзБуфера(ПараметрыВставки)
	
	СписокСвойств = Новый Массив;
	
	СписокСвойств.Добавить("Номенклатура");
	СписокСвойств.Добавить("Количество");
	СписокСвойств.Добавить("Цена");
	СписокСвойств.Добавить("Сумма");
	
	Если ПараметрыВставки.ПоказыватьСчетаУчетаВДокументах Тогда
		СписокСвойств.Добавить("СчетУчета");
	КонецЕсли;
	
	ПараметрыВставки.СписокСвойств = ОбработкаТабличныхЧастей.ПолучитьСписокСвойствИмеющихсяВТаблицеДанных(
		ПараметрыВставки.Данные, СписокСвойств);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение)
	
	ЭтоВставкаИзБуфера = ВыбранноеЗначение.Свойство("ЭтоВставкаИзБуфера");
	СписокСвойств = Неопределено;
	Если ЭтоВставкаИзБуфера Тогда
		ТаблицаЦенностей = ВыбранноеЗначение.Данные;
		СписокСвойств = ВыбранноеЗначение.СписокСвойств;
	Иначе
		ТаблицаЦенностей = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	КонецЕсли;
	
	КоличествоДобавленныхСтрок = 0;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	ДанныеОбъекта.Вставить("СпособЗаполненияЦены", ПредопределенноеЗначение("Перечисление.СпособыЗаполненияЦен.ПоПродажнымЦенам"));
	ДанныеОбъекта.Вставить("СуммаВключаетНДС", Ложь);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаЦенностей, "Номенклатура", Истина),
		ДанныеОбъекта, Ложь);
	
	Для Каждого СтрокаТовара Из ТаблицаЦенностей Цикл
		
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТовара.Номенклатура);
		
		// Пропускаем строки с неправильным типом номенклатуры
		Если ЭтоВставкаИзБуфера 
			И СведенияОНоменклатуре <> Неопределено
			И ЗначениеЗаполнено(СведенияОНоменклатуре.Услуга)
			И СведенияОНоменклатуре.Услуга Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		СтрокаТабличнойЧасти = ЦенностиОтВыбытия.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара, СписокСвойств);
		
		Если ВедетсяУчетПрослеживаемыхТоваров Тогда
			СтрокаТабличнойЧасти.ПрослеживаемыйТовар = СведенияОНоменклатуре.ПрослеживаемыйТовар;
			СтрокаТабличнойЧасти.СтранаПроисхождения = СведенияОНоменклатуре.СтранаПроисхождения;
		Иначе
			СтрокаТабличнойЧасти.ПрослеживаемыйТовар = Ложь;
			СтрокаТабличнойЧасти.СтранаПроисхождения = Справочники.СтраныМира.ПустаяСсылка();
		КонецЕсли;

		КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок + 1;
		
		Если СтрокаТабличнойЧасти.Сумма = 0 Тогда
			
			Если ЗначениеЗаполнено(СведенияОНоменклатуре) Тогда
				Если СтрокаТабличнойЧасти.Цена = 0 Тогда
					СтрокаТабличнойЧасти.Цена = СведенияОНоменклатуре.Цена;
				КонецЕсли;
			КонецЕсли;
			
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
			
		ИначеЕсли СтрокаТабличнойЧасти.Количество <> 0 Тогда
			
			СтрокаТабличнойЧасти.Цена =  СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество;
			
		КонецЕсли;
		
		ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура,Количество,Цена,Сумма");
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
		
		ПараметрыЗаполненияСчетовУчета = НачатьЗаполнениеСчетовУчета(
			"ЦенностиОтВыбытия.Номенклатура",
			Неопределено,
			СтрокаТабличнойЧасти,
			ДанныеОбъекта,
			ДанныеСтрокиТаблицы);
		
		ЗаполненныеСчетаУчета = СчетаУчетаВДокументах.ЗаполнитьРеквизитыПриИзменении(
			Документы.СписаниеОС,
			ПараметрыЗаполненияСчетовУчета.КЗаполнению,
			ДанныеОбъекта,
			"ЦенностиОтВыбытия",
			СтрокаТабличнойЧасти);
		
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗаполненныеСчетаУчета);
		
	КонецЦикла;
	
	Если ЭтоВставкаИзБуфера Тогда
		ВыбранноеЗначение.КоличествоДобавленныхСтрок = КоличествоДобавленныхСтрок;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СчетаУчета

&НаСервере
Процедура УстановитьВидимостьСчетовУчета()
	
	ЭлементыСчетов = Новый Массив();
	ЭлементыСчетов.Добавить("ЦенностиОтВыбытияСчетУчета");
	
	СчетаУчетаВДокументах.УстановитьВидимостьСчетовУчета(Элементы, ЭлементыСчетов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НачатьЗаполнениеСчетовУчета(ПричиныИзменения, Объект = Неопределено, СтрокаСписка = Неопределено, КонтейнерОбъект = Неопределено, КонтейнерСтрокаСписка = Неопределено) Экспорт

	// Код этой функции сформирован автоматически с помощью СчетаУчетаВДокументах.КодФункцииНачатьЗаполнениеСчетовУчета()
	
	ПараметрыЗаполнения = СчетаУчетаВДокументахКлиентСервер.НовыйПараметрыЗаполнения(
		"СписаниеОС",
		ПричиныИзменения,
		Объект,
		СтрокаСписка,
		КонтейнерОбъект,
		КонтейнерСтрокаСписка);

	// 1. Заполняемые реквизиты
	// Организация
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Организация") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "ЦенностиОтВыбытия.СчетУчета");
	КонецЕсли;

	// Дата
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Дата") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "ЦенностиОтВыбытия.СчетУчета");
	КонецЕсли;

	// Склад
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Склад") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "ЦенностиОтВыбытия.СчетУчета");
	КонецЕсли;
	
	// ЦенностиОтВыбытия.Номенклатура
	Если ПараметрыЗаполнения.ПричиныИзменения.Найти("ЦенностиОтВыбытия.Номенклатура") <> Неопределено Тогда
		СчетаУчетаВДокументахКлиентСервер.НачатьЗаполнениеРеквизита(ПараметрыЗаполнения, "ЦенностиОтВыбытия.СчетУчета");
	КонецЕсли;
	
	// 2. (если требуется) Передадим на сервер данные, необходимые для заполнения
	Если ПараметрыЗаполнения.Свойство("Контейнер") Тогда
		// Организация
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Организация") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Дата");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "Номенклатура");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "СчетУчета");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Склад");
		КонецЕсли;

		// Дата
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Дата") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Дата");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "Номенклатура");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "СчетУчета");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Склад");
		КонецЕсли;

		// ЦенностиОтВыбытия.Номенклатура
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("ЦенностиОтВыбытия.Номенклатура") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "Номенклатура");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "СчетУчета");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Склад");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Дата");
		КонецЕсли;

		// Склад
		Если ПараметрыЗаполнения.ПричиныИзменения.Найти("Склад") <> Неопределено Тогда
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Склад");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Организация");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Объект", "Дата");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "Номенклатура");
			СчетаУчетаВДокументахКлиентСервер.ДополнитьДанныеЗаполнения(ПараметрыЗаполнения, "Строка", "СчетУчета");
		КонецЕсли;

	КонецЕсли; // Нужно передавать на сервер данные заполнения
	
	Возврат ПараметрыЗаполнения;

КонецФункции

#КонецОбласти

&НаСервере
Процедура ЦенностиОтВыбытияНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта, Знач СчетаУчетаКЗаполнению)
	
	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта, Ложь, Истина);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Цена <> 0 Тогда
		СтрокаТабличнойЧасти.Цена = СведенияОНоменклатуре.Цена;
	КонецЕсли;
	
	Если ДанныеОбъекта.ВедетсяУчетПрослеживаемыхТоваров Тогда
		СтрокаТабличнойЧасти.ПрослеживаемыйТовар = СведенияОНоменклатуре.ПрослеживаемыйТовар;
		СтрокаТабличнойЧасти.СтранаПроисхождения = СведенияОНоменклатуре.СтранаПроисхождения;
	КонецЕсли;
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	
	ЗаполненныеСчетаУчета = СчетаУчетаВДокументах.ЗаполнитьРеквизитыПриИзменении(
		Документы.СписаниеОС,
		СчетаУчетаКЗаполнению,
		ДанныеОбъекта,
		"ЦенностиОтВыбытия",
		СтрокаТабличнойЧасти);
	
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗаполненныеСчетаУчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандыВставки(Форма, Доступность)
	
	Доступность = Не Форма.ТолькоПросмотр И Доступность;
	Элементы = Форма.Элементы;
	Элементы.ЦенностиОтВыбытияВставитьСтроки.Доступность = Доступность;
	Элементы.ЦенностиОтВыбытияЗаполнитьПрослеживаемымиМатериалами.Видимость = Форма.ВедетсяУчетпрослеживаемыхТоваров;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрослеживаемымиМатериаламиНаСервере()
	Если СведенияПрослеживаемости.Количество() > 0 Тогда
		Результат = СведенияПрослеживаемости;
	Иначе
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПрослеживаемыеОСОстатки.РНПТ КАК РНПТ,
		|	ПрослеживаемыеОСОстатки.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ПрослеживаемыеОСОстатки.Комплектующие КАК Номенклатура,
		|	ПрослеживаемыеОСОстатки.КоличествоОстаток КАК Количество,
		|	ИСТИНА КАК ПрослеживаемыйТовар
		|ИЗ
		|	РегистрНакопления.ПрослеживаемыеОсновныеСредства.Остатки(
		|			&Дата,
		|			Организация = &Организация
		|				И ОсновноеСредство = &ОС) КАК ПрослеживаемыеОСОстатки";
		
		Запрос.УстановитьПараметр("Организация",    Организация);
		Запрос.УстановитьПараметр("ОС",             ОсновноеСредство);
		Запрос.УстановитьПараметр("Дата",           Новый Граница(Дата, ВидГраницы.Исключая));
		Результат = Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	Для Каждого Стр Из Результат Цикл
		НоваяСтрока = ЦенностиОтВыбытия.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
		Если ЗначениеЗаполнено(НоваяСтрока.Номенклатура) Тогда
			НоваяСтрока.ПрослеживаемыйТовар = Истина;
			ДанныеСтрокиТаблицы = Новый Структура(
			"Номенклатура,Количество,Цена,Сумма");
			ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, НоваяСтрока);
			
			ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
			ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
			ДанныеОбъекта.Вставить("СпособЗаполненияЦены", ПредопределенноеЗначение("Перечисление.СпособыЗаполненияЦен.ПоПродажнымЦенам"));
			ДанныеОбъекта.Вставить("СуммаВключаетНДС", Ложь);
			
			ПараметрыЗаполненияСчетовУчета = НачатьЗаполнениеСчетовУчета(
			"ЦенностиОтВыбытия.Номенклатура",
			Неопределено,
			НоваяСтрока,
			ДанныеОбъекта,
			ДанныеСтрокиТаблицы);
			
			ЗаполненныеСчетаУчета = СчетаУчетаВДокументах.ЗаполнитьРеквизитыПриИзменении(
			Документы.СписаниеОС,
			ПараметрыЗаполненияСчетовУчета.КЗаполнению,
			ДанныеОбъекта,
			"ЦенностиОтВыбытия",
			НоваяСтрока);
			НоваяСтрока.СчетУчета = ЗаполненныеСчетаУчета.СчетУчета;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПрослеживаемымиМатериалами(Команда)
	ЗаполнитьПрослеживаемымиМатериаламиНаСервере();
КонецПроцедуры

#КонецОбласти

