﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",             Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",              Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",              Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",                  Истина);
	Результат.Вставить("ИспользоватьФиксированныйМакетЗаголовкаИПодвала", Истина);
							
	Возврат Результат;
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Доходы и расходы по документам" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт

	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки.Выбор,	"Доходы");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки.Выбор,	"Расходы");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек.Настройки.Выбор,	"Прибыль");
	
	ГоризонтальнаяГруппировка = КомпоновщикНастроек.Настройки.Структура;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Группировка = ГоризонтальнаяГруппировка.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ГоризонтальнаяГруппировка = Группировка.Структура;
			БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);
		КонецЕсли;
	КонецЦикла;
	
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Для Каждого Рисунок Из Результат.Рисунки Цикл
		Попытка
			Если ТипЗнч(Рисунок.Объект) = Тип("Диаграмма") Тогда
				
				// немного расширим легенду влево
				Рисунок.Объект.ОбластьЛегенды.Лево = Рисунок.Объект.ОбластьЛегенды.Лево - 0.01;
				Рисунок.Объект.ОбластьПостроения.Право = Рисунок.Объект.ОбластьПостроения.Право - 0.01;
				
				Для Каждого Серия Из Рисунок.Объект.Серии Цикл
					Если Серия.Текст = "Доходы без НДС"
						ИЛИ Серия.Текст = "Расходы" Тогда
							Серия.Индикатор = Истина;
					КонецЕсли;
				КонецЦикла;
				
				
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


#КонецЕсли