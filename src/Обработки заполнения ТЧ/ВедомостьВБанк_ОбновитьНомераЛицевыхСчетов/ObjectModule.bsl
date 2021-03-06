﻿
Функция СведенияОВнешнейОбработке() Экспорт
	
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.ВедомостьНаВыплатуЗарплатыВБанк"); //Указываем документ к которому делаем внешнюю печ. форму
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Вид          = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиЗаполнениеОбъекта();
	ПараметрыРегистрации.Наименование = Метаданные().Представление();
	ПараметрыРегистрации.Версия       = Метаданные().Комментарий;
	ПараметрыРегистрации.Назначение   = МассивНазначений;
	
	ДобавитьКоманду(ПараметрыРегистрации.Команды, "Обновить номера лицевых счетов", "Обновить номера лицевых счетов", ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыЗаполнениеФормы(), Истина, "");
		
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

Процедура ВыполнитьКоманду(ИмяКоманды, ОбъектыНазначения, ПараметрыВыполнения) Экспорт
	
	ЭтаФорма = ПараметрыВыполнения.ЭтаФорма;
	ЗарплатныйПроект = ЭтаФорма.Объект.ЗарплатныйПроект;
	Если НЕ ЗначениеЗаполнено(ЗарплатныйПроект) Тогда
    	Сообщение = Новый СообщениеПользователю();
        Сообщение.Поле  = "Объект.ЗарплатныйПроект";
        Сообщение.Текст = "Не указан зарплатный проект";
        Сообщение.Сообщить();
		Возврат;
	КонецЕсли;	
	
	Для каждого СтрокаТЧ из ЭтаФорма.Объект.Состав Цикл
		
		СтрокаТЧ.НомерЛицевогоСчета = ПолучитьНомерЛицевогоСчета(СтрокаТЧ.ФизическоеЛицо, ЗарплатныйПроект, ЭтаФорма.Объект.ПериодРегистрации);
		
	КонецЦикла;	
	
КонецПроцедуры

Функция ПолучитьНомерЛицевогоСчета(ФизическоеЛицо, ЗарплатныйПроект, Период)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ФизическоеЛицо",   ФизическоеЛицо);
	Запрос.Параметры.Вставить("ЗарплатныйПроект", ЗарплатныйПроект);
	Запрос.Параметры.Вставить("Период",           Период);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МестаВыплатыЗарплатыСотрудников.Вид
	|ИЗ
	|	РегистрСведений.МестаВыплатыЗарплатыСотрудников КАК МестаВыплатыЗарплатыСотрудников
	|ГДЕ
	|	МестаВыплатыЗарплатыСотрудников.ФизическоеЛицо = &ФизическоеЛицо";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда 
		Вид = Результат.Выгрузить()[0][0];
		Если Вид <> Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект Тогда
			Возврат Неопределено;
		КонецЕсли;	
	КонецЕсли;	
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Рег.НомерЛицевогоСчета
	|ИЗ
	|	РегистрСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СрезПоследних(&Период, ФизическоеЛицо = &ФизическоеЛицо) КАК Рег
	|ГДЕ
	|	Рег.ЗарплатныйПроект = &ЗарплатныйПроект";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Возврат Результат.Выгрузить()[0][0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции	