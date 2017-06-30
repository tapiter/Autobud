﻿#Область ПрограммныйИнтерфейс

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.3.2.111");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "1.0";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Закрытие заказов на перемещение (по расписанию)'");
	НоваяКоманда.Идентификатор = "ДополнительнаяОбработка_ЗакрытиеЗаказовНаПеремещение";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	НоваяКоманда.ПоказыватьОповещение = Ложь;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	Если ИдентификаторКоманды = "ДополнительнаяОбработка_ЗакрытиеЗаказовНаПеремещение" Тогда
		ВыполнитьОбработку();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьОбработку() Экспорт
	
	Сообщить("Начало обработки: " + ТекущаяДата());
	
	ЗакрытьЗаказы();
	
	Сообщить("Окончание обработки: " + ТекущаяДата());
	
КонецПроцедуры

Процедура ЗакрытьЗаказы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказНаПеремещениеТовары.Ссылка КАК Ссылка,
		|	МАКСИМУМ(ЗаказНаПеремещениеТовары.ОкончаниеПоступления) КАК ОкончаниеПоступления
		|ПОМЕСТИТЬ ВТЗаказы
		|ИЗ
		|	Документ.ЗаказНаПеремещение.Товары КАК ЗаказНаПеремещениеТовары
		|ГДЕ
		|	НЕ ЗаказНаПеремещениеТовары.Ссылка.ПометкаУдаления
		|	И ЗаказНаПеремещениеТовары.Ссылка.Проведен
		|	И ЗаказНаПеремещениеТовары.Ссылка.Статус <> &Статус
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказНаПеремещениеТовары.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТЗаказы.Ссылка
		|ИЗ
		|	ВТЗаказы КАК ВТЗаказы
		|ГДЕ
		|	ВТЗаказы.ОкончаниеПоступления <= &ДатаПроверки";
	
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыВнутреннихЗаказов.Закрыт);
	ТекущийДень = НачалоДня(ТекущаяДатаСеанса());
	ДатаПроверки = ТекущийДень - (86400 * 7); // Отсчитываем назад 7 дней
	Запрос.УстановитьПараметр("ДатаПроверки", ДатаПроверки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выгрузить();
	
	Заказы = ВыборкаДетальныеЗаписи.ВыгрузитьКолонку("Ссылка");
	
	Если Заказы.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ШаблонОшибкиЗаблокировать     = НСтр("ru='Не удалось заблокировать %Документ%. %ОписаниеОшибки%'");
	ШаблонОшибкиЗаписать          = НСтр("ru='Не удалось записать %Документ%. %ОписаниеОшибки%'");
	УстановитьСтатусДокументов(Заказы, "Закрыт", Новый Структура("ОтменитьНеотработанныеСтроки", Истина));
	
КонецПроцедуры

// Устанавливает статус для списка документов
//
// Параметры:
// 		МассивДокументов - Массив - Массив документов
// 		НовыйСтатус - Строка - Имя нового статуса для документов
// 		ДополнительныеПараметры - Структура - Структура дополнительных параметров
//
// Возвращаемое значение:
// 		Число - Количество документов у которых был изменен статус
//
// ВАЖНО. При использования процедуры для каждого типа документа из массива должны быть объявлены функции:
// В модуле менеджера документа:
// 		Функция СформироватьЗапросПроверкиПриСменеСтатуса(МассивДокументов, НовыйСтатус, ДополнительныеПараметры) Экспорт
// 		Функция ПроверкаПередСменойСтатуса(ВыборкаПроверки, НовыйСтатус, ДополнительныеПараметры) Экспорт
// В модуле объекта документа:
// 		Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
//
Функция УстановитьСтатусДокументов(Знач МассивДокументов, Знач НовыйСтатус, Знач ДополнительныеПараметры=Неопределено)
	
	// Получение шаблонов сообщений стандартных ошибок
	ШаблонОшибкиСтатусСовпадает   = НСтр("ru='Документу %Документ% уже присвоен статус ""%Статус%""'");
	ШаблонОшибкиНеПроведен        = НСтр("ru='Документ %Документ% не проведен. Невозможно изменить статус'");
	ШаблонОшибкиПомеченНаУдаление = НСтр("ru='Документ %Документ% помечен на удаление. Невозможно изменить статус'");
	ШаблонОшибкиЗаблокировать     = НСтр("ru='Не удалось заблокировать %Документ%. %ОписаниеОшибки%'");
	ШаблонОшибкиЗаписать          = НСтр("ru='Не удалось записать %Документ%. %ОписаниеОшибки%'");
	
	// Получение исключаемых типов
	МассивИсключаемыхТипов = Новый Массив;
	Если ДополнительныеПараметры <> Неопределено 
		И ДополнительныеПараметры.Свойство("ИсключаемыеТипы") Тогда
		
		МассивИсключаемыхТипов = ДополнительныеПараметры.ИсключаемыеТипы;
		
	КонецЕсли;
	
	// Получение соответствие типов документов из массива документов разных типов
	СоответствиеТипов = ОбщегоНазначенияУТ.РазложитьМассивСсылокПоТипам(МассивДокументов);
	
	КоличествоОбработанных = 0;
	Для Каждого СоставДокументов Из СоответствиеТипов Цикл
		
		// Пропуск документов исключаемого типа
		Если МассивИсключаемыхТипов.Найти(СоставДокументов.Ключ) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		// Получение менеджера документов данного типа
		МенеджерДокументов = Документы[Метаданные.НайтиПоТипу(СоставДокументов.Ключ).Имя];
		
		// Получение массива ссылок документов данного типа
		МассивСсылок = СоставДокументов.Значение;
		
		// Формирование запроса
		Запрос = МенеджерДокументов.СформироватьЗапросПроверкиПриСменеСтатуса(МассивСсылок, НовыйСтатус, ДополнительныеПараметры);
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		Если Результат.Пустой() Тогда
			Возврат 0;
		КонецЕсли;
		
		// Цикл обхода выборки
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			// Универсальные проверки
			Если Выборка.ПометкаУдаления Тогда
				// Не нужно изменять статус документа.
				Продолжить;
			КонецЕсли;

			Если Не Выборка.Проведен Тогда
				// Не нужно изменять статус документа.
				Продолжить;
			КонецЕсли;

			Если Выборка.СтатусСовпадает Тогда
				// Не нужно изменять статус документа.
				Продолжить;
			КонецЕсли;
			
			// Проверки уникальные для каждого из типов документов
			Если Не МенеджерДокументов.ПроверкаПередСменойСтатуса(Выборка, НовыйСтатус, ДополнительныеПараметры) Тогда
				Продолжить;
			КонецЕсли;
			
			// Захват объекта для редактирования
			Попытка
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			Исключение
				ТекстОшибки = СтрЗаменить(ШаблонОшибкиЗаблокировать, "%Документ%", Выборка.Представление);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка,
					Выборка.Ссылка.Метаданные(),
					Выборка.Ссылка,
					ТекстОшибки);
				Продолжить;
			КонецПопытки;
			
			// Получение объекта документа
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			// Установка статуса документа
			Если Не Объект.УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Тогда
				Продолжить;
			КонецЕсли;
			
			// Запись документа
			Попытка
				Объект.Записать(?(Выборка.ЗаписьПроведением, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
				КоличествоОбработанных = КоличествоОбработанных + 1;
			Исключение
				ТекстОшибки = СтрЗаменить(ШаблонОшибкиЗаписать, "%Документ%", Выборка.Представление);
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка,
					Выборка.Ссылка.Метаданные(),
					Выборка.Ссылка,
					ТекстОшибки);
			КонецПопытки
			
		КонецЦикла; // выборки документов данного типа
		
	КонецЦикла; // обхода соответствия типов
	
	Возврат КоличествоОбработанных;
	
КонецФункции

#КонецОбласти