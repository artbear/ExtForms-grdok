﻿Перем ПолеТекстовогоДокументаСКонтекстнойПодсказкой;

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой.Нажатие(Кнопка);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Истина;
	Предупреждение("Эта обработка - класс. Она не предназначена для непосредственного использования.");
	
КонецПроцедуры

