﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает массив категорий пособий, которые после вступления в прямые выплаты выплачиваются напрямую ФСС.
//
// Возвращаемое значение:
//   Массив
//
Функция КатегорииПрямыхВыплатФСС() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(ОплатаБольничногоЛиста);
	Массив.Добавить(ОплатаБольничногоНесчастныйСлучайНаПроизводстве);
	Массив.Добавить(ОплатаБольничногоПрофзаболевание);
	Массив.Добавить(ОтпускПоБеременностиИРодам);
	Возврат Массив;
КонецФункции

#КонецОбласти

#КонецЕсли