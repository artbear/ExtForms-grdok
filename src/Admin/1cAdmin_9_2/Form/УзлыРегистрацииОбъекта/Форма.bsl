﻿
// Обработчики событий формы.

&НаСервере
Функция ОбъектОбработка(ТекущийОбъект = Неопределено)
	Если ТекущийОбъект = Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УстановитьУсловноеОформление();
	
	Объект.Настройки = Параметры.Настройки;
	ЗаполнитьЗначенияСвойств(Объект, Объект.Настройки);
	РежимИспользованияМодальностиБулево = Объект.РежимИспользованияМодальностиБулево;
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	ТекущийОбъект = ОбъектОбработка();
	ТекущийОбъект.ПрочитатьНастройки();
	ОбъектОбработка(ТекущийОбъект);
	
	ОбъектРегистрации = Параметры.ОбъектРегистрации;
	Расшифровка       = "";
	
	Если ТипЗнч(ОбъектРегистрации) = Тип("Структура") Тогда
		ТаблицаРегистрации = Параметры.ТаблицаРегистрации;
		ОбъектСтрокой = ТаблицаРегистрации;
		Для Каждого КлючЗначение Из ОбъектРегистрации Цикл
			Расшифровка = Расшифровка + "," + КлючЗначение.Значение;
		КонецЦикла;
		Расшифровка = " (" + Сред(Расшифровка,2) + ")";
	Иначе		
		ТаблицаРегистрации = "";
		ОбъектСтрокой = ОбъектРегистрации;
	КонецЕсли;
	Заголовок = "Регистрация " + ТекущийОбъект.ПредставлениеСсылки(ОбъектСтрокой) + Расшифровка;
	
	ПрочитатьУзлыОбмена();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РазвернутьВсеУзлы();
КонецПроцедуры

// Обработчики событий элементов таблицы формы ДеревоУзловОбмена.
//

&НаКлиенте
Процедура ДеревоУзловОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Перем ТекущиеДанные, Подсказка;
	Перем Оповещение, Параметры;
	
	СтандартнаяОбработка = Ложь;
	Если Поле = Элементы.ДеревоУзловОбменаНаименование Или Поле = Элементы.ДеревоУзловОбменаКод Тогда
		ОткрытьФормуРедактированияДругихОбъектов();
		Возврат;
	ИначеЕсли Поле <> Элементы.ДеревоУзловОбменаНомерСообщения Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	
	Подсказка = НСтр("ru = 'Номер отправленного'"); 
	Если ИспользоватьРежимМодальности() Тогда
		Параметры = Новый Структура("Узел", ТекущиеДанные.Ссылка);
		// Стандартно в модальном режиме (8.2/8.3) с обработкой результата.
		Если ВвестиЧисло(ТекущиеДанные.НомерСообщения, Подсказка) Тогда
			ДеревоУзловОбменаВыборЗавершение(ТекущиеДанные.НомерСообщения, Параметры);
		КонецЕсли;
	Иначе
		// Стандартно в немодальном режиме (8.3) с обработкой результата.
		//+yuraos, 10.09.2015 - для обратной совместимости лучше использовать атрибут "ЭтаФорма", "ЭтотОбъект" появляется в режиме совместимости "Версия 8.3.3" и выше.
		Оповещение = Вычислить("Новый ОписаниеОповещения(""ДеревоУзловОбменаВыборЗавершение"", ЭтаФормаЭтотОбъект(), Новый Структура)");
		Выполнить("Оповещение.ДополнительныеПараметры.Вставить(""Узел"", ТекущиеДанные.Ссылка)");
		Выполнить("ПоказатьВводЧисла(Оповещение, ТекущиеДанные.НомерСообщения, Подсказка)");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоУзловОбменаВыборЗавершение(Знач Число, Знач ДополнительныеПараметры) Экспорт
	
	Если Число = Неопределено Тогда 
		// Отказ от ввода
		Возврат;
	КонецЕсли;
	
	ИзменитьНомерСообщенияНаСервере(ДополнительныеПараметры.Узел, Число, ОбъектРегистрации, ТаблицаРегистрации);
	
	ТекущийУзел = ТекущийВыбранныйУзел();
	ПрочитатьУзлыОбмена(Истина);
	РазвернутьВсеУзлы(ТекущийУзел);
	
	Если Параметры.ОповещатьОбИзменениях Тогда
		Оповестить("ИзменениеРегистрацииОбменаДаннымиОбъекта",
			Новый Структура("ОбъектРегистрации, ТаблицаРегистрации", ОбъектРегистрации, ТаблицаРегистрации),
			ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоУзловОбменаПометкаПриИзменении(Элемент)
	ИзменениеПометки(Элементы.ДеревоУзловОбмена.ТекущаяСтрока);
КонецПроцедуры

// Обработчики команд формы

&НаКлиенте
Процедура ПеречитатьДеревоУзлов(Команда)
	ТекущийУзел = ТекущийВыбранныйУзел();
	ПрочитатьУзлыОбмена();
	РазвернутьВсеУзлы(ТекущийУзел);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияОтУзла(Команда)
	ОткрытьФормуРедактированияДругихОбъектов();
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсеУзлы(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		СтрокаПлана.Пометка = Истина;
		ИзменениеПометки(СтрокаПлана.ПолучитьИдентификатор())
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуВсемУзлам(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		СтрокаПлана.Пометка = Ложь;
		ИзменениеПометки(СтрокаПлана.ПолучитьИдентификатор())
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьПометкуВсемУзлам(Команда)
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
			СтрокаУзла.Пометка = Не СтрокаУзла.Пометка;
			ИзменениеПометки(СтрокаУзла.ПолучитьИдентификатор())
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРегистрацию(Команда)
	Перем ЗаголовокВопроса, Текст;
	Перем Оповещение;
	
	ЗаголовокВопроса = НСтр("ru = 'Подтверждение'");
	Текст = НСтр("ru = 'Изменить регистрацию ""%1""
	             |на узлах?'");
	
	Текст = СтрЗаменить(Текст, "%1", ОбъектРегистрации);
	
	Если ИспользоватьРежимМодальности() Тогда
		// Стандартно в модальном режиме (8.2/8.3) с обработкой результата.
		Ответ = Вопрос(Текст, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет, ЗаголовокВопроса, КодВозвратаДиалога.Нет);
		ИзменитьРегистрациюЗавершение(Ответ, Неопределено);
	Иначе
		// Стандартно в немодальном режиме (8.3) с обработкой результата.
		//+yuraos, 10.09.2015 - для обратной совместимости лучше использовать атрибут "ЭтаФорма", "ЭтотОбъект" появляется в режиме совместимости "Версия 8.3.3" и выше.
		Оповещение = Вычислить("Новый ОписаниеОповещения(""ИзменитьРегистрациюЗавершение"", ЭтаФормаЭтотОбъект(), Неопределено)");
		Выполнить("ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет, ЗаголовокВопроса)");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРегистрациюЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Перем ЗначениеОтвета;
	
	ЗначениеОтвета = ПолучитьКодВозвратаДиалога(РезультатВопроса);
	Если ЗначениеОтвета = Неопределено ИЛИ ЗначениеОтвета = КодВозвратаДиалога.НЕТ ИЛИ ЗначениеОтвета = КодВозвратаДиалога.Таймаут Тогда
		Возврат;
	КонецЕсли;
	
	Количество = ИзменениеРегистрацииПоУзлам(ДеревоУзловОбмена);
	Если Количество > 0 Тогда
		Текст = НСтр("ru = 'Регистрация %1 была изменена на %2 узлах'");
		ЗаголовокОповещения = НСтр("ru = 'Изменение регистрации:'");
		
		Текст = СтрЗаменить(Текст, "%1", ОбъектРегистрации);
		Текст = СтрЗаменить(Текст, "%2", Количество);
		
		ПоказатьОповещениеПользователя(ЗаголовокОповещения,
			ПолучитьНавигационнуюСсылку(ОбъектРегистрации),
			Текст,
			Элементы.СкрытаяКартинкаИнформация32.Картинка);
		
		Если Параметры.ОповещатьОбИзменениях Тогда
			Оповестить("ИзменениеРегистрацииОбменаДаннымиОбъекта",
				Новый Структура("ОбъектРегистрации, ТаблицаРегистрации", ОбъектРегистрации, ТаблицаРегистрации),
				ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
	ТекущийУзел = ТекущийВыбранныйУзел();
	ПрочитатьУзлыОбмена(Истина);
	РазвернутьВсеУзлы(ТекущийУзел);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастроек(Команда)
	ОткрытьФормуНастроекОбработки();
КонецПроцедуры

// Служебные процедуры и функции.

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаНомерСообщения.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоУзловОбмена.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоУзловОбмена.Пометка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ДеревоУзловОбменаНомерСообщения'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не выгружалось'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаКод.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаАвторегистрация.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоУзловОбменаНомерСообщения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоУзловОбмена.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

КонецПроцедуры
//

&НаКлиенте
Функция ТекущийВыбранныйУзел()
	ТекущиеДанные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат Новый Структура("Наименование, Ссылка", ТекущиеДанные.Наименование, ТекущиеДанные.Ссылка);
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНастроекОбработки()
	ТекИмяФормы = ПолучитьИмяФормы() + "Форма.Настройки";
	ОткрытьФорму(ТекИмяФормы, , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияДругихОбъектов()
	ТекИмяФормы = ПолучитьИмяФормы() + "Форма.Форма";
	Данные = Элементы.ДеревоУзловОбмена.ТекущиеДанные;
	Если Данные <> Неопределено И Данные.Ссылка <> Неопределено Тогда
		ТекПараметры = Новый Структура("УзелОбмена, ИдентификаторКоманды, ОбъектыНазначения", Данные.Ссылка);
		ОткрытьФорму(ТекИмяФормы, ТекПараметры, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсеУзлы(УзелФокуса = Неопределено)
	НайденныйУзел = Неопределено;
	
	Для Каждого Строка Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Идентификатор = Строка.ПолучитьИдентификатор();
		Элементы.ДеревоУзловОбмена.Развернуть(Идентификатор, Истина);
		
		Если УзелФокуса <> Неопределено И НайденныйУзел = Неопределено Тогда
			Если Строка.Наименование = УзелФокуса.Наименование И Строка.Ссылка = УзелФокуса.Ссылка Тогда
				НайденныйУзел = Идентификатор;
			Иначе
				Для Каждого Подстрока Из Строка.ПолучитьЭлементы() Цикл
					Если Подстрока.Наименование = УзелФокуса.Наименование И Подстрока.Ссылка = УзелФокуса.Ссылка Тогда
						НайденныйУзел = Подстрока.ПолучитьИдентификатор();
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если УзелФокуса <> Неопределено И НайденныйУзел <> Неопределено Тогда
		Элементы.ДеревоУзловОбмена.ТекущаяСтрока = НайденныйУзел;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменениеРегистрацииПоУзлам(Знач Данные)
	ТекущийОбъект = ОбъектОбработка();
	КоличествоУзлов = 0;
	Для Каждого Строка Из Данные.ПолучитьЭлементы() Цикл
		Если Строка.Ссылка <> Неопределено Тогда
			УжеЗарегистрировано = ТекущийОбъект.ОбъектЗарегистрированНаУзле(Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
			Если Строка.Пометка = 0 И УжеЗарегистрировано Тогда
				Результат = ТекущийОбъект.ИзменитьРегистрациюНаСервере(Ложь, Истина, Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
				КоличествоУзлов = КоличествоУзлов + Результат.Успешно;
			ИначеЕсли Строка.Пометка = 1 И (Не УжеЗарегистрировано) Тогда
				Результат = ТекущийОбъект.ИзменитьРегистрациюНаСервере(Истина, Истина, Строка.Ссылка, ОбъектРегистрации, ТаблицаРегистрации);
				КоличествоУзлов = КоличествоУзлов + Результат.Успешно;
			КонецЕсли;
		КонецЕсли;
		КоличествоУзлов = КоличествоУзлов + ИзменениеРегистрацииПоУзлам(Строка);
	КонецЦикла;
	Возврат КоличествоУзлов;
КонецФункции

&НаСервере
Функция ИзменитьНомерСообщенияНаСервере(Узел, НомерСообщения, Данные, ИмяТаблицы = Неопределено)
	Возврат ОбъектОбработка().ИзменитьРегистрациюНаСервере(НомерСообщения, Истина, Узел, Данные, ИмяТаблицы);
КонецФункции

&НаСервере
Функция ПолучитьИмяФормы(ТекущийОбъект = Неопределено)
	Возврат ОбъектОбработка().ПолучитьИмяФормы(ТекущийОбъект);
КонецФункции

&НаСервере
Процедура ИзменениеПометки(Строка)
	ЭлементДанных = ДеревоУзловОбмена.НайтиПоИдентификатору(Строка);
	ОбъектОбработка().ИзменениеПометки(ЭлементДанных);
КонецПроцедуры

&НаСервере
Процедура ПрочитатьУзлыОбмена(ТолькоОбновить = Ложь)
	ТекущийОбъект = ОбъектОбработка();
	Дерево = ТекущийОбъект.СформироватьДеревоУзлов(ОбъектРегистрации, ТаблицаРегистрации);
	
	Если ТолькоОбновить Тогда
		// Обновляем некоторые поля текущим данным.
		Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
			Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
				СтрокаДерева = Дерево.Строки.Найти(СтрокаУзла.Ссылка, "Ссылка", Истина);
				Если СтрокаДерева <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(СтрокаУзла, СтрокаДерева, "Пометка, ИсходнаяПометка, НомерСообщения, НеВыгружалось");
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		// Переформируем полностью
		ЗначениеВРеквизитФормы(Дерево, "ДеревоУзловОбмена");
	КонецЕсли;
	
	Для Каждого СтрокаПлана Из ДеревоУзловОбмена.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаУзла Из СтрокаПлана.ПолучитьЭлементы() Цикл
			ТекущийОбъект.ИзменениеПометки(СтрокаУзла);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// МОДАЛЬНОЕ/НЕМОДАЛЬНОЕ ПРЕДУПРЕЖДЕНИЕ.
//

&НаКлиенте
Процедура ПредупреждениеСообщение(Оповещение, ТекстПредупрежденияСообщения, Таймаут = 0, Заголовок = "")
	
	Если ИспользоватьРежимМодальности() Тогда
		// Стандартно в модальном режиме (8.2/8.3) с обработкой результата.
		Предупреждение(ТекстПредупрежденияСообщения, Таймаут, Заголовок);
	Иначе
		// Стандартно в немодальном режиме (8.3) с обработкой результата.
		Выполнить("ПоказатьПредупреждение(Оповещение, ТекстПредупрежденияСообщения, Таймаут, Заголовок)");
	КонецЕсли;;
		
КонецПроцедуры

&НаКлиенте
Функция ИспользоватьРежимМодальности()
	Возврат РежимИспользованияМодальностиБулево;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// НЕМОДАЛЬНЫЙ ВОПРОС.
//

&НаКлиенте
Функция ПолучитьКодВозвратаДиалога(Ответ)
	Перем ЗначениеОтвета;
	
	Если ТипЗнч(Ответ) = Тип("Структура") Тогда
		ЗначениеОтвета = Ответ.Значение;
	Иначе
		ЗначениеОтвета = Ответ;
	КонецЕсли;
	
	Возврат ЗначениеОтвета;
	
КонецФункции

//+yuraos, 20.10.2015
&НаКлиенте
Функция ЭтаФормаЭтотОбъект()
	Попытка
		Возврат Вычислить("ЭтотОбъект");
	Исключение
		Возврат Вычислить("ЭтаФорма");
	КонецПопытки;
КонецФункции
