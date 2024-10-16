import org.apache.spark.sql.SparkSession
import java.io.File
import java.nio.file.{Files, Paths, StandardCopyOption}

// Инициализируем сессию Spark
val spark = SparkSession.builder().appName("Export Hive Table by Partition with Custom Column Names").enableHiveSupport().getOrCreate()

// Выполняем SQL-запрос для получения данных
val df = spark.sql("""
  SELECT `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, 
         `11`, `12`, `13`, `14`, `15`, `16`, `17`, `18`, `19`, `20`, 
         `21`, `22`, `23`, `24`, `25`, `26`, `27`, `28`, `29`, `30`, 
         `31`, `32`, `33`, `34`, `35`, `36`, `37`, `38`, `39`, `40`, 
         `41`, `42`, `43`, `44`, `45`, `46`, `47`, `48`, `49`, `50`,
         part
  FROM default.rb068198_all
""")

// Определяем новые названия столбцов
val newColumnNames = Map(
  "1" -> "Дата и время транзакции",
  "2" -> "Статус транзакции",
  "3" -> "Номер транзакции плательщика",
  "4" -> "RRN транзакции",
  "5" -> "ARN транзакции",
  "6" -> "ID операции СБП",
  "7" -> "Номер транзакции получателя",
  "8" -> "Внутренний идентификатор операции (ID)",
  "9" -> "ID Мерчанта / ТСП",
  "10" -> "Наименование Мерчанта / ТСП",
  "11" -> "ИНН Мерчанта / ТСП",
  "12" -> "ID терминала",
  "13" -> "Тип терминала",
  "14" -> "Сумма операции в копейках",
  "15" -> "Код валюты операции",
  "16" -> "Сумма операции в руб. эквиваленте",
  "17" -> "Тип перевода",
  "18" -> "Наименование платежного посредника / партнера-плательщика",
  "19" -> "ИНН / КИО платежного посредника / партнера-плательщика",
  "20" -> "Наименование / ФИО плательщика",
  "21" -> "ИНН плательщика",
  "22" -> "Адрес Web-сайта плательщика",
  "23" -> "Код страны плательщика",
  "24" -> "Тип плательщика",
  "25" -> "Платежная система / мобильный оператор",
  "26" -> "Тип идентификатора плательщика",
  "27" -> "Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона",
  "28" -> "Эмитент",
  "29" -> "Наименование платежного посредника / партнера-получателя",
  "30" -> "ИНН / КИО платежного посредника / партнера-получателя",
  "31" -> "Наименование / ФИО получателя",
  "32" -> "ИНН получателя",
  "33" -> "Адрес Web-сайта получателя",
  "34" -> "Код страны получателя",
  "35" -> "Тип получателя",
  "36" -> "MCC-код",
  "37" -> "Платежная система / мобильный оператор",
  "38" -> "Тип идентификатора получателя",
  "39" -> "Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона",
  "40" -> "Эмитент",
  "41" -> "Комментарий к платежу",
  "42" -> "Дата включения операции в баланс Банка",
  "43" -> "Поле UKEY/O_ID из УОИ",
  "44" -> "Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)",
  "45" -> "Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)",
  "46" -> "Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов",
  "47" -> "Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов",
  "48" -> "ID клиента плательщика в КО",
  "49" -> "ID клиента получателя в КО",
  "50" -> "Аббревиатура товара"
)

// Переименовываем столбцы в DataFrame
val renamedDF = newColumnNames.foldLeft(df)((tempDF, names) => tempDF.withColumnRenamed(names._1, names._2))

// Получаем уникальные значения из поля партиции 'part'
val partitions = renamedDF.select("part").distinct().collect().map(_.getString(0))

// Указываем корневой путь для сохранения файлов
val baseOutputPath = "/user/rb068198/cbr/csv_files"

// Для каждой партиции фильтруем данные, удаляем столбец part, объединяем в один файл и сохраняем с именем, соответствующим значению партиции
partitions.foreach { partValue =>
  val partitionDF = renamedDF.filter(s"part = '$partValue'")
                             .drop("part")    // Удаляем поле part
                             .coalesce(1)     // Объединяем в один файл
  
  // Временный путь для сохранения
  val tempPath = s"$baseOutputPath/temp_$partValue"
  
  // Итоговый путь к файлу с именем партиции
  val finalFilePath = s"$baseOutputPath/$partValue.csv"

  // Сохраняем DataFrame для данной партиции в временную папку с нужной кодировкой и разделителем
  partitionDF.write
    .mode("overwrite")
    .option("header", "true")
    .option("encoding", "windows-1251")
    .option("delimiter", "\u00A6")  // Символ разделителя ¦ (код 0166)
    .csv(tempPath)

  // Находим сгенерированный CSV-файл в временной папке и переименовываем его
  val tempDir = new File(tempPath)
  val tempFile = tempDir.listFiles().find(_.getName.endsWith(".csv")).get

  // Перемещаем файл в нужное место с нужным именем
  Files.move(tempFile.toPath, Paths.get(finalFilePath), StandardCopyOption.REPLACE_EXISTING)

  // Удаляем временную папку
  tempDir.delete()
}

spark.stop()
