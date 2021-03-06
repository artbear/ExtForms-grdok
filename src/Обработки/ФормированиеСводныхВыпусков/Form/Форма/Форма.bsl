﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СхемаСКД = ОбработкаОбъект.ПолучитьМакет("СхемаСКД");
	
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаСКД, УникальныйИдентификатор);
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаСКД.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	СхемаСКД = ПолучитьИзВременногоХранилища(АдресСхемы);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаСКД, КомпоновщикНастроек.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Таблица = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	
	ТаблицаДанных.Загрузить(Таблица);
	Для каждого СтрокаТЗ из ТаблицаДанных Цикл
		
		Если СтрокаТЗ.КоличествоВыпусков = 1 Тогда
			СтрокаТЗ.Результат = 2;
		Иначе
			СтрокаТЗ.Результат = 1;
			СтрокаТЗ.Пометка   = Истина;
		КонецЕсли;	
			
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВклВсе(Команда)
	
	Для каждого СтрокаТЗ из ТаблицаДанных Цикл
		СтрокаТЗ.Пометка = Истина;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыклВсе(Команда)
	
	Для каждого СтрокаТЗ из ТаблицаДанных Цикл
		СтрокаТЗ.Пометка = Ложь;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ТаблицаДанныхСводныйВыпускПродукции" Тогда
		
		СтрокаТЗ = ТаблицаДанных.НайтиПоИдентификатору(ВыбраннаяСтрока);
		ПоказатьЗначение(,СтрокаТЗ.СводныйВыпускПродукции);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["НастройкиСКД"] <> Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки["НастройкиСКД"]);
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ПередЗакрытиемСервер(Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗакрытиемСервер(Отказ, СтандартнаяОбработка)
	
	НастройкиСКД = КомпоновщикНастроек.ПолучитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументы(Команда)
	
	Для каждого СтрокаТЗ из ТаблицаДанных Цикл
		
		Если СтрокаТЗ.Пометка Тогда
			
			Состояние("" + СтрокаТЗ.Подразделение + " / " + СтрокаТЗ.Склад);
			
			ПараметрыДокумента = Новый Структура;
			ПараметрыДокумента.Вставить("Месяц",              СтрокаТЗ.Месяц);
			ПараметрыДокумента.Вставить("Организация",        СтрокаТЗ.Организация);
			ПараметрыДокумента.Вставить("Подразделение",      СтрокаТЗ.Подразделение);
			ПараметрыДокумента.Вставить("Склад",              СтрокаТЗ.Склад);
			ПараметрыДокумента.Вставить("НаправлениеВыпуска", СтрокаТЗ.НаправлениеВыпуска);
			
			СтрокаТЗ.Результат = СформироватьСводыйВыпуск(ПараметрыДокумента, СтрокаТЗ.СводныйВыпускПродукции);
			Если СтрокаТЗ.Результат = 2 Тогда
				СтрокаТЗ.Количествовыпусков = 1;
			КонецЕсли;	
			ОчиститьСообщения();
			ОбновитьОтображениеДанных(Элементы.ТаблицаДанных);
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьСводыйВыпуск(Знач ПараметрыДокумента, СводныйВыпуск) Экспорт
	
	Если ПараметрыДокумента.КоличествоВыпусков = 1 Тогда
		Возврат 2;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(СводныйВыпуск) Тогда
		ДокументОбъект = СводныйВыпуск.ПолучитьОбъект();
	Иначе
		ДокументОбъект = Документы.ВыпускПродукции.СоздатьДокумент();
		ДокументОбъект.Дата               = НачалоДня(КонецМесяца(ПараметрыДокумента.Месяц));
		ДокументОбъект.Организация        = ПараметрыДокумента.Организация;
		ДокументОбъект.Подразделение      = ПараметрыДокумента.Подразделение;
		ДокументОбъект.Склад              = ПараметрыДокумента.Склад;
		ДокументОбъект.НаправлениеВыпуска = ПараметрыДокумента.НаправлениеВыпуска;
		ДокументОбъект.Комментарий        = "Сводный выпуск";
	КонецЕсли;
	
	ДокументОбъект.ВыпускПоРаспоряжениям = Истина;
	ДокументОбъект.ВыпускПодДеятельность = Перечисления.ТипыНалогообложенияНДС.ПоФактическомуИспользованию;
	ДокументОбъект.Ответственный         = Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыпускПродукцииТовары.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВыпускПродукцииТовары.Распоряжение = ЗНАЧЕНИЕ(Документ.МаршрутныйЛистПроизводства.ПустаяСсылка)
	|			ТОГДА ВыпускПродукцииТовары.Ссылка.Распоряжение
	|		ИНАЧЕ ВыпускПродукцииТовары.Распоряжение
	|	КОНЕЦ КАК Распоряжение,
	|	ВыпускПродукцииТовары.Номенклатура,
	|	ВыпускПродукцииТовары.Характеристика,
	|	ВыпускПродукцииТовары.Спецификация,
	|	ВыпускПродукцииТовары.Упаковка,
	|	ВыпускПродукцииТовары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВыпускПродукцииТовары.Количество КАК Количество,
	|	ВыпускПродукцииТовары.Цена,
	|	ВыпускПродукцииТовары.Сумма КАК Сумма,
	|	ВыпускПродукцииТовары.ТипСтоимости,
	|	ВыпускПродукцииТовары.СтатусУказанияСерий,
	|	ВыпускПродукцииТовары.КодСтроки,
	|	ВыпускПродукцииТовары.Серия,
	|	ВыпускПродукцииТовары.Назначение,
	|	ВыпускПродукцииТовары.СтатьяРасходов,
	|	ВыпускПродукцииТовары.АналитикаРасходов,
	|	ВыпускПродукцииТовары.СписатьНаРасходы,
	|	ВЫБОР
	|		КОГДА ВыпускПродукцииТовары.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ТОГДА ВыпускПродукцииТовары.Ссылка.Склад
	|		ИНАЧЕ ВыпускПродукцииТовары.Склад
	|	КОНЕЦ КАК Склад,
	|	ВыпускПродукцииТовары.Подразделение,
	|	ВыпускПродукцииТовары.Калькуляция
	|ИЗ
	|	Документ.ВыпускПродукции.Товары КАК ВыпускПродукцииТовары
	|ГДЕ
	|	ВыпускПродукцииТовары.Ссылка.Дата МЕЖДУ &Дата1 И &Дата2
	|	И ВыпускПродукцииТовары.Ссылка.Проведен
	|	И ВыпускПродукцииТовары.Ссылка.Организация = &Организация
	|	И ВыпускПродукцииТовары.Ссылка.Подразделение = &Подразделение
	|	И ВыпускПродукцииТовары.Ссылка.Склад = &Склад
	|	И ВыпускПродукцииТовары.Ссылка.НаправлениеВыпуска = &НаправлениеВыпуска
	|	И (ВыпускПродукцииТовары.Ссылка.Распоряжение <> ЗНАЧЕНИЕ(Документ.МаршрутныйЛистПроизводства.ПустаяСсылка)
	|			ИЛИ ВыпускПродукцииТовары.Ссылка.Комментарий ПОДОБНО &Комментарий)";
	
	Запрос.Параметры.Вставить("Дата1",              НачалоМесяца(ПараметрыДокумента.Месяц));
	Запрос.Параметры.Вставить("Дата2",              КонецМесяца(ПараметрыДокумента.Месяц));
	Запрос.Параметры.Вставить("Организация",        ПараметрыДокумента.Организация);
	Запрос.Параметры.Вставить("Подразделение",      ПараметрыДокумента.Подразделение);
	Запрос.Параметры.Вставить("Склад",              ПараметрыДокумента.Склад);
	Запрос.Параметры.Вставить("НаправлениеВыпуска", ПараметрыДокумента.НаправлениеВыпуска);
	Запрос.Параметры.Вставить("Комментарий",        "Сводный выпуск%");
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Если Таблица.Количество() = 0 Тогда
		// Документов нет, выходим
		Возврат 2;
	КонецЕсли;	
	
	ДокументОбъект.Товары.Загрузить(Таблица);
	
	ДокументОбъект.Записать();
	СводныйВыпуск = ДокументОбъект.Ссылка;
	
	Таблица.Свернуть("Ссылка");
	
	Попытка
		
		НачатьТранзакцию();
		
		Для каждого СтрокаТЗ из Таблица Цикл
			
			ДокументКУдалению = СтрокаТЗ.Ссылка.ПолучитьОбъект();
			ДокументКУдалению.УстановитьПометкуУдаления(Истина);
			
		КонецЦикла;	
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		ЗафиксироватьТранзакцию();
		
	Исключение	
		
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации("Формирование сводных выпусков", УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.ВыпускПродукции,
			ДокументОбъект.Ссылка,
			ОписаниеОшибки());
			
		Возврат 0;
		
	КонецПопытки;
	
	Возврат 2;
	
КонецФункции	

&НаКлиенте
Процедура СброситьНастройки(Команда)
	СброситьНастройкиНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьНастройкиНаСервере()
	
	СхемаСКД = ПолучитьИзВременногоХранилища(АдресСхемы);
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаСКД.НастройкиПоУмолчанию);
	
КонецПроцедуры
