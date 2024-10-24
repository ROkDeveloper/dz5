﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КонтролируемыеСделки.ЗаполнитьСписокГоловныхОрганизаций(Элементы.Организация.СписокВыбора);
	
	Если Параметры.Свойство("Уведомление") И ЗначениеЗаполнено(Параметры.Уведомление) Тогда
		СвойстваУведомления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Уведомление, "Организация, ОтчетныйГод");
		Объект.Организация = СвойстваУведомления.Организация;
		Объект.ОтчетныйГод = Год(СвойстваУведомления.ОтчетныйГод);
		Объект.Уведомление = Параметры.Уведомление;
		ОбновитьУведомление();
	Иначе
		Если Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) Тогда
			Объект.Организация = Параметры.Организация;
		Иначе
			Объект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		КонецЕсли;
		НайтиУведомление("Последний");
	КонецЕсли;
	
	ОбновитьНастройкиФормированияУведомления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Подключаемый_ПодключитьРасширениеРаботыСФайлами", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_УведомлениеОКонтролируемыхСделках"
		И Источник = Объект.Уведомление Тогда
		ОбновитьУведомление();
	ИначеЕсли ИмяСобытия = "Запись_НастройкиФормированияУведомления" Тогда;
		ОбновитьНастройкиФормированияУведомления();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	НомерКорректировки 	= 0;
	ТипУведомления 		= 0;
	НайтиУведомление("Последний");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйГодПриИзменении(Элемент)
	
	НомерКорректировки 	= 0;
	ТипУведомления 		= 0;
	НайтиУведомление("Последний");
	
КонецПроцедуры

&НаКлиенте
Процедура ТипУведомленияПриИзменении(Элемент)
	
	НомерКорректировки = ?(ТипУведомления = 0, 0, ?(НомерКорректировки = 0,1,НомерКорректировки));
	НайтиУведомление("Указанный");
	
КонецПроцедуры

&НаКлиенте
Процедура НомерКорректировкиПриИзменении(Элемент)
	
	НайтиУведомление("Указанный");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСведенияОбОрганизацииНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура("Организация, ОтчетныйГод", Объект.Организация, Объект.ОтчетныйГод);
	ОткрытьФорму("Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.Форма.ФормаСведенияОбОрганизации", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетНастройкиКонтрагентовНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("КлючВарианта, Уведомление", "ДанныеКонтрагентов", Объект.Уведомление);
	ОткрытьФорму("Отчет.КонтрагентыКонтролируемыхСделок.Форма.ФормаОтчетаКонтрагенты", ПараметрыОткрытия, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСписокКонтролируемыхСделокНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Уведомление, КлючВарианта", Объект.Уведомление,  "КонтролируемыеСделкиДляВключенияВУведомление");
	ОткрытьФорму("Отчет.КонтролируемыеСделкиДляВключенияВУведомление.Форма.ФормаОтчета", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСписокПрочихКонтролируемыхСделокНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыФормы=Новый Структура; 
	ПараметрыФормы.Вставить("Отбор", Новый Структура("УведомлениеОКонтролируемойСделке", Объект.Уведомление));
	ПараметрыФормы.Вставить("УведомлениеОКонтролируемыхСделках", Объект.Уведомление);
	ОткрытьФорму("Документ.ПрочиеКонтролируемыеСделки.ФормаСписка", ПараметрыФормы, , Объект.Уведомление);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСведенияОВзаимозависимыхЛицахНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("КлючВарианта, Уведомление", "ВзаимозависимыеЛицаКонтролируемыхСделок", Объект.Уведомление);
	ОткрытьФорму("Отчет.ВзаимозависимыеЛицаКонтролируемыхСделок.Форма.ВзаимозависимыеЛица", ПараметрыОткрытия, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьУведомление(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	Если Объект.Уведомление <> ПредопределенноеЗначение("Документ.УведомлениеОКонтролируемыхСделках.ПустаяСсылка") Тогда
		ТекстВопроса = НСтр("ru = 'Заполнение уведомления может занять значительное время%ОчисткаУведомления%
			|Продолжить?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ОчисткаУведомления%",
			?(УведомлениеЗаполнено, НСтр("ru = ',
			|существующие листы 1А при заполнении будут помечены на удаление.'"), НСтр("ru = '.'")));
			
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнениеУведомленийЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСоставУведомленияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыФормы=Новый Структура; 
	ПараметрыФормы.Вставить("Отбор", Новый Структура("УведомлениеОКонтролируемойСделке", Объект.Уведомление));
	ПараметрыФормы.Вставить("УведомлениеОКонтролируемыхСделках", Объект.Уведомление);
	ОткрытьФорму("Документ.КонтролируемаяСделка.ФормаСписка", ПараметрыФормы, , Объект.Уведомление);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияАнализУведомленияНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("КлючВарианта, Уведомление", "АнализУведомления", Объект.Уведомление);
	ОткрытьФорму("Отчет.АнализУведомления.Форма.ФормаОтчета", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиПредметовНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	КлючВарианта = КлючВариантаОтчетаПредметыСделок(Объект.Уведомление);
	
	ПараметрыОткрытия = Новый Структура("КлючВарианта, Уведомление", КлючВарианта, Объект.Уведомление);
	ОткрытьФорму("Отчет.ПредметыКонтролируемыхСделок.Форма.ФормаОтчетаПредметы", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВзаимозависимыеЛицаНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура("Организация, ОтчетныйГод", Объект.Организация, Объект.ОтчетныйГод);
	ОткрытьФорму("Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.Форма.ФормаВзаимозависимыеЛица", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСведенияГраницахВключенияНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("ОтчетныйГод", Объект.ОтчетныйГод);
	ПараметрыОткрытия.Вставить("Уведомление", Объект.Уведомление);
	ОткрытьФорму("Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.Форма.ФормаГраницыВключенияСделок", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСписокСделокНажатие(Элемент)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("КлючВарианта, Уведомление", "КонтролируемыеСделки", Объект.Уведомление);
	ОткрытьФорму("Отчет.СписокКонтролируемыхСделок.Форма.ФормаОтчетаКонтролируемыеСделки", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстНастройкиЗаполненияУведомленияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура("Уведомление", Объект.Уведомление);
	ОткрытьФорму("Документ.УведомлениеОКонтролируемыхСделках.Форма.НастройкиЗаполнения", ПараметрыОткрытияФормы, ЭтотОбъект, Объект.Уведомление);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстНастройкиФормированияСпискаСделокНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура("Уведомление", Объект.Уведомление);
	ОткрытьФорму("РегистрСведений.НастройкиФормированияКонтролируемыхСделок.Форма.НастройкиФормированияСпискаСделок", ПараметрыОткрытияФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаполнитьСписокСделок(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	Если Объект.Уведомление <> ПредопределенноеЗначение("Документ.УведомлениеОКонтролируемыхСделках.ПустаяСсылка") Тогда
		ТекстВопроса = НСтр("ru = 'Заполнение списка сделок может занять длительное время%ОчисткаСпискаСделок%
			|Продолжить?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ОчисткаСпискаСделок%",
			?(СделкиСуществуют, НСтр("ru = ',
			|существующие данные о сделках при заполнении будут очищены.'"), НСтр("ru = '.'")));
			
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполненияСделокЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПечатьУведомленияОКонтролируемыхСделках(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Уведомление) Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыПечати = Новый Структура("Уведомление", Объект.Уведомление);
	ОткрытьФорму("Документ.УведомлениеОКонтролируемыхСделках.Форма.ФормаПечатиУведомления", ПараметрыПечати, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПроверитьЗаполнение(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	РезультатВыполнения = ПроверитьЗаполнениеНаСервере(Объект.Уведомление, УникальныйИдентификатор);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Объект.Уведомление);
	ПараметрыФормы.Вставить("АдресХранилища", РезультатВыполнения.АдресХранилища);
	
	ОткрытьФорму("Документ.УведомлениеОКонтролируемыхСделках.Форма.ФормаОшибок", ПараметрыФормы, ЭтотОбъект, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузить(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Уведомление) Тогда
		СоздатьУведомление();
		Оповестить("Запись_УведомлениеОКонтролируемыхСделках", Неопределено, Объект.Уведомление);
	КонецЕсли;
	
	Если НЕ НомераКонтролируемыхСделокКорректны(Объект.Уведомление) Тогда
		ТекстВопроса = Нстр("ru = 'Нумерация листов 1А не корректна.#РазделительСтрок#Перенумеровать листы 1А?#РазделительСтрок#(операция может занять продолжительное время)'");
		Оповещение = Новый ОписаниеОповещения("ВопросПеренумероватьЛисты1АЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, СтрЗаменить(ТекстВопроса, "#РазделительСтрок#", Символы.ПС), РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыгрузитьУведомление();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьДанныеАвтоматическогоЗаполненияНаСервере()
	
	Документы.УведомлениеОКонтролируемыхСделках.ПодготовитьДанныеАвтоматическогоЗаполнения(Объект.Уведомление);
	НайтиУведомление(Истина);
	
КонецПроцедуры

&НаСервере
Функция НачатьЗаполнениеУведомленияНаСервере()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Заполнение уведомления о контролируемых сделках'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Уведомление", Объект.Уведомление);
	ПараметрыПроцедуры.Вставить("СообщатьОПрогрессе", Истина);
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне("Документы.УведомлениеОКонтролируемыхСделках.СформироватьКонтролируемыеСделкиУведомленияВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаСервере
Процедура ПослеЗаполненияУведомленияНаСервере()
	
	НайтиУведомление("Указанный");
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЗаполнениеНаСервере(Уведомление, УникальныйИдентификатор)
	
	РезультатВыполнения = Документы.УведомлениеОКонтролируемыхСделках.ПроверитьЗаполнениеУведомления(Уведомление, УникальныйИдентификатор);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеСделок(СделкиСуществуют, ДатаФормированияСпискаСделок)
	
	СделкиЗаполнены = ?(СделкиСуществуют, НСтр("ru = 'Сформирован %ДатаФормированияСпискаСделок%'"),НСтр("ru = 'Список сделок пуст'"));
	СделкиЗаполнены = СтрЗаменить(СделкиЗаполнены, "%ДатаФормированияСпискаСделок%", Формат(ДатаФормированияСпискаСделок, "ДФ=dd.MM.yyyy"));
	
	Возврат СделкиЗаполнены;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеУведомления(УведомлениеЗаполнено, ДатаЗаполненияУведомления);
	
	Представление = ?(УведомлениеЗаполнено, НСтр("ru = 'Сформировано %ДатаЗаполненияУведомления%'"),НСтр("ru = 'Не заполнено'"));
	Представление = СтрЗаменить(Представление, "%ДатаЗаполненияУведомления%", Формат(ДатаЗаполненияУведомления, "ДФ=dd.MM.yyyy"));
	
	Возврат Представление;

КонецФункции

&НаСервере
Процедура НайтиУведомление(ТипПоиска)
	
	Если Не ЗначениеЗаполнено(Объект.ОтчетныйГод) Тогда 
		Объект.ОтчетныйГод = Год(ДобавитьМесяц(ТекущаяДатаСеанса(), -6));
	КонецЕсли;
	
	Результат = Документы.УведомлениеОКонтролируемыхСделках.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		
		Результат = КонтролируемыеСделки.НайтиУведомлениеОрганизацииВОтчетномГоду(Объект.Организация,Объект.ОтчетныйГод,ТипУведомления,НомерКорректировки,ТипПоиска);
		
	КонецЕсли;
	
	Объект.Уведомление = Результат;
	ОбновитьУведомление();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьУведомление()
	
	Если ЗначениеЗаполнено(Объект.Уведомление) Тогда
		
		СвойстваУведомления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Уведомление, 
			"ВерсияУведомления, НомерКорректировки, ДатаФормированияСпискаСделок, ДатаЗаполненияУведомления");
		
		ТипУведомления = ?(СвойстваУведомления.НомерКорректировки = 0, 0, 1);
		НомерКорректировки = ?(ТипУведомления = 0, 0, СвойстваУведомления.НомерКорректировки);
		СделкиСуществуют = Документы.УведомлениеОКонтролируемыхСделках.ДанныеАвтоматическогоЗаполненияПодготовлены(Объект.Уведомление);
		УведомлениеЗаполнено = Документы.УведомлениеОКонтролируемыхСделках.УведомлениеЗаполнено(Объект.Уведомление);
		ДатаФормированияСпискаСделок = СвойстваУведомления.ДатаФормированияСпискаСделок;
		ДатаЗаполненияУведомления = СвойстваУведомления.ДатаЗаполненияУведомления;
		ВерсияУведомления = СвойстваУведомления.ВерсияУведомления;
	Иначе
		СделкиСуществуют = Ложь;
		УведомлениеЗаполнено = Ложь;
		ДатаФормированияСпискаСделок = Дата(1,1,1);
		ДатаЗаполненияУведомления  = Дата(1,1,1);
		ВерсияУведомления = Документы.УведомлениеОКонтролируемыхСделках.ВерсияУведомленияПоОтчетномуГоду(Дата(Объект.ОтчетныйГод, 1, 1));
	КонецЕсли;
	
	ПредставлениеСделок = ПредставлениеСделок(СделкиСуществуют, ДатаФормированияСпискаСделок);
	ПредставлениеУведомления = ПредставлениеУведомления(УведомлениеЗаполнено, ДатаЗаполненияУведомления);
	
	ТекстНастройкиЗаполненияУведомления    = Документы.УведомлениеОКонтролируемыхСделках.ПолучитьТекстНастроекФормированияУведомления(Объект.Уведомление);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиФормированияУведомления()
	
	ТекстНастройкиФормированияСпискаСделок = РегистрыСведений.НастройкиФормированияКонтролируемыхСделок.ПолучитьТекстНастроекФормированияКонтролируемыхСделок();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.НомерКорректировки.Доступность = Форма.ТипУведомления <> 0;
	
	ДоступностьГиперссылок = ЗначениеЗаполнено(Форма.Объект.Организация) И ЗначениеЗаполнено(Форма.Объект.ОтчетныйГод);
	
	Форма.Элементы.ДекорацияВзаимозависимыеЛица.Доступность               = ДоступностьГиперссылок;
	Форма.Элементы.ТекстНастройкиФормированияСпискаСделок.Доступность     = ДоступностьГиперссылок;
	Форма.Элементы.ПредставлениеСделок.Доступность                        = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияСписокСделок.Доступность                      = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияСписокПрочихКонтролируемыхСделок.Доступность  = ДоступностьГиперссылок;
	Форма.Элементы.КомандаСформироватьСписокСделок.Доступность            = ДоступностьГиперссылок;
	Форма.Элементы.ТекстНастройкиЗаполненияУведомления.Доступность        = ДоступностьГиперссылок;
	
	Форма.Элементы.ДекорацияСведенияОбОрганизации.Доступность         = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияСведенияОВзаимозависимыхЛицах.Доступность = ДоступностьГиперссылок;
	Форма.Элементы.КнопкаОтчетНастройкиКонтрагентов.Доступность       = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияНастройкиПредметов.Доступность            = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияСведенияГраницахВключения.Доступность     = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияСведенияОбОрганизации.Доступность         = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияСписокКонтролируемыхСделок.Доступность    = ДоступностьГиперссылок;
	Форма.Элементы.КомандаЗаполнитьУведомление.Доступность            = ДоступностьГиперссылок;
	Форма.Элементы.КомандаПроверитьЗаполнение.Доступность             = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияСоставУведомления.Доступность             = ДоступностьГиперссылок;
	Форма.Элементы.ДекорацияАнализУведомления.Доступность             = ДоступностьГиперссылок;
	
	Форма.Элементы.КомандаВыгрузить.Доступность                       = ДоступностьГиперссылок;
	Форма.Элементы.КомандаПечатьУведомленияОКонтролируемыхСделках.Доступность = ДоступностьГиперссылок;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСвойстваПредыдущегоУведомления(Организация, ОтчетныйГод, НомерКорректировки)
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("ОтчетныйГод", ОтчетныйГод);
	Запрос.Параметры.Вставить("НомерКорректировки", НомерКорректировки);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УведомлениеОКонтролируемыхСделках.Ссылка,
	|	УведомлениеОКонтролируемыхСделках.Организация,
	|	УведомлениеОКонтролируемыхСделках.ОтчетныйГод КАК ОтчетныйГод,
	|	УведомлениеОКонтролируемыхСделках.НомерКорректировки КАК НомерКорректировки,
	|	УведомлениеОКонтролируемыхСделках.КодМестаПредставления,
	|	УведомлениеОКонтролируемыхСделках.ГруппироватьСделкиСОдинаковойЦеной,
	|	УведомлениеОКонтролируемыхСделках.КодФормыРеорганизации,
	|	УведомлениеОКонтролируемыхСделках.ИННРеорганизованнойОрганизации,
	|	УведомлениеОКонтролируемыхСделках.КППРеорганизованнойОрганизации,
	|	1 КАК Приоритет
	|ИЗ
	|	Документ.УведомлениеОКонтролируемыхСделках КАК УведомлениеОКонтролируемыхСделках
	|ГДЕ
	|	УведомлениеОКонтролируемыхСделках.Организация = &Организация
	|	И УведомлениеОКонтролируемыхСделках.ОтчетныйГод = &ОтчетныйГод
	|	И УведомлениеОКонтролируемыхСделках.НомерКорректировки < &НомерКорректировки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УведомлениеОКонтролируемыхСделках.Ссылка,
	|	УведомлениеОКонтролируемыхСделках.Организация,
	|	УведомлениеОКонтролируемыхСделках.ОтчетныйГод,
	|	УведомлениеОКонтролируемыхСделках.НомерКорректировки,
	|	УведомлениеОКонтролируемыхСделках.КодМестаПредставления,
	|	УведомлениеОКонтролируемыхСделках.ГруппироватьСделкиСОдинаковойЦеной,
	|	УведомлениеОКонтролируемыхСделках.КодФормыРеорганизации,
	|	УведомлениеОКонтролируемыхСделках.ИННРеорганизованнойОрганизации,
	|	УведомлениеОКонтролируемыхСделках.КППРеорганизованнойОрганизации,
	|	2
	|ИЗ
	|	Документ.УведомлениеОКонтролируемыхСделках КАК УведомлениеОКонтролируемыхСделках
	|ГДЕ
	|	УведомлениеОКонтролируемыхСделках.Организация = &Организация
	|	И УведомлениеОКонтролируемыхСделках.ОтчетныйГод < &ОтчетныйГод
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет,
	|	ОтчетныйГод,
	|	НомерКорректировки";
	
	
	СвойстваУведомления = Новый Структура("КодМестаПредставления, ГруппироватьСделкиСОдинаковойЦеной, 
		|КодФормыРеорганизации, ИННРеорганизованнойОрганизации, КППРеорганизованнойОрганизации", "", Ложь, "", "", "");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СвойстваУведомления, Выборка);
	КонецЕсли;
	
	Возврат СвойстваУведомления;
	
КонецФункции

&НаСервере
Процедура СоздатьУведомление()
	
	Если ЗначениеЗаполнено(Объект.Организация)
		И Объект.ОтчетныйГод > 2000 Тогда
		
		НовоеУведомление = Документы.УведомлениеОКонтролируемыхСделках.СоздатьДокумент();
		НовоеУведомление.Дата = ТекущаяДатаСеанса();
		НовоеУведомление.Организация = Объект.Организация;
		НовоеУведомление.ОтчетныйГод = Дата(Объект.ОтчетныйГод, 1, 1);
		НовоеУведомление.НомерКорректировки = НомерКорректировки;
		
		СвойстваПредыдущегоУведомления = ПолучитьСвойстваПредыдущегоУведомления(НовоеУведомление.Организация, НовоеУведомление.ОтчетныйГод, НовоеУведомление.НомерКорректировки);
		
		ЗаполнитьЗначенияСвойств(НовоеУведомление, СвойстваПредыдущегоУведомления);
		
		НовоеУведомление.Записать();
		
		НайтиУведомление("Указанный");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПеренумероватьЛисты1А(Уведомление)
	
	КонтролируемыеСделки.ПеренумерацияКонтролируемыхСделокУведомления(Уведомление);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НомераКонтролируемыхСделокКорректны(Уведомление)
	
	Возврат КонтролируемыеСделки.НомераКонтролируемыхСделокУведомленияКоректны(Уведомление);
	
КонецФункции

&НаКлиенте
Процедура ВопросЗаполненияСделокЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодготовитьДанныеАвтоматическогоЗаполненияНаСервере();
		УправлениеФормой(ЭтотОбъект);
		ПоказатьПредупреждение( , НСтр("ru = 'Список сделок успешно заполнен по данным учета'"), 60);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнениеУведомленийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ДлительнаяОперация = НачатьЗаполнениеУведомленияНаСервере();
		
		ОповещениеПослеЗаполнения = Новый ОписаниеОповещения("ПослеЗаполненияУведомления", ЭтотОбъект);
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется заполнение уведомления о контролируемых сделках'");
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеПослеЗаполнения, ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаполненияУведомления(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	ПослеЗаполненияУведомленияНаСервере();
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПеренумероватьЛисты1АЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренумероватьЛисты1А(Объект.Уведомление);
	КонецЕсли;
	
	ВыгрузитьУведомление();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючВариантаОтчетаПредметыСделок(Уведомление)
	
	Возврат Отчеты.ПредметыКонтролируемыхСделок.ИмяВариантаНастроекУведомления(Уведомление);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПодключитьРасширениеРаботыСФайлами() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("Подключаемый_ПодключитьРасширениеРаботыСФайламиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодключитьРасширениеРаботыСФайламиЗавершение(ПодключеноРасширениеРаботыСФайлами, ДополнительныеПараметры) Экспорт
	
	РасширениеРаботыСФайламиПодключено = ПодключеноРасширениеРаботыСФайлами;
	
КонецПроцедуры

#Область ВыгрузкаУведомления

&НаКлиенте
Процедура ОткрытьФормуВыгрузкиУведомления_2012_2017()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыгрузкиУведомления_2012_2017Завершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("Уведомление", Объект.Уведомление);
	ОткрытьФорму("Документ.УведомлениеОКонтролируемыхСделках.Форма.ФормаВыгрузкиВXML", ПараметрыФормы, ЭтотОбъект,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыгрузкиУведомления_2012_2017Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Для Каждого Сообщение из Результат Цикл
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьУведомление()
	
	Если ВерсияУведомления < КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018() Тогда
		ОткрытьФормуВыгрузкиУведомления_2012_2017();
	Иначе
		ВыгружаемыеДанные= ВыгрузитьФайлНаСервере(Объект.Уведомление);
		Если ВыгружаемыеДанные <> Неопределено Тогда
			ВыгрузитьУведомлениеВXML(ВыгружаемыеДанные, "");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыгрузитьФайлНаСервере(Уведомление)
	
	Если ЗначениеЗаполнено(Уведомление) Тогда
		ОбъектУведомления = Уведомление.ПолучитьОбъект();
		Возврат ОбъектУведомления.ВыгрузитьДокументСРазделениемНаФайлы(УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ВыгрузитьУведомлениеВXML(ВыгружаемыеДанные, ПутьВыгрузки="")
	
	Если РасширениеРаботыСФайламиПодключено Тогда
		
		ПолучаемыеФайлы = Новый Массив;
		Для Каждого ФайлВыгрузки Из ВыгружаемыеДанные Цикл
			ПолучаемыеФайлы.Добавить(
				Новый ОписаниеПередаваемогоФайла(ФайлВыгрузки.ИмяФайлаВыгрузки, ФайлВыгрузки.АдресФайлаВыгрузки));
		КонецЦикла;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьУведомлениеВXMLЗавершение", ЭтотОбъект);
		НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы, ПутьВыгрузки, Истина);
		
	Иначе
		
		Для Каждого ФайлВыгрузки Из ВыгружаемыеДанные Цикл
			
			ПолучитьФайл(ФайлВыгрузки.АдресФайлаВыгрузки, ФайлВыгрузки.ИмяФайлаВыгрузки, Истина);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьУведомлениеВXMLЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПолученныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ПолученныйФайл Из ПолученныеФайлы Цикл
		Если ПолученныйФайл <> Неопределено Тогда
			ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Нстр("ru = 'Выгружен файл %1'"), ПолученныйФайл.Имя);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОповещения);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти