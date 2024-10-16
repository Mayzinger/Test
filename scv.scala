import org.apache.spark.sql.SparkSession
import java.io.File
import java.nio.file.{Files, Paths}
import scala.sys.process._

val spark = SparkSession.builder()
  .appName("Export Hive Table to CSV with ZIP and Custom Column Names")
  .enableHiveSupport()
  .getOrCreate()

// Имя таблицы Hive
val hiveTableName = "my_hive_table"

// Чтение данных из Hive таблицы
val df = spark.sql(s"SELECT `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `13`, `14`, `15`, `16`, `17`, `18`, `19`, `20`, `21`, `22`, `23`, `24`, `25`, `26`, `27`, `28`, `29`, `30`, `31`, `32`, `33`, `34`, `35`, `36`, `37`, `38`, `39`, `40`, `41`, `42`, `43`, `44`, `45`, `46`, `47`, `48`, `49`, `50` FROM default.rb068198_all")

// Определяем новые названия столбцов
val newColumnNames = Map(
  "old_column1" -> "new_column1",
  "old_column2" -> "new_column2",
  "old_column3" -> "new_column3"
)

// Переименовываем столбцы
val renamedDF = newColumnNames.foldLeft(df)((df, names) => df.withColumnRenamed(names._1, names._2))

// Задаем целевой размер файлов в 200 МБ
val targetFileSizeMB = 200
val bytesPerMB = 1024 * 1024

// Рассчитываем количество партиций, чтобы ограничить размер файлов
val totalSizeInBytes = renamedDF.rdd.map(_.mkString.length.toLong).reduce(_ + _)
val numPartitions = math.max(1, (totalSizeInBytes / (targetFileSizeMB * bytesPerMB)).toInt)

// Перепартиционируем DataFrame для ограничения размера файлов
val repartitionedDF = renamedDF.repartition(numPartitions)

// Указываем пути для сохранения CSV и ZIP
val outputPath = "/path/to/output/csv_files"
val zipPath = "/path/to/output/zipped_files/output_archive.zip"

// Сохраняем DataFrame в формате CSV с заголовками
repartitionedDF.write
  .mode("overwrite")
  .option("header", "true")
  .csv(outputPath)

// Упаковываем все CSV-файлы в ZIP-архив
val outputDir = new File(outputPath)
val zipFile = new File(zipPath)

if (outputDir.exists && outputDir.isDirectory) {
  // Создаем ZIP-архив из директории с CSV-файлами
  val zipCommand = s"zip -r ${zipFile.getAbsolutePath} ${outputDir.getAbsolutePath}"
  zipCommand.!
  
  // Опционально удаляем исходные CSV-файлы после упаковки
  outputDir.listFiles().foreach(_.delete())
  outputDir.delete()
}

spark.stop()
