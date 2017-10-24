﻿
#Область ПрограммныйИнтерфейс

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.3.2.53"); // СтандартныеПодсистемыСервер.ВерсияБиблиотеки()
	
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "1.4";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Оформление передач (возвратов) товаров'");
	НоваяКоманда.Идентификатор = "ДополнительнаяОбработка_ОформлениеПередачВозвратовТоваров";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	НоваяКоманда.ПоказыватьОповещение = Ложь;
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Оформление передач (возвратов) товаров (по расписанию)'");
	НоваяКоманда.Идентификатор = "ДополнительнаяОбработка_ОформлениеПередачВозвратовТоваровПоРасписанию";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	НоваяКоманда.ПоказыватьОповещение = Ложь;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	Если ИдентификаторКоманды = "ДополнительнаяОбработка_ОформлениеПередачВозвратовТоваровПоРасписанию" Тогда
		ВыполнитьОбработку(НачалоМесяца(ТекущаяДата()), КонецМесяца(ТекущаяДата()));
	КонецЕсли;
  
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьОбработку(НачалоПериода, КонецПериода) Экспорт
	
	Сообщить("Начало обработки: " + ТекущаяДата());
	
	СоздатьДокументыПоТоварамКПередачеТиповойАлгоритм(НачалоПериода, КонецПериода);
	//СоздатьДокументыПоОтрицательнымОстаткамТиповойАлгоритм(НачалоПериода, КонецПериода);
	СоздатьДокументыПоОтрицательнымОстаткам(КонецПериода);
	
	Сообщить("Окончание обработки: " + ТекущаяДата());
	
КонецПроцедуры

Процедура СоздатьДокументыПоТоварамКПередачеТиповойАлгоритм(НачалоПериода, КонецПериода)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПередачаТоваровМеждуОрганизациями.Ссылка КАК Документ
	               |ИЗ
	               |	Документ.ПередачаТоваровМеждуОрганизациями КАК ПередачаТоваровМеждуОрганизациями
	               |ГДЕ
	               |	ПередачаТоваровМеждуОрганизациями.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	               |	И Не ПередачаТоваровМеждуОрганизациями.ПометкаУдаления
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ВозвратТоваровМеждуОрганизациями.Ссылка
	               |ИЗ
	               |	Документ.ВозвратТоваровМеждуОрганизациями КАК ВозвратТоваровМеждуОрганизациями
	               |ГДЕ
	               |	ВозвратТоваровМеждуОрганизациями.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	               |	И Не ВозвратТоваровМеждуОрганизациями.ПометкаУдаления
				   |";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		ВыборкаДокументов = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДокументов.Следующий() Цикл 
			Док = ВыборкаДокументов.Документ.ПолучитьОбъект();
			Док.УстановитьПометкуУдаления(Истина);
			Док.Записать();
		КонецЦикла;
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЗаПериод.ПериодМесяц КАК Месяц,
	               |	ВЫБОР
	               |		КОГДА ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	               |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию)
	               |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию)
	               |	КОНЕЦ КАК ХозяйственнаяОперация,
	               |	ЗаПериод.ВидЗапасовПродавца.НалогообложениеНДС КАК ПередачаПодДеятельность,
	               |	СпрСклады.Ссылка КАК Склад,
	               |	ЗаПериод.ОрганизацияВладелец КАК Отправитель,
	               |	ВидЗапасов.Организация КАК Получатель,
	               |	ВидЗапасов.ТипЗапасов КАК ТипЗапасов
	               |ИЗ
	               |	РегистрНакопления.ТоварыОрганизацийКПередаче.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, Авто, , ) КАК ЗаПериод
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидЗапасов
	               |		ПО ЗаПериод.ВидЗапасовПродавца = ВидЗапасов.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизацийКПередаче.Остатки(, ) КАК НаСейчас
	               |		ПО ЗаПериод.АналитикаУчетаНоменклатуры = НаСейчас.АналитикаУчетаНоменклатуры
	               |			И ЗаПериод.НомерГТД = НаСейчас.НомерГТД
	               |			И ЗаПериод.ВидЗапасовПродавца = НаСейчас.ВидЗапасовПродавца
	               |			И ЗаПериод.ОрганизацияВладелец = НаСейчас.ОрганизацияВладелец
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	               |		ПО (Аналитика.КлючАналитики = ЗаПериод.АналитикаУчетаНоменклатуры)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК СпрСклады
	               |		ПО (Аналитика.Склад = СпрСклады.Ссылка)
	               |ГДЕ
	               |	ЕСТЬNULL(НаСейчас.КоличествоОстаток, 0) > 0
	               |	И ЗаПериод.КоличествоКонечныйОстаток > 0
	               |	И ЗаПериод.КоличествоКонечныйОстаток > ЗаПериод.КоличествоНачальныйОстаток
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЗаПериод.ПериодМесяц,
	               |	ВЫБОР
	               |		КОГДА ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	               |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями)
	               |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями)
	               |	КОНЕЦ,
	               |	ЗаПериод.ВидЗапасовПродавца.НалогообложениеНДС,
	               |	СпрСклады.Ссылка,
	               |	ВидыЗапасов.Организация,
	               |	ЗаПериод.ОрганизацияВладелец,
	               |	ВидыЗапасов.ТипЗапасов
	               |ИЗ
	               |	РегистрНакопления.ТоварыОрганизацийКПередаче.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, Авто, , ) КАК ЗаПериод
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасов
	               |		ПО ЗаПериод.ВидЗапасовПродавца = ВидыЗапасов.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизацийКПередаче.Остатки(, ) КАК НаСейчас
	               |		ПО ЗаПериод.АналитикаУчетаНоменклатуры = НаСейчас.АналитикаУчетаНоменклатуры
	               |			И ЗаПериод.НомерГТД = НаСейчас.НомерГТД
	               |			И ЗаПериод.ВидЗапасовПродавца = НаСейчас.ВидЗапасовПродавца
	               |			И ЗаПериод.ОрганизацияВладелец = НаСейчас.ОрганизацияВладелец
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	               |		ПО (Аналитика.КлючАналитики = ЗаПериод.АналитикаУчетаНоменклатуры)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК СпрСклады
	               |		ПО (Аналитика.Склад = СпрСклады.Ссылка)
	               |ГДЕ
	               |	ЕСТЬNULL(НаСейчас.ВозвращеноОстаток, 0) > 0
	               |	И ЗаПериод.ВозвращеноКонечныйОстаток > 0
	               |	И ЗаПериод.ВозвращеноКонечныйОстаток > ЗаПериод.ВозвращеноНачальныйОстаток";

	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	Строка = РезультатЗапроса.Выбрать();
	Пока Строка.Следующий() Цикл
		СтруктураОснование = Новый Структура;
		СтруктураОснование.Вставить("Организация",				Строка.Отправитель);
		СтруктураОснование.Вставить("ОрганизацияПолучатель",	Строка.Получатель);
		СтруктураОснование.Вставить("Склад",					Строка.Склад);
		СтруктураОснование.Вставить("ПередачаПодДеятельность",	Строка.ПередачаПодДеятельность);
		СтруктураОснование.Вставить("ТипЗапасов",				Строка.ТипЗапасов);
		СтруктураОснование.Вставить("НачалоПериода",			?(ЗначениеЗаполнено(Строка.Месяц), НачалоМесяца(Строка.Месяц), НачалоПериода));
		СтруктураОснование.Вставить("КонецПериода",				?(ЗначениеЗаполнено(Строка.Месяц), КонецМесяца(Строка.Месяц), КонецПериода));
		СтруктураОснование.Вставить("ЗаполнятьПоСхеме",			Истина);
		СтруктураОснование.Вставить("ХозяйственнаяОперация",	Строка.ХозяйственнаяОперация);
		СтруктураОснование.Вставить("ДатаОформления",			Неопределено);
		
		Если    Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию")
			Или Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию")
		Тогда
			СоздатьДокументНаОсновании(СтруктураОснование, "ПередачаТоваровМеждуОрганизациями");
		ИначеЕсли Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями")
			  Или Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями")
		Тогда
			СоздатьДокументНаОсновании(СтруктураОснование, "ВозвратТоваровМеждуОрганизациями");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

Процедура СоздатьДокументыПоОтрицательнымОстаткамТиповойАлгоритм(НачалоПериода, КонецПериода)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала", НачалоПериода);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецПериода);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	ТоварыОрганизаций.Получатель КАК Получатель,
	               |	ТоварыОрганизаций.Отправитель КАК Отправитель,
	               |	ТоварыОрганизаций.АналитикаУчетаНоменклатуры.Склад КАК Склад,
	               |	ТоварыОрганизаций.Период КАК Период
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ТаблицаТоваровВНаличии.Организация КАК Отправитель,
	               |		ТоварыОрганизаций.Организация КАК Получатель,
	               |		ТоварыОрганизаций.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	               |		ТоварыОрганизаций.Период КАК Период
	               |	ИЗ
	               |		РегистрНакопления.ТоварыОрганизаций.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, Месяц, , ) КАК ТоварыОрганизаций
	               |			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |				ТоварыОрганизаций.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	               |				ТоварыОрганизаций.Период КАК Период
	               |			ИЗ
	               |				РегистрНакопления.ТоварыОрганизаций.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, Месяц, , ) КАК ТоварыОрганизаций
	               |			ГДЕ
	               |				ТоварыОрганизаций.КоличествоКонечныйОстаток < 0
	               |				И ТоварыОрганизаций.КоличествоНачальныйОстаток <> ТоварыОрганизаций.КоличествоКонечныйОстаток) КАК ТаблицаОтсутствующихТоваров
	               |			ПО ТоварыОрганизаций.АналитикаУчетаНоменклатуры = ТаблицаОтсутствующихТоваров.АналитикаУчетаНоменклатуры
	               |				И ТоварыОрганизаций.Период = ТаблицаОтсутствующихТоваров.Период
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |				ТоварыОрганизаций.Организация КАК Организация,
	               |				ТоварыОрганизаций.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	               |			ИЗ
	               |				РегистрНакопления.ТоварыОрганизаций.Остатки(, ) КАК ТоварыОрганизаций
	               |			ГДЕ
	               |				ТоварыОрганизаций.КоличествоОстаток > 0) КАК ТаблицаТоваровВНаличии
	               |			ПО ТоварыОрганизаций.Организация <> ТаблицаТоваровВНаличии.Организация
	               |				И ТоварыОрганизаций.АналитикаУчетаНоменклатуры = ТаблицаТоваровВНаличии.АналитикаУчетаНоменклатуры
	               |	ГДЕ
	               |		ТоварыОрганизаций.КоличествоКонечныйОстаток < 0
	               |		И ТоварыОрганизаций.КоличествоНачальныйОстаток <> ТоварыОрганизаций.КоличествоКонечныйОстаток
	               |		И ТаблицаОтсутствующихТоваров.Период ЕСТЬ NULL ) КАК ТоварыОрганизаций
	               |";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();

		Пока Выборка.Следующий() Цикл
			Док = Документы.ПередачаТоваровМеждуОрганизациями.СоздатьДокумент();
			
			СтруктураОснование = Новый Структура("Дата, Организация, ОрганизацияПолучатель, Склад, ЗаполнятьПоОтрицательнымОстаткам",
				КонецМесяца(Выборка.Период),
				Выборка.Отправитель,
				Выборка.Получатель,
				Выборка.Склад,
				Истина);
			СоздатьДокументНаОсновании(СтруктураОснование, "ПередачаТоваровМеждуОрганизациями");
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьДокументыПоОтрицательнымОстаткам(Дата)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТоварыОрганизацийОстатки.Организация,
	               |	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	               |	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	               |	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Склад КАК Склад,
	               |	СУММА(ТоварыОрганизацийОстатки.КоличествоОстаток) КАК Количество
	               |ПОМЕСТИТЬ Остатки
	               |ИЗ
	               |	РегистрНакопления.ТоварыОрганизаций.Остатки(ДОБАВИТЬКДАТЕ(&Дата, СЕКУНДА, 1), ) КАК ТоварыОрганизацийОстатки
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТоварыОрганизацийОстатки.Организация,
	               |	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Номенклатура,
	               |	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Склад,
	               |	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Характеристика
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Остатки.Организация,
	               |	Остатки.Склад,
	               |	Остатки.Номенклатура,
	               |	Остатки.Характеристика,
	               |	-Остатки.Количество КАК Количество
	               |ИЗ
	               |	Остатки КАК Остатки
	               |ГДЕ
	               |	Остатки.Количество < 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Остатки.Организация,
	               |	Остатки.Склад,
	               |	Остатки.Номенклатура,
	               |	Остатки.Характеристика,
	               |	Остатки.Количество
	               |ИЗ
	               |	Остатки КАК Остатки
	               |ГДЕ
	               |	Остатки.Количество > 0";
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ОтрицательныеОстатки = МассивРезультатов[1].Выгрузить();
	ПоложительныеОстатки = МассивРезультатов[2].Выгрузить();
	
	ТаблицаПередач = Новый ТаблицаЗначений;
	ТаблицаПередач.Колонки.Добавить("ОрганизацияПолучатель", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаПередач.Колонки.Добавить("ОрганизацияОтправитель", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаПередач.Колонки.Добавить("Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	ТаблицаПередач.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаПередач.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаПередач.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15,3)));
	
	Для Каждого СтрокаПолучателя Из ОтрицательныеОстатки Цикл
		Количество = 0;
		
		СтрокиОтправителей = ПоложительныеОстатки.НайтиСтроки(Новый Структура("Склад, Номенклатура, Характеристика", 
		                     СтрокаПолучателя.Склад, СтрокаПолучателя.Номенклатура, СтрокаПолучателя.Характеристика));
		
		Для Каждого СтрокаОтправителя Из СтрокиОтправителей Цикл
			Если СтрокаОтправителя.Количество > 0 И СтрокаПолучателя.Количество > Количество Тогда
				Требуется = СтрокаПолучателя.Количество - Количество;
				
				Добавляем = ?(Требуется > СтрокаОтправителя.Количество, СтрокаОтправителя.Количество, Требуется);
				
				Количество = Количество + Добавляем;
				
				Стр = ТаблицаПередач.Добавить();
				Стр.ОрганизацияПолучатель = СтрокаПолучателя.Организация;
				Стр.ОрганизацияОтправитель = СтрокаОтправителя.Организация;
				Стр.Склад = СтрокаПолучателя.Склад;
				Стр.Номенклатура = СтрокаПолучателя.Номенклатура;
				Стр.Характеристика = СтрокаПолучателя.Характеристика;
				Стр.Количество = Добавляем;
				
				СтрокаОтправителя.Количество = СтрокаОтправителя.Количество - Добавляем;
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;
	
	Если ТаблицаПередач.Количество() Тогда
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ ТаблицаПередач ИЗ &ТаблицаПередач КАК ТаблицаПередач";
		Запрос.УстановитьПараметр("ТаблицаПередач", ТаблицаПередач);
		Запрос.Выполнить();
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	ТаблицаПередач.ОрганизацияПолучатель КАК ОрганизацияПолучатель,
		               |	ТаблицаПередач.ОрганизацияОтправитель КАК ОрганизацияОтправитель,
		               |	ТаблицаПередач.Склад КАК Склад,
		               |	ТаблицаПередач.Номенклатура,
		               |	ТаблицаПередач.Характеристика,
		               |	ТаблицаПередач.Количество
		               |ИЗ
		               |	ТаблицаПередач КАК ТаблицаПередач
		               |ИТОГИ ПО
		               |	ОрганизацияПолучатель,
		               |	ОрганизацияОтправитель,
		               |	Склад";
		ВыборкаОрганизацияПолучатель = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаОрганизацияПолучатель.Следующий() Цикл 
			ВыборкаОрганизацияОтправитель = ВыборкаОрганизацияПолучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаОрганизацияОтправитель.Следующий() Цикл 
				ВыборкаСклад = ВыборкаОрганизацияОтправитель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаСклад.Следующий() Цикл
					Док = Документы.ПередачаТоваровМеждуОрганизациями.СоздатьДокумент();
					Док.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию;
					Док.Дата = Дата;
					Док.Организация = ВыборкаСклад.ОрганизацияОтправитель;
					Док.ОрганизацияПолучатель = ВыборкаСклад.ОрганизацияПолучатель;
					Док.Склад = ВыборкаСклад.Склад;
					
					ТаблицаТовары = Док.Товары.Выгрузить();
					
					Выборка = ВыборкаСклад.Выбрать();
					Пока Выборка.Следующий() Цикл
						НоваяСтрокаТоваров = ТаблицаТовары.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрокаТоваров, Выборка);
						НоваяСтрокаТоваров.КоличествоУпаковок = НоваяСтрокаТоваров.Количество;
					КонецЦикла;
					
					ТаблицаТовары.Свернуть("Номенклатура, Характеристика, СтавкаНДС", "Количество, КоличествоУпаковок");
					Док.Товары.Загрузить(ТаблицаТовары);
					
					Если Док.Товары.Количество() = 0 Тогда
						Возврат;
					КонецЕсли;
					ИнициализироватьДокумент(Док);
					
					ЗаполнитьРеквизитыПоУмолчаниюВТабличнойЧасти(Док);
					
					Попытка
						Док.Записать(РежимЗаписиДокумента.Проведение);
					Исключение
						Сообщить(ОписаниеОшибки());
						Док.Записать(РежимЗаписиДокумента.Запись);
					КонецПопытки;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПоУмолчаниюВТабличнойЧасти(Док)
	
	Если Док.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию Тогда
		Док.НалогообложениеНДС = Справочники.Организации.НалогообложениеНДС(
			Док.Организация,
			Неопределено, // Склад
			Док.Дата);
	КонецЕсли;
	
	КэшированныеЗначения = Неопределено;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",  Док.НалогообложениеНДС);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Док.Товары, СтруктураДействий, КэшированныеЗначения);

	Если Не ЗначениеЗаполнено(Док.ВидЦены) Тогда
		Док.ВидЦены = Справочники.ВидыЦен.ВидЦеныПоУмолчанию(Док.ВидЦены, Новый Структура("ИспользоватьПриПередачеМеждуОрганизациями", Истина));
	КонецЕсли;
	
	ЗаполнитьЦеныПоСебестоимости(Док);
	
КонецПроцедуры

Процедура ЗаполнитьЦеныПоСебестоимости(Док)
	
	ТаблицаТовары = Док.Товары;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВТ_Товары",     ТаблицаТовары.Выгрузить());
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Док.Дата));
	Запрос.УстановитьПараметр("КонецПериода",  Док.Дата);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Товары.НомерСтроки,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия
		|ПОМЕСТИТЬ ТаблицаНоменклатуры
		|ИЗ
		|	&ВТ_Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия,
		|	АналитикаУчетаНоменклатуры.КлючАналитики
		|ПОМЕСТИТЬ АналитикаУчета
		|ИЗ
		|	ТаблицаНоменклатуры КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
		|		ПО Товары.Номенклатура = АналитикаУчетаНоменклатуры.Номенклатура
		|			И Товары.Характеристика = АналитикаУчетаНоменклатуры.Характеристика
		|			И Товары.Серия = АналитикаУчетаНоменклатуры.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АналитикаУчета.НомерСтроки,
		|	АналитикаУчета.Номенклатура,
		|	АналитикаУчета.Характеристика,
		|	АналитикаУчета.Серия,
		|	СУММА(СебестоимостьТоваровОстаткиИОбороты.КоличествоКонечныйОстаток) КАК КоличествоОстаток,
		|	СУММА(СебестоимостьТоваровОстаткиИОбороты.СтоимостьКонечныйОстаток) КАК СтоимостьОстаток,
		|	СУММА(СебестоимостьТоваровОстаткиИОбороты.КоличествоПриход) КАК КоличествоПриход,
		|	СУММА(СебестоимостьТоваровОстаткиИОбороты.СтоимостьПриход) КАК СтоимостьПриход
		|ПОМЕСТИТЬ ВТ_Себестоимость
		|ИЗ
		|	АналитикаУчета КАК АналитикаУчета
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, Месяц, , ) КАК СебестоимостьТоваровОстаткиИОбороты
		|		ПО АналитикаУчета.КлючАналитики = СебестоимостьТоваровОстаткиИОбороты.АналитикаУчетаНоменклатуры
		|
		|СГРУППИРОВАТЬ ПО
		|	АналитикаУчета.НомерСтроки,
		|	АналитикаУчета.Номенклатура,
		|	АналитикаУчета.Характеристика,
		|	АналитикаУчета.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Себестоимость.НомерСтроки,
		|	ВТ_Себестоимость.Номенклатура,
		|	ВТ_Себестоимость.Характеристика,
		|	ВТ_Себестоимость.Серия,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ВТ_Себестоимость.КоличествоОстаток, 0) <> 0
		|			ТОГДА ЕСТЬNULL(ВТ_Себестоимость.СтоимостьОстаток, 0) / ВТ_Себестоимость.КоличествоОстаток
		|		КОГДА ЕСТЬNULL(ВТ_Себестоимость.КоличествоПриход, 0) <> 0
		|			ТОГДА ЕСТЬNULL(ВТ_Себестоимость.СтоимостьПриход, 0) / ВТ_Себестоимость.КоличествоПриход
		|		ИНАЧЕ ЕСТЬNULL(ВТ_Себестоимость.СтоимостьОстаток, 0)
		|	КОНЕЦ КАК Себестоимость
		|ИЗ
		|	ВТ_Себестоимость КАК ВТ_Себестоимость";
	
	ТаблицаССебестоимостью = Запрос.Выполнить().Выгрузить();
	ТаблицаССебестоимостью.Индексы.Добавить("НомерСтроки");
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Док);
	СтруктураДействий = Новый Структура( // Структура действий с измененными строками
		"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
		"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы);
	
	КэшированныеЗначения = Неопределено;
	
	Для Каждого СтрокаТаблицыТовары Из ТаблицаТовары Цикл
		СтруктураОтбора = Новый Структура("НомерСтроки", СтрокаТаблицыТовары.НомерСтроки);
		СтрокаСебестоимости = ТаблицаССебестоимостью.НайтиСтроки(СтруктураОтбора)[0];
		Множитель = ?(СтрокаСебестоимости.Себестоимость < 0, -1, 1);
		СтрокаТаблицыТовары.Цена = СтрокаСебестоимости.Себестоимость * Множитель;
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицыТовары, СтруктураДействий, КэшированныеЗначения);
	КонецЦикла;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(Док, ДанныеЗаполнения = Неопределено)

	Док.Менеджер = Пользователи.ТекущийПользователь();
	Док.Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Док.Организация);
	Док.Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Док.Склад);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    = Док.Организация;
	СтруктураПараметров.БанковскийСчет = Док.БанковскийСчетОрганизации;

	Док.БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    = Док.ОрганизацияПолучатель;
	СтруктураПараметров.БанковскийСчет = Док.БанковскийСчетОрганизацииПолучателя;

	БанковскийСчетОрганизацииПолучателя = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	Док.Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Пользователи.ТекущийПользователь(), Док.Подразделение);
	
	Если Не ЗначениеЗаполнено(Док.ВидЦены) Тогда
		Док.ВидЦены = Справочники.ВидыЦен.ВидЦеныПоУмолчанию(Док.ВидЦены, Новый Структура("ИспользоватьПриПередачеМеждуОрганизациями", Истина));
		Если ЗначениеЗаполнено(Док.ВидЦены) Тогда
			Реквизиты = Справочники.ВидыЦен.ПолучитьРеквизитыВидаЦены(Док.ВидЦены);
			Док.Валюта = Реквизиты.ВалютаЦены;
			Док.ЦенаВключаетНДС = Реквизиты.ЦенаВключаетНДС;
		Иначе
			
			Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("Валюта") Тогда
				Док.Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Док.Валюта);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Док.ВалютаВзаиморасчетов) Тогда
		Док.ВалютаВзаиморасчетов = Док.Валюта;
	КонецЕсли;
	
	ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(Док.Валюта, Док.НалогообложениеНДС);
	Док.ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьГруппуФинансовогоУчетаПоУмолчанию(Док.ПорядокОплаты);
	
	Если НЕ ЗначениеЗаполнено(Док.ПередачаПодДеятельность) Тогда
		ТекущийВидДеятельностиНДСОрганизации = Справочники.Организации.ЗакупкаПодДеятельность(Док.ОрганизацияПолучатель, Док.Склад, Док.Дата);
		
		УчетНДСУТ.ПроверитьКорректностьДеятельностиНДСПоступления(
			Док.ПередачаПодДеятельность, 
			Док.Дата, 
			ТекущийВидДеятельностиНДСОрганизации,
			Док.ХозяйственнаяОперация);
			
		Док.ПередачаПодДеятельность = ТекущийВидДеятельностиНДСОрганизации;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАктыНаПередачуПрав") Тогда
		Док.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Док.ДатаПлатежа) Тогда
		Док.ДатаПлатежа = ТекущаяДатаСеанса();
	КонецЕсли;
	
	СтруктураОтветственного = ПродажиСервер.ПолучитьОтветственногоПоСкладу(Док.Склад, Док.Менеджер);
	Если СтруктураОтветственного <> Неопределено Тогда
		Док.Отпустил = СтруктураОтветственного.Ответственный;
		Док.ОтпустилДолжность = СтруктураОтветственного.ОтветственныйДолжность;
	КонецЕсли;
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Док.Курс, Док.Кратность, Док.Валюта, Док.ВалютаВзаиморасчетов);
	
	ВалютаОплаты  = ДенежныеСредстваСервер.ПолучитьВалютуОплаты(Док.ФормаОплаты,?(ЗначениеЗаполнено(Док.БанковскийСчетОрганизации),Док.БанковскийСчетОрганизации,Док.БанковскийСчетОрганизацииПолучателя));
	Док.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(Док.ВалютаВзаиморасчетов,Док.НалогообложениеНДС,ВалютаОплаты);

КонецПроцедуры

Процедура СоздатьДокументНаОсновании(СтруктураОснование, ТипДокумента)
	
	Док = Документы[ТипДокумента].СоздатьДокумент();
	Док.Заполнить(СтруктураОснование);
	
	Если ТипДокумента = "ВозвратТоваровМеждуОрганизациями" Тогда 
		Док.Дата = СтруктураОснование.КонецПериода; //для возвратов указываем явно
	КонецЕсли;
	
	Если Док.Товары.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЦеныПоСебестоимости(Док);
	
	Попытка
		Док.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Сообщить(ОписаниеОшибки());
		Док.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти
