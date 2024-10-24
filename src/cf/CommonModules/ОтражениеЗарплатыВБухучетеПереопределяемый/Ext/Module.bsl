﻿////////////////////////////////////////////////////////////////////////////////
// Отражение зарплаты в регламентированном учете.
// Переопределяемое в потребителе поведение.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция предназначена для вычисления процента ЕНВД в текущем месяце по данным бухгалтерского учета.
// 
//
//	Параметры:
//	 Организация - СправочникСсылка.Организации,
//	 ПериодРегистрации - Дата, состав дата.
//
//	Возвращаемое значение:
//		Число или Неопределено
//
Функция ПроцентЕНВД(Организация, ПериодРегистрации) Экспорт
	
	Если УчетнаяПолитика.ПлательщикЕНВД(Организация, ПериодРегистрации) Тогда
		
		Если УчетнаяПолитика.ПрименяетсяУСН(Организация, ПериодРегистрации) Тогда
			
			МетодРаспределения = УчетнаяПолитика.МетодРаспределенияРасходовУСНПоВидамДеятельности(Организация, ПериодРегистрации);
			
			БазаРаспределения = УчетнаяПолитика.БазаРаспределенияРасходовУСНПоВидамДеятельности(Организация, ПериодРегистрации);
			
			Если МетодРаспределения = Перечисления.МетодыРаспределенияРасходовУСНПоВидамДеятельности.НарастающимИтогомСНачалаГода Тогда
				Метод = "Год";
			Иначе
				Метод = "Квартал";
			КонецЕсли;
			
			Если БазаРаспределения = Перечисления.БазаРаспределенияРасходовУСНПоВидамДеятельности.ДоходыВсегоНУ Тогда
				База = "НВ";
			ИначеЕсли БазаРаспределения = Перечисления.БазаРаспределенияРасходовУСНПоВидамДеятельности.ДоходыПринимаемыеНУ Тогда
				База = "НУ";
			Иначе
				База = "БУ";
			КонецЕсли;
			
			СтруктураПараметров = Новый Структура("Дата, Организация", КонецМесяца(ПериодРегистрации), Организация);
			
			Возврат НалоговыйУчетУСН.ПолучитьКоэффРаспределенияЕНВД(СтруктураПараметров, Метод, База)*100;
		Иначе
			Возврат НалоговыйУчет.КоэффициентРаспределенияРасходовПоВидамДеятельности(Организация,
																						НачалоМесяца(ПериодРегистрации),
																						КонецМесяца(ПериодРегистрации))*100;
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Процедура предназначена для формирования движений по бухучету.
//
// Параметры:
//	Движения - Коллекция движений документа, 
//	Отказ - булево, признак отказа от проведения документа.
//	Организация - СправочникСсылка.Организации.
//	МесяцНачисления - тип Дата, месяц, зарплата которого отражается в бухучете.
//	ДанныеДляОтражения - структура. Таблицы значений с данными, которые 
//						могут использоваться для формирования движений по бухучету.
//						При вызове процедуры ДанныеДляОтражения может содержать 
//						одно или несколько полей с приведенными ниже именами, т.е.
//						Необходимо проверять наличие того или иного элемента структуры.
//
//		Имена полей структуры ДанныеДляОтражения (таблиц значений):
//			НачисленнаяЗарплатаИВзносы
//			НачисленныйНДФЛ
//			УдержаннаяЗарплата
//			ОценочныеОбязательства - эта таблица формируется документом НачислениеОценочныхОбязательствПоОтпускам
//			Депоненты - эта таблица формируется документом Депонирование.
//
//		Структура таблиц значений:
//			НачисленнаяЗарплатаИВзносы.
//				ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//				Подразделение  - СправочникСсылка.ПодразделенияОрганизаций
//				ВидОперации    - ПеречислениеСсылка.ВидыОперацийПоЗарплате
//				СтатьяРасходов - СправочникСсылка.СтатьиРасходовЗарплата
//				СпособОтраженияЗарплатыВБухучете- СправочникСсылка.СпособыОтраженияЗарплатыВБухУчете
//				ОблагаетсяЕНВД - булево
//				ПериодПринятияРасходов - Дата, для учета РБП, определяет месяц, к которому относятся расходы. Передается дата
//				                         начала месяца.
//				ВидНачисленияОплатыТрудаДляНУ - ПеречислениеСсылка.ВидыНачисленийОплатыТрудаДляНУ
//				Сумма - Число 15.2
//				ПФРПоСуммарномуТарифу - Число 15.2   
//				ПФРСПревышения - Число 15.2
//				ПФРСтраховая - Число 15.2
//				ПФРНакопительная - Число 15.2
//				ФСС - Число 15.2
//				ФФОМС - Число 15.2
//				ТФОМС - Число 15.2
//				ПФРНаДоплатуЛетчикам - Число 15.2
//				ПФРНаДоплатуШахтерам - Число 15.2
//				ПФРЗаЗанятыхНаПодземныхИВредныхРаботах - Число 15.2
//				ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах - Число 15.2
//				ФССНесчастныеСлучаи - Число 15.2.
//				ПФРДоПредельнойВеличины - Число 15.2.
//				ПФРЗаЗанятыхНаПодземныхИВредныхРаботахБезСпецОценки - Число 15.2.
//				ПФРЗаЗанятыхНаПодземныхИВредныхРаботахСпецОценка - Число 15.2.
//				ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахБезСпецОценки - Число 15.2.
//				ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахСпецОценка - Число 15.2.
//				ВзносыПоЕдиномуТарифу - Число 15.2.
//				
//			НачисленныйНДФЛ
//				ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//				ВидОперации    - ПеречислениеСсылка.ВидыОперацийПоЗарплате
//				СтатьяРасходов - СправочникСсылка.СтатьиРасходовЗарплата
//				КодПоОКАТО     - Строка, 11
//				КодПоОКТМО     - Строка, 11
//				КПП   - Строка, 9
//				КодНалоговогоОргана - Строка, 4
//				Сумма - Число 15.2
//				РегистрацияВНалоговомОргане - СправочникСсылка.РегистрацияВНалоговомОргане
//												поле может быть не заполнено, тогда регистрацию надо вычислять по КодПоОКАТО,КодПоОКТМО,КПП,КодНалоговогоОргана.
//				
//			УдержаннаяЗарплата
//				ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//				Подразделение  - СправочникСсылка.ПодразделенияОрганизаций
//				ВидОперации    - ПеречислениеСсылка.ВидыОперацийПоЗарплате
//				СтатьяРасходов - СправочникСсылка.СтатьиРасходовЗарплата
//				Контрагент     - СправочникСсылка.Контрагенты, контрагент, в пользу которого произведено удержание.
//				Сумма          - Число 15.2.
//				ОписаниеУдержанияДляЧека - Строка.
//				ЯвляетсяОснованиемОформленияКассовогоЧека - Булево.
//				ДокументОснование - ОпределяемыйТип.ОснованиеУдержания
//				
//			ОценочныеОбязательства
//				Подразделение  - СправочникСсылка.ПодразделенияОрганизаций
//				СпособОтраженияЗарплатыВБухучете- СправочникСсылка.СпособыОтраженияЗарплатыВБухУчете
//				СуммаРезерва - Число 15.2
//				СуммаРезерваСтраховыхВзносов - Число 15.2
//				СуммаРезерваНУ - Число 15.2
//				СуммаРезерваСтраховыхВзносовНУ - Число 15.2
//				СуммаРезерваФССНесчастныеСлучаи - Число 15.2
//				СуммаРезерваФССНесчастныеСлучаиНУ - Число 15.2.
//                             
Процедура СформироватьДвижения(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляОтражения) Экспорт
	
	УчетЗарплаты.СформироватьДвиженияПоОтражениюЗарплатыВРегламентированномУчете(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляОтражения);
	
КонецПроцедуры

// Процедура предназначена для управления актуализацией данных бухучета при изменении процента ЕНВД.
//
// Параметры:
//	Организация     - СправочникСсылка.Организации.
//	МесяцНачисления - Дата -  месяц, в котором меняется процент ЕНВД.
//
Процедура УправлениеДолейЕНВД(Организация, МесяцНачисления) Экспорт
	
	Период = НачалоМесяца(МесяцНачисления);
	МоментВремениПервогоДокумента = РаботаСПоследовательностями.МоментВремениПервогоДокументаВПоследовательности(Организация, Период);
	Если МоментВремениПервогоДокумента <> Неопределено Тогда
		РаботаСПоследовательностями.СброситьСостояниеПоследовательностиДокумента(МоментВремениПервогоДокумента.Ссылка, Период, Организация);
	КонецЕсли;
	
КонецПроцедуры

// Подтверждение требуется, если используется обмен в формате ED.
// Уточняется значение ТребуетсяУтверждение.
//
Процедура ТребуетсяУтверждениеДокументаБухгалтером(Организация, ТребуетсяУтверждение) Экспорт
	
	Если Не ТребуетсяУтверждение И ПолучитьФункциональнуюОпцию("УчетЗарплатыИКадровВоВнешнейПрограмме") Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменДаннымиУниверсальныйФормат") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиУниверсальныйФормат");
			ТребуетсяУтверждение = Модуль.ИспользуетсяОбменБП3(Организация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
