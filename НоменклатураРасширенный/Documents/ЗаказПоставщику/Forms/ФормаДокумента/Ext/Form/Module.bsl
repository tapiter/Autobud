﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура Номенклатура_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПараметрыКорзины") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Склад") Тогда
		Объект.Склад = Параметры.Склад;
	КонецЕсли;
	
	ПараметрыКорзины = Параметры.ПараметрыКорзины;
	Если ПараметрыКорзины.Свойство("АдресКорзиныВХранилище") И ЗначениеЗаполнено(ПараметрыКорзины.АдресКорзиныВХранилище) Тогда
		ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(ПараметрыКорзины.АдресКорзиныВХранилище);
		Объект.Товары.Загрузить(ТаблицаДляЗагрузки);
		ПерезаполнитьРеквизитыТовары = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ПриОткрытии(Отказ)
	
	Если ПерезаполнитьРеквизитыТовары Тогда
		ПересчитатьТоварыИзКорзиныНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ОбработкаОповещенияПеред(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ЭтотОбъект Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ДополнитьТовары" И Параметры.КлючНазначенияИспользования = "Корзина" Тогда
		Если Параметр.Свойство("ИмяДокумента") И Параметр.ИмяДокумента = "ЗаказПоставщику" Тогда
			ДополнитьТоварыНаСервере(Параметр.АдресКорзиныВХранилище);
			ПересчитатьТоварыИзКорзиныНаКлиенте();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Номенклатура_ПриИзмененииНоменклатуры(СтрокаТаблицы)

		СтруктураПересчетаСуммы = ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтаФорма);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", СтрокаТаблицы.Характеристика);
		СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", СтрокаТаблицы.Упаковка);
		СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаРасходовОбязательна");
		СтруктураДействий.Вставить("ЗаполнитьНоменклатуруПоставщикаПоНоменклатуре", Объект.Партнер);
		СтруктураДействий.Вставить("ПроверитьСтатьюАналитикуРасходов", СтрокаТаблицы.Номенклатура);
		СтруктураДействий.Вставить(
			"ПроверитьСопоставленнуюНоменклатуруПоставщика",
			ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПроверкиСопоставленнойНоменклатурыПоставщикаВСтрокеТЧ(
			Объект,
			НеВыполнятьПроверкуСопоставленнойНоменклатурыПоставщика));
		СтруктураДействий.Вставить(
			"ПроверитьЗаполнитьСклад",
			ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияСкладаВСтрокеТЧ(
			Объект,
			СкладГруппа));
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", Объект.НалогообложениеНДС);
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДСВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСумму");
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Истина));
		СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
		СтруктураДействий.Вставить("ЗаполнитьПризнакБезВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
		СтруктураДействий.Вставить("ЗаполнитьПризнакОтмененоБезВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
		СтруктураДействий.Вставить("ЗаполнитьДубликатыЗависимыхРеквизитов", ЗависимыеРеквизиты());
		
		Если КонтролироватьАссортимент Тогда
			СтруктураПроверкиАссортимента = АссортиментКлиентСервер.ПараметрыПроверкиАссортимента();
			СтруктураПроверкиАссортимента.Ссылка = Объект.Ссылка;
			СтруктураПроверкиАссортимента.Склад = Объект.Склад;
			СтруктураПроверкиАссортимента.Дата = ?(ЗначениеЗаполнено(Объект.ЖелаемаяДатаПоступления), Объект.ЖелаемаяДатаПоступления, Объект.Дата);
			СтруктураПроверкиАссортимента.ТекстСообщения = НСтр("ru = 'Товар %1 не включен в ассортимент магазина. Заказывать его не рекомендуется.'");
			СтруктураПроверкиАссортимента.ИмяРесурсаАссортимента = "РазрешеныЗакупки";
			СтруктураПроверкиАссортимента.ПровереноМожноДобавлять = Истина;
			СтруктураПроверкиАссортимента.РазрешатьДобавление = Истина;
			//
			СтруктураДействий.Вставить("ПроверитьАссортиментСтроки", СтруктураПроверкиАссортимента);
		КонецЕсли;
		НаправленияДеятельностиКлиентСервер.СтруктураДействийВставитьПриДобавленииСтроки(ЭтаФорма, СтруктураДействий);
		СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
			ЭтаФорма.ИмяФормы, "Товары"));
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
		
		Если СтрокаТаблицы.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар") Или
			СтрокаТаблицы.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара") Или 
			СтрокаТаблицы.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Набор") Тогда
			СтрокаТаблицы.СписатьНаРасходы = Ложь;
			СтрокаТаблицы.СтатьяРасходов = ПредопределенноеЗначение("ПланВидовХарактеристик.СтатьиРасходов.ПустаяСсылка");
			СтрокаТаблицы.АналитикаРасходов = Неопределено;
			СтрокаТаблицы.Подразделение = ПредопределенноеЗначение("Справочник.СтруктураПредприятия.ПустаяСсылка");
		ИначеЕсли СтрокаТаблицы.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга") Тогда
			СтрокаТаблицы.СписатьНаРасходы = Истина;
		КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьТоварыИзКорзиныНаКлиенте()
	
	Для Каждого ТекущаяСтрока Из Объект.Товары Цикл
		
		Номенклатура_ПриИзмененииНоменклатуры(ТекущаяСтрока);
		
	КонецЦикла;
	
	РассчитатьИтоговыеПоказателиЗаказа(ЭтаФорма);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьТоварыНаСервере(АдресКорзиныВХранилище)
	
	ИсходнаяТаблица = Объект.Товары.Выгрузить();
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресКорзиныВХранилище);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаДляЗагрузки, ИсходнаяТаблица);
	Объект.Товары.Загрузить(ИсходнаяТаблица);
	
КонецПроцедуры

#КонецОбласти