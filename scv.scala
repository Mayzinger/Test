import org.apache.spark.sql.SparkSession
import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.fs.{FileSystem, Path}
import java.util.zip.{ZipEntry, ZipOutputStream}
import java.io.OutputStream

val spark = SparkSession.builder().appName("Export Hive Table by Partition with Custom Column Names").enableHiveSupport().getOrCreate()

val df = spark.sql("SELECT `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `13`, `14`, `15`, `16`, `17`, `18`, `19`, `20`, `21`, `22`, `23`, `24`, `25`, `26`, `27`, `28`, `29`, `30`, `31`, `32`, `33`, `34`, `35`, `36`, `37`, `38`, `39`, `40`, `41`, `42`, `43`, `44`, `45`, `46`, `47`, `48`, `49`, `50`, nttdat part FROM default.rb068198_all")

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
  "30" -> "ИНН / КИО платежного посредника / партнера-получателя_",
  "31" -> "Наименование / ФИО получателя",
  "32" -> "ИНН получателя",
  "33" -> "Адрес Web-сайта получателя",
  "34" -> "Код страны получателя",
  "35" -> "Тип получателя",
  "36" -> "MCC-код",
  "37" -> "Платежная система / мобильный оператор_",
  "38" -> "Тип идентификатора получателя",
  "39" -> "Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона_",
  "40" -> "Эмитент_",
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

val renamedDF = newColumnNames.foldLeft(df)((tempDF, names) => tempDF.withColumnRenamed(names._1, names._2))

val partitions = renamedDF.select("part").distinct().collect().map(_.getString(0))

val baseOutputPath = "/user/rb068198/cbr/csv_files"
val hadoopConfig = new Configuration()
val hdfs = FileSystem.get(hadoopConfig)

partitions.foreach { partValue =>
  val partitionDF = renamedDF.filter(s"part = '$partValue'").drop("part")

  // Используем repartition(1) для записи данных в один файл
  val singleFileDF = partitionDF.repartition(1)

  // Путь для сохранения CSV-файла и ZIP-архива
  val csvOutputPath = s"$baseOutputPath/$partValue.csv"
  val zipOutputPath = s"$baseOutputPath/$partValue.zip"

  // Сохраняем DataFrame в один CSV-файл
  singleFileDF.write
    .mode("overwrite")
    .option("header", "true")
    .option("encoding", "windows-1251")
    .option("delimiter", "\u00A6")
    .csv(s"$baseOutputPath/$partValue-temp")

  // Находим сгенерированный CSV-файл и перемещаем его в окончательный путь
  val tempDir = new Path(s"$baseOutputPath/$partValue-temp")
  val csvFile = hdfs.listStatus(tempDir).find(_.getPath.getName.endsWith(".csv")).get.getPath
  hdfs.rename(csvFile, new Path(csvOutputPath))

  // Создаем ZIP-архив
  val zipOutStream = new ZipOutputStream(hdfs.create(new Path(zipOutputPath)))
  zipOutStream.putNextEntry(new ZipEntry(s"$partValue.csv"))
  val csvInputStream = hdfs.open(new Path(csvOutputPath))
  val buffer = new Array[Byte](4 * 1024) // Массив размером 4096 байт
  var len = csvInputStream.read(buffer)
  while (len > 0) {
    zipOutStream.write(buffer, 0, len)
    len = csvInputStream.read(buffer)
  }
  csvInputStream.close()
  zipOutStream.closeEntry()
  zipOutStream.close()

  // Удаляем временную директорию и CSV-файл после создания ZIP-архива
  hdfs.delete(new Path(csvOutputPath), true)
  hdfs.delete(tempDir, true)
}

spark.stop()
