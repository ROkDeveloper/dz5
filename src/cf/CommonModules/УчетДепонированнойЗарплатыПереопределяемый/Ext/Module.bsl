﻿////////////////////////////////////////////////////////////////////////////////
// Учет депонированной зарплаты
// Переопределяемое в потребителе поведение
////////////////////////////////////////////////////////////////////////////////

// Процедура предназначена для формирования движений по бухучету
//
// Параметры:
//  Регистратор	- Тип - ДокументОбъект, документ, от имени которого регистрируются данные по зарплате
//                 по этим данным необходимо сформировать бухгалтерские проводки
//	Отказ – булево, признак отказа от проведения документа
//	Организация
//	ДатаОперации
//	Депоненты	– таблица значений с данными о депонированной зарплате:
//								•	ВидОперации	- ПеречислениеСсылка.ВидыОперацийПоЗарплате
//								•	ФизическоеЛицо (СправочникСсылка.ФизическиеЛица)
//								•	Сумма
//
Процедура ОтразитьВБухучете(Движения, Отказ, Организация, ДатаОперации, Депоненты) Экспорт
	
	Если Депоненты.Колонки.Найти("СтатьяРасходов") = Неопределено Тогда
		Депоненты.Колонки.Добавить("СтатьяРасходов", Новый ОписаниеТипов("СправочникСсылка.СтатьиРасходовЗарплата"));
	КонецЕсли;
	
	ДанныеДляОтражения = Новый Структура;
	ДанныеДляОтражения.Вставить("Депоненты", Депоненты);
	УчетЗарплаты.СформироватьДвиженияПоОтражениюЗарплатыВРегламентированномУчете(Движения, Отказ, Организация, ДатаОперации, ДанныеДляОтражения);
	
КонецПроцедуры