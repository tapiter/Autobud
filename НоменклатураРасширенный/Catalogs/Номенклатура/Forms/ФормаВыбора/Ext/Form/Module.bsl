﻿
&НаСервере
Процедура Номенклатура_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	// Арипов Н. Снятые с производства детали выделяем зачеркнутым шрифтом.
	// https://autobud.bitrix24.ru/company/personal/user/56/tasks/
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СписокСтандартныйПоискНоменклатура");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СписокРасширенныйПоискНоменклатура");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокНоменклатура.АБ_СнятоСПроизводства");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(255, 0, 0));
	
	//
КонецПроцедуры
