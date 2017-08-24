﻿
#Область ПрограмныйИнтерфейс

Функция СведенияОВнешнейОбработке() Экспорт
	
	МассивНазначений = Новый Массив;
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Вид          = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Наименование = Метаданные().Представление();
	ПараметрыРегистрации.Версия       = Метаданные().Комментарий;
	ПараметрыРегистрации.Назначение   = МассивНазначений;
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	ДобавитьКоманду(ПараметрыРегистрации.Команды, ПараметрыРегистрации.Наименование, ПараметрыРегистрации.Наименование, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы(), Истина, "ПечатьMXL");
		
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

#КонецОбласти
