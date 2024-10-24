﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресКлючейПоказателей = Параметры.АдресКлючейПоказателей;
	
	Если Параметры.Свойство("СтруктураДоходовВычетов") 
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов)
		И Параметры.СтруктураДоходовВычетов.Свойство("ДанныеФормы")
		И ЗначениеЗаполнено(Параметры.СтруктураДоходовВычетов.ДанныеФормы) Тогда
		ЗаполнитьФормуИзДанных(Параметры.СтруктураДоходовВычетов.ДанныеФормы);
	Иначе
		ЗаполнитьНовуюФорму();
	КонецЕсли;
	
	НалоговаяСтавка = Обработки.ПомощникЗаполнения3НДФЛ.СтавкаНалога(Параметры.Декларация3НДФЛВыбраннаяФорма);
	
	КодыВидовДоходовРФ = Отчеты.РегламентированныйОтчет3НДФЛ.КодыВидовДоходовРФ(Параметры.Декларация3НДФЛВыбраннаяФорма);
	
	ПомощникЗаполнения3НДФЛ.ИсточникДоходовПриСозданииНаСервере(ЭтотОбъект);
	
	УправлениеФормойПриСозданииНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ПомощникЗаполнения3НДФЛ.ПроверитьЗаполнениеРеквизитовИсточникаДоходов(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	ОрганизацииФормыДляОтчетности.ПроверитьКодПоОКТМОНаФорме(ОКТМО, "ОКТМО", Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаДоходаПриИзменении(Элемент)
	
	НалоговаяБаза = СуммаДохода;
	НалогУдержанный = НалогИсчисленный();
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговаяБазаПриИзменении(Элемент)
	
	НалогУдержанный = НалогИсчисленный();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидКонтрагентаПриИзменении(Элемент)
	
	// Очистим реквизиты, которые зависят от вида контрагента.
	Наименование = "";
	ФИО = "";
	ИНН = "";
	КПП = "";
	ОКТМО = "";
	
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Истина);
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьВидимостьПолейКонтрагента(ЭтотОбъект);
	УстановитьКлючСохраненияПоложенияОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаИНННаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПолеПоискаИНННаименование)
		И НЕ ЗначениеЗаполнено(ИНН) 
		И НЕ ЗначениеЗаполнено(Наименование) Тогда
		
		ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
		ОтключитьЗаполнениеПоИНН = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ВключитьЗаполнениеПоИНН", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ИНН = СокрП(ИНН);
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	КПП = СокрП(КПП);
	ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаполнитьПоИНН(Команда)
	
	Если НЕ ЗначениеЗаполнено(ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""ИНН"" не заполнено'"));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	ИначеЕсли НЕ ОшибокПоИННнет Тогда
		ПоказатьПредупреждение(, Строка(РезультатПроверкиИНН));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	КонецЕсли;
	
	ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоИНН(ИНН, ОповещениеПослеЗаполненияПоИНН());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоДаннымЕГР(Команда)
	
	ПомощникЗаполнения3НДФЛКлиент.ЗаполнитьРеквизитыПоДаннымЕГР(ПолеПоискаИНННаименование, ОповещениеПослеЗаполненияПоИНН());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованию(Команда)
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""Наименование"" не заполнено'"));
		ТекущийЭлемент = Элементы.Наименование;
	Иначе
		ПомощникЗаполнения3НДФЛКлиент.ВыполнитьЗаполнениеРеквизитовПоНаименованию(Наименование, ОповещениеПослеЗаполненияПоИНН());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура;
	
	// Информация для формы помощника.
	СтруктураРезультата.Вставить("Вид", ПредопределенноеЗначение("Перечисление.ИсточникиДоходовФизическихЛиц.ОплатаТруда"));
	НаименованиеКонтрагента = ?(ВидКонтрагента = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо"),
		ФИО,
		Наименование);
	СтруктураРезультата.Вставить("Информация", СтрШаблон(НСтр("ru='Оплата труда - %1'"), НаименованиеКонтрагента));
	СтруктураРезультата.Вставить("СуммаДохода", СуммаДохода);
	
	Если КодыВидовДоходовРФ.Свойство("ИнойДоходПоПрогрессивнойШкале") Тогда
		КодВидаДохода = КодыВидовДоходовРФ.ИнойДоходПоПрогрессивнойШкале;
	Иначе
		КодВидаДохода = ?(НалогУдержанный < НалогИсчисленный(),
			КодыВидовДоходовРФ.ОплатаТрудаНалогНеУдержанАгентом,
			КодыВидовДоходовРФ.ОплатаТруда);
	КонецЕсли;
	
	// Данные для отчетности.
	ДанныеОтчетности = Новый Структура;
	ДанныеОтчетности.Вставить("КодВидаДохода", КодВидаДохода);
	ДанныеОтчетности.Вставить("СуммаДохода", СуммаДохода);
	ДанныеОтчетности.Вставить("НалоговаяБаза", НалоговаяБаза);
	ДанныеОтчетности.Вставить("СуммаНалога", НалогУдержанный);
	ДанныеОтчетности.Вставить("ВидКонтрагента", ВидКонтрагента);
	ДанныеОтчетности.Вставить("Наименование", НаименованиеКонтрагента);
	ДанныеОтчетности.Вставить("ФИО", ФИО);
	ДанныеОтчетности.Вставить("ИНН", ИНН);
	ДанныеОтчетности.Вставить("КПП", КПП);
	ДанныеОтчетности.Вставить("ОКТМО", ОКТМО);
	СтруктураРезультата.Вставить("ДанныеОтчетности", ДанныеОтчетности);
	
	// Данные формы для восстановления.
	СтруктураДанныхФормы = Новый Структура;
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		СтруктураДанныхФормы.Вставить(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	СтруктураРезультата.Вставить("ДанныеФормы", СтруктураДанныхФормы);
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормойПриСозданииНаСервере()
	
	Элементы.ФормаКомандаОК.Доступность = Не ТолькоПросмотр;
	Элементы.ЗаполнитьРеквизитыПоДаннымЕГР.Доступность = Не ТолькоПросмотр;
	Элементы.КнопкаЗаполнитьРеквизитыПоНаименованию.Доступность = Не ТолькоПросмотр;
	Элементы.КомандаЗаполнитьПоИНН.Доступность = Не ТолькоПросмотр;
	
	Элементы.РасчетСуммыНалога.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.ГруппаРеквизитыИсточникаДохода.ТолькоПросмотр = ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.НалоговаяБаза.Видимость = ЕстьКлючПоказателя("СуммаОблагаемогоДоходаРФ", Форма.АдресКлючейПоказателей);
	
КонецПроцедуры

&НаКлиенте
Функция НалогИсчисленный()
	
	Возврат Окр(НалоговаяБаза * НалоговаяСтавка / 100, 0);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьФормуИзДанных(ДанныеФормы)
	
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		ДанныеФормы.Свойство(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	Если Не ДанныеФормы.Свойство("НалоговаяБаза")
		Или Не ЕстьКлючПоказателя("СуммаОблагаемогоДоходаРФ", АдресКлючейПоказателей) Тогда
		НалоговаяБаза = СуммаДохода;
	КонецЕсли;
	
	ЗаполнениеРеквизитовПлашкой = НЕ ЗначениеЗаполнено(СуммаДохода);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНовуюФорму()
	
	ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	ЗаполнениеРеквизитовПлашкой = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКлючСохраненияПоложенияОкна(Форма)
	
	ПрефиксКлючаСохранения = "";
	
	ПомощникЗаполнения3НДФЛКлиентСервер.УстановитьКлючСохраненияПоложенияОкна(Форма, ПрефиксКлючаСохранения);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивРеквизитовФормы()
	
	Массив = Новый Массив;
	Массив.Добавить("СуммаДохода");
	Массив.Добавить("НалоговаяБаза");
	Массив.Добавить("НалогУдержанный");
	Массив.Добавить("ВидКонтрагента");
	Массив.Добавить("ФИО");
	Массив.Добавить("Наименование");
	Массив.Добавить("ИНН");
	Массив.Добавить("КПП");
	Массив.Добавить("ОКТМО");
	
	Возврат Массив;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьКлючПоказателя(Знач ИмяКлюча, Знач АдресКлючейПоказателей)
	
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.ЕстьКлючПоказателя(ИмяКлюча, АдресКлючейПоказателей);
	
КонецФункции

#Область ЗаполнениеРеквизитовКонтрагента

&НаКлиенте
Функция ОповещениеПослеЗаполненияПоИНН()
	
	Возврат Новый ОписаниеОповещения("ПослеЗаполненияПоИНН", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаполненияПоИНН(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
		ПомощникЗаполнения3НДФЛКлиентСервер.ПроверитьИННКПП(ЭтотОбъект, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключитьЗаполнениеПоИНН()
	
	ОтключитьЗаполнениеПоИНН = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
