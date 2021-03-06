﻿
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.ЗаказНаПроизводство"); //Указываем документ к которому делаем внешнюю печ. форму
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Вид          = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиЗаполнениеОбъекта();
	ПараметрыРегистрации.Наименование = Метаданные().Представление();
	ПараметрыРегистрации.Версия       = Метаданные().Комментарий;
	ПараметрыРегистрации.Назначение   = МассивНазначений;
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	ДобавитьКоманду(ПараметрыРегистрации.Команды, "Закрытие заказа", "Закрытие заказа", ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы(), Ложь);
		
	Возврат ПараметрыРегистрации;	
		
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

Процедура Заполнить() Экспорт
	
	ЗаполнитьВыпуск();
	ЗаполнитьПродукцию();
	ЗаполнитьМатериалы();
	
КонецПроцедуры

Процедура ЗаполнитьВыпуск() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Заказ",          ЗаказНаПроизводство);
	Запрос.Параметры.Вставить("СтатусВыполнен", Перечисления.СтатусыМаршрутныхЛистовПроизводства.Выполнен);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Выборка.Распоряжение КАК Распоряжение,
	|	Выборка.Номенклатура,
	|	Выборка.Характеристика,
	|	Выборка.Назначение,
	|	СУММА(Выборка.КоличествоМЛ) КАК КоличествоМЛ,
	|	СУММА(Выборка.КоличествоВыпуск) КАК КоличествоВыпуск
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДокВыходныеИзделия.Ссылка КАК Распоряжение,
	|		ДокВыходныеИзделия.Номенклатура КАК Номенклатура,
	|		ДокВыходныеИзделия.Характеристика КАК Характеристика,
	|		ДокВыходныеИзделия.Назначение КАК Назначение,
	|		ДокВыходныеИзделия.КоличествоФакт КАК КоличествоМЛ,
	|		0 КАК КоличествоВыпуск
	|	ИЗ
	|		Документ.МаршрутныйЛистПроизводства.ВыходныеИзделия КАК ДокВыходныеИзделия
	|	ГДЕ
	|		ДокВыходныеИзделия.Ссылка.Распоряжение В(&Заказ)
	|		И ДокВыходныеИзделия.Ссылка.Проведен
	|		И ДокВыходныеИзделия.Ссылка.Статус = &СтатусВыполнен
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДокВыходныеИзделия.Ссылка,
	|		ДокВыходныеИзделия.Номенклатура,
	|		ДокВыходныеИзделия.Характеристика,
	|		ДокВыходныеИзделия.Назначение,
	|		ДокВыходныеИзделия.КоличествоФакт,
	|		0
	|	ИЗ
	|		Документ.МаршрутныйЛистПроизводства.ВозвратныеОтходы КАК ДокВыходныеИзделия
	|	ГДЕ
	|		ДокВыходныеИзделия.Ссылка.Распоряжение В(&Заказ)
	|		И ДокВыходныеИзделия.Ссылка.Проведен
	|		И ДокВыходныеИзделия.Ссылка.Статус = &СтатусВыполнен
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Док.Распоряжение,
	|		Док.Номенклатура,
	|		Док.Характеристика,
	|		Док.Назначение,
	|		0,
	|		Док.Количество
	|	ИЗ
	|		Документ.ВыпускПродукции.Товары КАК Док
	|	ГДЕ
	|		Док.Ссылка.Проведен
	|		И Док.Распоряжение.Распоряжение В(&Заказ)) КАК Выборка
	|
	|СГРУППИРОВАТЬ ПО
	|	Выборка.Распоряжение,
	|	Выборка.Номенклатура,
	|	Выборка.Характеристика,
	|	Выборка.Назначение
	|
	|ИМЕЮЩИЕ
	|	СУММА(Выборка.КоличествоМЛ) <> СУММА(Выборка.КоличествоВыпуск)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Распоряжение
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Выпуск.Загрузить(Таблица);
	
КонецПроцедуры	

Процедура ЗаполнитьПродукцию() Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	_ЗаказНаПроизводство.ВТСостояниеЗаказа(МенеджерВременныхТаблиц, ЗаказНаПроизводство);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Параметры.Вставить("Заказ", ЗаказНаПроизводство);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК Пометка,
	|	ВТСостояниеЗаказа.КодСтроки КАК КодСтроки,
	|	ВТСостояниеЗаказа.КлючСвязи КАК КлючСвязи,
	|	ВТСостояниеЗаказа.Номенклатура КАК Номенклатура,
	|	ВТСостояниеЗаказа.Характеристика КАК Характеристика,
	|	ВТСостояниеЗаказа.Назначение КАК Назначение,
	|	ВТСостояниеЗаказа.КоличествоПлан КАК КоличествоПлан,
	|	ВТСостояниеЗаказа.КоличествоФакт КАК КоличествоФакт,
	|	ВТСостояниеЗаказа.КоличествоОстаток КАК КоличествоОстаток,
	|	Этапы.Запланировано КАК ЭтаповЗапланировано,
	|	Этапы.Выполнено КАК ЭтаповВыполнено
	|ИЗ
	|	ВТСостояниеЗаказа КАК ВТСостояниеЗаказа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Этапы КАК Этапы
	|		ПО ВТСостояниеЗаказа.Заказ = Этапы.Заказ
	|			И ВТСостояниеЗаказа.КодСтроки = Этапы.КодСтроки
	|ГДЕ
	|	Этапы.Остаток > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодСтроки,
	|	Назначение,
	|	Номенклатура,
	|	Характеристика
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Продукция.Загрузить(Таблица);
	
КонецПроцедуры	

Процедура ЗаполнитьМатериалы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Заказ", ЗаказНаПроизводство);
	Запрос.Параметры.Вставить("ВариантНеТребуется", Перечисления.ВариантыОбеспечения.НеТребуется);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегОбороты.Распоряжение КАК Заказ,
	|	РегОбороты.Номенклатура,
	|	РегОбороты.Характеристика,
	|	РегОбороты.Назначение,
	|	РегОбороты.ВариантОбеспечения,
	|	РегОбороты.КодСтрокиРаспоряжения,
	|	РегОбороты.ДатаПотребности,
	|	РегОбороты.Склад,
	|	РегОбороты.КодСтроки,
	|	РегОбороты.Упаковка,
	|	РегОбороты.Подразделение,
	|	РегОбороты.КоличествоОборот КАК Количество
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловСУчетомКорректировок.Обороты(, , , Распоряжение В (&Заказ)) КАК РегОбороты
	|ГДЕ
	|	РегОбороты.ВариантОбеспечения <> &ВариантНеТребуется";
	
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Материалы.Загрузить(Таблица);
	
КонецПроцедуры	


Функция ЗакрытьЗаказ() Экспорт
	
	МассивДокументов = Новый Массив;
	
	НачатьТранзакцию();
	ЗаказОбъект = ЗаказНаПроизводство.ПолучитьОбъект();
	ЗаказОбъект.Заблокировать();
	
	Если ЗаказОбъект.Статус = Перечисления.СтатусыЗаказовНаПроизводство.Закрыт Тогда
		Возврат "Уже закрыт";
	КонецЕсли;	
	
	СократитьПроизводство(ЗаказОбъект);
	
	ДокСсылка = СформироватьКорректировкуМатериалов();
	Если ДокСсылка <> Неопределено Тогда
		МассивДокументов.Добавить(ДокСсылка);
	КонецЕсли;	
	
	ЗаказОбъект.Статус = Перечисления.СтатусыЗаказовНаПроизводство.Закрыт;
	ЗаказОбъект.ДополнительныеСвойства.Вставить("ВерсионированиеОбъектовКомментарийКВерсии", "Закрыт");
	ЗаказОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	ДокСсылка = СформироватьНовыйЗаказ();
	Если ДокСсылка <> Неопределено Тогда
		МассивДокументов.Добавить(ДокСсылка);
	КонецЕсли;	
	
	ЗафиксироватьТранзакцию();
	
	Возврат МассивДокументов;
	
КонецФункции	

Функция СформироватьКорректировкуМатериалов()
	
	Если Материалы.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	ТаблицаПодразделенией = Материалы.Выгрузить(, "Подразделение");
	ТаблицаПодразделенией.Свернуть("Подразделение", "");
	
	Для каждого СтрокаПодразделения из ТаблицаПодразделенией Цикл
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаказНаПроизводство, "Организация");
		
		ДокументОбъект = Документы.КорректировкаЗаказаМатериаловВПроизводство.СоздатьДокумент();
		ДокументОбъект.Дата          = ТекущаяДатаСеанса();
		ДокументОбъект.Организация   = Реквизиты.Организация;
		ДокументОбъект.Подразделение = СтрокаПодразделения.Подразделение;
		ДокументОбъект.Распоряжение  = ЗаказНаПроизводство;
		ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
		
		Для каждого СтрокаТЧ из Материалы.Выгрузить(Новый Структура("Подразделение", СтрокаПодразделения.Подразделение)) Цикл
			
			НоваяСтрока = ДокументОбъект.МатериалыИУслуги.Добавить();
			НоваяСтрока.Номенклатура   = СтрокаТЧ.Номенклатура;
			НоваяСтрока.Характеристика = СтрокаТЧ.Характеристика;
			НоваяСтрока.НазначениеИсходный = СтрокаТЧ.Назначение;
			НоваяСтрока.Назначение         = СтрокаТЧ.Назначение;
			НоваяСтрока.ЗаказатьНаСкладИсходный = Истина;
			НоваяСтрока.СкладИсходный      = СтрокаТЧ.Склад;
			НоваяСтрока.Склад              = Неопределено;
			НоваяСтрока.ВариантОбеспеченияИсходный = СтрокаТЧ.ВариантОбеспечения;
			НоваяСтрока.ВариантОбеспечения         = Перечисления.ВариантыОбеспечения.НеТребуется;
			НоваяСтрока.ДатаПотребностиИсходный    = СтрокаТЧ.ДатаПотребности;
			НоваяСтрока.ДатаПотребности            = СтрокаТЧ.ДатаПотребности;
			НоваяСтрока.КодСтрокиИсходный  = СтрокаТЧ.КодСтроки;
			НоваяСтрока.КодСтроки          = СтрокаТЧ.КодСтроки;
			НоваяСтрока.КодСтрокиРаспоряжения      = СтрокаТЧ.КодСтрокиРаспоряжения;
			НоваяСтрока.КоличествоУпаковок = СтрокаТЧ.Количество;
			НоваяСтрока.Количество         = СтрокаТЧ.Количество;
			НоваяСтрока.УпаковкаИсходный   = СтрокаТЧ.Упаковка;
			НоваяСтрока.Упаковка           = СтрокаТЧ.Упаковка;
			
		КонецЦикла;
		
		ДокументОбъект.Записать();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	КонецЦикла;
	
	Возврат ДокументОбъект.Ссылка;
	
КонецФункции	

Функция СократитьПроизводство(ЗаказОбъект)
	
	Если Продукция.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	// Сокращение производства
	Для каждого СтрокаТЧ из Продукция Цикл
		СократитьПроизводствоПоСтроке(ЗаказОбъект, СтрокаТЧ);
	КонецЦикла;	
	
	ЗаказОбъект.СтатусГрафикаПроизводства = Перечисления.СтатусыГрафикаПроизводстваВЗаказеНаПроизводство.ТребуетсяРассчитать;
	ЗаказОбъект.РассчитатьГрафикВыпуска();
	ЗаказОбъект.ДополнительныеСвойства.Вставить("ВерсионированиеОбъектовКомментарийКВерсии", "Сокращение заказа при закрытии");
	ЗаказОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	
	//ЗаполнитьМатериалы();
	
	// Формирование и обнуление МЛ
	МассивЗаказов = Новый Массив;
	МассивЗаказов.Добавить(ЗаказНаПроизводство);
	Результат = ОперативныйУчетПроизводстваВызовСервера.СформироватьМаршрутныеЛистыПоЗаказам(МассивЗаказов);
	Если Результат.Выполнено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Параметры.Вставить("Заказ",  ЗаказНаПроизводство);
		Запрос.Параметры.Вставить("Статус", Перечисления.СтатусыМаршрутныхЛистовПроизводства.Создан);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Док.Ссылка
		|ИЗ
		|	Документ.МаршрутныйЛистПроизводства КАК Док
		|ГДЕ
		|	Док.Проведен
		|	И Док.Статус = &Статус
		|	И Док.Распоряжение = &Заказ";
		
		Таблица = Запрос.Выполнить().Выгрузить();
		Для каждого СтрокаТЗ из Таблица Цикл
			
			ДокументОбъект = СтрокаТЗ.Ссылка.ПолучитьОбъект();
			Если Ложь Тогда
				ДокументОбъект = Документы.МаршрутныйЛистПроизводства.СоздатьДокумент();
			КонецЕсли;	
			
			ДокументОбъект.ВыходныеИзделия.Очистить();
			ДокументОбъект.ВозвратныеОтходы.Очистить();
			ДокументОбъект.МатериалыИУслуги.Очистить();
			ДокументОбъект.Трудозатраты.Очистить();
			
			Если Месяц(ТекущаяДатаСеанса()) <> Месяц(ЗаказОбъект.Дата) Тогда
				ДатаВыполнения = КонецМесяца(ЗаказОбъект.Дата);
			Иначе
				ДатаВыполнения = Неопределено;
			КонецЕсли;	
				
			ДокументОбъект.Статус = Перечисления.СтатусыМаршрутныхЛистовПроизводства.Выполнен;
			ДокументОбъект.ПриИзмененииСтатуса(Перечисления.СтатусыМаршрутныхЛистовПроизводства.Создан, ДатаВыполнения);
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЦикла;
		
	КонецЕсли;	
	
КонецФункции

Функция СократитьПроизводствоПоСтроке(ЗаказОбъект, СтрокаТЧ)
	
	// Структура данных
	СписокКодовСтрокПродукции = Новый Массив;
	СписокКодовСтрокПродукции.Добавить(СтрокаТЧ.КодСтроки);
	
	ПараметрыЗадания = Новый Структура;
	
	ПараметрыЗадания.Вставить("СписокЗаказов",             ЗаказНаПроизводство);
	ПараметрыЗадания.Вставить("СписокКодовСтрокПродукции", СписокКодовСтрокПродукции);
	ПараметрыЗадания.Вставить("ТекущаяДатаСеанса",         ТекущаяДатаСеанса());
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	Обработки.СокращениеПроизводства.СостояниеЗаказовНаПроизводство(ПараметрыЗадания, АдресХранилища);
	
	
	// Отменить неначатое
	ПараметрыСокращения = Новый Структура;
	ПараметрыСокращения.Вставить("Заказ",                        ЗаказНаПроизводство);
	ПараметрыСокращения.Вставить("КлючСвязиПродукция",           СтрокаТЧ.КлючСвязи);
	ПараметрыСокращения.Вставить("КлючСвязиПолуфабрикат",        Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	ПараметрыСокращения.Вставить("ДоделатьНачатыеПолуфабрикаты", Истина);
	ПараметрыСокращения.Вставить("НовоеКоличество",              СтрокаТЧ.КоличествоФакт);
	ПараметрыСокращения.Вставить("КоличествоТребуется",          СтрокаТЧ.КоличествоФакт);
	ПараметрыСокращения.Вставить("БезопасноеСокращение",         СтрокаТЧ.КоличествоФакт);
	
	
	// Параметры команды
	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("АдресХранилища", АдресХранилища);
	ПараметрыКоманды.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор);
	
	ПараметрыКоманды.Вставить("ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	ПараметрыКоманды.Вставить("ПоказыватьЭтапы",   Ложь);
	
	ПараметрыКоманды.Вставить("ПараметрыСокращения", ПараметрыСокращения);

	АдресХранилища = Обработки.СокращениеПроизводства.СократитьПроизводство(ПараметрыКоманды);
	
	
	// Изменение заказа
	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("Заказ", ЗаказНаПроизводство);
	ПараметрыКоманды.Вставить("КодСтрокиПродукция", СтрокаТЧ.КодСтроки);
	ПараметрыКоманды.Вставить("КлючСвязиПродукция", СтрокаТЧ.КлючСвязи);
	
	ПараметрыКоманды.Вставить("АдресХранилища", АдресХранилища);
	ПараметрыКоманды.Вставить("АдресСпецификация", ПланированиеПроизводства.ДанныеСпецификацииЗаказаВХранилилище(
		ЗаказОбъект, СтрокаТЧ.КлючСвязи, Новый УникальныйИдентификатор));
	
	ПараметрыКоманды.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор);
	
	ПланированиеПроизводства.УдалитьДанныеСпецификацииПоКлючу(ЗаказОбъект, СтрокаТЧ.КлючСвязи);
	
	РезультатРедактирования = Обработки.СокращениеПроизводства.РезультатРедактированияСтрокиСпецификацииЗаказа(ПараметрыКоманды);
	
	 //Запись изменений в табличную часть Продукция.
	ДанныеПродукции = ЗаказОбъект.Продукция.Найти(РезультатРедактирования.СтруктураПродукции.КлючСвязи, "КлючСвязи");
	
	ЗаполнитьЗначенияСвойств(ДанныеПродукции, РезультатРедактирования.СтруктураПродукции, "Упаковка, КоличествоУпаковок, Количество, ДатаПотребности,
		|НачатьНеРанее, РазмещениеВыпуска, Склад, Назначение, ЕстьСоответствиеСтандартнойСпецификации");
	ДанныеПродукции.ГрафикРассчитан = Ложь;
	
	// Запись изменений в табличную часть Этапы.
	Для Каждого Строка Из РезультатРедактирования.Этапы Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.Этапы.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть ВыходныеИзделия.
	Для Каждого Строка Из РезультатРедактирования.ВыходныеИзделия Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.ВыходныеИзделия.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть ВозвратныеОтходы.
	Для Каждого Строка Из РезультатРедактирования.ВозвратныеОтходы Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.ВозвратныеОтходы.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть МатериалыИУслуги.
	Для Каждого Строка Из РезультатРедактирования.МатериалыИУслуги Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.МатериалыИУслуги.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть Трудозатраты.
	Для Каждого Строка Из РезультатРедактирования.Трудозатраты Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.Трудозатраты.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть ВидыРабочихЦентров.
	Для Каждого Строка Из РезультатРедактирования.ВидыРабочихЦентров Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.ВидыРабочихЦентров.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть АльтернативныеВидыРабочихЦентров.
	Для Каждого Строка Из РезультатРедактирования.АльтернативныеВидыРабочихЦентров Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.АльтернативныеВидыРабочихЦентров.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть ЭтапыВосстановленияБрака.
	Для Каждого Строка Из РезультатРедактирования.ЭтапыВосстановленияБрака Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.ЭтапыВосстановленияБрака.Добавить(), Строка);
	КонецЦикла;
	
КонецФункции

Функция ДанныеПоНоменклатуре(ДанныеСтроки, РеквизитыЗаказа)
	
	ДанныеПоНоменклатуре = Новый Структура;
	
	ДанныеПоНоменклатуре.Вставить("КлючСвязиПродукция",     ДанныеСтроки.КлючСвязи);
	ДанныеПоНоменклатуре.Вставить("Номенклатура",           ДанныеСтроки.Номенклатура);
	ДанныеПоНоменклатуре.Вставить("Характеристика",         ДанныеСтроки.Характеристика);
	ДанныеПоНоменклатуре.Вставить("Склад",                  ДанныеСтроки.Склад);
	ДанныеПоНоменклатуре.Вставить("Подразделение",          ДанныеСтроки.Подразделение);
	ДанныеПоНоменклатуре.Вставить("Спецификация",           ДанныеСтроки.Спецификация);
	ДанныеПоНоменклатуре.Вставить("Количество",             ДанныеСтроки.Количество);
	ДанныеПоНоменклатуре.Вставить("Упаковка",               ДанныеСтроки.Упаковка);
	ДанныеПоНоменклатуре.Вставить("НачалоПроизводства",     ДанныеСтроки.НачатьНеРанее);
	ДанныеПоНоменклатуре.Вставить("ДатаПотребности",        ДанныеСтроки.НачатьНеРанее);
	ДанныеПоНоменклатуре.Вставить("КлючСвязиПолуфабрикат");
	ДанныеПоНоменклатуре.Вставить("КлючСвязиЭтапы");
	
	ДанныеПоНоменклатуре.Вставить("Назначение",             ДанныеСтроки.Назначение);
	ДанныеПоНоменклатуре.Вставить("НазначениеЗаказа",       РеквизитыЗаказа.Назначение);
	
	ДанныеПоНоменклатуре.Вставить("ПодразделениеДиспетчер", РеквизитыЗаказа.Подразделение);
	
	Возврат ДанныеПоНоменклатуре;
	
КонецФункции

Функция СформироватьНовыйЗаказ()
	
	Если ВариантСократитьПроизводство = "ОтменитьВыполнение" Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	КэшированныеЗначения = Неопределено;
	МассивДанных = Новый Массив;
	
	НовыйЗаказ = Документы.ЗаказНаПроизводство.СоздатьДокумент();
	НовыйЗаказ.Дата          = ТекущаяДатаСеанса();
	НовыйЗаказ.Ответственный = Пользователи.ТекущийПользователь();
	НовыйЗаказ.Комментарий   = "Сформирован обработкой закрытие заказа";
	НовыйЗаказ.Приоритет     = Справочники.Приоритеты.НайтиПоНаименованию("Средний");
	НовыйЗаказ.Статус        = Перечисления.СтатусыЗаказовНаПроизводство.Создан;
	НовыйЗаказ.Организация   = ЗаказНаПроизводство.Организация;
	НовыйЗаказ.Подразделение = ЗаказНаПроизводство.Подразделение;
	НовыйЗаказ.ЗаказПодДеятельность = ЗаказНаПроизводство.ЗаказПодДеятельность;
	НовыйЗаказ.СтатусГрафикаПроизводства = Перечисления.СтатусыГрафикаПроизводстваВЗаказеНаПроизводство.ТребуетсяРассчитать;
	
	Для каждого СтрокаТЧ из Продукция Цикл
		
		Если НЕ СтрокаТЧ.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаЗаказа = ЗаказНаПроизводство.Продукция.Найти(СтрокаТЧ.КодСтроки, "КодСтроки");
		
		НоваяСтрока = НовыйЗаказ.Продукция.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗаказа);
		
		НоваяСтрока.Количество         = СтрокаТЧ.КоличествоОстаток;
		НоваяСтрока.КоличествоУпаковок = СтрокаТЧ.КоличествоОстаток;
		НоваяСтрока.НачатьНеРанее      = ТекущаяДата();
		НоваяСтрока.ДатаПотребности    = Макс(НоваяСтрока.НачатьНеРанее + 86400, НоваяСтрока.ДатаПотребности);
		
		МассивДанных.Добавить(ДанныеПоНоменклатуре(НоваяСтрока, НовыйЗаказ));
		
	КонецЦикла;	
		
	ПланированиеПроизводства.ЗаполнитьДанныеСпецификаций(НовыйЗаказ, МассивДанных, КэшированныеЗначения);
	НовыйЗаказ.Записать(РежимЗаписиДокумента.Запись);
	
	Возврат НовыйЗаказ.Ссылка;
	
КонецФункции