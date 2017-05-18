﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура Номенклатура_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПараметрыКорзины") Тогда
		Возврат;
	КонецЕсли;
	
	Объект.КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторДляРМК();
	Если ЗначениеЗаполнено(Объект.КассаККМ) Тогда
		СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(Объект.КассаККМ);
		ЗаполнитьЗначенияСвойств(Объект, СостояниеКассовойСмены,,"Кассир");
	Иначе
		ВызватьИсключение НСтр("ru = 'Для текущего рабочего места не настроено подключаемое оборудование: Фискальный регистратор'");
	КонецЕсли;
	
	ПараметрыКорзины = Параметры.ПараметрыКорзины;
	Если ПараметрыКорзины.Свойство("АдресКорзиныВХранилище") И ЗначениеЗаполнено(ПараметрыКорзины.АдресКорзиныВХранилище) Тогда
		ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(ПараметрыКорзины.АдресКорзиныВХранилище);
		Объект.Товары.Загрузить(ТаблицаДляЗагрузки);
		ПерезаполнитьРеквизитыТовары = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ПриОткрытииПеред(Отказ)
	
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
		Если Параметр.Свойство("ИмяДокумента") И Параметр.ИмяДокумента = "ЧекККМ" Тогда
			ДополнитьТоварыНаСервере(Параметр.АдресКорзиныВХранилище);
			ПересчитатьТоварыИзКорзиныНаКлиенте();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Номенклатура_ПриИзмененииНоменклатуры(ТекущаяСтрока)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	Если КонтролироватьАссортимент Тогда
		СтруктураДействий.Вставить("ЗаполнитьЦенуПродажиПоАссортименту", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияЦеныПоАссортиментуВСтрокеТЧ(Объект));
	Иначе
		СтруктураДействий.Вставить("ЗаполнитьЦенуПродажи", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияЦеныРозницаВСтрокеТЧ(Объект));
	КонецЕсли;
	
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", Объект.НалогообложениеНДС);
	СтруктураДействий.Вставить("ЗаполнитьПомещение", Новый Структура("Склад, Номенклатура, Характеристика", Объект.Склад, ТекущаяСтрока.Номенклатура, ТекущаяСтрока.Характеристика));
	СтруктураДействий.Вставить("ЗаполнитьПродавца", Новый Структура("Продавец", ТекущийПродавец));
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомАвтоматическойСкидки", Новый Структура("Очищать", Истина));
	СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Истина));
	СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомСкидкиБонуснымиБаллами");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяАлкогольнаяПродукция", Новый Структура("Номенклатура", "МаркируемаяАлкогольнаяПродукция"));
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
	
	Если КонтролироватьАссортимент Тогда
		СтруктураПроверкиАссортимента = АссортиментКлиентСервер.ПараметрыПроверкиАссортимента();
		СтруктураПроверкиАссортимента.Ссылка = Объект.Ссылка;
		СтруктураПроверкиАссортимента.Склад = Объект.Склад;
		СтруктураПроверкиАссортимента.Дата = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата());
		СтруктураПроверкиАссортимента.ТекстСообщения = НСтр("ru = 'Товар %1 не включен в ассортимент магазина или запрещен к продаже.'");
		СтруктураПроверкиАссортимента.ИмяРесурсаАссортимента = "РазрешеныПродажи";
		СтруктураПроверкиАссортимента.ПровереноМожноДобавлять = Истина;
		СтруктураПроверкиАссортимента.РазрешатьДобавление = Ложь;
		
		СтруктураДействий.Вставить("ПроверитьАссортиментСтроки", СтруктураПроверкиАссортимента);
	КонецЕсли;

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтотОбъект.ИмяФормы, "Товары"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьТоварыИзКорзиныНаКлиенте()
	
	Для Каждого СтрокаТовары Из Объект.Товары Цикл
		
		Номенклатура_ПриИзмененииНоменклатуры(СтрокаТовары);
		
	КонецЦикла;
	
	СкидкиНаценкиКлиент.СброситьФлагСкидкиРассчитаны(ЭтотОбъект);
	ПересчитатьДокументНаКлиенте();
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
