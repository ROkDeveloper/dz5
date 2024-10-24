﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		
		// Заменим платформенный механизм формирования списка выбора,
		// т.к. необходим отбор по дате получения данных об ответственных лицах
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора 		 = Новый СписокЗначений;
		
		ТаблицаОтветственных = ТаблицуОтветственныхЛицПоОтбору(Параметры.Отбор);
		
		ДанныеВыбора.ЗагрузитьЗначения(ТаблицаОтветственных.ВыгрузитьКолонку("Основание"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ОснованиеПраваПодписиФизЛица(ФизическоеЛицо,Организация,ДатаОтбор) Экспорт
	
	Основание = Неопределено;
	
	Отбор = Новый Структура();
	Отбор.вставить("ФизическоеЛицо",ФизическоеЛицо);
	Отбор.вставить("Организация",Организация);
	Отбор.вставить("Дата",ДатаОтбор); 
	
	ТаблицаОтветственных = ТаблицуОтветственныхЛицПоОтбору(Отбор);
	
	Если ТаблицаОтветственных.Количество()>0 тогда
		Основание = ТаблицаОтветственных[0].Основание;
	КонецЕсли;
	
	Возврат Основание;
	
КонецФункции

// Процедуры обновления ИБ

// Процедура создает элементы справочника и перезаполняет документы при обновлении ИБ
//
Процедура СоздатьОснованияПраваПодписи() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УполномоченныеЛицаОрганизаций.Организация КАК Организация,
	|	УполномоченныеЛицаОрганизаций.УполномоченноеЛицо КАК ФизическоеЛицо,
	|	УполномоченныеЛицаОрганизаций.УдалитьНомерДатаПриказа КАК Наименование
	|ПОМЕСТИТЬ ВТ_ДанныеРеквизитовПодписи
	|ИЗ
	|	РегистрСведений.УполномоченныеЛицаОрганизаций КАК УполномоченныеЛицаОрганизаций
	|ГДЕ
	|	УполномоченныеЛицаОрганизаций.УдалитьНомерДатаПриказа <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ОказаниеУслуг.Организация,
	|	ОказаниеУслуг.Исполнитель,
	|	ОказаниеУслуг.УдалитьИсполнительПоПриказу
	|ИЗ
	|	Документ.ОказаниеУслуг КАК ОказаниеУслуг
	|ГДЕ
	|	ОказаниеУслуг.Исполнитель <> &ПустоеФизическоеЛицо
	|	И ОказаниеУслуг.Организация <> &ПустаяОрганизация
	|	И ОказаниеУслуг.УдалитьИсполнительПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	АктОбОказанииПроизводственныхУслуг.Организация,
	|	АктОбОказанииПроизводственныхУслуг.Исполнитель,
	|	АктОбОказанииПроизводственныхУслуг.УдалитьИсполнительПоПриказу
	|ИЗ
	|	Документ.АктОбОказанииПроизводственныхУслуг КАК АктОбОказанииПроизводственныхУслуг
	|ГДЕ
	|	АктОбОказанииПроизводственныхУслуг.Исполнитель <> &ПустоеФизическоеЛицо
	|	И АктОбОказанииПроизводственныхУслуг.Организация <> &ПустаяОрганизация
	|	И АктОбОказанииПроизводственныхУслуг.УдалитьИсполнительПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КорректировкаРеализации.Организация,
	|	КорректировкаРеализации.Руководитель,
	|	КорректировкаРеализации.УдалитьЗаРуководителяПоПриказу
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|ГДЕ
	|	КорректировкаРеализации.Руководитель <> &ПустоеФизическоеЛицо
	|	И КорректировкаРеализации.Организация <> &ПустаяОрганизация
	|	И КорректировкаРеализации.УдалитьЗаРуководителяПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КорректировкаРеализации.Организация,
	|	КорректировкаРеализации.ГлавныйБухгалтер,
	|	КорректировкаРеализации.УдалитьЗаГлавногоБухгалтераПоПриказу
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|ГДЕ
	|	КорректировкаРеализации.ГлавныйБухгалтер <> &ПустоеФизическоеЛицо
	|	И КорректировкаРеализации.Организация <> &ПустаяОрганизация
	|	И КорректировкаРеализации.УдалитьЗаГлавногоБухгалтераПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РеализацияУслугПоПереработке.Организация,
	|	РеализацияУслугПоПереработке.Исполнитель,
	|	РеализацияУслугПоПереработке.УдалитьИсполнительПоПриказу
	|ИЗ
	|	Документ.РеализацияУслугПоПереработке КАК РеализацияУслугПоПереработке
	|ГДЕ
	|	РеализацияУслугПоПереработке.Исполнитель <> &ПустоеФизическоеЛицо
	|	И РеализацияУслугПоПереработке.Организация <> &ПустаяОрганизация
	|	И РеализацияУслугПоПереработке.УдалитьИсполнительПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Организация,
	|	РеализацияТоваровУслуг.Руководитель,
	|	РеализацияТоваровУслуг.УдалитьЗаРуководителяПоПриказу
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Руководитель <> &ПустоеФизическоеЛицо
	|	И РеализацияТоваровУслуг.Организация <> &ПустаяОрганизация
	|	И РеализацияТоваровУслуг.УдалитьЗаРуководителяПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Организация,
	|	РеализацияТоваровУслуг.ГлавныйБухгалтер,
	|	РеализацияТоваровУслуг.УдалитьЗаГлавногоБухгалтераПоПриказу
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.ГлавныйБухгалтер <> &ПустоеФизическоеЛицо
	|	И РеализацияТоваровУслуг.Организация <> &ПустаяОрганизация
	|	И РеализацияТоваровУслуг.УдалитьЗаГлавногоБухгалтераПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СчетНаОплатуПокупателю.Организация,
	|	СчетНаОплатуПокупателю.Руководитель,
	|	СчетНаОплатуПокупателю.УдалитьЗаРуководителяПоПриказу
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
	|ГДЕ
	|	СчетНаОплатуПокупателю.Руководитель <> &ПустоеФизическоеЛицо
	|	И СчетНаОплатуПокупателю.Организация <> &ПустаяОрганизация
	|	И СчетНаОплатуПокупателю.УдалитьЗаРуководителяПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СчетНаОплатуПокупателю.Организация,
	|	СчетНаОплатуПокупателю.ГлавныйБухгалтер,
	|	СчетНаОплатуПокупателю.УдалитьЗаГлавногоБухгалтераПоПриказу
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
	|ГДЕ
	|	СчетНаОплатуПокупателю.ГлавныйБухгалтер <> &ПустоеФизическоеЛицо
	|	И СчетНаОплатуПокупателю.Организация <> &ПустаяОрганизация
	|	И СчетНаОплатуПокупателю.УдалитьЗаГлавногоБухгалтераПоПриказу <> """"
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ФизическоеЛицо,
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДанныеРеквизитовПодписи.Организация,
	|	ВТ_ДанныеРеквизитовПодписи.ФизическоеЛицо,
	|	ВТ_ДанныеРеквизитовПодписи.Наименование
	|ИЗ
	|	ВТ_ДанныеРеквизитовПодписи КАК ВТ_ДанныеРеквизитовПодписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОснованияПраваПодписи КАК ОснованияПраваПодписи
	|		ПО (ОснованияПраваПодписи.Организация = ВТ_ДанныеРеквизитовПодписи.Организация)
	|			И (ОснованияПраваПодписи.Наименование = ВТ_ДанныеРеквизитовПодписи.Наименование)
	|			И (ОснованияПраваПодписи.ФизическоеЛицо = ВТ_ДанныеРеквизитовПодписи.ФизическоеЛицо)
	|ГДЕ
	|	ОснованияПраваПодписи.Ссылка ЕСТЬ NULL ";

	Запрос.УстановитьПараметр("ПустоеФизическоеЛицо",	Справочники.ФизическиеЛица.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяОрганизация",		Справочники.Организации.ПустаяСсылка());
	
	Выборка = Запрос.Выполнить().выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовыйЭлемент =  Справочники.ОснованияПраваПодписи.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НовыйЭлемент,Выборка);
		
		Попытка
			
			НовыйЭлемент.Записать();
			
		Исключение
			
			ШаблонСообщения = НСтр("ru = 'Не удалось записать элемент "" %1 ""
				| для физического лица "" %2 ""
				| по организации "" %3 ""
				| по причине:
				| %4'");
			
			ТекстСообщения = СтрШаблон(
				ШаблонСообщения,
				Выборка.Наименование,
				Выборка.ФизическоеЛицо,
				Выборка.Организация,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,,
				ТекстСообщения);

			
		КонецПопытки;

	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьОснованияПраваПодписиВДокументах() Экспорт
	
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УполномоченныеЛицаОрганизаций.Организация,
	|	УполномоченныеЛицаОрганизаций.ПодразделениеОрганизации,
	|	УполномоченныеЛицаОрганизаций.Пользователь КАК Пользователь,
	|	УполномоченныеЛицаОрганизаций.ЗаКогоПодписывает,
	|	УполномоченныеЛицаОрганизаций.УполномоченноеЛицо КАК УполномоченноеЛицо,
	|	"""" КАК УдалитьНомерДатаПриказа,
	|	ОснованияПраваПодписи.Ссылка КАК ОснованиеПраваПодписи
	|ИЗ
	|	РегистрСведений.УполномоченныеЛицаОрганизаций КАК УполномоченныеЛицаОрганизаций
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОснованияПраваПодписи КАК ОснованияПраваПодписи
	|		ПО УполномоченныеЛицаОрганизаций.УдалитьНомерДатаПриказа = ОснованияПраваПодписи.Наименование
	|			И УполномоченныеЛицаОрганизаций.Организация = ОснованияПраваПодписи.Организация
	|			И УполномоченныеЛицаОрганизаций.УполномоченноеЛицо = ОснованияПраваПодписи.ФизическоеЛицо
	|ГДЕ
	|	УполномоченныеЛицаОрганизаций.УдалитьНомерДатаПриказа <> """"
	|	И НЕ УполномоченныеЛицаОрганизаций.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УполномоченныеЛицаОрганизаций.Организация,
	|	УполномоченныеЛицаОрганизаций.ПодразделениеОрганизации,
	|	УполномоченныеЛицаОрганизаций.Пользователь,
	|	УполномоченныеЛицаОрганизаций.ЗаКогоПодписывает,
	|	УполномоченныеЛицаОрганизаций.УполномоченноеЛицо,
	|	УполномоченныеЛицаОрганизаций.УдалитьНомерДатаПриказа,
	|	УполномоченныеЛицаОрганизаций.ОснованиеПраваПодписи
	|ИЗ
	|	РегистрСведений.УполномоченныеЛицаОрганизаций КАК УполномоченныеЛицаОрганизаций
	|ГДЕ
	|	УполномоченныеЛицаОрганизаций.УдалитьНомерДатаПриказа = """"
	|	И НЕ УполномоченныеЛицаОрганизаций.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
	
	Набор = РегистрыСведений.УполномоченныеЛицаОрганизаций.СоздатьНаборЗаписей();
	
	Набор.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Попытка
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			
	Исключение
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось обновить значения оснований права подписи в регистре сведений ""Уполномоченные лица""
				|по причине:
				|%1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстСообщения);
		
	КонецПопытки;
		
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОказаниеУслуг.Ссылка КАК СсылкаНаДокумент,
	|	ОказаниеУслуг.Организация КАК Организация,
	|	ОказаниеУслуг.Исполнитель КАК ФизическоеЛицо,
	|	ОказаниеУслуг.УдалитьИсполнительПоПриказу КАК Наименование,
	|	""УдалитьИсполнительПоПриказу"" КАК ИмяСтарогоРеквизита,
	|	""ИсполнительНаОсновании"" КАК ИмяНовогоРеквизита
	|ПОМЕСТИТЬ ВТ_ДокументыДляЗаполнения
	|ИЗ
	|	Документ.ОказаниеУслуг КАК ОказаниеУслуг
	|ГДЕ
	|	ОказаниеУслуг.Исполнитель <> &ПустоеФизическоеЛицо
	|	И ОказаниеУслуг.Организация <> &ПустаяОрганизация
	|	И ОказаниеУслуг.УдалитьИсполнительПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктОбОказанииПроизводственныхУслуг.Ссылка,
	|	АктОбОказанииПроизводственныхУслуг.Организация,
	|	АктОбОказанииПроизводственныхУслуг.Исполнитель,
	|	АктОбОказанииПроизводственныхУслуг.УдалитьИсполнительПоПриказу,
	|	""УдалитьИсполнительПоПриказу"",
	|	""ИсполнительНаОсновании""
	|ИЗ
	|	Документ.АктОбОказанииПроизводственныхУслуг КАК АктОбОказанииПроизводственныхУслуг
	|ГДЕ
	|	АктОбОказанииПроизводственныхУслуг.Исполнитель <> &ПустоеФизическоеЛицо
	|	И АктОбОказанииПроизводственныхУслуг.Организация <> &ПустаяОрганизация
	|	И АктОбОказанииПроизводственныхУслуг.УдалитьИсполнительПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеализацияУслугПоПереработке.Ссылка,
	|	РеализацияУслугПоПереработке.Организация,
	|	РеализацияУслугПоПереработке.Исполнитель,
	|	РеализацияУслугПоПереработке.УдалитьИсполнительПоПриказу,
	|	""УдалитьИсполнительПоПриказу"",
	|	""ИсполнительНаОсновании""
	|ИЗ
	|	Документ.РеализацияУслугПоПереработке КАК РеализацияУслугПоПереработке
	|ГДЕ
	|	РеализацияУслугПоПереработке.Исполнитель <> &ПустоеФизическоеЛицо
	|	И РеализацияУслугПоПереработке.Организация <> &ПустаяОрганизация
	|	И РеализацияУслугПоПереработке.УдалитьИсполнительПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КорректировкаРеализации.Ссылка,
	|	КорректировкаРеализации.Организация,
	|	КорректировкаРеализации.Руководитель,
	|	КорректировкаРеализации.УдалитьЗаРуководителяПоПриказу,
	|	""УдалитьЗаРуководителяПоПриказу"",
	|	""ЗаРуководителяНаОсновании""
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|ГДЕ
	|	КорректировкаРеализации.Руководитель <> &ПустоеФизическоеЛицо
	|	И КорректировкаРеализации.Организация <> &ПустаяОрганизация
	|	И КорректировкаРеализации.УдалитьЗаРуководителяПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КорректировкаРеализации.Ссылка,
	|	КорректировкаРеализации.Организация,
	|	КорректировкаРеализации.ГлавныйБухгалтер,
	|	КорректировкаРеализации.УдалитьЗаГлавногоБухгалтераПоПриказу,
	|	""УдалитьЗаГлавногоБухгалтераПоПриказу"",
	|	""ЗаГлавногоБухгалтераНаОсновании""
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|ГДЕ
	|	КорректировкаРеализации.ГлавныйБухгалтер <> &ПустоеФизическоеЛицо
	|	И КорректировкаРеализации.Организация <> &ПустаяОрганизация
	|	И КорректировкаРеализации.УдалитьЗаГлавногоБухгалтераПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка,
	|	РеализацияТоваровУслуг.Организация,
	|	РеализацияТоваровУслуг.Руководитель,
	|	РеализацияТоваровУслуг.УдалитьЗаРуководителяПоПриказу,
	|	""УдалитьЗаРуководителяПоПриказу"",
	|	""ЗаРуководителяНаОсновании""
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Руководитель <> &ПустоеФизическоеЛицо
	|	И РеализацияТоваровУслуг.Организация <> &ПустаяОрганизация
	|	И РеализацияТоваровУслуг.УдалитьЗаРуководителяПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка,
	|	РеализацияТоваровУслуг.Организация,
	|	РеализацияТоваровУслуг.ГлавныйБухгалтер,
	|	РеализацияТоваровУслуг.УдалитьЗаГлавногоБухгалтераПоПриказу,
	|	""УдалитьЗаГлавногоБухгалтераПоПриказу"",
	|	""ЗаГлавногоБухгалтераНаОсновании""
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.ГлавныйБухгалтер <> &ПустоеФизическоеЛицо
	|	И РеализацияТоваровУслуг.Организация <> &ПустаяОрганизация
	|	И РеализацияТоваровУслуг.УдалитьЗаГлавногоБухгалтераПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СчетНаОплатуПокупателю.Ссылка,
	|	СчетНаОплатуПокупателю.Организация,
	|	СчетНаОплатуПокупателю.Руководитель,
	|	СчетНаОплатуПокупателю.УдалитьЗаРуководителяПоПриказу,
	|	""УдалитьЗаРуководителяПоПриказу"",
	|	""ЗаРуководителяНаОсновании""
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
	|ГДЕ
	|	СчетНаОплатуПокупателю.Руководитель <> &ПустоеФизическоеЛицо
	|	И СчетНаОплатуПокупателю.Организация <> &ПустаяОрганизация
	|	И СчетНаОплатуПокупателю.УдалитьЗаРуководителяПоПриказу <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СчетНаОплатуПокупателю.Ссылка,
	|	СчетНаОплатуПокупателю.Организация,
	|	СчетНаОплатуПокупателю.ГлавныйБухгалтер,
	|	СчетНаОплатуПокупателю.УдалитьЗаГлавногоБухгалтераПоПриказу,
	|	""УдалитьЗаГлавногоБухгалтераПоПриказу"",
	|	""ЗаГлавногоБухгалтераНаОсновании""
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
	|ГДЕ
	|	СчетНаОплатуПокупателю.ГлавныйБухгалтер <> &ПустоеФизическоеЛицо
	|	И СчетНаОплатуПокупателю.Организация <> &ПустаяОрганизация
	|	И СчетНаОплатуПокупателю.УдалитьЗаГлавногоБухгалтераПоПриказу <> """"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОснованияПраваПодписи.Ссылка КАК ОснованиеПраваПодписи,
	|	ВТ_ДокументыДляЗаполнения.Организация,
	|	ВТ_ДокументыДляЗаполнения.ФизическоеЛицо,
	|	ВТ_ДокументыДляЗаполнения.СсылкаНаДокумент КАК СсылкаНаДокумент,
	|	ВТ_ДокументыДляЗаполнения.ИмяСтарогоРеквизита,
	|	ВТ_ДокументыДляЗаполнения.ИмяНовогоРеквизита
	|ИЗ
	|	Справочник.ОснованияПраваПодписи КАК ОснованияПраваПодписи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ДокументыДляЗаполнения КАК ВТ_ДокументыДляЗаполнения
	|		ПО ОснованияПраваПодписи.Организация = ВТ_ДокументыДляЗаполнения.Организация
	|			И ОснованияПраваПодписи.Наименование = ВТ_ДокументыДляЗаполнения.Наименование
	|			И ОснованияПраваПодписи.ФизическоеЛицо = ВТ_ДокументыДляЗаполнения.ФизическоеЛицо
	|ИТОГИ ПО
	|	СсылкаНаДокумент";
	
	Запрос.УстановитьПараметр("ПустоеФизическоеЛицо",	Справочники.ФизическиеЛица.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяОрганизация",		Справочники.Организации.ПустаяСсылка());
	
	ВыборкаДокументов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокументов.Следующий() Цикл
	
		ДокументОбъект = ВыборкаДокументов.СсылкаНаДокумент.ПолучитьОбъект();
		
		ВыборкаРеквизитов = ВыборкаДокументов.Выбрать();
		Пока ВыборкаРеквизитов.Следующий() Цикл
			ДокументОбъект[ВыборкаРеквизитов.ИмяСтарогоРеквизита]	= "";
			ДокументОбъект[ВыборкаРеквизитов.ИмяНовогоРеквизита]	= ВыборкаРеквизитов.ОснованиеПраваПодписи;
		КонецЦикла;
		
		Попытка
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект);
			
		Исключение
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось обновить значение основания права подписи в документе ""%1""
					|по причине:
					|%2'"), 
				ВыборкаДокументов.СсылкаНаДокумент,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				,
				ВыборкаДокументов.СсылкаНаДокумент,
				ТекстСообщения);
			
		КонецПопытки;
			
	КонецЦикла;

КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицуОтветственныхЛицПоОтбору(Знач Отбор) 
	
	Если Отбор.Свойство("Дата") Тогда
		ДатаОтбора = НачалоДня(Отбор.Дата);
	иначе
		ДатаОтбора = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОснованияПраваПодписи.Ссылка КАК Основание
	|ИЗ
	|	Справочник.ОснованияПраваПодписи КАК ОснованияПраваПодписи
	|ГДЕ
	|	&ОтборОрганизация
	|	И &ОтборФизическоеЛицо
	|	И НЕ ОснованияПраваПодписи.ПометкаУдаления
	|	И ОснованияПраваПодписи.ДатаНачала <= &ОтборПоДате
	|	И (ОснованияПраваПодписи.ДатаОкончания >= &ОтборПоДате
	|			ИЛИ ОснованияПраваПодписи.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОснованияПраваПодписи.Наименование УБЫВ";
	
	ТекстОтбораОрганизация = "Истина";
	ТекстОтбораФизическоеЛицо = "Истина";
	Если Отбор.Свойство("Организация") Тогда
		Запрос.УстановитьПараметр("Организация", Отбор.Организация);
		ТекстОтбораОрганизация = "ОснованияПраваПодписи.Организация = &Организация";
	КонецЕсли;
	Если Отбор.Свойство("ФизическоеЛицо") Тогда
		Запрос.УстановитьПараметр("ФизическоеЛицо", Отбор.ФизическоеЛицо);
		ТекстОтбораФизическоеЛицо = "ОснованияПраваПодписи.ФизическоеЛицо = &ФизическоеЛицо";
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборОрганизация",    ТекстОтбораОрганизация);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборФизическоеЛицо", ТекстОтбораФизическоеЛицо);
	
	Запрос.УстановитьПараметр("ОтборПоДате",	ДатаОтбора);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
