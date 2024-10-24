﻿
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Процедура ПолучитьАдресВременногоФайла()
	
	АдресФайла = Неопределено;
	
	Если ВозможностьВыбораФайлов Тогда
		
		ПомещаемыеФайлы = Новый Массив;
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(Объект.ИмяФайлаДанных));
		
		ПомещениеФайловЗавершение = Новый ОписаниеОповещения("ПолучитьАдресВременногоФайлаЗавершение", ЭтотОбъект);
		
		НачатьПомещениеФайлов(ПомещениеФайловЗавершение, ПомещаемыеФайлы, Ложь, ЭтаФорма.УникальныйИдентификатор);
		
	Иначе
		
		Попытка
			ПомещениеФайлаЗавершение = Новый ОписаниеОповещения("ПомещениеФайлаЗавершение", ЭтотОбъект);
			НачатьПомещениеФайла(ПомещениеФайлаЗавершение, АдресФайла, , Истина, УникальныйИдентификатор);
		Исключение
			ТекстСообщения = НСтр("ru = 'Не удалось загрузить данные из указанного файла.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьАдресВременногоФайлаЗавершение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы<>Неопределено
		И ПомещенныеФайлы.Количество()>0 Тогда
		Попытка
			ОписаниеФайлов = ПомещенныеФайлы.Получить(0);
			АдресФайла = ОписаниеФайлов.Хранение;
			ЗагрузитьДанныеСинхронногоУчета(АдресФайла);
		Исключение
			ТекстСообщения = НСтр("ru = 'Не удалось загрузить данные из указанного файла.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если НЕ Форма.ВозможностьВыбораФайлов Тогда
		
		Элементы.ИмяФайлаДанных.Видимость = Ложь;
		Элементы.ГруппаИмяФайла.Видимость = Ложь;
		
		ТекстПояснения = "По кнопке ""Загрузить данные"" укажите путь к файлу, в который были 
		|выгружены данные из 1С:Бухгалтерии 7.7
		|
		|Файл должен быть предварительно сформирован в информационной базе
		|1С:Бухгалтерия 7.7 с помощью обработки ""Синхронизация данных с 1С:Бухгалтерией 8""";
	Иначе
		ТекстПояснения = "Файл должен быть предварительно сформирован в информационной базе
		|1С:Бухгалтерия 7.7 с помощью обработки ""Синхронизация данных с 1С:Бухгалтерией 8""";
	КонецЕсли;
	
	Элементы.ДекорацияПояснение.Заголовок = ТекстПояснения;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайлами() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайламиЗавершение(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	ВозможностьВыбораФайлов = РасширениеРаботыСФайламиПодключено;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайлаЗавершение(Результат, АдресФайлаПомещенный, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	ЗагрузитьДанныеСинхронногоУчета(АдресФайлаПомещенный);

КонецПроцедуры

&НаКлиенте
Процедура ВопросПолучениеОтветаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
					
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда		
		Закрыть();		
	Иначе
		ЗагрузитьДанныеСинхронногоУчета(ДополнительныеПараметры.АдресФайла);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеСинхронногоУчета(АдресФайла) Экспорт
	
	ТекстСообщения = "ru = 'Начало регламентной загрузки данных  из 1С:Бухгалтерии 7.7'";
	СинхронизацияДанныхV77ВызовСервера.ЗаписатьСообщениеВЖР(ТекстСообщения);
	
	Результат      = ВыполнитьЗагрузкуДанныхНаСервере(АдресФайла);
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		Если НЕ ПустаяСтрока(Результат.ВидДиалога) Тогда
			ВидДиалога = Результат.ВидДиалога;
			Если НЕ ПустаяСтрока(Результат.ТекстСообщения) Тогда
				ТекстСообщения = Результат.ТекстСообщения;
				
				Если ВидДиалога = "Предупреждение" Тогда
					ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьДанныеСинхронногоУчетаЗавершение", ЭтотОбъект);
					ПоказатьПредупреждение(ОписаниеОповещения, ТекстСообщения);
					Возврат;
				ИначеЕсли ВидДиалога = "Вопрос"	 Тогда
					ЗаголовокДиалога = "Расхождение данных";
					
					ДополнительныеПараметры = Новый Структура;
					ДополнительныеПараметры.Вставить("АдресФайла", АдресФайла);
					ОтветНаВопросЗавершение = Новый ОписаниеОповещения("ВопросПолучениеОтветаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
					ПоказатьВопрос(ОтветНаВопросЗавершение, ТекстСообщения, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да, ЗаголовокДиалога);
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Если Результат.ВебКлиент Тогда
			ИдентификаторЗадания = Результат.ИдентификаторЗадания;
			
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		Иначе
			Оповестить("СУСерверЗагрузкаЗавершена");
			ВывестиТаблицуСоответствий();
		КонецЕсли;
		
		Если НЕ Результат.ПоказатьТаблицуСоответствий Тогда
			ТекстСообщения = "ru = 'Данные загружены.'";
			Закрыть();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеСинхронногоУчетаЗавершение(Результат) Экспорт
	
	Закрыть();

КонецПроцедуры

&НаСервере
Функция ВыполнитьЗагрузкуДанныхНаСервере(АдресФайла)
	
	Результат = Новый Структура("ЗаданиеВыполнено, ВидДиалога, ТекстСообщения, НомерВыгрузки, ВебКлиент", Истина, "", "", 0, Ложь);
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
	
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайла);
	
	ИмяВременногоФайлаПравил  = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанныеФайлаПравил = Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ПолучитьМакет("ACC_xml");
	ДвоичныеДанныеФайлаПравил.Записать(ИмяВременногоФайлаПравил);
	
	ФайлОбмена = Новый ЧтениеXML();
	ФайлОбмена.ОткрытьФайл(ИмяВременногоФайлаПравил);
	
	Пока ФайлОбмена.Прочитать() Цикл
		Если ФайлОбмена.ЛокальноеИмя = "Источник" Тогда
			НомерРелиза77 =  ФайлОбмена.ПолучитьАтрибут("ВерсияКонфигурации");
		ИначеЕсли ФайлОбмена.ЛокальноеИмя = "Приемник" Тогда
			НомерРелиза8 =  ФайлОбмена.ПолучитьАтрибут("ВерсияКонфигурации");
			Прервать;				
		КонецЕсли;
	КонецЦикла;
	
	ВозрастРелизаПравил77 = Число(Прав(СокрЛП(НомерРелиза77), 3));
	ВозрастРелизаПравил8  = Число(Лев(СокрЛП(СтрЗаменить(НомерРелиза8, ".", "")), 4));
	
	ФайлОбмена = Новый ЧтениеXML();
	ФайлОбмена.ОткрытьФайл(ИмяВременногоФайла);
	ФайлОбмена.Прочитать();	
	
	НомерРелизаКонфигурации77   = ФайлОбмена.ПолучитьАтрибут("НомерРелиза");
	ВозрастРелизаКонфигурации77 = Число(Прав(СокрЛП(НомерРелизаКонфигурации77), 3));
	ВозрастРелизаКонфигурации8  = Число(Лев(СокрЛП(СтрЗаменить(Метаданные.Версия, ".", "")), 4));
	
	Если ВозрастРелизаПравил77 > ВозрастРелизаКонфигурации77 Тогда
		ТекстСообщения = НСтр("ru = 'Текущая версия правил предназначена для релиза конфигурации не ниже %1
		|Рекомендуется обновить релиз конфигурации информационной базы, из которой производится перенос данных.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НомерРелиза77);
		Результат.ЗаданиеВыполнено = Ложь;
		Результат.ВидДиалога = "";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Результат;
	КонецЕсли;
	
	Если ВозрастРелизаПравил8 > ВозрастРелизаКонфигурации8 Тогда
		ТекстСообщения = НСтр("ru = 'Текущая версия правил предназначена для релиза конфигурации не ниже %1
		|Рекомендуется обновить релиз конфигурации информационной базы,  в которую переносятся данные.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НомерРелиза8);
		Результат.ЗаданиеВыполнено = Ложь;
		Результат.ВидДиалога = "";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Результат;
	КонецЕсли;
	
	СтрОтветственный = СокрП(СинхронизацияДанныхV77ВызовСервера.ПолучитьПараметрСинхронизацииV77("ОтветственныйПользователь"));
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
	Если ЗначениеЗаполнено(СтрОтветственный) И (СтрОтветственный <> ПользовательИБ) Тогда
		ТекстСообщения = НСтр("ru = 'Только пользователь %1 может выполнять синхронизацию данных!'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрОтветственный);
		Результат.ЗаданиеВыполнено = Ложь;
		Результат.ВидДиалога = "";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Результат;
	КонецЕсли;
	
	ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
	
	ВебКлиент = Ложь;
	
	Если НЕ ПараметрыСоединения.Свойство("File") Тогда
		ВебКлиент = Истина;
	КонецЕсли;
	
	ЕстьОстатки                   = Число(ФайлОбмена.ПолучитьАтрибут("ЕстьОстатки"));
	НомерВыгрузки                 = Число(ФайлОбмена.ПолучитьАтрибут("НомерВыгрузки"));
	НомерКорректировочнойВыгрузки = Число(ФайлОбмена.ПолучитьАтрибут("НомерКорректировочнойВыгрузки"));
	Разница                       = ?(НомерКорректировочнойВыгрузки = 0, НомерВыгрузки - НомерЗагрузки, НомерКорректировочнойВыгрузки - НомерЗагрузки);
	
	Результат.ВебКлиент           = ВебКлиент;
	
	Если Разница = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Данные, которые Вы пытаетесь загрузить, уже имеются в информационной базе.
		|Прекратить загрузку данных?'");
		ФлагПовторнойЗагрузки      = Истина;
		Результат.ЗаданиеВыполнено = Ложь;
		Результат.ВидДиалога       = "Вопрос";
		Результат.ТекстСообщения   = ТекстСообщения;
		НомерЗагрузки              = НомерЗагрузки - 1;
		Возврат Результат;
	КонецЕсли;
	
	Если Разница > 1 ИЛИ (Разница < 0 И НомерКорректировочнойВыгрузки = 0) Тогда
		ТекстСообщения = НСтр("ru = 'Внимание! Данные не могут быть загружены.
		|Повторите выгрузку из 1С:Бухгалтерии 7.7, укажите при этом номер выгрузки %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НомерЗагрузки + 1);
		Результат.ЗаданиеВыполнено = Ложь;
		Результат.ВидДиалога       = "Предупреждение";
		Результат.ТекстСообщения   = ТекстСообщения;
		Возврат Результат;
	КонецЕсли;
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ДвоичныеДанныеФайла", ДвоичныеДанныеФайла);
	ПараметрыВыгрузки.Вставить("ОтчетТаблицаСоответствий", ОтчетТаблицаСоответствий);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Если ЕстьОстатки = 1 Тогда
			ПараметрыВыгрузки.Вставить("ВебКлиент", Истина);//для проведения документов
			Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ЗагрузитьДанныеВИБ(ПараметрыВыгрузки, АдресХранилища);
		Иначе
			Обработки.СинхронизацияДанныхV77.ЗагрузитьДанныеВИБ(ПараметрыВыгрузки, АдресХранилища);
		КонецЕсли;
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Загрузка данных из информационных баз 1С:Предприятия 7.7'");
		
		Если ЕстьОстатки = 1 Тогда
			РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			Новый УникальныйИдентификатор,
			"Обработки.ПереносДанныхИзИнформационныхБаз1СПредприятия77.ЗагрузитьДанныеВИБ", 
			ПараметрыВыгрузки, 
			НаименованиеЗадания);
		Иначе
			РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			Новый УникальныйИдентификатор,
			"Обработки.СинхронизацияДанныхV77.ЗагрузитьДанныеВИБ", 
			ПараметрыВыгрузки, 
			НаименованиеЗадания);
		КонецЕсли;
		
		АдресХранилища = РезультатВыполнения.АдресХранилища;
		Результат.Вставить("ИдентификаторЗадания", РезультатВыполнения.ИдентификаторЗадания);
	КонецЕсли;
	
	ПоказатьТаблицуСоответствий = Истина;
	
	Если Результат.ЗаданиеВыполнено И НЕ ВебКлиент Тогда
		ПоказатьТаблицуСоответствий = ЗагрузитьРезультат();
	КонецЕсли;
	
	Результат.Вставить("ПоказатьТаблицуСоответствий", ПоказатьТаблицуСоответствий);
	
	Возврат Результат;
	
КонецФункции	

&НаСервере
Процедура ВывестиТаблицуСоответствий()
	
	ТаблицаВывода = ОтчетТаблицаСоответствий;
	Элементы.ТаблицаВывода.ТолькоПросмотр = Истина;
	Элементы.ТаблицаВывода.ОтображатьЗаголовки = Ложь;
	Элементы.ТаблицаВывода.ОтображатьСетку = Ложь;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Объект.ИмяФайлаДанных = СинхронизацияДанныхV77ВызовСервера.ПолучитьПараметрСинхронизацииV77("ИмяФайлаДанных");
	НомерЗагрузки         = СинхронизацияДанныхV77ВызовСервера.ПолучитьПараметрСинхронизацииV77("НомерПоследнейЗагрузки");
	Элементы.СтраницыПереносДанных.ТекущаяСтраница = Элементы.СтраницаВыполнить;
	
	#Если ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ПодключениеРасширенияРаботыСФайлами", 0.1, Истина);
	#Иначе
		ЭтаФорма.ВозможностьВыбораФайлов = Истина;
		УправлениеФормой(ЭтотОбъект);
	#КонецЕсли
	
Конецпроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "СУСерверЗагрузкаЗавершена" Тогда
		Элементы.СтраницыПереносДанных.ТекущаяСтраница = Элементы.СтраницаОкончание;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ПоказатьТаблицуСоответствий = ЗагрузитьРезультат();				
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				
				Оповестить("СУСерверЗагрузкаЗавершена");
				
				Если ПоказатьТаблицуСоответствий Тогда
					ВывестиТаблицуСоответствий();
				Иначе
					ТекстСообщения = "ru = 'Данные загружены.'";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
					Закрыть();
				КонецЕсли;	
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ЗагрузитьРезультат()
	
	ПоказатьТаблицуСоответствий = Истина;
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ТекстСообщения = "ru = 'Окончание регламентной загрузки данных  из 1С:Бухгалтерии 7.7'";
	СинхронизацияДанныхV77ВызовСервера.ЗаписатьСообщениеВЖР(ТекстСообщения);
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда	
		Если Результат.Свойство("ОтчетТаблицаСоответствий",) Тогда
			ОтчетТаблицаСоответствий = Результат.ОтчетТаблицаСоответствий;
		Иначе
			ПоказатьТаблицуСоответствий = Ложь;
		КонецЕсли;
		СинхронизацияДанныхV77ВызовСервера.УстановитьПараметрСинхронизацииV77("НомерПоследнейЗагрузки", НомерВыгрузки);
	КонецЕсли;
	
	Возврат ПоказатьТаблицуСоответствий;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	Элементы.СтраницыПереносДанных.ТекущаяСтраница = Элементы.СтраницаПеренос;
	ПодключитьОбработчикОжидания("ПолучитьАдресВременногоФайла", 0.5, Истина);
	
КонецПроцедуры	

&НаКлиенте
Процедура ИмяФайлаДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);

	ДиалогВыбораФайла.Фильтр                      = "Файл данных (*.xml)|*.xml";
	ДиалогВыбораФайла.Заголовок                   = "Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр     = Ложь;
	ДиалогВыбораФайла.Расширение                  = "xml";
	ДиалогВыбораФайла.ИндексФильтра               = 0;	
	ДиалогВыбораФайла.ПолноеИмяФайла              = Элемент.ТекстРедактирования;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИмяФайлаДанныхНачалоВыбораЗавершение", ЭтотОбъект);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаДанныхНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	СтароеИмяФайла = Объект.ИмяФайлаДанных;
	
	Если ВыбранныеФайлы <> Неопределено 
		И ВыбранныеФайлы.Количество()>0 Тогда
		
		Объект.ИмяФайлаДанных = ВыбранныеФайлы.Получить(0);
		
	КонецЕсли;
	
	Если СтароеИмяФайла <> Объект.ИмяФайлаДанных Тогда
		СинхронизацияДанныхV77ВызовСервера.УстановитьПараметрСинхронизацииV77("ИмяФайлаДанных", Объект.ИмяФайлаДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
		
	СтароеИмяФайла = СинхронизацияДанныхV77ВызовСервера.ПолучитьПараметрСинхронизацииV77("ИмяФайлаДанных");
	
	Если СтароеИмяФайла <> Объект.ИмяФайлаДанных Тогда
		СинхронизацияДанныхV77ВызовСервера.УстановитьПараметрСинхронизацииV77("ИмяФайлаДанных", Объект.ИмяФайлаДанных);
	КонецЕсли;
	
КонецПроцедуры