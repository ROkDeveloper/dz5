﻿#Область СлужебныйПрограммныйИнтерфейс

// Определяет доступность функциональности по оплате сервиса.
//
Функция ДоступнаОплатаСервиса() Экспорт
	
	Возврат Обработки.ОплатаСервисаБП.ДоступнаОплатаСервиса();
	
КонецФункции

// Возвращает результат проверки выполнения условия тарифного ограничения на число сотрудников
//
// См. УчетЗарплаты.РезультатПроверкиУсловийТарификацииПоКоличествуСотрудников
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, для которой рассчитывается количество сотрудников
//
// ВозвращаемоеЗначение:
//  Структура - см. ТарификацияБП.НовыйРезультатПроверкиУсловийТарификацииПоСотрудникам()
//
//
Функция РезультатПроверкиУсловийТарификацииПоКоличествуСотрудников(Организация) Экспорт
	
	Возврат УчетЗарплаты.РезультатПроверкиУсловийТарификацииПоКоличествуСотрудников(Организация);
	
КонецФункции

// Возвращает текущие значения тарифицируемых опций
// 
// См. ТарификацияБП.ЗначенияТарифицируемыхОпций()
//
// Возвращаемое значение:
//  Структура
//
Функция ЗначенияТарифицируемыхОпций() Экспорт
	
	Возврат ТарификацияБП.ЗначенияТарифицируемыхОпций();
	
КонецФункции

// Сравнивает сохраненные значения тарифицируемых опций с текущими значениями
// 
// См. ТарификацияБП.ТарифицируемыеОпцииИзменены()
//
// Параметры:
//  АдресЗначенийТарифицируемыхОпций - Строка - Адрес значений во временном хранилище
//
// Возвращаемое значение:
//  Булево - Истина, если было изменено значение хотя бы одной опции
//
Функция ТарифицируемыеОпцииИзменены(АдресЗначенийТарифицируемыхОпций) Экспорт
	
	Возврат ТарификацияБП.ТарифицируемыеОпцииИзменены(АдресЗначенийТарифицируемыхОпций);
	
КонецФункции

// Возвращает признак необходимости отображения баннера ожидания оплаты тарифа
//
// Возвращаемое значение:
//  Булево - Истина, если требуется отображать баннер ожидания оплаты тарифа
//
Функция ОтображатьБаннерОжиданияОплатыТарифа() Экспорт
	
	Возврат ОбщегоНазначенияБП.ЭтоБизнесСтарт() Или ТарификацияБП.РежимОтладки();
	
КонецФункции

Функция ПараметрыОткрытияНастроекОрганизации() Экспорт
	
	Возврат Новый Структура("Ключ", Справочники.Организации.ОрганизацияПоУмолчанию());
	
КонецФункции

#КонецОбласти