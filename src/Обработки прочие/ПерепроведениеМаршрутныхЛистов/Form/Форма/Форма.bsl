﻿&НаСервере
Функция ИнициализацияОбработкиСервер()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Дата1",       Период.ДатаНачала);
	Запрос.Параметры.Вставить("Дата2",       Период.ДатаОкончания);
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("Статус",      Перечисления.СтатусыМаршрутныхЛистовПроизводства.Выполнен);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Док.Ссылка
	|ИЗ
	|	Документ.МаршрутныйЛистПроизводства.ВыходныеИзделия КАК Док
	|ГДЕ
	|	Док.Ссылка.Дата МЕЖДУ &Дата1 И &Дата2
	|	И Док.Ссылка.Проведен
	|	И Док.Ссылка.Организация = &Организация
	|	И Док.Ссылка.Статус = &Статус
	|	И Док.ДоляСтоимости <> Док.КоличествоФакт * 1000
	|
	|УПОРЯДОЧИТЬ ПО
	|	Док.Ссылка.Дата";
	
	Данные      = Запрос.Выполнить().Выгрузить();
	АдресДанных = ПоместитьВоВременноеХранилище(Данные, УникальныйИдентификатор);
	
	Если ТипЗнч(Данные) = Тип("ДеревоЗначений") Тогда
		Возврат Данные.Строки.Количество();
	Иначе	
		Возврат Данные.Количество();
	КонецЕсли;	
	
КонецФункции

&НаСервереБезКонтекста
Функция ОбработатьЭлемент(ДанныеЭлемента, ДополнительныеПараметры)
	
	СпрОбъект = ДанныеЭлемента.Ссылка.ПолучитьОбъект();
	СпрОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецФункции	

&НаСервереБезКонтекста
Функция ОбработатьПорциюНаСервере(Начало, Конец, АдресДанных, ДополнительныеПараметры)
	
	Данные = ПолучитьИзВременногоХранилища(АдресДанных);
	Если ТипЗнч(Данные) = Тип("ДеревоЗначений") Тогда
		Данные = Данные.Строки;
	КонецЕсли;	
	
	КоличествоОшибок = 0;
	Для Счетчик = Начало - 1 По Конец - 1 Цикл
		
		Попытка
			НачатьТранзакцию();
			ОбработатьЭлемент(Данные[Счетчик], ДополнительныеПараметры);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			КоличествоОшибок = КоличествоОшибок + 1;
			Сообщить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;	
		
	КонецЦикла;
	
	Возврат КоличествоОшибок;
	
КонецФункции	
	
&НаКлиенте
Процедура ВыполнитьОбработкуИндикатор(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПослеЗакрытияВопроса", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, "Выполнить обработку?", РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Да, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработкуСостояние(Команда)
	
	ВыполнитьОбработку(10);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияВопроса(Ответ, Параметр) Экспорт
	
	ВыполнитьОбработку(10, Элементы.Индикатор, Элементы.Обработано);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработку(РазмерШага, ЭлементИндикатор = Неопределено, ЭлементПояснение = Неопределено)
	
	Количество      = ИнициализацияОбработкиСервер();
	КоличествоШагов = Цел(Количество / РазмерШага);
	КоличествоЦел   = КоличествоШагов * РазмерШага;
	
	Если КоличествоЦел < Количество Тогда
		МаксимальноеЗначение = КоличествоШагов + 1;
	Иначе
		МаксимальноеЗначение = КоличествоШагов;
	КонецЕсли;
	
	Если ЭлементИндикатор <> Неопределено Тогда
		ЭлементИндикатор.МаксимальноеЗначение = МаксимальноеЗначение;
	КонецЕсли;	
	
	Пояснение = "Для прерывания нажмите Ctrl+Break";
	ДополнительныеПараметры = Неопределено;
	
	ВремяНачала = ТекущаяДата();
	
	ВсегоОшибок = 0;
	Для Счетчик = 1 По КоличествоШагов Цикл
		
		ОшибокНаШаге = ОбработатьПорциюНаСервере(РазмерШага * (Счетчик - 1) + 1, РазмерШага * Счетчик, АдресДанных, ДополнительныеПараметры);
		ВсегоОшибок = ВсегоОшибок + ОшибокНаШаге;
		
		Текст = "Обработано: " + Формат(РазмерШага * Счетчик) + " из " + Формат(Количество);
		Если ВсегоОшибок > 0 Тогда
			Текст = Текст + " - Ошибок: " + Формат(ВсегоОшибок);
		КонецЕсли;	
		
		ПрошлоВремени   = ТекущаяДата() - ВремяНачала;
		СкоростьШага    = ПрошлоВремени / Счетчик;
		ОсталосьВремени = Окр((КоличествоШагов - Счетчик) * СкоростьШага, 0);
		ОсталосьВремениМин = Цел(ОсталосьВремени / 60);
		ОсталосьВремениСек = ОсталосьВремени - 60*ОсталосьВремениМин;
		
		Текст = Текст + ". Осталось: " + ОсталосьВремениМин + "м " + ОсталосьВремениСек + " с";
		
		Если ЭлементИндикатор = Неопределено Тогда
			Состояние(Текст, Окр(Счетчик / МаксимальноеЗначение * 100, 0), Пояснение);
		Иначе
			ЭтаФорма[ЭлементИндикатор.Имя] = Счетчик;
			ЭтаФорма[ЭлементПояснение.Имя] = Текст;
		КонецЕсли;	
		
		ОбработкаПрерыванияПользователя();
		Если ЭлементИндикатор <> Неопределено Тогда
			ОбновитьОтображениеДанных();
		КонецЕсли;
		
	КонецЦикла;
	
	Если КоличествоЦел < Количество Тогда
		ОбработатьПорциюНаСервере(КоличествоШагов * РазмерШага + 1, Количество, АдресДанных, ДополнительныеПараметры);
	КонецЕсли;
	
	Состояние("Обработка завершениа");
	
КонецПроцедуры	

// Прочие процедуры и функции
&НаСервереБезКонтекста
Функция ОбработатьПроводки(ДанныеЭлемента, ДополнительныеПараметры)
	
	Сообщить(ДанныеЭлемента.Регистратор);
	
	НаборЗаписей = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(ДанныеЭлемента.Регистратор);
	НаборЗаписей.Прочитать();
		
	Для каждого Строка1 Из ДанныеЭлемента.Строки Цикл
		
		Запись = НаборЗаписей[Строка1.НомерСтроки - 1];
		
		Если Строка1.ДтКт = "Дт" Тогда
		Иначе
		КонецЕсли;	
		
	КонецЦикла;
	
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать();
	
КонецФункции