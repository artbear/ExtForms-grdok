﻿
// Сервисная экспортная функция. Вызывается в основной программе при регистрации обработки в информационной базе
// Возвращает структуру с параметрами регистрации
//
// Возвращаемое значение:
//		Структура с полями:
//			Вид - строка, вид обработки, один из возможных: "ДополнительнаяОбработка", "ДополнительныйОтчет", 
//					"ЗаполнениеОбъекта", "Отчет", "ПечатнаяФорма", "СозданиеСвязанныхОбъектов"
//			Назначение - Массив строк имен объектов метаданных в формате: 
//					<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]. 
//					Например, "Документ.СчетЗаказ" или "Справочник.*". Параметр имеет смысл только для назначаемых обработок, для глобальных может не задаваться.
//			Наименование - строка - Наименование обработки, которым будет заполнено наименование элемента справочника по умолчанию.
//			Информация  - строка - Краткая информация или описание по обработке.
//			Версия - строка - Версия обработки в формате “<старший номер>.<младший номер>” используется при загрузке обработок в информационную базу.
//			БезопасныйРежим - булево - Принимает значение Истина или Ложь, в зависимости от того, требуется ли устанавливать или отключать безопасный режим 
//							исполнения обработок. Если истина, обработка будет запущена в безопасном режиме. 
//
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	//Инициализируем структуру с параметрами регистрации
	
	//Определяем список объектов, вызывающих обработку
	ОбъектыНазначенияФормы = Новый Массив;
	ОбъектыНазначенияФормы.Добавить("Документ.ЗаказКлиента");
	ОбъектыНазначенияФормы.Добавить("Документ.ТранспортнаяНакладная");
	ОбъектыНазначенияФормы.Добавить("Документ.РеализацияТоваровУслуг");
	
	ПараметрыРегистрации = ПолучитьПараметрыРегистрации(ОбъектыНазначенияФормы);
	
	//Определяем команды для печати формы
	
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	
	ДобавитьКоманду(ТаблицаКоманд,
		"Лист отгрузки", // Представление команды в пользовательском интерфейсе
		"ЛистОтгрузки",	// Уникальный идентификатор команды
		);
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Формирует структуру с параметрами регистрации регистрации обработки в информационной базе
//
// Параметры:
//	ОбъектыНазначенияФормы - Массив - Массив строк имен объектов метаданных в формате: 
//					<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]. 
//					или строка с именем объекта метаданных 
//	НаименованиеОбработки - строка - Наименование обработки, которым будет заполнено наименование элемента справочника по умолчанию.
//							Необязательно, по умолчанию синоним или представление объекта
//	Информация  - строка - Краткая информация или описание обработки.
//							Необязательно, по умолчанию комментарий объекта
//	Версия - строка - Версия обработки в формате “<старший номер>.<младший номер>” используется при загрузке обработок в информационную базу.
//
//
// Возвращаемое значение:
//		Структура
//
Функция ПолучитьПараметрыРегистрации(ОбъектыНазначенияФормы = Неопределено, НаименованиеОбработки = "", Информация = "")
	
	Если ТипЗнч(ОбъектыНазначенияФормы) = Тип("Строка") Тогда
		ОбъектНазначенияФормы = ОбъектыНазначенияФормы;
		ОбъектыНазначенияФормы = Новый Массив;
		ОбъектыНазначенияФормы.Добавить(ОбъектНазначенияФормы);
	КонецЕсли; 
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид",             "ПечатнаяФорма");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);
	ПараметрыРегистрации.Вставить("Назначение",      ОбъектыНазначенияФормы);
	
	Если Не ЗначениеЗаполнено(НаименованиеОбработки) Тогда
		НаименованиеОбработки = ЭтотОбъект.Метаданные().Представление();
	КонецЕсли; 
	ПараметрыРегистрации.Вставить("Наименование", НаименованиеОбработки);
	
	ПараметрыРегистрации.Вставить("Информация", Информация);
	ПараметрыРегистрации.Вставить("Версия",     ЭтотОбъект.Метаданные().Комментарий);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Вспомогательная процедура.
//
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование = "ВызовСерверногоМетода", ПоказыватьОповещение = Ложь, Модификатор = "ПечатьMXL")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

// Формирует таблицу значений с командами печати
//	
// Возвращаемое значение:
//		ТаблицаЗначений
//
Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	
	//Представление команды в пользовательском интерфейсе
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	//Уникальный идентификатор команды или имя макета печати
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	
	//Способ вызова команды: "ОткрытиеФормы", "ВызовКлиентскогоМетода", "ВызовСерверногоМетода"
	// "ОткрытиеФормы" - применяется только для отчетов и дополнительных отчетов
	// "ВызовКлиентскогоМетода" - вызов процедуры Печать(), определённой в модуле формы обработки
	// "ВызовСерверногоМетода" - вызов процедуры Печать(), определённой в модуле объекта обработки
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	
	//Показывать оповещение.
	//Если Истина, требуется показать оповещение при начале и при завершении работы обработки. 
	//Имеет смысл только при запуске обработки без открытия формы
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	
	//Дополнительный модификатор команды. 
	//Используется для дополнительных обработок печатных форм на основе табличных макетов.
	//Для таких команд должен содержать строку ПечатьMXL
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

// Экспортная процедура печати, вызываемая из основной программы
//
// Параметры:
// ВХОДЯЩИЕ:
//  МассивОбъектовНазначения - Массив - список объектов ссылочного типа для печати документа
//                 Как правило, содержит один элемент с ссылкой на вызвавший форму объект (документ, справочник)
//
// ИСХОДЯЩИЕ:
//  КоллекцияПечатныхФорм - ТаблицаЗначений - таблица сформированных табличных документов.
//                 Как правило, содержит одну строку с именем текущей печатной формы
//  ОбъектыПечати - СписокЗначений - список объектов печати. 
//  ПараметрыВывода - Структура - Параметры сформированных табличных документов. Содержит поля:
//  						ДоступнаПечатьПоКомплектно - булево - по умолчанию Ложь
//							ПолучательЭлектронногоПисьма
//							ОтправительЭлектронногоПисьма
//
Процедура Печать(МассивОбъектовНазначения, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЛистОтгрузки") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФорму(МассивОбъектовНазначения, ОбъектыПечати, "ПФ_MXL_ЛистОтгрузки");
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЛистОтгрузки",
			"Лист отгрузки",
			ТабличныйДокумент
			);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб			= Истина;
	ТабДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_" + ИмяМакета;

	Макет = ПолучитьМакет(ИмяМакета);	
	
	Если ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.ТранспортнаяНакладная") Тогда
		МассивОбъектовНакладная = МассивОбъектов;
		
	ИначеЕсли  ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Док.Ссылка
		|ИЗ
		|	Документ.ТранспортнаяНакладная.ДокументыОснования КАК Док
		|ГДЕ
		|	Док.ДокументОснование В(&МассивОбъектов)
		|	И НЕ Док.Ссылка.ПометкаУдаления";
		
		МассивОбъектовНакладная = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ИначеЕсли ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Док.Ссылка
		|ИЗ
		|	Документ.ТранспортнаяНакладная.ДокументыОснования КАК Док
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|		ПО Док.ДокументОснование = РеализацияТоваровУслуг.Ссылка
		|ГДЕ
		|	РеализацияТоваровУслуг.ЗаказКлиента В(&МассивОбъектов)
		|	И НЕ Док.Ссылка.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Док.Ссылка
		|ИЗ
		|	Документ.ТранспортнаяНакладная.ДокументыОснования КАК Док
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслуг
		|		ПО Док.ДокументОснование = РеализацияТоваровУслуг.Ссылка
		|ГДЕ
		|	РеализацияТоваровУслуг.ЗаказКлиента В(&МассивОбъектов)
		|	И НЕ Док.Ссылка.ПометкаУдаления";
	
		МассивОбъектовНакладная = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	КонецЕсли;	
	
	Если МассивОбъектовНакладная.Количество() = 0 Тогда
		
		Стр = "Не введен документ ""Транспортная накладная""
		|
		|Цепочка документов:
		|
		|Реализация товаров и услуг
		|	Транспортная накладная";
		
		ВызватьИсключение Стр;
		
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектовНакладная);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.Ссылка,
	|	Док.Дата,
	|	Док.Номер,
	|	Док.Плательщик,
	|	Док.Грузополучатель,
	|	Док.АвтомобильГосударственныйНомер,
	|	Док.Водитель,
	|	Док._ВодительТелефон КАК ВодительТелефон,
	|	Док._НомерКонтейнера КАК НомерКонтейнера,
	|	Док.Перевозчик,
	|	Док.Отпустил,
	|	Док._НачалоЗагрузки КАК НачалоЗагрузки,
	|	Док._ОкончаниеЗагрузки КАК ОкончаниеЗагрузки,
	|	Док._Ответственный КАК Ответственный,
	|	Док._ДатаПрибытия КАК ДатаПрибытия
	|ИЗ
	|	Документ.ТранспортнаяНакладная КАК Док
	|ГДЕ
	|	Док.Ссылка В(&МассивОбъектов)";
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	
	ПервыйДокумент = Истина;
	Пока Шапка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		ГрузополучательКИ = _ОбщегоНазначенияДоп.ПолучитьКИ(Шапка.Грузополучатель);
		
		ОбластьШапка.Параметры.Заполнить(Шапка);
		ОбластьШапка.Параметры.Покупатель      = Шапка.Плательщик.НаименованиеПолное;
		ОбластьШапка.Параметры.Грузополучатель = Шапка.Грузополучатель.НаименованиеПолное;
		ОбластьШапка.Параметры.ГрузополучательАдрес = ГрузополучательКИ["Юридический адрес"];
		
		ПеревозчикКИ = _ОбщегоНазначенияДоп.ПолучитьКИ(Шапка.Перевозчик);
		ОбластьШапка.Параметры.Перевозчик = Шапка.Перевозчик.НаименованиеПолное;
		ОбластьШапка.Параметры.ПеревозчикАдрес   = ПеревозчикКИ["Юридический адрес"];
		ОбластьШапка.Параметры.Перевозчиктелефон = ПеревозчикКИ["Телефон"];
		
		ОбластьШапка.Параметры.ОтветственныйФИО = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(Строка(Шапка.Ответственный));
		
		ОбластьШапка.Параметры.Кладовщик = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Отпустил, Шапка.Дата);
		
		Заказ = ПолучитьЗаказ(Шапка.Ссылка);
		ОбластьШапка.Параметры.ЗаказНомер = Заказ.Номер;
		ОбластьШапка.Параметры.ЗаказДата  = Формат(Заказ.Дата, "ДФ=dd.MM.yyyy");
		
		ОбластьШапка.Параметры.ДатаПечати   = ТекущаяДатаСеанса();
		ОбластьШапка.Параметры.ДатаПрибытия = Формат(Шапка.ДатаПрибытия, "ДФ=dd.MM.yyyy");
		
		ТабДокумент.Вывести(ОбластьШапка);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции	

Функция ПолучитьЗаказ(Накладная)
	
	Структура = Новый Структура("Ссылка, Номер, Дата");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Накладная);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РеализацияТоваровУслугТовары.ЗаказКлиента КАК Ссылка,
	|	РеализацияТоваровУслугТовары.ЗаказКлиента.Номер КАК Номер,
	|	РеализацияТоваровУслугТовары.ЗаказКлиента.Дата КАК Дата
	|ИЗ
	|	Документ.ТранспортнаяНакладная.ДокументыОснования КАК Док
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|		ПО Док.ДокументОснование = РеализацияТоваровУслугТовары.Ссылка
	|ГДЕ
	|	Док.Ссылка В(&Ссылка)";
		
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ЗаполнитьЗначенияСвойств(Структура, Результат.Выгрузить()[0]);
	КонецЕсли;	
	
	Возврат Структура;
	
КонецФункции

