﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура Номенклатура_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	НастроитьВидимостьКомандОтчета();
	
	УправлениеСписком();
	УправлениеФормой(ЭтотОбъект);
	
	РедактированиеЗаказаКлиента = ПравоДоступа("Редактирование", Метаданные.Документы.ЗаказКлиента);
	РедактированиеЗаказаПоставщику = ПравоДоступа("Редактирование", Метаданные.Документы.ЗаказПоставщику);
	РедактированиеПоступления = ПравоДоступа("Редактирование", Метаданные.Документы.ПоступлениеТоваровУслуг);
	РедактированиеРеализации = ПравоДоступа("Редактирование", Метаданные.Документы.РеализацияТоваровУслуг);
	РедактированиеЗаказНаПерещение = ПравоДоступа("Редактирование", Метаданные.Документы.ЗаказНаПеремещение);
	РедактированиеПеремещение = ПравоДоступа("Редактирование", Метаданные.Документы.ПеремещениеТоваров);
	РедактированиеЧекККМ = ПравоДоступа("Редактирование", Метаданные.Документы.ЧекККМ);
	
	Элементы.ДокументЗаказКлиента1.Видимость = РедактированиеЗаказаКлиента;
	Элементы.ДокументЗаказПоставщику1.Видимость = РедактированиеЗаказаПоставщику;
	Элементы.ДокументПоступлениеТоваровУслугСоздатьИзКорзины1.Видимость = РедактированиеПоступления;
	Элементы.ДокументРеализацияТоваровУслугСоздатьИзКорзины1.Видимость = РедактированиеРеализации;
	Элементы.СоздатьЗаказНаПеремещение1.Видимость = РедактированиеЗаказНаПерещение;
	Элементы.СоздатьПеремещениеТоваров1.Видимость = РедактированиеПеремещение;
	Элементы.СоздатьЧекККМ1.Видимость = РедактированиеЧекККМ;
	
	Элементы.ДокументЗаказКлиента.Видимость = РедактированиеЗаказаКлиента;
	Элементы.ДокументЗаказПоставщику.Видимость = РедактированиеЗаказаПоставщику;
	Элементы.ДокументПоступлениеТоваровУслугСоздатьИзКорзины.Видимость = РедактированиеПоступления;
	Элементы.ДокументРеализацияТоваровУслугСоздатьИзКорзины.Видимость = РедактированиеРеализации;
	Элементы.СоздатьЗаказНаПеремещение.Видимость = РедактированиеЗаказНаПерещение;
	Элементы.СоздатьПеремещениеТоваров.Видимость = РедактированиеПеремещение;
	Элементы.СоздатьЧекККМ.Видимость = РедактированиеЧекККМ;
	
	ДоступныЦены = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ЦеныНоменклатуры);
	
	Если НЕ ПравоДоступа("Просмотр", Метаданные.Отчеты.ПоступлениеИОтгрузкаТоваров) Тогда
		Элементы.ИнформацияПоСкладамОжидается.ГиперссылкаЯчейки = Ложь;
		Элементы.ИнформацияПоСкладамОжидается.ТолькоПросмотр = Истина;
	КонецЕсли;
		
	ВсеСклады.ЗагрузитьЗначения(ВсеСклады());
	
КонецПроцедуры

&НаСервере
Процедура Номенклатура_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	// Установим условное оформление
	
	// 1. Итоги по складам
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияПоСкладам.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияПоСкладам.ЭтоИтог");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ИтогиФон);
	
КонецПроцедуры

&НаСервере
Процедура Номенклатура_ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УправлениеСписком();
	УправлениеФормой(ЭтотОбъект);
	УстановитьОтборПоИерархии(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Номенклатура_ДекорацияКорзинаНажатие(Элемент)
	
	ОткрытьКорзину();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ДекорацияКорзинаПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ДекорацияКорзинаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавитьВКорзину(ПараметрыПеретаскивания.Значение);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_НадписьПодобраноТоваровНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьКорзину();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ОтборОрганизацияПриИзмененииПеред(Элемент)
	
	УправлениеСписком();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ОтборСкладПриИзменении(Элемент)
	
	УправлениеСписком();
	ВывестиИнформациюПоСкладам();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ОтборПроизводительПриИзмененииПеред(Элемент)
	
	УправлениеСписком();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ОтборОстаткиПриИзменении(Элемент)
	
	УстановитьЗначениеПараметраПоказыватьТолькоОстаткиСпискаНоменклатуры(ЭтаФорма);
	ВывестиИнформациюПоСкладам();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ОтборВидЦенПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	УправлениеСписком();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ОтборВидЦенОчистка(Элемент, СтандартнаяОбработка)
	
	УправлениеФормой(ЭтотОбъект);
	УправлениеСписком();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ЦеныОтПриИзменении(Элемент)
	
	УправлениеСписком();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ЦеныДоПриИзменении(Элемент)
	
	УправлениеСписком();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ПоказыватьСкладыПриИзмененииПеред(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ПоказыватьСвободныеОстаткиПриИзмененииПеред(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ИспользоватьФильтрыПриИзменении(Элемент)
	
	УправлениеСписком();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура Номенклатура_СписокРасширенныйПоискНоменклатураПриАктивизацииСтрокиВместо(Элемент)
	
	ПодключитьОбработчикОжидания("ВывестиИнформациюПоСкладам", 0.1, Истина);
	// Чтобы не перескакивала текущая группа, не выполняем типовой обработчик.
	УстановитьВыполнениеОбработчиковСобытия(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_СписокСтандартныйПоискНоменклатураПриАктивизацииСтрокиВместо(Элемент)
	
	ПодключитьОбработчикОжидания("ВывестиИнформациюПоСкладам", 0.1, Истина);
	// Чтобы не перескакивала текущая группа, не выполняем типовой обработчик.
	УстановитьВыполнениеОбработчиковСобытия(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ИерархияНоменклатурыВыборПеред(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элементы.ИерархияНоменклатуры.Развернут(ВыбраннаяСтрока) Тогда
		Элементы.ИерархияНоменклатуры.Свернуть(ВыбраннаяСтрока);
	Иначе
		Элементы.ИерархияНоменклатуры.Развернуть(ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыИнформацияПоСкладам

&НаКлиенте
Процедура Номенклатура_ИнформацияПоСкладамПередНачаломИзмененияПеред(Элемент, Отказ)
	// На текущий момент единственной доступной колонкой для редактирования является "Ожидается".
	// Поэтому считаем, что если пользоваль попал в редактирование, то нажав на эту колонку.
	Отказ = Истина; // Запретим менять реквизит.
	ОткрытьОтчетПоступлениеИОтгрузкаТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ИнформацияПоСкладамПриИзменении(Элемент)
	
	СортироватьСкладыНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Номенклатура_ДобавитьВКорзинуИзСписка(Команда)
	
	ТекущиеДанные = ТекущиеДанныеСписка();
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВКорзину(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ДобавитьВКорзинуИзСпискаСКоличествомПеред(Команда)
	
	ТекущиеДанные = ТекущиеДанныеСписка();
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьВКорзину(ТекущиеДанные, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_СоздатьЗаказКлиента(Команда)
	СоздатьДокумент("ЗаказКлиента");
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_СоздатьРеализацияТоваровУслуг(Команда)
	СоздатьДокумент("РеализацияТоваровУслуг");
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_СоздатьЧекККМПеред(Команда)
	СоздатьДокумент("ЧекККМ");
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_СоздатьЗаказПоставщику(Команда)
	СоздатьДокумент("ЗаказПоставщику");
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_СоздатьПоступлениеТоваровУслуг(Команда)
	СоздатьДокумент("ПоступлениеТоваровУслуг");
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_СоздатьЗаказНаПеремещениеПеред(Команда)
	СоздатьДокумент("ЗаказНаПеремещение");
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_СоздатьПеремещениеТоваровПеред(Команда)
	СоздатьДокумент("ПеремещениеТоваров");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ТекущиеДанныеСписка()
	
	Если Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура Тогда
		ТекущиеДанные = Элементы.СписокРасширенныйПоискНоменклатура.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.СписокСтандартныйПоискНоменклатура.ТекущиеДанные;
	КонецЕсли;
	
	Возврат ТекущиеДанные;
	
КонецФункции

#Область Отчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	ТекущиеДанные = ТекущиеДанныеСписка();
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Функция СтруктураВидимостиЭлементовФормы()
	
	СтруктураВидимости = Новый Структура;
	СтруктураВидимости.Вставить("ВедомостьПоТоварамОрганизаций",
		ПравоДоступа("Просмотр", Метаданные.Отчеты.ВедомостьПоТоварамОрганизаций));
	СтруктураВидимости.Вставить("ВедомостьПоТоварамНаСкладах",
		ПравоДоступа("Просмотр", Метаданные.Отчеты.ВедомостьПоТоварамНаСкладах));
	СтруктураВидимости.Вставить("ОстаткиИДоступностьТоваров",
		ПравоДоступа("Просмотр", Метаданные.Отчеты.ОстаткиИДоступностьТоваров));
	СтруктураВидимости.Вставить("ВыручкаИСебестоимостьПродаж",
		ПравоДоступа("Просмотр", Метаданные.Отчеты.ВыручкаИСебестоимостьПродаж));
	СтруктураВидимости.Вставить("СостояниеАссортимента", Ложь);
	СтруктураВидимости.Вставить("ВедомостьПоСериямНоменклатуры", Ложь);
	СтруктураВидимости.Вставить("ТоварыВЯчейках", Ложь);
	СтруктураВидимости.Вставить("ТоварыНаСкладахПоСрокамГодности", Ложь);
	
	Возврат СтруктураВидимости;
	
КонецФункции

&НаСервере
Процедура НастроитьВидимостьКомандОтчета()
	
	ВидимостьЭлементов = СтруктураВидимостиЭлементовФормы();
	
	Для Каждого ГруппыПодменюОтчеты Из Элементы.ПодменюОтчеты.ПодчиненныеЭлементы Цикл
		Для Каждого ЭлементКомандаОтчета Из ГруппыПодменюОтчеты.ПодчиненныеЭлементы Цикл
			Для Каждого ЭлементВидимость Из ВидимостьЭлементов Цикл
				Если СтрНайти(ЭлементКомандаОтчета.Имя, ЭлементВидимость.Ключ) > 1 Тогда
					ЭлементКомандаОтчета.Видимость = ЭлементВидимость.Значение;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетПоступлениеИОтгрузкаТоваров()
	
	ТекущиеДанныеИнформацииПоСкладам = Элементы.ИнформацияПоСкладам.ТекущиеДанные;
	Если ТекущиеДанныеИнформацииПоСкладам = Неопределено ИЛИ ТекущиеДанныеИнформацииПоСкладам.Ожидается = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ТекущиеДанныеСписка();
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Номенклатура = ТекущиеДанные.Ссылка;
	Склад        = ТекущиеДанныеИнформацииПоСкладам.СкладДляСоединения;
	Отбор        = Новый Структура("Номенклатура", Номенклатура);
	
	Если ЗначениеЗаполнено(Склад) Тогда
		Отбор.Вставить("Склад", Склад);
	КонецЕсли;
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", Отбор, Истина);
	
	ОткрытьФорму("Отчет.ПоступлениеИОтгрузкаТоваров.Форма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Корзина

&НаКлиенте
Процедура ОткрытьКорзину()
	
	Если Корзина.Количество() > 0 Тогда
		ПараметрыКорзины = ЗаписатьПодборВХранилище();
		ОткрытьКорзинуПродолжить(ПараметрыКорзины);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКорзинуПродолжить(ПараметрыКорзины)
	
	ПередаваемыеПараметры = Новый Структура;
	ПередаваемыеПараметры.Вставить("АдресКорзиныВХранилище", 
		?(ЗначениеЗаполнено(ПараметрыКорзины), ПараметрыКорзины.АдресКорзиныВХранилище, Неопределено));
	ПередаваемыеПараметры.Вставить("ОтборВидЦен", ОтборВидЦен);
	ПередаваемыеПараметры.Вставить("ОтборСклад", ОтборСклад);
	ПередаваемыеПараметры.Вставить("ПоказыватьСвободныеОстатки", ПоказыватьСвободныеОстатки);
	
	ПередаваемыеПараметры.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификатор);
	ОповещениеКорзинаЗакрытие = Новый ОписаниеОповещения("КорзинаЗакрытие",ЭтотОбъект);
	ОткрытьФорму(
		"Обработка.ПанельИнформацииНоменклатуры.Форма.ФормаКорзина",
		ПередаваемыеПараметры, 
		ЭтотОбъект,
		,
		,
		,
		ОповещениеКорзинаЗакрытие,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаЗакрытие(ПараметрЗакрытия, Параметры) Экспорт

	Корзина.Очистить();
	
	Если ПараметрЗакрытия = Неопределено Тогда
		//Закрытие без сохранения
	ИначеЕсли ПараметрЗакрытия="ПеренестиВДокумент" Тогда
		//Закрытие без сохранения
	Иначе 
		//Закрытие с сохранением
		Для каждого СтрокаКорзины Из ПараметрЗакрытия.Корзина Цикл
			НоваяСтрокаКорзины = Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаКорзины, СтрокаКорзины);
		КонецЦикла;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВКорзину(ВыбранныеСтроки, ЗапрашиватьКоличество = Ложь)
	
	Если ТипЗнч(ВыбранныеСтроки) = Тип("Массив") Тогда
		Для Каждого ВыделеннаяСтрока Из ВыбранныеСтроки Цикл
			ДобавитьСтрокуВКорзину(ВыделеннаяСтрока, ЗапрашиватьКоличество);
		КонецЦикла;
	ИначеЕсли ТипЗнч(ВыбранныеСтроки) = Тип("СправочникСсылка.Номенклатура") ИЛИ 
		ТипЗнч(ВыбранныеСтроки) = Тип("ДанныеФормыСтруктура") Тогда
		
		ДобавитьСтрокуВКорзину(ВыбранныеСтроки, ЗапрашиватьКоличество);
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеСтрокиСписка(ВыделеннаяСтрока)
	
	Если Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура Тогда
		ДанныеСтроки = Элементы.СписокРасширенныйПоискНоменклатура.ДанныеСтроки(ВыделеннаяСтрока);
	Иначе
		ДанныеСтроки = Элементы.СписокСтандартныйПоискНоменклатура.ДанныеСтроки(ВыделеннаяСтрока);
	КонецЕсли;
	
	Возврат ДанныеСтроки;

КонецФункции

&НаКлиенте
Процедура ДобавитьСтрокуВКорзину(ВыделеннаяСтрока, ЗапрашиватьКоличество)
	
	Если ТипЗнч(ВыделеннаяСтрока) = Тип("ДанныеФормыСтруктура") Тогда
		ДанныеСтроки = ВыделеннаяСтрока;
	Иначе
		ДанныеСтроки = ДанныеСтрокиСписка(ВыделеннаяСтрока);
	КонецЕсли;
	
	СтруктураВыбора = СтруктураВыбора();
	ЗаполнитьЗначенияСвойств(СтруктураВыбора, ДанныеСтроки);
	СтруктураВыбора.Номенклатура            = ДанныеСтроки.Ссылка;
	СтруктураВыбора.Количество              = 1;
	СтруктураВыбора.КоличествоУпаковок      = 1;
	СтруктураВыбора.ЗапрашиватьКоличество   = ЗапрашиватьКоличество;
	СтруктураВыбора.ВызватьУправлениеФормой = ЗапрашиватьКоличество;
	
	Если СтруктураВыбора.ИспользуютсяХарактеристики Тогда
		ДополнитьСтруктуруВыбораХарактеристикой(СтруктураВыбора);
	Иначе
		ДобавитьНоменклатуруВКорзинуЗапроситьКоличество(СтруктураВыбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрокуВКорзинуЗавершение(Количество, СтруктураВыбора) Экспорт
	
	Если Количество = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВыбора.Количество = Количество;
	СтруктураВыбора.КоличествоУпаковок = Количество;
	
	СтруктураПоискаВКорзине = Новый Структура;
	СтруктураПоискаВКорзине.Вставить("Номенклатура",               СтруктураВыбора.Номенклатура);
	СтруктураПоискаВКорзине.Вставить("ИспользуютсяХарактеристики", СтруктураВыбора.ИспользуютсяХарактеристики);
	Если СтруктураВыбора.ИспользуютсяХарактеристики Тогда
		СтруктураПоискаВКорзине.Вставить("Характеристика", СтруктураВыбора.Характеристика);
	КонецЕсли;
	
	НайденныеСтроки = Корзина.НайтиСтроки(СтруктураПоискаВКорзине);
	Если НайденныеСтроки.Количество() = 0 Тогда
		СтрокаКорзины = Корзина.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаКорзины, СтруктураВыбора);
	Иначе
		СтрокаКорзины                    = НайденныеСтроки[0];
		СтрокаКорзины.Количество         = СтрокаКорзины.Количество + СтруктураВыбора.Количество;
		СтрокаКорзины.КоличествоУпаковок = СтрокаКорзины.Количество;
		//Если цена изменилась - перезаполняем новым значением
		СтрокаКорзины.Цена               = СтруктураВыбора.Цена;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаКорзины, СтруктураДействий, Неопределено);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Подбор товаров'")
		,
		,
		НСтр("ru = 'Товар "+СтруктураВыбора.Номенклатура+" добавлен в корзину'"));
		
	Если СтруктураВыбора.ВызватьУправлениеФормой Тогда
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьСтруктуруВыбораХарактеристикой(СтруктураВыбора)

	ОписаниеОповещения = Новый ОписаниеОповещения("ДополнитьСтруктуруВыбораХарактеристикойЗавершение", ЭтотОбъект, СтруктураВыбора);
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Номенклатура", СтруктураВыбора.Номенклатура);
	Если ЗначениеЗаполнено(ОтборСклад) Тогда
		МассивСкладов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОтборСклад);
	Иначе
		МассивСкладов = ВсеСклады;
	КонецЕсли;
	СтруктураПараметров.Вставить("ОтборСклад", МассивСкладов);
	СтруктураПараметров.Вставить("ВидЦены", ОтборВидЦен);
	СтруктураПараметров.Вставить("ПоказыватьСвободныеОстатки", ПоказыватьСвободныеОстатки);
	
	ОткрытьФорму(
		"Обработка.ПанельИнформацииНоменклатуры.Форма.ФормаВыбораХарактеристики", 
		СтруктураПараметров, 
		ЭтотОбъект,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьСтруктуруВыбораХарактеристикойЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДополнительныеПараметры.Характеристика          = Результат;
	ДополнительныеПараметры.ВызватьУправлениеФормой = Истина;
	ДобавитьНоменклатуруВКорзинуЗапроситьКоличество(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНоменклатуруВКорзинуЗапроситьКоличество(СтруктураВыбора)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьСтрокуВКорзинуЗавершение", ЭтотОбъект, СтруктураВыбора);
	
	Если СтруктураВыбора.ЗапрашиватьКоличество Тогда
		ПоказатьВводЧисла(ОписаниеОповещения, СтруктураВыбора.Количество, "Количество товара", 15, 3);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, СтруктураВыбора.Количество);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураВыбора()
	
	Возврат Новый Структура(
		"Номенклатура,
		|ЕдиницаИзмерения,
		|Цена,
		|Количество,
		|КоличествоУпаковок,
		|ИспользуютсяХарактеристики,
		|Характеристика,
		|ЗапрашиватьКоличество,
		|ВызватьУправлениеФормой");
		
КонецФункции

&НаСервере
// Функция помещает результаты подбора в хранилище
//
// Возвращает структуру:
//	Структура
//		- Адрес в хранилище, куда помещена выбранная номенклатура (корзина);
//		- Уникальный идентификатор формы владельца, необходим для идентификации при обработке результатов подбора;
//
Функция ЗаписатьПодборВХранилище() 
	
	ПодобранныеТовары = Корзина.Выгрузить();
	АдресКорзиныВХранилище = ПоместитьВоВременноеХранилище(ПодобранныеТовары, УникальныйИдентификатор);
	Возврат Новый Структура("АдресКорзиныВХранилище, УникальныйИдентификаторФормыВладельца", АдресКорзиныВХранилище, УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

#Область СозданиеДокументов

&НаСервере
Функция ПараметрыСозданияДокумента()

	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ВидЦен", ОтборВидЦен);
	Если ЗначениеЗаполнено(ОтборСклад) И НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтборСклад, "ЭтоГруппа") Тогда
		ДанныеЗаполнения.Вставить("Склад", ОтборСклад);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "Корзина");
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ДанныеЗаполнения);
	ПараметрыФормы.Вставить("ПараметрыКорзины", ЗаписатьПодборВХранилище());
	ПараметрыФормы.Вставить("ВидЦен", ОтборВидЦен);
	Если ЗначениеЗаполнено(ОтборСклад) И НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтборСклад, "ЭтоГруппа") Тогда
		ПараметрыФормы.Вставить("Склад", ОтборСклад);
	КонецЕсли;
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Функция НазваниеДокумента(ИмяДокумента)
	
	СоответствиеИменДокументов = Новый Структура;
	СоответствиеИменДокументов.Вставить("ЧекККМ", НСтр("ru='Чек ККМ'"));
	СоответствиеИменДокументов.Вставить("ЗаказКлиента", НСтр("ru='Заказ клиента'"));
	СоответствиеИменДокументов.Вставить("ЗаказПоставщику", НСтр("ru='Заказ поставщику'"));
	СоответствиеИменДокументов.Вставить("РеализацияТоваровУслуг", НСтр("ru='Реализация товаров и услуг'"));
	СоответствиеИменДокументов.Вставить("ПоступлениеТоваровУслуг", НСтр("ru='Поступление товаров и услуг'"));
	СоответствиеИменДокументов.Вставить("ПеремещениеТоваров", НСтр("ru='Перемещение товаров'"));
	СоответствиеИменДокументов.Вставить("ЗаказНаПеремещение", НСтр("ru='Заказ на перемещение'"));
	
	Если СоответствиеИменДокументов.Свойство(ИмяДокумента) Тогда
		Возврат СоответствиеИменДокументов[ИмяДокумента];
	Иначе
		Возврат ИмяДокумента;
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура СоздатьДокумент(ИмяДокумента)
	
	Если ИмяДокумента = "ЧекККМ" Тогда
		ИмяФормыДокумента = "Документ.ЧекККМ.Форма.ФормаДокументаРМК";
	Иначе
		ИмяФормыДокумента = СтрШаблон("Документ.%1.ФормаОбъекта", ИмяДокумента);
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыСозданияДокумента();
	
	ОткрытаяФорма = ПолучитьФорму(ИмяФормыДокумента, ПараметрыФормы);
	Если ОткрытаяФорма.Открыта() Тогда
		ДополнительныеПараметры = Новый Структура;
		// Для открытой формы передаем форму и параметр оповещения.
		ДополнительныеПараметры.Вставить("Форма", ОткрытаяФорма);
		ДополнительныеПараметры.Вставить("Параметр", 
			Новый Структура("ИмяДокумента, АдресКорзиныВХранилище", ИмяДокумента, ПараметрыФормы.ПараметрыКорзины.АдресКорзиныВХранилище));
		// Для новой формы передаем имя формы и параметры.
		ДополнительныеПараметры.Вставить("ИмяФормыДокумента", ИмяФормыДокумента);
		ДополнительныеПараметры.Вставить("ПараметрыФормы", ПараметрыФормы);
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("ЕстьОткрытыйДокументЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = 
			СтрШаблон(НСтр("ru='Есть открытый ""%1"", оформленный из корзины.
			|Что сделать с набранным товаром?'"),
			НазваниеДокумента(ИмяДокумента));
		КнопкиВопроса = Новый СписокЗначений;
		КнопкиВопроса.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Добавить в открытый'"));
		КнопкиВопроса.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Создать новый'"));
		КнопкиВопроса.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, КнопкиВопроса);
	Иначе
		ОткрытаяФорма.Открыть();
		Корзина.Очистить();
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЕстьОткрытыйДокументЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьДокументЗавершение", ЭтотОбъект);
		ПараметрыФормы = ДополнительныеПараметры.ПараметрыФормы;
		ПараметрыФормы.КлючНазначенияИспользования = "НовыйДокументИзКорзины";
		ОткрытьФорму(
			ДополнительныеПараметры.ИмяФормыДокумента,
			ПараметрыФормы,
			,
			Новый УникальныйИдентификатор,
			,
			,
			ОписаниеОповещения);
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		Оповестить("ДополнитьТовары", ДополнительныеПараметры.Параметр);
		ДополнительныеПараметры.Форма.Открыть();
	КонецЕсли;
	
	Корзина.Очистить();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.СписокРасширенныйПоискНоменклатура.Обновить();
	Элементы.СписокСтандартныйПоискНоменклатура.Обновить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.Корзина.Количество() = 0 Тогда
		Элементы.ГруппаСтраницыКартинки.ТекущаяСтраница = Элементы.ГруппаКорзинаПустая;
	Иначе
		Элементы.ГруппаСтраницыКартинки.ТекущаяСтраница = Элементы.ГруппаКорзинаПолная;
	КонецЕсли;
	
	Элементы.ЦеныДиапазон.Доступность = ЗначениеЗаполнено(Форма.ОтборВидЦен);
	
	Если Форма.ДоступныЦены Тогда
		Элементы.СписокРасширенныйПоискНоменклатураЦена.Видимость = ЗначениеЗаполнено(Форма.ОтборВидЦен);
		Элементы.СписокСтандартныйПоискНоменклатураЦена.Видимость = ЗначениеЗаполнено(Форма.ОтборВидЦен);
	КонецЕсли;
	
	Элементы.ИнформацияПоСкладам.Видимость = Форма.ПоказыватьИнформациюПоСкладам;
	Элементы.СписокСтандартныйПоискНоменклатураСвободныйОстаток.Видимость = Форма.ПоказыватьСвободныеОстатки;
	Элементы.СписокРасширенныйПоискНоменклатураВСвободныйОстаток.Видимость = Форма.ПоказыватьСвободныеОстатки;
	Элементы.ИнформацияПоСкладамСвободныйОстаток.Видимость = Форма.ПоказыватьСвободныеОстатки;
	
	ОбновитьНадписьПодобраноТоваров(Форма);
	
КонецПроцедуры

//Обновляет итоги подобранных товаров в форме Корзина справочника Номенклатура
&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписьПодобраноТоваров(Форма)
	
	КоличествоТоваров = Форма.Корзина.Итог("Количество");
	СуммаТоваров      = Форма.Корзина.Итог("Сумма");
	
	Если Форма.Корзина.Количество()=0 Тогда
		Форма.НадписьПодобраноТоваров = НСтр("ru = 'перетащите товары в корзину'");
	ИначеЕсли ЗначениеЗаполнено(Форма.ОтборВидЦен) Тогда
		Форма.НадписьПодобраноТоваров = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подобрано: %1 на сумму %2'"),
			Форма.Корзина.Итог("Количество"),
			Формат(Форма.Корзина.Итог("Сумма"),"ЧДЦ=2; ЧН=0"));
	Иначе
		Форма.НадписьПодобраноТоваров = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подобрано: %1'"),
			Форма.Корзина.Итог("Количество")
			);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервереБезКонтекста
Функция ВсеСклады()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.ПометкаУдаления = ЛОЖЬ";
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервере
Процедура УправлениеСписком()
	
	Если ЗначениеЗаполнено(ОтборСклад) Тогда
		МассивСкладов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОтборСклад);
	Иначе
		МассивСкладов = ВсеСклады.ВыгрузитьЗначения();
	КонецЕсли;
	СписокНоменклатура.Параметры.УстановитьЗначениеПараметра("ОтборСклад", МассивСкладов);
	СписокНоменклатура.Параметры.УстановитьЗначениеПараметра("ВидЦены",    ОтборВидЦен);
	УстановитьЗначениеПараметраПоказыватьТолькоОстаткиСпискаНоменклатуры(ЭтаФорма);
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокНоменклатура,
		"Цена",
		ЦенаОт,
		(ЦенаОт <> 0) И ЗначениеЗаполнено(ОтборВидЦен),
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокНоменклатура,
		"Цена2",
		ЦенаДо,
		(ЦенаДо <> 0) И ЗначениеЗаполнено(ОтборВидЦен),
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
		
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокНоменклатура,
		"Производитель",
		ОтборПроизводитель,
		ЗначениеЗаполнено(ОтборПроизводитель),
		ВидСравненияКомпоновкиДанных.Равно);
		
	Элементы.СписокРасширенныйПоискНоменклатура.Обновить();
	Элементы.СписокСтандартныйПоискНоменклатура.Обновить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗначениеПараметраПоказыватьТолькоОстаткиСпискаНоменклатуры(Форма)
	
	ИспользованиеОтбора = (Форма.ОтборОстатки <> 0);
	ИспользуемыйВидСравнения = ?(
		Форма.ОтборОстатки = 1,
		ВидСравненияКомпоновкиДанных.Больше,
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Форма.СписокНоменклатура,
		"ВНаличии",
		0,
		ИспользованиеОтбора,
		ИспользуемыйВидСравнения);
	
КонецПроцедуры

#КонецОбласти

#Область ИнформацияПоСкладам

&НаКлиенте
Процедура ВывестиИнформациюПоСкладам()
	
	Если НЕ ПоказыватьИнформациюПоСкладам Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ТекущиеДанныеСписка();
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОстаткиПоСкладам(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткиПоСкладам(Номенклатура)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	МассивСкладов = ВсеСклады.ВыгрузитьЗначения();
	
	Если ЗначениеЗаполнено(ОтборСклад) Тогда
		Склад = ОтборСклад;
	Иначе
		Склад = МассивСкладов;
	КонецЕсли;
	Запрос.УстановитьПараметр("Склад",     Склад);
	Запрос.УстановитьПараметр("ВсеСклады", МассивСкладов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПРЕДСТАВЛЕНИЕ(ТоварыНаСкладахОстатки.Склад) КАК Склад,
	|	ТоварыНаСкладахОстатки.Склад КАК СкладДляСоединения,
	|	ТоварыНаСкладахОстатки.ВНаличииОстаток КАК ВНаличии,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(СвободныеОстаткиОстатки.ВНаличииОстаток, ЛОЖЬ) = ЛОЖЬ
	|			ТОГДА ТоварыНаСкладахОстатки.ВНаличииОстаток
	|		ИНАЧЕ СвободныеОстаткиОстатки.ВНаличииОстаток - СвободныеОстаткиОстатки.ВРезервеСоСкладаОстаток
	|	КОНЕЦ КАК СвободныйОстаток,
	|	ЛОЖЬ КАК ЭтоИтог
	|ПОМЕСТИТЬ ОстаткиПоСкладам
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(
	|			,
	|			Номенклатура = &Номенклатура
	|				И Склад В ИЕРАРХИИ (&Склад)) КАК ТоварыНаСкладахОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеОстатки.Остатки(
	|				,
	|				Номенклатура = &Номенклатура
	|					И Склад В ИЕРАРХИИ (&Склад)) КАК СвободныеОстаткиОстатки
	|		ПО ТоварыНаСкладахОстатки.Номенклатура = СвободныеОстаткиОстатки.Номенклатура
	|			И ТоварыНаСкладахОстатки.Склад = СвободныеОстаткиОстатки.Склад
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Итого по всем складам"",
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка),
	|	ТоварыНаСкладахОстатки.ВНаличииОстаток,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(СвободныеОстаткиОстатки.ВНаличииОстаток, ЛОЖЬ) = ЛОЖЬ
	|			ТОГДА ТоварыНаСкладахОстатки.ВНаличииОстаток
	|		ИНАЧЕ СвободныеОстаткиОстатки.ВНаличииОстаток - СвободныеОстаткиОстатки.ВРезервеСоСкладаОстаток
	|	КОНЕЦ,
	|	ИСТИНА
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(
	|			,
	|			Склад В ИЕРАРХИИ (&ВсеСклады)
	|				И Номенклатура = &Номенклатура) КАК ТоварыНаСкладахОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеОстатки.Остатки(
	|				,
	|				Номенклатура = &Номенклатура
	|					И Склад В ИЕРАРХИИ (&ВсеСклады)) КАК СвободныеОстаткиОстатки
	|		ПО ТоварыНаСкладахОстатки.Номенклатура = СвободныеОстаткиОстатки.Номенклатура
	|ГДЕ
	|	ТоварыНаСкладахОстатки.ВНаличииОстаток <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(ГрафикПоступленияТоваровОстатки.Склад) КАК Склад,
	|	ГрафикПоступленияТоваровОстатки.Склад КАК СкладДляСоединения,
	|	ГрафикПоступленияТоваровОстатки.КоличествоИзЗаказовОстаток КАК Ожидается
	|ПОМЕСТИТЬ ВТОжидается
	|ИЗ
	|	РегистрНакопления.ГрафикПоступленияТоваров.Остатки(
	|			,
	|			Номенклатура = &Номенклатура
	|				И Склад В ИЕРАРХИИ (&Склад)) КАК ГрафикПоступленияТоваровОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Итого по складам"",
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка),
	|	ГрафикПоступленияТоваровОстатки.КоличествоИзЗаказовОстаток
	|ИЗ
	|	РегистрНакопления.ГрафикПоступленияТоваров.Остатки(
	|			,
	|			Номенклатура = &Номенклатура
	|				И Склад В ИЕРАРХИИ (&ВсеСклады)) КАК ГрафикПоступленияТоваровОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ОстаткиПоСкладам.Склад, ВТОжидается.Склад) КАК Склад,
	|	ЕСТЬNULL(ОстаткиПоСкладам.ВНаличии, 0) КАК ВНаличии,
	|	ЕСТЬNULL(ОстаткиПоСкладам.СвободныйОстаток, 0) КАК СвободныйОстаток,
	|	ОстаткиПоСкладам.ЭтоИтог КАК ЭтоИтог,
	|	ЕСТЬNULL(ВТОжидается.Ожидается, 0) КАК Ожидается,
	|	ОстаткиПоСкладам.СкладДляСоединения
	|ИЗ
	|	ОстаткиПоСкладам КАК ОстаткиПоСкладам
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТОжидается КАК ВТОжидается
	|		ПО ОстаткиПоСкладам.СкладДляСоединения = ВТОжидается.СкладДляСоединения";
	ИнформацияПоСкладам.Загрузить(Запрос.Выполнить().Выгрузить());
	ИнформацияПоСкладам.Сортировать("ЭтоИтог, Склад", Новый СравнениеЗначений);
	
КонецПроцедуры

&НаСервере
Процедура СортироватьСкладыНаСервере();
	
	ИнформацияПоСкладам.Сортировать("ЭтоИтог", Новый СравнениеЗначений);
	
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ПоказыватьСнятыеСПроизводстваПриИзмененииПеред(Элемент)
	УправлениеСписком();
КонецПроцедуры

&НаКлиенте
Процедура Номенклатура_ИерархияНоменклатурыПриАктивизацииСтрокиВместо(Элемент)
	
	// Устанавливаем свой отбор по группам, который учитывает иерархии.
	ПодключитьОбработчикОжидания("УстановитьОтборПоИерархииНаКлиенте", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоИерархииНаКлиенте()
	
	УстановитьОтборПоИерархии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоИерархии(Форма)
	
	Если Форма.ТекущаяИерархияНоменклатуры = Форма.Элементы.ИерархияНоменклатуры.ТекущаяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	Форма.ТекущаяИерархияНоменклатуры = Форма.Элементы.ИерархияНоменклатуры.ТекущаяСтрока;
	
	Если Не Форма.ИспользоватьФильтры Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Форма.ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.СписокНоменклатура,
		"Родитель",
		Форма.ТекущаяИерархияНоменклатуры,
		ВидСравненияКомпоновкиДанных.ВИерархии,
		"Родитель",
		Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти