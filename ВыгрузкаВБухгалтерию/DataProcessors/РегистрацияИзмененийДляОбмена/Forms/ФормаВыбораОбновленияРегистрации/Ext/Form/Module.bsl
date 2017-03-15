﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекстВопросаПользователю = Параметры.ТекстВопросаПользователю;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	Если ИмяМетаданных <> "" Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " [" + ИмяМетаданных + "]";
	КонецЕсли;
	Элементы.ТекстВопроса.Заголовок = ТекстВопросаПользователю;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	СтруктураВозврата = Новый Структура;
	Закрыть(СтруктураВозврата);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры