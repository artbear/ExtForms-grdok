﻿Функция СведенияОВнешнейОбработке() Экспорт
    // Объявим переменную, в которой мы сохраним и вернем "наружу" необходимые данные
    ПараметрыРегистрации = Новый Структура;

    // Объявим еще одну переменную, которая нам потребуется ниже
    МассивНазначений = Новый Массив;
    
    // Первый параметр, который мы должны указать - это какой вид обработки системе должна зарегистрировать. 
    // Допустимые типы: ДополнительнаяОбработка, ДополнительныйОтчет, ЗаполнениеОбъекта, Отчет, ПечатнаяФорма, СозданиеСвязанныхОбъектов
    ПараметрыРегистрации.Вставить("Вид", "ДополнительныйОтчет");

    // Теперь нам необходимо передать в виде массива имен, к чему будет подключена наш Отчёт
	// Так как данный отчёт не "завязан" на какие-либо объекты, то
	//   подключаем просто Новый Массив
    ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
    
    // Теперь зададим имя, под которым отчёт будет зарегистрирован в справочнике внешних обработок
    ПараметрыРегистрации.Вставить("Наименование", "Свод товародвижения маршрутных листов (Дополнительный)");
    
    // Зададим право обработке на использование безопасного режима. Более подробно можно узнать в справке к платформе (метод УстановитьБезопасныйРежим)
    ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);

    // Следующие два параметра играют больше информационную роль, т.е. это то, что будет видеть пользователь в информации к обработке
    ПараметрыРегистрации.Вставить("Версия", "1.0");    
    ПараметрыРегистрации.Вставить("Информация", "Свод товародвижения маршрутных листов (Дополнительный)");
    
    // Создадим таблицу команд (подробнее смотрим ниже)
    ТаблицаКоманд = ПолучитьТаблицуКоманд();
    
    // Добавим команду в таблицу
    ДобавитьКоманду(ТаблицаКоманд, "Свод товародвижения маршрутных листов (Дополнительный)", "СводТовародвиженияМаршрутныхЛистов", "ОткрытиеФормы", Истина, "");
    
    // Сохраним таблицу команд в параметры регистрации обработки
    ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
    
    // Теперь вернем системе наши параметры
    Возврат ПараметрыРегистрации;
КонецФункции

// Здесь можно посмотреть как устроена Таблица Команда
Функция ПолучитьТаблицуКоманд()

// Таблица Команд – это таблица значений – вот её и создаём
//
Команды = Новый ТаблицаЗначений;

// Начинаем делать колонки для таблицы команд

// КОЛОНКА Представление
// Представление – представление команды в пользовательском интерфейсе;
Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));

// КОЛОНКА Идентификатор
// Идентификатор – идентификатор команды; любая строка, уникальная в пределах данной обработки (отчета). 
// Для обработок с печатными формами на основе макета табличного документа должен содержать список макетов,
//      на основе которых нужно получить печатную форму
//      (см. описание параметра ИменаМакетов процедуры УправлениеПечатьюКлиент.ВыполнитьКомандуПечати в разделе Печать).
//    ??? Имя нашего макета, что бы могли отличить вызванную команду в списке отчётов ???
Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));

// КОЛОНКА Использование 
// Использование – вариант запуска команды – их всего Три – они задаются строками:
// ● "ОткрытиеФормы" – открыть форму обработки;
// ● "ВызовКлиентскогоМетода" – вызвать клиентскую экспортную процедуру из модуля формы обработки;
// ● "ВызовСерверногоМетода" – вызвать серверную экспортную процедуру из модуля объекта обработки.
Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));

// КОЛОНКА Показывать Оповещение
// ПоказыватьОповещение – Истина, если требуется показать оповещение при начале и при завершении работы обработки.
//   Например, при запуске обработки без открытия формы.
//   Не имеет смысла при открытии формы
Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));

// КОЛОНКА Модификатор
// Модификатор – дополнительный модификатор команды.
// Используется для дополнительных обработок печатных форм на основе табличных макетов,
//     для таких команд должен содержать строку ПечатьMXL
//     (см. пример в демонстрационной конфигурации Библиотеки Стандартных Подсистем).
Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));

// Созданную пустую таблицу возвращают назад
Возврат Команды;

КонецФункции
///////////////////////////////////////////////


Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
  // Добавляем команду в таблицу команд по переданному описанию.
  // Параметры и их значения можно посмотреть в функции ПолучитьТаблицуКоманд
  НоваяКоманда = ТаблицаКоманд.Добавить();
  НоваяКоманда.Представление = Представление;
  НоваяКоманда.Идентификатор = Идентификатор;
  НоваяКоманда.Использование = Использование;
  НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
  НоваяКоманда.Модификатор = Модификатор;
КонецПроцедуры
