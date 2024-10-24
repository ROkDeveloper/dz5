﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

Процедура НастроитьСписокПравДоступа(Форма, СписокИмяЭлемента, ПрефиксИменПолейСписка = "") Экспорт
	
	МетаПраваДоступаВЕТИС   = Новый Массив();
	ТекстВыборкиВремТаблицы = "";
	ТекствВыборкиЗапроса    = "";
	
	Для Каждого МетаПравоДоступа Из Метаданные.Перечисления.ПраваДоступаВЕТИС.ЗначенияПеречисления Цикл
		ПравоДоступаИмя = МетаПравоДоступа.Имя;
		
		ТекстВыборкиВремТаблицы = ТекстВыборкиВремТаблицы + ?(ПустаяСтрока(ТекстВыборкиВремТаблицы), "", ",") + "
		|	ЗНАЧЕНИЕ(Перечисление.ПраваДоступаВЕТИС." + ПравоДоступаИмя + ") КАК " + ПравоДоступаИмя;
		
		ТекствВыборкиЗапроса = ТекствВыборкиЗапроса + ?(ПустаяСтрока(ТекствВыборкиЗапроса), "", ",") + "
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ПраваДоступаПользователей.ПравоДоступа = ПраваДоступа." + ПравоДоступаИмя + " ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ) КАК " + ПравоДоступаИмя;
		
		МетаПраваДоступаВЕТИС.Добавить(МетаПравоДоступа);
	КонецЦикла;
	
	ТекстЗапроса = "ВЫБРАТЬ" + ТекстВыборкиВремТаблицы + "
	|ПОМЕСТИТЬ
	|	ВремТаблПраваДоступаВЕТИС
	|
	|;
	|
	|ВЫБРАТЬ" + ТекствВыборкиЗапроса + ",
	|	ПраваДоступаПользователей.ХозяйствующийСубъект           КАК ХозяйствующийСубъект,
	|	ПраваДоступаПользователей.ПользовательВЕТИС              КАК ПользовательВЕТИС,
	|	ПраваДоступаПользователей.ПользовательВЕТИС.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.ПраваДоступаПользователейВЕТИС КАК ПраваДоступаПользователей
	|	,
	|	ВремТаблПраваДоступаВЕТИС КАК ПраваДоступа
	|СГРУППИРОВАТЬ ПО
	|	ПраваДоступаПользователей.ХозяйствующийСубъект,
	|	ПраваДоступаПользователей.ПользовательВЕТИС
	|";
	
	СвойстваДинамическогоСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваДинамическогоСписка.ДинамическоеСчитываниеДанных = Ложь;
	СвойстваДинамическогоСписка.ОсновнаяТаблица              = "";
	СвойстваДинамическогоСписка.ТекстЗапроса                 = ТекстЗапроса;
	
	СписокЭлемент = Форма.Элементы[СписокИмяЭлемента];
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(СписокЭлемент, СвойстваДинамическогоСписка);
	
	НастройкиПредставленияПрав = Перечисления.ПраваДоступаВЕТИС.НастройкиПредставленияПравДоступаВЕТИС();
	
	Для Каждого МетаПравоДоступа Из МетаПраваДоступаВЕТИС Цикл
		ПравоДоступаИмя = МетаПравоДоступа.Имя;
		НастройкаПредставления = НастройкиПредставленияПрав.Найти(ПравоДоступаИмя, "ПравоДоступа");
		
		Если НастройкаПредставления = Неопределено Тогда
			
			ПолеСписка = Форма.Элементы.Вставить(ПрефиксИменПолейСписка + ПравоДоступаИмя, Тип("ПолеФормы"), СписокЭлемент);
			ПолеСписка.Вид = ВидПоляФормы.ПолеКартинки;
			ПолеСписка.ПутьКДанным = СписокЭлемент.ПутьКДанным + "." + ПравоДоступаИмя;
			ПолеСписка.КартинкаЗначений = БиблиотекаКартинок.СтатусыПраваДоступаГосИС;
			ПолеСписка.Подсказка = МетаПравоДоступа.Синоним;
			ПолеСписка.Видимость = Истина;
			ПолеСписка.Ширина = 5;
			
		Иначе
			
			Если ЗначениеЗаполнено(НастройкаПредставления.ИмяГруппы) Тогда
				ИмяГруппы = ПрефиксИменПолейСписка + "Группа" + СтрЗаменить(НастройкаПредставления.ИмяГруппы, " ", "");
				ГруппаКолонок = Форма.Элементы.Найти(ИмяГруппы);
				Если ГруппаКолонок = Неопределено Тогда
					ГруппаКолонок = Форма.Элементы.Вставить(ИмяГруппы, Тип("ГруппаФормы"), СписокЭлемент);
					ГруппаКолонок.Вид = ВидГруппыФормы.ГруппаКолонок;
					ГруппаКолонок.Группировка = ГруппировкаКолонок.Горизонтальная;
					ГруппаКолонок.Заголовок = НастройкаПредставления.ИмяГруппы;
					ГруппаКолонок.ОтображатьВШапке = Истина;
					ГруппаКолонок.ОтображатьЗаголовок = Истина;
				КонецЕсли;
			Иначе
				ГруппаКолонок = СписокЭлемент;
			КонецЕсли;
			
			ПолеСписка = Форма.Элементы.Вставить(ПрефиксИменПолейСписка + ПравоДоступаИмя, Тип("ПолеФормы"), ГруппаКолонок);
			ПолеСписка.Вид = ВидПоляФормы.ПолеКартинки;
			ПолеСписка.ПутьКДанным = СписокЭлемент.ПутьКДанным + "." + ПравоДоступаИмя;
			ПолеСписка.КартинкаЗначений = БиблиотекаКартинок.СтатусыПраваДоступаГосИС;
			ПолеСписка.Заголовок = НастройкаПредставления.Заголовок;
			ПолеСписка.Подсказка = НастройкаПредставления.Подсказка;
			ПолеСписка.Ширина = 5;
		
			Если Форма.ОсновныеПраваДоступа Тогда
				ПолеСписка.Видимость = НастройкаПредставления.Значимое;
			Иначе
				ПолеСписка.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли
