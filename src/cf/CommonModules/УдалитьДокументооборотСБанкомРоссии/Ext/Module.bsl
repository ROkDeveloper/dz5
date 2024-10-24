﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Документооборот с Банком России".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
	
Функция ОтправитьОтчет(Организация, СсылкаНаОтчет, Пакет, ПараметрыАутентификации) Экспорт
		
	КлиентСервиса = КлиентСервиса(ПараметрыАутентификации);
	
	ПакетДвоичныеДанные = ПолучитьИзВременногоХранилища(Пакет.Адрес);
	
	ReportТип = КлиентСервиса.ФабрикаXDTO.Тип(ПространствоИмен(), "Report");
	Report = КлиентСервиса.ФабрикаXDTO.Создать(ReportТип);
	Report.Name = Пакет.Имя;
	Report.Data = ПакетДвоичныеДанные;
	
	Попытка
		Идентификатор = КлиентСервиса.sendReport(Report);
	Исключение
		ОбработатьИсключение(ИнформацияОбОшибке());
		ВызватьИсключение;
	КонецПопытки;

	Если ЗначениеЗаполнено(Идентификатор) Тогда
		НоваяОтправка = Справочники.УдалитьОтправкиБанкРоссии.СоздатьЭлемент();
		
		НоваяОтправка.ОтчетСсылка                = СсылкаНаОтчет;
		НоваяОтправка.Идентификатор              = Идентификатор;
		НоваяОтправка.Пакет                      = Новый ХранилищеЗначения(ПакетДвоичныеДанные, Новый СжатиеДанных(9));
		НоваяОтправка.ИмяФайлаПакета             = Пакет.Имя;
		НоваяОтправка.ДатаОтправки               = ТекущаяДатаСеанса();
		НоваяОтправка.Организация                = Организация;
		НоваяОтправка.ВидОтчета                  = Справочники.ВидыОтправляемыхДокументов.ОперацииСДенежнымиСредствамиНФО;
		НоваяОтправка.ДатаНачалаПериода          = СсылкаНаОтчет.ДатаНачала; 
		НоваяОтправка.ДатаОкончанияПериода       = СсылкаНаОтчет.ДатаОкончания;
		НоваяОтправка.Версия                     = СсылкаНаОтчет.Вид;
		НоваяОтправка.ПредставлениеПериода       = ПредставлениеПериода(НоваяОтправка.ДатаНачалаПериода, КонецДня(НоваяОтправка.ДатаОкончанияПериода), "ФП=Истина");
		НоваяОтправка.ПредставлениеВидаДокумента = СсылкаНаОтчет.ПредставлениеВида;
		
		НоваяОтправка.СтатусОтправки             = Перечисления.СтатусыОтправки.Отправлен;
		
		НоваяОтправка.Записать();

		Возврат НоваяОтправка.Ссылка;		
	КонецЕсли;
		
КонецФункции

Функция ПолучитьСтатусОтчета(Ссылка, ПараметрыАутентификации) Экспорт
		
	КлиентСервиса = КлиентСервиса(ПараметрыАутентификации);

	Попытка
		Result = КлиентСервиса.receiveResult(Ссылка.Идентификатор);
	Исключение
		ОбработатьИсключение(ИнформацияОбОшибке());
		ВызватьИсключение;
	КонецПопытки;
	
	ОтправкаОбъект = Ссылка.ПолучитьОбъект();
	ОтправкаОбъект.ДатаПолученияРезультата = ТекущаяДатаСеанса();
	ОтправкаОбъект.Уведомление             = Новый ХранилищеЗначения(Result.Data, Новый СжатиеДанных(9));
	ОтправкаОбъект.ИмяФайлаУведомления     = "Уведомление." + ОтправкаОбъект.Идентификатор + ".zip";
	ОтправкаОбъект.СтатусОтправки          = ОпределитьСтатусОтправки(Result.Status);
	Если ОтправкаОбъект.СтатусОтправки = Перечисления.СтатусыОтправки.Сдан
		ИЛИ ОтправкаОбъект.СтатусОтправки = Перечисления.СтатусыОтправки.НеПринят Тогда
		ОтправкаОбъект.Протокол = Новый ХранилищеЗначения(СформироватьПротокол(ОтправкаОбъект, Result.Status, Result.Data), Новый СжатиеДанных(9));
	КонецЕсли;
	
	ОтправкаОбъект.Записать();
	
	Возврат Истина;
	
КонецФункции

Функция ПроверитьВозможностьВыполненияОперации(Знач ПараметрыАутентификации) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат "ВыполнениеРазрешено";		
	Иначе
		Если Не ЗначениеЗаполнено(ПараметрыАутентификации)
			ИЛИ НЕ (ПараметрыАутентификации.Свойство("Логин") И ЗначениеЗаполнено(ПараметрыАутентификации.Логин))
			ИЛИ НЕ (ПараметрыАутентификации.Свойство("Пароль") И ЗначениеЗаполнено(ПараметрыАутентификации.Пароль)) Тогда
			УстановитьПривилегированныйРежим(Истина);
			ПараметрыАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыАутентификации) Тогда
			Возврат "ПараметрыАутентификацииНеЗаполнены";
		Иначе
			Результат = ПараметрыАутентификацииКорректные(ПараметрыАутентификации);
			Если Результат = "НекорректноеИмяПользователяИлиПароль" Тогда
				Возврат "ПараметрыАутентификацииУказаныНеВерно";
			ИначеЕсли Результат = "АутентификацияВыполнена" Тогда				
				Возврат "ВыполнениеРазрешено";
			ИначеЕсли Результат = "НеизвестнаяОшибка" Тогда
				Возврат "НеизвестнаяОшибкаПриПроверке";
			Иначе
				Возврат "ВыполнениеЗапрещено";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьНастройки(Организация) Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("Сертификат", "");
	Настройки.Вставить("ИспользоватьОбмен", Ложь);
	Настройки.Вставить("ОбменНастроен", Ложь);
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УдалитьНастройкиОбменаБанкРоссии.ИспользоватьОбмен КАК ИспользоватьОбмен,
	|	УдалитьНастройкиОбменаБанкРоссии.СертификатАбонентаОтпечаток КАК Сертификат
	|ИЗ
	|	РегистрСведений.УдалитьНастройкиОбменаБанкРоссии КАК УдалитьНастройкиОбменаБанкРоссии
	|ГДЕ
	|	УдалитьНастройкиОбменаБанкРоссии.Организация = &Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Настройки.Сертификат = Выборка.Сертификат;
		Настройки.ИспользоватьОбмен = Выборка.ИспользоватьОбмен;
		Настройки.ОбменНастроен = ЗначениеЗаполнено(Настройки.Сертификат);
	КонецЕсли;
		
	Возврат Настройки;
	
КонецФункции

Функция СохранитьНастройки(Организация, Сертификат) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.УдалитьНастройкиОбменаБанкРоссии.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация = Организация;
	МенеджерЗаписи.ИспользоватьОбмен = Истина;
	МенеджерЗаписи.СертификатАбонентаОтпечаток = Сертификат;
	МенеджерЗаписи.Записать();
	
	Возврат ПолучитьНастройки(Организация);
	
КонецФункции

Функция ПолучитьПоследнююОтправкуОтчета(ОтчетСсылка) Экспорт
	
	Отправка = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УдалитьОтправкиБанкРоссии.Ссылка
	|ИЗ
	|	Справочник.УдалитьОтправкиБанкРоссии КАК УдалитьОтправкиБанкРоссии
	|ГДЕ
	|	УдалитьОтправкиБанкРоссии.ОтчетСсылка = &ЭтотОтчет
	|	И НЕ УдалитьОтправкиБанкРоссии.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	УдалитьОтправкиБанкРоссии.ДатаОтправки УБЫВ";
	Запрос.Параметры.Вставить("ЭтотОтчет", ОтчетСсылка);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Отправка = Выборка.Ссылка;
		
	КонецЕсли;
	
	Возврат Отправка;
	
КонецФункции

Функция ПолучитьНеЗавершенныеОтправки(Организация) Экспорт
	
	Настройки = ПолучитьНастройки(Организация);
	Если ЗначениеЗаполнено(Настройки) И Настройки.ИспользоватьОбмен Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УдалитьОтправкиБанкРоссии.Ссылка
		|ИЗ
		|	Справочник.УдалитьОтправкиБанкРоссии КАК УдалитьОтправкиБанкРоссии
		|ГДЕ
		|	УдалитьОтправкиБанкРоссии.СтатусОтправки = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.Отправлен)";
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Иначе
		Возврат Новый Массив;
	КонецЕсли;                                                            	
	
КонецФункции

Функция ПолучитьТекстЗапросаДляФормыНастроек() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА Организации.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК ПометкаУдаления,
	|	Организации.Ссылка КАК Организация,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(УдалитьНастройкиОбменаБанкРоссии.ИспользоватьОбмен, ЛОЖЬ)
	|			ТОГДА ""Используется""
	|		ИНАЧЕ ""Не используется""
	|	КОНЕЦ КАК ВидОбменаСКонтролирующимиОрганами
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьНастройкиОбменаБанкРоссии КАК УдалитьНастройкиОбменаБанкРоссии
	|		ПО (УдалитьНастройкиОбменаБанкРоссии.Организация = Организации.Ссылка)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьТекстыДляЗапросаСпискаНастроекОбмена() Экспорт
	
	ПеречислениеКолонок =
		"	ЕСТЬNULL(УдалитьНастройкиОбменаБанкРоссии.ИспользоватьОбмен, ЛОЖЬ) КАК НастройкиОбменаЦБ_ИспользоватьОбмен,
		|	ЕСТЬNULL(УдалитьНастройкиОбменаБанкРоссии.СертификатАбонентаОтпечаток, """") КАК НастройкиОбменаЦБ_СертификатАбонентаОтпечаток";
	
	СоединениеСОрганизацией =
		"		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьНастройкиОбменаБанкРоссии КАК УдалитьНастройкиОбменаБанкРоссии
		|		ПО УдалитьНастройкиОбменаБанкРоссии.Организация = Организации.Ссылка";
	
	Возврат Новый Структура("ПеречислениеКолонок, СоединениеСОрганизацией", ПеречислениеКолонок, СоединениеСОрганизацией);
	
КонецФункции

Функция ПолучитьТекстЗапросаДляВсеОтправки() Экспорт
	
	ТекстЗапроса = 
	"
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	УдалитьОтправкиБанкРоссии.ПометкаУдаления,
	|	УдалитьОтправкиБанкРоссии.Ссылка,
	|	""УдалитьБанкРоссии"",
	|	"""",
	|	УдалитьОтправкиБанкРоссии.Организация,
	|	УдалитьОтправкиБанкРоссии.ПредставлениеПериода,
	|	УдалитьОтправкиБанкРоссии.ПредставлениеВидаДокумента,
	|	УдалитьОтправкиБанкРоссии.ДатаОтправки,
	|	ВЫБОР
	|		КОГДА ГОД(УдалитьОтправкиБанкРоссии.ДатаЗакрытия) = 3999
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ УдалитьОтправкиБанкРоссии.ДатаЗакрытия
	|	КОНЕЦ,
	|	УдалитьОтправкиБанкРоссии.Идентификатор,
	|	НЕОПРЕДЕЛЕНО
	|ИЗ
	|	Справочник.УдалитьОтправкиБанкРоссии КАК УдалитьОтправкиБанкРоссии
	|ГДЕ
	|	УдалитьОтправкиБанкРоссии.ОтчетСсылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КлиентСервиса(ПараметрыАутентификации)
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Если Не ЗначениеЗаполнено(ПараметрыАутентификации)
			ИЛИ НЕ (ПараметрыАутентификации.Свойство("Логин") И ЗначениеЗаполнено(ПараметрыАутентификации.Логин))
			ИЛИ НЕ (ПараметрыАутентификации.Свойство("Пароль") И ЗначениеЗаполнено(ПараметрыАутентификации.Пароль)) Тогда
			УстановитьПривилегированныйРежим(Истина);
			ПараметрыАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыАутентификации) Тогда
			ВызватьИсключение("ПараметрыАутентификацииНеЗаполнены");
		КонецЕсли;
	КонецЕсли;

	Попытка
		
		ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
		ПараметрыПодключения.АдресWSDL 				= АдресСервиса();
		ПараметрыПодключения.URIПространстваИмен 	= ПространствоИмен();
		ПараметрыПодключения.ИмяСервиса 			= "NfoReportWebServiceEndpointImplService";
		ПараметрыПодключения.ИмяТочкиПодключения 	= "NfoReportWebServiceEndpointImplPort";
		ПараметрыПодключения.ИмяПользователя 		= ПараметрыАутентификации.Логин;
		ПараметрыПодключения.Пароль 				= ПараметрыАутентификации.Пароль;
		ПараметрыПодключения.Таймаут 				= 30;
		
		Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
		
	Исключение
		ОбработатьИсключение(ИнформацияОбОшибке());
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Прокси;
	
КонецФункции

Функция ПространствоИмен()
	
	Возврат "http://ws.nforeport.company1c.com/";
	
КонецФункции

Функция АдресСервиса()
	
	Возврат "https://nfo-report.1c.ru/api/v1?wsdl";
	
КонецФункции

Процедура ОбработатьИсключение(ИнформацияОбОшибке)
	
	КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);

	Если СтрНайти(КраткоеПредставлениеОшибки, "SERVER-9:")
		ИЛИ СтрНайти(КраткоеПредставлениеОшибки, """STATUS"":401") Тогда
		ВызватьИсключение("ПараметрыАутентификацииУказаныНеВерно");
	КонецЕсли;
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Документооборот с Банком России'", ОбщегоНазначения.КодОсновногоЯзыка()),
	    УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
КонецПроцедуры

Функция ОпределитьСтатусОтправки(Status)
	
	СтатусыОшибок = Новый Массив;
	СтатусыОшибок.Добавить("SignatureError");
	СтатусыОшибок.Добавить("PackageCorrupted");
	СтатусыОшибок.Добавить("PackageNotRegistered");
	СтатусыОшибок.Добавить("ReportInvalid");
	СтатусыОшибок.Добавить("InvalidScheme");
	СтатусыОшибок.Добавить("InvalidSignature");
	
	Если Status = "IncomingNumberAssotiated" Тогда
		Возврат Перечисления.СтатусыОтправки.Сдан;
	ИначеЕсли СтатусыОшибок.Найти(Status) <> Неопределено Тогда
		Возврат Перечисления.СтатусыОтправки.НеПринят;
	Иначе
		Возврат Перечисления.СтатусыОтправки.Отправлен;		
	КонецЕсли;
	
КонецФункции

Функция ПараметрыАутентификацииКорректные(ПараметрыАутентификацииНаСайте, ОписаниеОшибки = "")
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте)
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте.Логин)
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыАутентификацииНаСайте.Пароль) Тогда
		Результат = "НекорректноеИмяПользователяИлиПароль";
		Возврат Результат;
	КонецЕсли;
	
	Результат = "НеизвестнаяОшибка";
	Билет = "";
	Попытка
		
		КлиентСервиса = КлиентСервиса(ПараметрыАутентификацииНаСайте);
		Ответ = КлиентСервиса.checkAccess();
			
		Если Ответ = Истина Тогда
			Результат = "АутентификацияВыполнена";
		КонецЕсли;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);

		Если СтрНайти(КраткоеПредставлениеОшибки, "SERVER-9:")
			ИЛИ СтрНайти(КраткоеПредставлениеОшибки, """STATUS"":401") Тогда
			Результат = "НекорректноеИмяПользователяИлиПароль";
		КонецЕсли;
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Документооборот с Банком России. checkAccess'", ОбщегоНазначения.КодОсновногоЯзыка()),
		    УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ПрочитатьXDTOИзУведомления(Уведомление)
	
	ИмяФайлаУведомления = ПолучитьИмяВременногоФайла("zip");
	Уведомление.Записать(ИмяФайлаУведомления);
	
	ВременныйКаталог = КаталогВременныхФайлов() + СтрЗаменить(Новый УникальныйИдентификатор, "-", "") + ПолучитьРазделительПути();
	СоздатьКаталог(ВременныйКаталог);
	
	ЧтениеZIP = Новый ЧтениеZipФайла(ИмяФайлаУведомления);
	ЧтениеZIP.ИзвлечьВсе(ВременныйКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	РаспакованныеФайлы = НайтиФайлы(ВременныйКаталог, "*", Истина);
	
	Для Каждого РаспакованныйФайл Из РаспакованныеФайлы Цикл
		Если СтрЗаканчиваетсяНа(РаспакованныйФайл.Имя, ".zip") Тогда
			ВременныйКаталогУведомление = ВременныйКаталог + "Уведомление" + ПолучитьРазделительПути();
			СоздатьКаталог(ВременныйКаталог + "Уведомление");
			
			ЧтениеZIP = Новый ЧтениеZipФайла(РаспакованныйФайл.ПолноеИмя);
			ЧтениеZIP.ИзвлечьВсе(ВременныйКаталогУведомление, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
			
			РаспакованныеФайлыУведомление = НайтиФайлы(ВременныйКаталогУведомление, "*", Истина);
			Для Каждого РаспакованныйФайлУведомление Из РаспакованныеФайлыУведомление Цикл
				Если СтрЗаканчиваетсяНа(РаспакованныйФайлУведомление.Имя, "xtdd") Тогда
					ЧтениеXML = Новый ЧтениеXML;
					ЧтениеXML.ОткрытьФайл(РаспакованныйФайлУведомление.ПолноеИмя);
					
					ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
					ЧтениеXML.Закрыть();
					
					
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	УдалитьФайлы(ВременныйКаталог);
	УдалитьФайлы(ИмяФайлаУведомления);

	Возврат ОбъектXDTO;
	
КонецФункции

Функция СформироватьПротокол(Отправка, Статус, Уведомление)
	
	УведомлениеXDTO = ПрочитатьXDTOИзУведомления(Уведомление);
	Если ТипЗнч(УведомлениеXDTO.ПодробныйКомментарий) = Тип("Строка") Тогда
		ПодробныйКомментарий = СокрЛП(УведомлениеXDTO.ПодробныйКомментарий);
	КонецЕсли;
	Если ТипЗнч(УведомлениеXDTO.ДатаПрисвоенияВходящегоНомера) = Тип("Строка") Тогда
		Попытка
			ДатаПрисвоенияВходящегоНомера = Формат(XMLЗначение(Тип("Дата"), СокрЛП(УведомлениеXDTO.ДатаПрисвоенияВходящегоНомера)), "ДФ='дд.ММ.гггг ЧЧ:мм:сс'; ДП=' '")
		Исключение
			ДатаПрисвоенияВходящегоНомера = "";
		КонецПопытки;
	КонецЕсли;
	Если ТипЗнч(УведомлениеXDTO.ДатаИзменения) = Тип("Строка") Тогда
		Попытка
			ДатаИзменения = Формат(XMLЗначение(Тип("Дата"), СокрЛП(УведомлениеXDTO.ДатаИзменения)), "ДФ='дд.ММ.гггг ЧЧ:мм:сс'; ДП=' '")
		Исключение
			ДатаИзменения = "";
		КонецПопытки;
	КонецЕсли;
	
	ОписаниеСостояний = Новый Соответствие;
	ОписаниеСостояний.Вставить("Processing", "Документ загружен в систему");
	ОписаниеСостояний.Вставить("SignatureCorrect", "ЭП корректна");
	ОписаниеСостояний.Вставить("SignatureError", "Ошибка проверки ЭП");
	ОписаниеСостояний.Вставить("PackageCorrupted", "Нарушена целостность документа");
	ОписаниеСостояний.Вставить("Accepted", "Документ принят к обработке");
	ОписаниеСостояний.Вставить("PackageNotRegistered", "Документ не принят к обработке");
	ОписаниеСостояний.Вставить("IncomingNumberAssotiated", "Документу присвоен входящий номер");
	ОписаниеСостояний.Вставить("ReportInvalid", "Не найдены необходимые поля в документе");
	ОписаниеСостояний.Вставить("InvalidScheme", "Документ не соответствует структуре отчета");
	ОписаниеСостояний.Вставить("InvalidSignature", "ЭП не легитимна");
	
	Протокол = Неопределено;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Макет = ПолучитьОбщийМакет("ШаблонПротоколаБанкРоссии");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьПротоколОшибок = Макет.ПолучитьОбласть("ПротоколОшибок");
		
	СвойстваОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Отправка.Организация, ,"НаимЮЛПол, ИННЮЛ");		
	ОбластьШапка.Параметры.Организация = СвойстваОрганизации.НаимЮЛПол;
	ОбластьШапка.Параметры.ИНН = СвойстваОрганизации.ИННЮЛ;
	ОбластьШапка.Параметры.Получатель = Перечисления.ТипыКонтролирующихОрганов.УдалитьБанкРоссии;
	ОбластьШапка.Параметры.Отчет = Отправка.ВидОтчета;
	ОбластьШапка.Параметры.Файл = Отправка.ИмяФайлаПакета;
	
	Если Отправка.СтатусОтправки = Перечисления.СтатусыОтправки.Сдан Тогда
		ОбластьШапка.Параметры.СтатусОтчета = НСтр("ru = 'Сдан, ошибок не обнаружено'");
		ОбластьШапка.Параметры.НаименованиеПротокола = НСтр("ru = 'Протокол о сдаче'");
		ОбластьШапка.Области.СтатусОтчета.ЦветТекста = ЦветаСтиля.ЦветПоложительногоПротокола;
	ИначеЕсли Отправка.СтатусОтправки = Перечисления.СтатусыОтправки.НеПринят Тогда
		ОбластьШапка.Параметры.СтатусОтчета = НСтр("ru = 'Не принят, обнаружены ошибки'");
		ОбластьШапка.Параметры.НаименованиеПротокола = НСтр("ru = 'Протокол ошибок'");
		ОбластьШапка.Области.СтатусОтчета.ЦветТекста = ЦветаСтиля.ЦветОшибкиВПротоколеБРО;
		
		Если Отправка.СтатусОтправки = Перечисления.СтатусыОтправки.НеПринят Тогда
			ОбластьПротоколОшибок.Параметры.ПротоколОшибок = ПодробныйКомментарий;
		КонецЕсли;
	Иначе
		ОбластьШапка.Параметры.СтутусОтчета = НСтр("ru = 'Находится в обработке'");
		ОбластьШапка.Параметры.НаименованиеПротокола = НСтр("ru = 'Протокол'");
		ОбластьШапка.Области.СтатусОтчета.ЦветТекста = ЦветаСтиля.ЦветНезавершившейсяОтправкиБРО;
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	ТаблицаЭтапов = Новый ТаблицаЗначений;
	ТаблицаЭтапов.Колонки.Добавить("СтадияОбработки");
	ТаблицаЭтапов.Колонки.Добавить("Статус");
	ТаблицаЭтапов.Колонки.Добавить("Дата");
	ТаблицаЭтапов.Колонки.Добавить("КодОшибки");
	ТаблицаЭтапов.Колонки.Добавить("ОписаниеОшибки");
	
	НоваяСтрока = ТаблицаЭтапов.Добавить();
	НоваяСтрока.СтадияОбработки = НСтр("ru = '1. Получение файла'");
	НоваяСтрока.Статус = НСтр("ru = 'Успешно'");
	
	ПроверкаПодписиУспешна = Ложь;
	Если Статус = "SignatureCorrect" ИЛИ (Статус <> "SignatureError" И Статус <> "InvalidSignature") Тогда
		НоваяСтрока = ТаблицаЭтапов.Добавить();
		НоваяСтрока.СтадияОбработки = НСтр("ru = '2. Проверка ЭП'");
		НоваяСтрока.Статус = НСтр("ru = 'Успешно'");
		ПроверкаПодписиУспешна = Истина;
	ИначеЕсли Статус = "SignatureError" ИЛИ Статус = "InvalidSignature" Тогда 
		НоваяСтрока = ТаблицаЭтапов.Добавить();
		НоваяСтрока.СтадияОбработки = НСтр("ru = '2. Проверка ЭП'");
		НоваяСтрока.Статус = НСтр("ru = 'Ошибка'");
		НоваяСтрока.Дата = ДатаИзменения;	
		НоваяСтрока.КодОшибки = Статус;
		НоваяСтрока.ОписаниеОшибки = ОписаниеСостояний.Получить(Статус);
	КонецЕсли;
	
	Если Статус = "Accepted" ИЛИ Статус = "IncomingNumberAssotiated" Тогда
		НоваяСтрока = ТаблицаЭтапов.Добавить();
		НоваяСтрока.СтадияОбработки = НСтр("ru = '3. Форматный контроль'");
		НоваяСтрока.Статус = НСтр("ru = 'Успешно'");
	ИначеЕсли ПроверкаПодписиУспешна Тогда
		НоваяСтрока = ТаблицаЭтапов.Добавить();
		НоваяСтрока.СтадияОбработки = НСтр("ru = '3. Форматный контроль'");
		НоваяСтрока.Статус = НСтр("ru = 'Ошибка'");
		НоваяСтрока.Дата = ДатаИзменения;	
		НоваяСтрока.КодОшибки = Статус;
		НоваяСтрока.ОписаниеОшибки = ОписаниеСостояний.Получить(Статус);
	КонецЕсли;
	
	Если Статус = "IncomingNumberAssotiated" Тогда
		НоваяСтрока = ТаблицаЭтапов.Добавить();
		НоваяСтрока.СтадияОбработки = НСтр("ru = '4. Проверка отсутствия в системе документа с таким же исходящим номером'");
		НоваяСтрока.Статус = НСтр("ru = 'Успешно'");
		НоваяСтрока.Дата = ДатаПрисвоенияВходящегоНомера;
	КонецЕсли;

	Для Каждого СтрокаТаблицы Из ТаблицаЭтапов Цикл
		ОбластьСтрока.Параметры.Заполнить(СтрокаТаблицы);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	Если Отправка.СтатусОтправки = Перечисления.СтатусыОтправки.НеПринят Тогда
		ТабличныйДокумент.Вывести(ОбластьПротоколОшибок);
	КонецЕсли;
	
	ИмяФайлаПротокола = ПолучитьИмяВременногоФайла("html");
	ТабличныйДокумент.Записать(ИмяФайлаПротокола, ТипФайлаТабличногоДокумента.HTML);
	
	Протокол = Новый ДвоичныеДанные(ИмяФайлаПротокола);
	УдалитьФайлы(ИмяФайлаПротокола);
	
	Возврат Протокол;
	
КонецФункции

#КонецОбласти