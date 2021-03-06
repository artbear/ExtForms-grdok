﻿//**************************************************************************************************
//* Процедура/Функция
//************************************************************************************************** 
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	//***** Описание переменных
	Перем лкСписок,лкМетаРег;
	
	//***** Получение списка выбора
	лкСписок=ЭлементыФормы.ВидНабораЗаписей.СписокВыбора;
	лкСписок.Добавить(Неопределено,"<<Не указан>>");
	
	//***** Заполнение списка (регистры сведений)
	Для Каждого лкМетаРег Из Метаданные.РегистрыСведений Цикл
		Если лкМетаРег.РежимЗаписи=Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
			лкСписок.Добавить(лкМетаРег,лкМетаРег.Представление(),,БиблиотекаКартинок.РегистрСведений);
		КонецЕсли; 
	КонецЦикла; 

	//***** Заполнение списка (регистры накопления)
	Для Каждого лкМетаРег Из Метаданные.РегистрыНакопления Цикл
		лкСписок.Добавить(лкМетаРег,лкМетаРег.Представление(),,БиблиотекаКартинок.РегистрНакопления);
	КонецЦикла; 

	//***** Заполнение списка (регистры бухгалтерии)
	Для Каждого лкМетаРег Из Метаданные.РегистрыБухгалтерии Цикл
		лкСписок.Добавить(лкМетаРег,лкМетаРег.Представление(),,БиблиотекаКартинок.РегистрБухгалтерии);
	КонецЦикла;
	
	//***** Инициализация реквизитов
	ВидНабораЗаписей=Неопределено;
	Регистратор=Неопределено;
	
	//***** Установка доступности
	УстановкаДоступности();

КонецПроцедуры //ПередОткрытием
 
//**************************************************************************************************
//* Процедура/Функция
//************************************************************************************************** 
Процедура ВидНабораЗаписейПриИзменении(Элемент)

	//***** Описание переменных
	Перем лкМассив,лкМетаДок;
	
	//***** Проверка условия
	Если Не(ВидНабораЗаписей=Неопределено) Тогда
		лкМассив=Новый Массив;
		Для Каждого лкМетаДок Из Метаданные.Документы Цикл
			Если лкМетаДок.Движения.Содержит(ВидНабораЗаписей) Тогда
				лкМассив.Добавить(Тип("ДокументСсылка."+лкМетаДок.Имя));
			КонецЕсли;
		КонецЦикла;
		ЭлементыФормы.Регистратор.ОграничениеТипа=Новый ОписаниеТипов(лкМассив);
		Регистратор=ЭлементыФормы.Регистратор.ОграничениеТипа.ПривестиЗначение(Регистратор);
	Иначе
		Регистратор=Неопределено;
	КонецЕсли; 
	
	//***** Чтение набора записей и установка доступности
	ЧтениеНабораЗаписей();
	УстановкаДоступности();
	
КонецПроцедуры //ВидНабораЗаписейПриИзменении
 
//**************************************************************************************************
//* Процедура/Функция
//************************************************************************************************** 
Процедура ВидНабораЗаписейОчистка(Элемент, СтандартнаяОбработка)

	//***** Очистка реквизитов
	СтандартнаяОбработка=Ложь;
	ВидНабораЗаписей=Неопределено;
	Регистратор=Неопределено;
	
	//***** Чтение набора записей и установка доступности
	ЧтениеНабораЗаписей();
	УстановкаДоступности();
	
КонецПроцедуры //ВидНабораЗаписейОчистка
 
//**************************************************************************************************
//* Процедура/Функция
//************************************************************************************************** 
Процедура РегистраторПриИзменении(Элемент)

	//***** Чтение набора записей и установка доступности
	ЧтениеНабораЗаписей();
	УстановкаДоступности();
	
КонецПроцедуры //РегистраторПриИзменении
 
//**************************************************************************************************
//* Процедура/Функция
//************************************************************************************************** 
Процедура ЗаписатьНажатие(Кнопка)
	
	//***** Описание переменных
	Перем лкНабор;
	
	//***** Проверка условия
	Если (Регистратор=Неопределено) ИЛИ Регистратор.Пустая() Тогда
		Предупреждение("Не указан регистратор набора записей !!!");
		Возврат;
	КонецЕсли; 
	
	//***** Вопрос пользователю
	Если Не(Вопрос("Записать набор в информационную базу?",РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет)=КодВозвратаДиалога.Да) Тогда
		Возврат;
	КонецЕсли;
	
	//***** Инициализация набора записей
	Если Метаданные.РегистрыСведений.Содержит(ВидНабораЗаписей) Тогда
		лкНабор=РегистрыСведений[ВидНабораЗаписей.Имя].СоздатьНаборЗаписей();
	ИначеЕсли Метаданные.РегистрыНакопления.Содержит(ВидНабораЗаписей) Тогда
		лкНабор=РегистрыНакопления[ВидНабораЗаписей.Имя].СоздатьНаборЗаписей();
	ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(ВидНабораЗаписей) Тогда
		лкНабор=РегистрыБухгалтерии[ВидНабораЗаписей.Имя].СоздатьНаборЗаписей();
	КонецЕсли;
	
	//***** Загрузка записей и установка отбора
	лкНабор.Отбор.Регистратор.Установить(Регистратор);
	лкНабор.Загрузить(НаборЗаписей);
	
	//***** Запись набора
	Попытка
		лкНабор.Записать(Истина);
		Сообщить("Набор успешно записан !!!",СтатусСообщения.Информация);
	Исключение
	    Сообщить("Не удалось записать набор !!!"+Символы.ПС+ОписаниеОшибки(),СтатусСообщения.Важное);
	КонецПопытки; 

КонецПроцедуры //ЗаписатьНажатие

//**************************************************************************************************
//* Процедура/Функция
//************************************************************************************************** 
Процедура ЧтениеНабораЗаписей()

	//***** Описание переменных
	Перем лкНабор;
	
	//***** Проверка условия
	Если Не(Регистратор=Неопределено) И Не(Регистратор.Пустая()) Тогда
		Если Метаданные.РегистрыСведений.Содержит(ВидНабораЗаписей) Тогда
			лкНабор=РегистрыСведений[ВидНабораЗаписей.Имя].СоздатьНаборЗаписей();
		ИначеЕсли Метаданные.РегистрыНакопления.Содержит(ВидНабораЗаписей) Тогда
			лкНабор=РегистрыНакопления[ВидНабораЗаписей.Имя].СоздатьНаборЗаписей();
		ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(ВидНабораЗаписей) Тогда
			лкНабор=РегистрыБухгалтерии[ВидНабораЗаписей.Имя].СоздатьНаборЗаписей();
		КонецЕсли;
		лкНабор.Отбор.Регистратор.Установить(Регистратор);
		лкНабор.Прочитать();
		НаборЗаписей=лкНабор.Выгрузить();
	Иначе
		НаборЗаписей=Новый ТаблицаЗначений;
	КонецЕсли; 
	ЭлементыФормы.НаборЗаписей.СоздатьКолонки();

КонецПроцедуры //ЧтениеНабораЗаписей

//**************************************************************************************************
//* Процедура/Функция
//************************************************************************************************** 
Процедура УстановкаДоступности()

	//***** Установка доступности элементов
	ЭлементыФормы.Регистратор.Доступность=Не(ВидНабораЗаписей=Неопределено);
	ЭлементыФормы.НаборЗаписей.Доступность=Не(Регистратор=Неопределено) И Не(Регистратор.Пустая());

КонецПроцедуры //УстановкаДоступности
 