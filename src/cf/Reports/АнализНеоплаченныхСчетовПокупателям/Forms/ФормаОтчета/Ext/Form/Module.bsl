﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем УИДЗамера;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если НЕ ИспользуетсяНесколькоОрганизаций Тогда
		Элементы.ГруппаБыстрыеОтборы.Видимость = Ложь;
	КонецЕсли;
	
	БыстрыеНастройкиОтчетовСервер.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если НЕ ИнформационнаяБазаФайловая Тогда
		
		Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		ИначеЕсли НЕ Отчет.РежимРасшифровки Тогда
			ПодключитьОбработчикОжидания("Подключаемый_СформироватьПриОткрытии", БухгалтерскиеОтчетыКлиент.ИнтервалЗапускаФормированияОтчетаПриОткрытии(), Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Отчет.РежимРасшифровки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки, ИспользуютсяСтандартныеНастройки)
	
	Если ИспользуютсяСтандартныеНастройки Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервереВОтчетеРуководителю(ЭтотОбъект, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если ИнформационнаяБазаФайловая Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
	
	Если Отчет.ДополнительныеПоля.Количество() = 0 Тогда
	
		ПолеНомерТелефона               = Отчет.ДополнительныеПоля.Добавить();
		ПолеНомерТелефона.Представление = "Номер телефона";
		ПолеНомерТелефона.Поле          = "НомерТелефона";
		ПолеНомерТелефона.Использование = Истина;
		
		ПолеАдресЭлектроннойПочты               = Отчет.ДополнительныеПоля.Добавить();
		ПолеАдресЭлектроннойПочты.Представление = "Электронная почта";
		ПолеАдресЭлектроннойПочты.Поле          = "ЭлектроннаяПочта";
		ПолеАдресЭлектроннойПочты.Использование = Истина;
		
		ПолеСуммаВВалюте               = Отчет.ДополнительныеПоля.Добавить();
		ПолеСуммаВВалюте.Представление = "Сумма счета в валюте";
		ПолеСуммаВВалюте.Поле          = "СуммаВВалюте";
		ПолеСуммаВВалюте.Использование = Ложь;
		
		ПолеСуммаОплатыВВалюте               = Отчет.ДополнительныеПоля.Добавить();
		ПолеСуммаОплатыВВалюте.Представление = "Оплачено в валюте";
		ПолеСуммаОплатыВВалюте.Поле          = "СуммаОплатыВВалюте";
		ПолеСуммаОплатыВВалюте.Использование = Ложь;
		
		ПолеОжидаетсяОплатаВВалюте               = Отчет.ДополнительныеПоля.Добавить();
		ПолеОжидаетсяОплатаВВалюте.Представление = "Ожидается оплата в валюте";
		ПолеОжидаетсяОплатаВВалюте.Поле          = "ОжидаетсяОплатаВВалюте";
		ПолеОжидаетсяОплатаВВалюте.Использование = Ложь;
		
		ПолеВалюта               = Отчет.ДополнительныеПоля.Добавить();
		ПолеВалюта.Представление = "Валюта";
		ПолеВалюта.Поле          = "ВалютаДокумента";
		ПолеВалюта.Использование = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.РассылкиОтчетов.Форма.НастройкаРассылкиБП" Тогда
		ОбработкаНастройкиРассылкиОтчета(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация,
		Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
		СоответствиеОрганизаций, Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложениеПоделитьсяМнениемОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьОтзывПоЭлектроннойПочте", ЭтотОбъект);
	РаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);

КонецПроцедуры

#Область ОбработчикиСобытийЭлементовБыстрогоОформления

&НаКлиенте
Процедура МакетОформленияБыстрыеНастройкиПриИзменении(Элемент)
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки,
		"МакетОформления", МакетОформления);
	
	ПриИзмененииНастройки();

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокБыстрыеНастройкиПриИзменении(Элемент)
	
	ПриИзмененииНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалБыстрыеНастройкиПриИзменении(Элемент)
	
	ПриИзмененииНастройки();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтборы

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Ложь);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора,
		СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеПоля

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ЭтаФорма.ТекущийЭлемент = Элементы.ДополнительныеПоля;
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ,
		Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСортировка

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУсловноеОформление

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки,
		"МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПоляРезультат

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторОбъекта = БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма);
	ПараметрыРасшифровки = БухгалтерскиеОтчетыВызовСервера.ПолучитьПараметрыРасшифровкиОтчета(ЭтаФорма.ДанныеРасшифровки,
		ИдентификаторОбъекта,
		Расшифровка);
	
	Если ПараметрыРасшифровки.Свойство("Значение")
		И ТипЗнч(ПараметрыРасшифровки.Значение) = Тип("Структура")
		И ПараметрыРасшифровки.Значение.Свойство("ЭлектроннаяПочта")
		И ЗначениеЗаполнено(ПараметрыРасшифровки.Значение.ЭлектроннаяПочта) Тогда
		
		АдресаЭлектроннойПочты = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(ПараметрыРасшифровки.Значение.ЭлектроннаяПочта);
		
		АдресаПолучателей = "";
		Для Каждого АдресЭлектроннойПочты Из АдресаЭлектроннойПочты Цикл
			Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭлектроннойПочты.Адрес) Тогда
				АдресаПолучателей = АдресаПолучателей + АдресЭлектроннойПочты.Адрес + "; ";
			КонецЕсли;
		КонецЦикла;
		
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ФормированиеПисьмаОтчетАнализНеоплаченныхСчетовПокупателям");
		
		ПараметрыПисьма = ПодготовитьПараметрыЭлектронногоПисьма(ПараметрыРасшифровки.Значение, АдресаПолучателей);
		
		Если ЗначениеЗаполнено(ПараметрыПисьма) Тогда
			РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыПисьма);
		КонецЕсли;
	Иначе
		БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизации(Элемент)
	
	БухгалтерскиеОтчетыКлиент.НачатьРасчетСуммыВыделенныхЯчеек(
		Элементы.Результат,
		ЭтотОбъект,
		"Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтчетСохранитьКак(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	ОтправкаПочтовыхСообщенийКлиент.ОтправитьОтчет(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ОткрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ИдентификаторПечатнойФормы = "ПечатнаяФорма";
	НазваниеПечатнойФормы = НСтр("ru='Анализ неоплаченных счетов покупателям'");
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета         = НазваниеПечатнойФормы;
	ПечатнаяФорма.ТабличныйДокумент     = Результат;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НазваниеПечатнойФормы;
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРассылкуОтчета(Команда)
	
	ЗаполнитьНастройкиОтчетаДляРассылки();
	
	РассылкаОтчетовБПКлиент.НастроитьРассылкуИзОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьБыстрыеНастройки(Команда)
	
	БыстрыеНастройкиОтчетовКлиент.ПереключитьВидимостьБыстрыхНастроек(ЭтотОбъект);

	Если ПоказыватьБыстрыеНастройки Тогда 
		ПоказатьБыстрыеНастройкиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьПараметрыЭлектронногоПисьма(Расшифровка, Получатель)
	
	СчетНаОплату = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Расшифровка, "СчетНаОплату");
	НомерСчета = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Расшифровка, "Номер", "");
	ДатаСчета = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Расшифровка, "Дата", Дата(1,1,1));
	СуммаВВалюте = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Расшифровка, "СуммаВВалюте", 0);
	ОплаченоПоСчету = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Расшифровка, "СуммаОплатыВВалюте", 0);
	ОжидаетсяОплата = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Расшифровка, "ОжидаетсяОплатаВВалюте", 0);
	
	// Если отключена ФО "ИспользоватьВалютныйУчет", поле "ВалютаДокумента" будет отсутствовать в расшифровке.
	// В таком случае используем валюту регламентированного учета.
	ВалютаДокумента = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Расшифровка, "ВалютаДокумента", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
	Если НЕ ЗначениеЗаполнено(СчетНаОплату) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СчетНаОплату);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УпаковатьВАрхив",   Ложь);
	ДополнительныеПараметры.Вставить("ФорматыСохранения", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		СтандартныеПодсистемыСервер.ТипФайлаТабличногоДокументаPDF()));
	
	ПечатныеФормы = УправлениеПечатью.СформироватьПечатныеФормыДляБыстройПечати(
		"Обработка.ПечатьСчетаНаОплату", "СчетЗаказ", МассивДокументов, Новый Структура);
	
	Если ПечатныеФормы.ПараметрыВывода.Свойство("ФормироватьЭД") Тогда
		ПечатныеФормы.ПараметрыВывода.ФормироватьЭД = Ложь;
	КонецЕсли;
	
	ПараметрыПисьма = ОтправкаПочтовыхСообщений.ПараметрыЭлектронногоПисьма(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПечатныеФормы), "", ДополнительныеПараметры);
	
	ПараметрыПисьма.Тема = НСтр("ru='Напоминание об оплате'") + Сред(ПараметрыПисьма.Тема, 10);
	
	Если ОплаченоПоСчету <> 0 Тогда
		ШаблонТекстаПисьма = 
			НСтр("ru='Уважаемый покупатель!
			|Напоминаем, что у Вас есть неоплаченный счет № %1 от %2 на сумму %3 %4 (оплачено %5 %6, ожидается оплата %7 %8)
			|Просим оплатить счет или сообщить об отказе от оплаты счета.'");
		ТекстПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаПисьма,
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(НомерСчета, Истина, Ложь),
			Формат(ДатаСчета, "ДЛФ=DD"),
			СуммаВВалюте, ВалютаДокумента,
			ОплаченоПоСчету, ВалютаДокумента,
			ОжидаетсяОплата, ВалютаДокумента);
	Иначе
		ШаблонТекстаПисьма = 
			НСтр("ru='Уважаемый покупатель!
			|Напоминаем, что у Вас есть неоплаченный счет № %1 от %2 на сумму %3 %4
			|Просим оплатить счет или сообщить об отказе от оплаты счета.'");
		ТекстПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаПисьма,
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(НомерСчета, Истина, Ложь),
			Формат(ДатаСчета, "ДЛФ=DD"), СуммаВВалюте, ВалютаДокумента);
	КонецЕсли;
	
	ПараметрыПисьма.Получатель = Получатель;
	ПараметрыПисьма.Текст      = ОтправкаПочтовыхСообщений.ПодготовитьТекстПисьма(ТекстПисьма);
	
	ОтправкаПочтовыхСообщений.ДополнитьПараметрыПисьма(ПараметрыПисьма);
	
	Возврат ПараметрыПисьма;
	
КонецФункции

&НаКлиенте
Процедура ЗафиксироватьДлительностьКлючевойОперации()
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	МенеджерОтчета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ЭтотОбъект.ИмяФормы);
	
	ПараметрыОтчета = МенеджерОтчета.ПустыеПараметрыКомпоновкиОтчета();
	
	ПараметрыОтчета.Организация                       = Отчет.Организация;
	ПараметрыОтчета.ВключатьОбособленныеПодразделения = Отчет.ВключатьОбособленныеПодразделения;
	ПараметрыОтчета.РазмещениеДополнительныхПолей     = Отчет.РазмещениеДополнительныхПолей;
	ПараметрыОтчета.ДополнительныеПоля                = Отчет.ДополнительныеПоля.Выгрузить();
	
	ПараметрыОтчета.ВыводитьЗаголовок                 = ВыводитьЗаголовок;
	ПараметрыОтчета.ВыводитьПодвал                    = ВыводитьПодвал;
	ПараметрыОтчета.МакетОформления                   = МакетОформления;
	ПараметрыОтчета.РежимРасшифровки                  = Отчет.РежимРасшифровки;
	ПараметрыОтчета.ДанныеРасшифровки                 = ДанныеРасшифровки;
	ПараметрыОтчета.СхемаКомпоновкиДанных             = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	ПараметрыОтчета.ИдентификаторОтчета               = БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтотОбъект);
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = НСтр("ru='Счета, не оплаченные покупателями'");
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(
			Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Сумма");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Режим = "Выбор" И ЭтаФорма.ТекущийЭлемент = Элементы.ДополнительныеПоля Тогда
		СписокПолей.Добавить("Дата");
		СписокПолей.Добавить("СчетНаОплату");
		СписокПолей.Добавить("Организация");
		СписокПолей.Добавить("Подразделение");
	КонецЕсли;
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" Тогда
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	БухгалтерскиеОтчеты.ЗаписатьОперациюБизнесСтатистики(ЭтотОбъект, "СформироватьОтчет", НастройкиОтчетаДляСтатистики());
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Настройки = Отчет.КомпоновщикНастроек.Настройки;
	Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = ""; 
	Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	Если ИнформационнаяБазаФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат           = РезультатВыполнения.Результат;
	ДанныеРасшифровки   = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанныеНаСервере();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
			ЗафиксироватьДлительностьКлючевойОперации();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, Элементы.Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
	// Обновим панель быстрых настроек, если она видна
	Если ПоказыватьБыстрыеНастройки Тогда
		ПоказатьБыстрыеНастройкиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация", Отчет.Организация);
	СписокПараметров.Вставить("Контрагент" , Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_СформироватьПриОткрытии()
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФормированиеОтчета()
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "ФормированиеОтчетаАнализНеоплаченныхСчетовПокупателям");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	Иначе
		ЗафиксироватьДлительностьКлючевойОперации();
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		СкрытьНастройки();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаНастройкиРассылкиОтчета(ВыбранноеЗначение)
	
	РассылкаОтчетовБП.ФормаОтчетаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиОтчетаДляРассылки()
	
	РассылкаОтчетовБП.ЗаполнитьНастройкиОтчетаДляРассылки(ЭтотОбъект);
	
КонецПроцедуры

#Область БизнесСтатистика

&НаСервере
Функция НастройкиОтчетаДляСтатистики()
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	НастройкиДляСтатистики = БухгалтерскиеОтчеты.ПоказателиОтчетаРуководителяДляСтатистики(ПараметрыОтчета);
	
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет);
	
	Возврат ОбщегоНазначенияБП.ЗначениеВСтрокуJSON(НастройкиДляСтатистики, ПараметрыЗаписиJSON);
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПоказатьБыстрыеНастройкиНаСервере()
	
	ГруппыНастроек = Новый Структура;
	ГруппыНастроек.Вставить("Отбор", Элементы.БыстрыеОтборы);
	ГруппыНастроек.Вставить("Оформление", Элементы.БыстроеОформление);
	
	БыстрыеНастройкиОтчетовСервер.ПоказатьБыстрыеНастройкиНаСервере(ЭтотОбъект, ГруппыНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОчисткаОтбора(Элемент)
	
	Если Не СоответствиеПолейОтчетаИРеквизитов.Свойство(Элемент.Имя) Тогда
		Возврат;
	КонецЕсли;

	ИмяРеквизита = Элемент.Имя;
	ОчиститьОтборНаСервере(ИмяРеквизита);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьОтборПриИзменении(Элемент)
	
	Если Не СоответствиеПолейОтчетаИРеквизитов.Свойство(Элемент.Имя) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизита = Элемент.Имя;
	УстановитьОтборПриИзмененииНаСервере(ИмяРеквизита);

	ПриИзмененииНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БыстрыеНастройкиОтчетовКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора,
		СтандартнаяОбработка, СписокПараметров);

КонецПроцедуры

&НаСервере
Процедура ОчиститьОтборНаСервере(ИмяРеквизита)
	
	БыстрыеНастройкиОтчетовСервер.ОчиститьОтборНаСервере(ЭтотОбъект, ИмяРеквизита);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПриИзмененииНаСервере(ИмяРеквизита)

	ГруппыНастроек = Новый Структура;
	ГруппыНастроек.Вставить("Отбор", Элементы.БыстрыеОтборы);
	
	БыстрыеНастройкиОтчетовСервер.УстановитьОтборПриИзмененииНаСервере(ЭтотОбъект, ГруппыНастроек, ИмяРеквизита);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНастройки()

	Если Отчет.ФормироватьОтчетПриИзмененииНастроек Тогда
		ЗапуститьФормированиеОтчета();
	Иначе
		Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#Область ОбратнаяСвязь

&НаКлиенте
Процедура ОтправитьОтзывПоЭлектроннойПочте(УчетнаяЗаписьНастроена, ДополнительныеПараметры) Экспорт
	
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	БыстрыеНастройкиОтчетовКлиент.ОтправитьОтзывПоЭлектроннойПочте();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
